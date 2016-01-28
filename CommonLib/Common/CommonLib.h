//
//  CommonLib.h
//  CommonLib
//
//  Created by popeveryday on 11/6/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DateObject.h"
#import "StringLib.h"
#import "NetLib.h"
#import "MBProgressHUD.h"
@import MessageUI;
@import AssetsLibrary;


enum DisplayStyle{
    DisplayStyleReplace,
    DisplayStylePush,
    DisplayStylePresent,
};

@protocol AppSettingsDelegate <NSObject>
@optional
-(void) appSettingsDidFinishAction:(BOOL)isRequireReload;
-(void) appSettingsDidViewItemAtIndex:(NSInteger)currentIndex;

-(void) appSettingsDidFinishActionWithObject:(ReturnSet*)object;
@end



@interface CommonLib : NSObject
+(UIButton*) CreateButton:(NSString*)title frame:(CGRect)frame font:(NSString*) font fontSize: (CGFloat)size buttonType: (UIButtonType) buttonType backgroundColor: (UIColor*)backgroundColor foreColor:(UIColor*)foreColor  image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id) target selector:(SEL) selector;
+(UIButton*) CreateButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id) target selector:(SEL) selector;

+(UIButton*) CreateButton:(NSString*)title frame:(CGRect)frame font:(NSString*) font fontSize: (CGFloat)size buttonType: (UIButtonType) buttonType backgroundColor: (UIColor*)backgroundColor foreColor:(UIColor*)foreColor  imageName:(NSString*)image highlightedImageName:(NSString*)highlightedImage target:(id) target selector:(SEL) selector;
+(UIButton*) CreateButtonWithImageName:(NSString*)image highlightedImageName:(NSString*)highlightedImage target:(id) target selector:(SEL) selector;


+(void) AlertWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...;
+(void) AlertWithTitle:(NSString*) title message:(NSString*) message;
+(void) Alert:(NSString*) message;
+(UIAlertView*) AlertLoginBoxWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...;
+(UIAlertView*) AlertInputBoxWithTitle:(NSString*) title message:(NSString*) message container:(id)sender cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...;
+(UIAlertView*) AlertSecureInputBoxWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...;

+(void) ActionSheetWithTitle:(NSString*) title container:(id) container cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...;

+(void) ActionSheetWithTitle:(NSString*) title container:(id) container cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitlesArray:(NSArray*)otherButtonTitles;

+(void) ActionSheetWithTitle:(NSString*) title container:(UIView*) container delegate:(id)delegate cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitlesArray:(NSArray*)otherButtonTitles;

+(void)SetAppPreference:(NSString*) key value:(id)value;
+(void)SetAppPreference:(NSString*) key boolValue:(BOOL)value;
+(id)GetAppPreference:(NSString*)key defaultValue:(id)defaultValue;

+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName;
+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName frame:(CGRect) frame;
+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName sideLength:(float) sideLength;
+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName scale:(float) scale x:(float)x y:(float)y;
+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName scale:(float) scale center:(CGPoint)center;

+(void) SetLocationView:(UIView*)view x:(float) x y:(float)y;
+(void) SetScaleView:(UIView*) view scale:(float) scale alignCenter:(BOOL) alignCenter;
+(void) SetCenterView:(UIView*) view center:(CGPoint) center padding:(CGPoint)padding;


+(NSInteger) RandomFromInt:(NSInteger) from toInt:(NSInteger) to;
+(id) PopRandomItemFromArray:(NSMutableArray*) array;
+(id) PopFirstItemFromArray:(NSMutableArray*) array;
+(void) ShufflingArray:(NSMutableArray*) array;
+ (UIColor *)ColorFromHexString:(NSString *)hexString alpha:(float) alpha;

+(MBProgressHUD*)ShowInformBoxNoInternet:(UIView*)uiview;
+(MBProgressHUD*)ShowInformBoxNoInternetPullDownToRefresh:(UIView*)uiview;
+(MBProgressHUD*)ShowInformBoxWithTitle:(NSString*)title detailText:(NSString*)detailText uiview:(UIView*)uiview delegate:(id<MBProgressHUDDelegate>) delegate;
+(void) HideInformBox:(UIView*) uiview;
+(void) HideInformBox:(UIView*) uiview afterDelay:(NSTimeInterval) delay;

+(void)ShowLoadingWhileExecuting:(SEL)method withObject:(id)object onTarget:(id)target displayOnView:(UIView*)uiview;
+(void)ShowLoadingWhileExecuting:(SEL)method withObject:(id)object onTargetAndViewController:(UIViewController*) controller;
+(void)ShowLoadingWhileExecuting:(SEL)method withObject:(id)object onTarget:(id)target title:(NSString*) title detailText:(NSString*)detailText displayOnView:(UIView*)uiview delegate:(id<MBProgressHUDDelegate>)delegate;

