//
//  SocialLib.m
//  DemoSocialFramework
//
//  Created by popeveryday on 11/26/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import "SocialLib.h"

@implementation SocialLib


+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message containerViewController:(UIViewController*) container
{
    return [self PostSocialMessageWithSLServiceType:type message:message embedUrlString:[[NSMutableArray alloc] init] embedImageNames:[[NSMutableArray alloc] init] containerViewController:container completeHandler:nil];
}

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSString*) url embedImageName:(NSString*) imageName containerViewController:(UIViewController*) container
{
    return [self PostSocialMessageWithSLServiceType:type message:message embedUrlString:[[NSMutableArray alloc] initWithObjects:url, nil] embedImageNames:[[NSMutableArray alloc] initWithObjects:imageName, nil] containerViewController:container completeHandler:nil];
}


+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSString*) url embedImageName:(NSString*) imageName containerViewController:(UIViewController*) container completeHandler:(SLComposeViewControllerCompletionHandler)completionHandler
{
    return [self PostSocialMessageWithSLServiceType:type message:message embedUrlString:[[NSMutableArray alloc] initWithObjects:url, nil] embedImageNames:[[NSMutableArray alloc] initWithObjects:imageName, nil] containerViewController:container completeHandler:completionHandler];
}

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSMutableArray*) urls embedImageNames:(NSMutableArray*) imageNames containerViewController:(UIViewController*) container
{
    return [self PostSocialMessageWithSLServiceType:type message:message embedUrlString:urls embedImageNames:imageNames containerViewController:container completeHandler:nil];
}

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSMutableArray*) urls embedImageNames:(NSMutableArray*) imageNames containerViewController:(UIViewController*) container completeHandler:(SLComposeViewControllerCompletionHandler)completionHandler
{
    SLComposeViewController *socialVC=[SLComposeViewController composeViewControllerForServiceType:type];
    
//    SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
//        [socialVC dismissViewControllerAnimated:YES completion:nil];
//        switch(result){
//            case SLComposeViewControllerResultDone: { NSLog(@"Posted...."); } break;
//            case SLComposeViewControllerResultCancelled: default: { NSLog(@"Posted...."); } break;
//        }};
    
    [socialVC setInitialText:message];
    
    if (completionHandler != Nil) {
        [socialVC setCompletionHandler:completionHandler];
    }
    
    for (NSString* url in urls) {
        [socialVC addURL:[NSURL URLWithString:url]];
    }
    
    for (NSString* image in imageNames) {
        [socialVC addImage:[UIImage imageNamed:image]];
    }
    
    [container presentViewController:socialVC animated:YES completion:nil];
    return [SLComposeViewController isAvailableForServiceType:type];
}



@end
