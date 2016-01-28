//
//  SocialLib.h
//  DemoSocialFramework
//
//  Created by popeveryday on 11/26/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface SocialLib : NSObject



+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSMutableArray*) urls embedImageNames:(NSMutableArray*) imageNames containerViewController:(UIViewController*) container completeHandler:(SLComposeViewControllerCompletionHandler)completionHandler;

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message containerViewController:(UIViewController*) container;

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSString*) url embedImageName:(NSString*) imageName containerViewController:(UIViewController*) container;

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSMutableArray*) urls embedImageNames:(NSMutableArray*) imageNames containerViewController:(UIViewController*) container;

+(BOOL) PostSocialMessageWithSLServiceType:(NSString*) type message:(NSString*) message embedUrlString:(NSString*) url embedImageName:(NSString*) imageName containerViewController:(UIViewController*) container completeHandler:(SLComposeViewControllerCompletionHandler)completionHandler;

@end