+(MBProgressHUD*) ShowLoading:(UIView*) container;
+(MBProgressHUD*)ShowLoadingWithTitle:(NSString*)title detailText:(NSString*)detailText uiview:(UIView*)uiview container:(id<MBProgressHUDDelegate>)container;
+(void)HideLoadingWithHUD:(MBProgressHUD*) loading;
+(void) HideLoading:(UIView*) container;


+(void) AddObserverBecomeActiveForObject:(id) container activeSelector:(SEL)activeSelector;
+(void) SlideViewUpForTextfield:(UITextField*) textField viewContainer:(UIView*)view isOn:(BOOL)isOn;

+(void) EmailWithAttachments:(NSMutableArray*) attachments viewContainer:(id)container delegate:(id<MFMailComposeViewControllerDelegate>) delegate;



+(BOOL) AlertInternetConnectionStatusWithTitle:(NSString*) title message:(NSString*)message;
+(BOOL) AlertInternetConnectionStatus;

+(NSArray*) AlertUpgrageFeaturesWithContainer:(id)container isIncludeRestoreButton:(BOOL)isIncludeRestoreButton;
+(NSArray*) AlertUpgrageFeaturesUnlimitWithContainer:(id)container limitMessage:(NSString*)limitMessage isIncludeRestoreButton:(BOOL)isIncludeRestoreButton;
+(NSArray*) AlertUpgrageProVersionWithContainer:(id)container featuresMessage:(NSString*)featuresMessage isIncludeRestoreButton:(BOOL)isIncludeRestoreButton;

+(NSArray*) SortArrayIndexPath:(NSArray*) arr ascending:(BOOL) ascending;
+(void) CreateSnowInView:(UIView*)view;

+(UIDocumentInteractionController*) ShowOpenInWithFile:(NSString*)filePath container:(UIView*)container delegate:(id<UIDocumentInteractionControllerDelegate>)delegate;
+(UIDocumentInteractionController*) ShowOpenInWithFile:(NSString*)filePath containerBarButton:(UIBarButtonItem*)container delegate:(id<UIDocumentInteractionControllerDelegate>)delegate;

+(void) FixNavigationBarCoverContent:(UIViewController*) controller;
+(void) FixNavigationBarCoverContent:(UIViewController*) controller isFixed:(BOOL)isFixed;
+(void) SetNavigationBarColor:(UIColor*)color tintColor:(UIColor*)tintColor foregroundColor:(UIColor*)foregroundColor viewController:(UIViewController*)controller;
+(void) SetToolbarColor:(UIColor*)color tintColor:(UIColor*)tintColor viewController:(UIViewController*)controller;

+(UIEdgeInsets) CollectionEdgeInsectFromHashString:(NSString*) hashString;
+(NSString*) SimulatorAppDirectoryPath;

+(void) SetNavigationBarColorHex:(NSString*)hexcolor viewController:(UIViewController*)controller;
+(void) SetNavigationBarColor:(UIColor*)color viewController:(UIViewController*)controller;
+(BOOL) IsRootViewController:(UIViewController*)controller;

+(void)BoldFontIOS7ForLabel:(UILabel *)label;

+(void) DisplayPopoverController:(UIViewController*)view container:(UIViewController<UIPopoverControllerDelegate> *)container displayTarget:(id) displayTarget isIphonePushView:(BOOL) isIphonePushView;
+(void) DisplayPopoverController:(UIViewController*)view container:(UIViewController<UIPopoverControllerDelegate> *)container displayTarget:(id) displayTarget isIphonePushView:(BOOL) isIphonePushView isEmbedNavigationController:(BOOL) isEmbedNavigationController;
+(void) DisplayPopoverController:(UIViewController*)view container:(UIViewController<UIPopoverControllerDelegate> *)container displayTarget:(id) displayTarget isIphonePushView:(BOOL) isIphonePushView isEmbedNavigationController:(BOOL) isEmbedNavigationController customSize:(CGSize) customSize;

+ (NSString *) deviceModelType;

+(NSString*)localizedText:(NSString*)text languageCode:(NSString*)code;
+(void)localizedDefaulLanguageCode:(NSString*)code;

+(void)presentViewWithStorboardName:(NSString*)storyboardName storyboardViewID:(NSString*)viewID currentViewController:(UIViewController*)viewController displayStyle:(enum DisplayStyle) displayStyle prepareBlock:(void(^)(UIViewController* destinationVC))prepareBlock completeBlock:(void(^)())completeBlock;
@end
