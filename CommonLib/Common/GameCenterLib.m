//
//  GameCenterLib.m
//  DemoGameCenter
//
//  Created by popeveryday on 11/26/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import "GameCenterLib.h"


@implementation GameCenterLib
@synthesize delegate;

+ (BOOL) isGameCenterAvailable
{
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (void)retrieveFriendsList;
{
	if([GKLocalPlayer localPlayer].authenticated == YES)
	{
		[[GKLocalPlayer localPlayer] loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error)
		 {
			 [self callDelegateOnMainThread: @selector(friendsFinishedLoading:error:) withArg: friends error: error];
		 }];
	}
	
	else
		NSLog(@"You must authenicate first");
}

- (void)playersForIDs:(NSArray *)playerIDs
{
	[GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error)
	 {
		 [self callDelegateOnMainThread: @selector(playerDataLoaded:error:) withArg: players error: error];
     }];
}

- (void)playerforID:(NSString *)playerID
{
	[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] withCompletionHandler:^(NSArray *players, NSError *error)
	 {
		 [self callDelegateOnMainThread: @selector(playerDataLoaded:error:) withArg: players error: error];
	 }];
}

- (void) authenticateLocalUser
{
    localPlayer = [GKLocalPlayer localPlayer];
    __weak typeof(self) weakSelf = self; // removes retain cycle error
    
    localPlayer = [GKLocalPlayer localPlayer]; // localPlayer is the public GKLocalPlayer
    __weak GKLocalPlayer *weakPlayer = localPlayer; // removes retain cycle error
    
    weakPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil)
        {
            [weakSelf showAuthenticationDialogWhenReasonable:viewController];
        }
        else if (weakPlayer.isAuthenticated)
        {
            [weakSelf authenticatedPlayer:weakPlayer];
        }
        else
        {
            [weakSelf disableGameCenter];
        }
    };
}

-(void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller
{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}

-(void)authenticatedPlayer:(GKLocalPlayer *)player
{
    player = localPlayer;
}

-(void)disableGameCenter
{
    
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
	GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error)
	 {
		 if (error != nil)
		 {
			 NSData* savedScoreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
			 [self storeScoreForLater: savedScoreData];
             //             int newscore = (int)score intValue];
		 }
		 
		 [self callDelegateOnMainThread: @selector(scoreReported:) withArg: NULL error: error];
	 }];
}

- (void)storeScoreForLater:(NSData *)scoreData;
{
	NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
	[savedScoreArray addObject: scoreData];
	[[NSUserDefaults standardUserDefaults] setObject:savedScoreArray forKey:@"savedScores"];
}

-(void)submitAllSavedScores
{
	NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey: @"savedScores"];
	
	for(NSData *scoreData in savedScoreArray)
	{
		GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData: scoreData];
		
		[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error)
		 {
			 if (error != nil)
			 {
				 NSData* savedScoreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
				 [self storeScoreForLater: savedScoreData];
			 }
			 
			 else
				 NSLog(@"Saved score submitted");
		 }];
	}
}

- (void)retrieveScoresForCategory:(NSString *)category withPlayerScope:(GKLeaderboardPlayerScope)playerScope timeScope:(GKLeaderboardTimeScope)timeScope withRange: (NSRange)range;
{
	GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
	leaderboardRequest.playerScope = playerScope;
	leaderboardRequest.timeScope = timeScope;
	leaderboardRequest.range = range;
	leaderboardRequest.category = category;
	
	[leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores,NSError *error)
	 {
		 [self callDelegateOnMainThread: @selector(leaderboardUpdated:error:) withArg: scores error: error];
	 }];
}

-(void)retrieveLocalScoreForCategory:(NSString *)category
{
	GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
	leaderboardRequest.category = category;
    
	[leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores,NSError *error)
	 {
		 [self callDelegateOnMainThread: @selector(localPlayerScore:error:) withArg: leaderboardRequest.localPlayerScore error: error];
	 }];
}

- (void)mapPlayerIDtoPlayer:(NSString*)playerID
{
	[GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error)
	 {
		 GKPlayer* player= NULL;
		 for (GKPlayer* tempPlayer in playerArray)
		 {
			 if([tempPlayer.playerID isEqualToString: playerID])
			 {
				 player = tempPlayer;
				 break;
			 }
		 }
		 [self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg: player error: error];
	 }];
}

