//
//  IAdBannerLib.m
//  DemoIAdBannerBasic
//
//  Created by popeveryday on 11/19/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import "IAdBannerLib.h"

@implementation IAdBannerLib
{
    UIViewController* containerVC;
}
-(id) initIAdOnViewController:(UIViewController*) container{
    
    containerVC = container;
    
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        self = [super initWithAdType:ADAdTypeBanner];
    } else {
        self = [super init];
    }
    
    if (self) {
        self.delegate = self;
        [containerVC.view addSubview:self];
    }
    
    return self;
}



- (void)ReloadLayout:(BOOL)animated
{
    CGRect contentFrame = containerVC.view.bounds;
    
    // all we need to do is ask the banner for a size that fits into the layout area we are using
    CGSize sizeForBanner = [self sizeThatFits:contentFrame.size];
    
    // compute the ad banner frame
    CGRect bannerFrame = self.frame;
    if (self.bannerLoaded) {
        
        // bring the ad into view
        contentFrame.size.height -= sizeForBanner.height;   // shrink down content frame to fit the banner below it
        bannerFrame.origin.y = contentFrame.size.height;
        bannerFrame.size.height = sizeForBanner.height;
        bannerFrame.size.width = sizeForBanner.width;
        
        // if the ad is available and loaded, shrink down the content frame to fit the banner below it,
        // we do this by modifying the vertical bottom constraint constant to equal the banner's height
        //
        NSLayoutConstraint *verticalBottomConstraint = self.bottomConstraint;
        verticalBottomConstraint.constant = sizeForBanner.height;
        [containerVC.view layoutSubviews];
        
    } else {
        // hide the banner off screen further off the bottom
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _contentView.frame = contentFrame;
        [_contentView layoutIfNeeded];
        self.frame = bannerFrame;
    }];
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self ReloadLayout:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError %@", error);
    [self ReloadLayout:YES];
    
    if (self.iadDelegate) {
        [self.iadDelegate iadBannerError:error];
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    if (self.iadDelegate) {
        [self.iadDelegate iadBannerDidFinish];
    }
}



@end
