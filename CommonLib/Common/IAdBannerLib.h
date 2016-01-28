//
//  IAdBannerLib.h
//  DemoIAdBannerBasic
//
//  Created by popeveryday on 11/19/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@protocol IAdBannerLibDelegate
- (void) iadBannerError:(NSError *)error;
- (void) iadBannerDidFinish;
@end

@interface IAdBannerLib : ADBannerView <ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic) id<IAdBannerLibDelegate> iadDelegate;

-(id) initIAdOnViewController:(UIViewController*) container;
- (void)ReloadLayout:(BOOL)animated;

@end


/** APPLY SOME EVENT WITH IAD
 
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    iad = [[IAdBannerLib alloc] initIAdOnViewController:self];
    iad.iadDelegate = self; // NEU MUON XEM ERROR, IMPLEMENT IAdBannerLibDelegate
}
 
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
 
- (void)viewDidLayoutSubviews
{
    [iad ReloadLayout:[UIView areAnimationsEnabled]];
}
 
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [iad ReloadLayout:animated];
}

 
**/