- (void)mapPlayerIDstoPlayers:(NSArray*)playerIDs
{
	[GKPlayer loadPlayersForIdentifiers: playerIDs withCompletionHandler:^(NSArray *playerArray, NSError *error)
	 {
         [self callDelegateOnMainThread: @selector(mappedPlayerIDs:error:) withArg: playerArray error: error];
	 }];
}

- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self callDelegate: selector withArg: arg error: err];
                   });
}


// Archivement
- (void)resetAchievements
{
	self->earnedAchievementCache = NULL;
	
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error)
	 {
		 if(error == NULL)
		 {
			 NSLog(@"Achievements have been reset");
             
		 }
		 else
		 {
			 NSLog(@"There was an error in resetting the achievements: %@", [error localizedDescription]);
		 }
	 }];
}


- (void)submitAchievement:(NSString*)identifier percentComplete:(double)percentComplete
{
	if(self->earnedAchievementCache == NULL)
	{
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *achievements, NSError *error)
		 {
			 if(error == NULL)
			 {
				 NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [achievements count]];
				 
				 for (GKAchievement* achievement in achievements)
				 {
					 [tempCache setObject: achievement forKey: achievement.identifier];
				 }
				 
				 self->earnedAchievementCache = tempCache;
				 [self submitAchievement: identifier percentComplete: percentComplete];
			 }
             
			 else
			 {
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: NULL error: error];
			 }
			 
		 }];
	}
	
	else
	{
		GKAchievement* achievement= [self->earnedAchievementCache objectForKey: identifier];
        
		if(achievement != NULL)
		{
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete))
			{
				achievement = NULL;
			}
			
			achievement.percentComplete = percentComplete;
		}
		
		else
		{
			achievement= [[GKAchievement alloc] initWithIdentifier: identifier];
			achievement.percentComplete= percentComplete;
            
			[self->earnedAchievementCache setObject: achievement forKey: achievement.identifier];
		}
        
		if(achievement!= NULL)
		{
            
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error)
			 {
				 if(error != nil)
				 {
					 [self storeAchievementToSubmitLater: achievement];
					 
				 }
				 
				 if(percentComplete >= 100)
				 {
					 [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler: ^(NSArray *descriptions, NSError *error)
                      {
                          for(GKAchievementDescription *achievementDescription in descriptions)
                          {
                              if([achievement.identifier isEqualToString: achievementDescription.identifier])
                              {
                                  [self callDelegateOnMainThread:@selector(achievementEarned:) withArg:achievementDescription error:nil];
                              }
                              
                          }
                          
                          
                      }];
				 }
				 
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
			 }];
		}
	}
}

-(void)populateAchievementCache
{
	if(self->earnedAchievementCache == NULL)
	{
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *achievements, NSError *error)
		 {
			 if(error == NULL)
			 {
				 NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [achievements count]];
				 
				 for (GKAchievement* achievement in achievements)
				 {
					 [tempCache setObject: achievement forKey: achievement.identifier];
				 }
				 
				 self->earnedAchievementCache = tempCache;
			 }
			 
			 else
			 {
				 NSLog(@"An error occurred while loading achievements: %@", [error localizedDescription]);
			 }
			 
		 }];
	}
}

-(void)storeAchievementToSubmitLater:(GKAchievement *)achievement
{
    //	NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"savedAchievements"]];
    
    NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedAchievements"] forKeys:nil];
	
	if([achievementDictionary objectForKey: achievement.identifier] == nil)
	{
		[achievementDictionary setObject:[NSNumber numberWithDouble: achievement.percentComplete] forKey:achievement.identifier];
	}
	
	else
	{
		double storedProgress = [[achievementDictionary objectForKey: achievement.identifier] doubleValue];
		
		if(achievement.percentComplete > storedProgress)
		{
			[achievementDictionary setObject:[NSNumber numberWithDouble: achievement.percentComplete] forKey:achievement.identifier];
		}
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:achievementDictionary forKey:@"savedAchievements"];
}


-(void)submitAllSavedAchievements
{
	NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] initWithDictionary: [[NSUserDefaults standardUserDefaults] objectForKey:@"savedAchievements"]];
	NSArray *keys = [achievementDictionary allKeys];
	
	for(int x = 0; x < [keys count]; x++)
	{
		[self submitAchievement:[keys objectAtIndex:x] percentComplete:[[achievementDictionary objectForKey: [keys objectAtIndex:x]] doubleValue]];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey: [keys objectAtIndex:x]];
	}
}

