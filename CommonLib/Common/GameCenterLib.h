//
//  GameCenterLib.h
//  DemoGameCenter
//
//  Created by popeveryday on 11/26/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameCenterLibDelegate <NSObject>
@optional
//- (void)processGameCenterAuthentication:(NSError*)error;
//- (void)friendsFinishedLoading:(NSArray *)friends error:(NSError *)error;
- (void)playerDataLoaded:(NSArray *)players error:(NSError *)error;
- (void)scoreReported: (NSError*) error;
- (void)leaderboardUpdated: (NSArray *)scores error:(NSError *)error;
- (void)mappedPlayerIDToPlayer:(GKPlayer *)player error:(NSError *)error;
- (void)mappedPlayerIDsToPlayers:(NSArray *)players error:(NSError *)error;
- (void)localPlayerScore:(GKScore *)score error:(NSError *)error;
- (void)achievementSubmitted:(GKAchievement *)achievement error:(NSError *)error;
- (void)achievementEarned:(GKAchievementDescription *)achievement;
- (void)achievementDescriptionsLoaded:(NSArray *)descriptions error:(NSError *)error;
@end

@interface GameCenterLib : NSObject <GameCenterLibDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
{
	id <GameCenterLibDelegate, NSObject> delegate;
    GKLocalPlayer *localPlayer;
    NSMutableDictionary* earnedAchievementCache;
}

@property(nonatomic, retain) id <GameCenterLibDelegate, NSObject> delegate;

+(GameCenterLib*) Instance;
+ (void)DisplayLeaderBoard:(UIViewController*) container;
+ (void)DisplayAchievement:(UIViewController*) container;
+ (void)ReportScore: (int64_t) score forCategory: (NSString*) category;
+ (void)SubmitAchievement:(NSString*)identifier percentComplete:(double)percentComplete;
+ (void)SubmitAchievement:(NSString *)identifier currentPoint:(NSInteger)currentPoint achievementPoint:(NSInteger) achievementPoint;

+ (BOOL)isGameCenterAvailable;
- (void)authenticateLocalUser;
- (void)callDelegateOnMainThread:(SEL)selector withArg:(id) arg error:(NSError*) err;
- (void)callDelegate:(SEL)selector withArg:(id)arg error:(NSError*) err;
- (void)retrieveFriendsList;
- (void)playersForIDs:(NSArray *)playerIDs;
- (void)playerforID:(NSString *)playerID;

- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)storeScoreForLater:(NSData *)scoreData;
- (void)submitAllSavedScores;
- (void)retrieveScoresForCategory:(NSString *)category withPlayerScope:(GKLeaderboardPlayerScope)playerScope timeScope:(GKLeaderboardTimeScope)timeScope withRange: (NSRange)range;
- (void)mapPlayerIDtoPlayer:(NSString*)playerID;
- (void)mapPlayerIDstoPlayers:(NSArray*)playerIDs;
- (void)retrieveLocalScoreForCategory:(NSString *)category;

- (void)submitAchievement:(NSString*)identifier percentComplete:(double)percentComplete;
- (double)percentageCompleteOfAchievementWithIdentifier:(NSString *)identifier;
- (BOOL)achievementWithIdentifierIsComplete:(NSString *)identifier;
- (void)populateAchievementCache;
- (void)resetAchievements;
- (void)retrieveAchievementMetadata;
- (void)storeAchievementToSubmitLater:(GKAchievement *)achievement;
- (void)submitAllSavedAchievements;

- (void)displayLeaderBoard:(UIViewController*) container;
- (void)displayAchievement:(UIViewController*) container;
@end