- (void)retrieveAchievementMetadata
{
	[GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler: ^(NSArray *descriptions, NSError *error)
     {
         [self callDelegateOnMainThread:@selector(achievementDescriptionsLoaded:error:) withArg:descriptions error:error];
     }];
}

-(GKAchievement *)achievementForIdentifier:(NSString *)identifier
{
	GKAchievement *achievement = [self->earnedAchievementCache objectForKey:identifier];
	
	if (achievement == nil)
	{
		achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
		[self->earnedAchievementCache setObject:achievement forKey:achievement.identifier];
	}
	
	return achievement;
}

-(double)percentageCompleteOfAchievementWithIdentifier:(NSString *)identifier
{
	
	if(self->earnedAchievementCache == NULL)
	{
		NSLog(@"Unable to determine achievement progress, local cache is empty");
        
	}
	
	else
	{
		GKAchievement* achievement= [self->earnedAchievementCache objectForKey: identifier];
        
		if(achievement != NULL)
		{
			return achievement.percentComplete;
		}
		
		else
		{
			return 0;
		}
	}
	
	return -1;
}

-(BOOL)achievementWithIdentifierIsComplete:(NSString *)identifier
{
	if([self percentageCompleteOfAchievementWithIdentifier: identifier] >= 100)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}


#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	assert([NSThread isMainThread]);
	if([delegate respondsToSelector: selector])
	{
		if(arg != NULL)
			[delegate performSelector: selector withObject: arg withObject: err];
		
		else
			[delegate performSelector: selector withObject: err];
	}
	
	//else
    //NSLog(@"Missed Method");
}


//=============================================================================================

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    
    [viewController dismissViewControllerAnimated:YES completion:Nil];
}


- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[viewController dismissViewControllerAnimated:YES completion:Nil];
}

//==========================================================================================

- (void)displayLeaderBoard:(UIViewController*) container{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL)
	{
		leaderboardController.category = @"RelaxMuzikWord.TotalPlayingTime";
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self;
		[container presentViewController:leaderboardController animated:YES completion:Nil];
	}
}

- (void)displayAchievement:(UIViewController*) container{
    GKAchievementViewController *achievementViewController = [[GKAchievementViewController alloc] init];
	[achievementViewController setAchievementDelegate:self];
    
	[container presentViewController:achievementViewController animated:YES completion:Nil];
}


//==========

- (void)processGameCenterAuthentication:(NSError*)error;
{
	if(error != nil)
		NSLog(@"An error occured during authentication: %@", [error localizedDescription]);
	else
		[self retrieveFriendsList];
}

- (void)friendsFinishedLoading:(NSArray *)friends error:(NSError *)error;
{
	if(error != nil)
		NSLog(@"An error occured during friends list request: %@", [error localizedDescription]);
	else
		[self playersForIDs: friends];
}

//================
static GameCenterLib* instance;

+(GameCenterLib*) Instance
{
    if (instance == nil) {
        if([GameCenterLib isGameCenterAvailable])
        {
            instance = [[GameCenterLib alloc] init];
            instance.delegate = instance;
            [instance authenticateLocalUser];
        }
    }
    
    return instance;
}

+ (void)DisplayLeaderBoard:(UIViewController*) container{
    if ([GameCenterLib Instance] == Nil) return;
    [[GameCenterLib Instance] displayLeaderBoard:container];
}

+ (void)DisplayAchievement:(UIViewController*) container{
    if ([GameCenterLib Instance] == Nil) return;
    [[GameCenterLib Instance] displayAchievement:container];
}

+ (void)ReportScore: (int64_t) score forCategory: (NSString*) category{
    if ([GameCenterLib Instance] == Nil) return;
    [[GameCenterLib Instance] reportScore:score forCategory:category];
}

+ (void)SubmitAchievement:(NSString*)identifier percentComplete:(double)percentComplete{
    if ([GameCenterLib Instance] == Nil) return;
    [[GameCenterLib Instance] submitAchievement:identifier percentComplete:percentComplete];
}

+ (void)SubmitAchievement:(NSString *)identifier currentPoint:(NSInteger)currentPoint achievementPoint:(NSInteger) achievementPoint
{
    if (currentPoint > achievementPoint){
        [self SubmitAchievement:identifier percentComplete:100];
    }else{
        double onePercent = achievementPoint/100;
        double percent = currentPoint/onePercent;
        [self SubmitAchievement:identifier percentComplete:percent];
    }
    
}


@end













