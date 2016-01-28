//
//  CommonLib.m
//  CommonLib
//
//  Created by popeveryday on 11/6/13.
//  Copyright (c) 2013 Lapsky. All rights reserved.
//

#import "CommonLib.h"
#import <sys/sysctl.h>


@implementation CommonLib
+(UIButton*) CreateButton:(NSString*)title frame:(CGRect)frame font:(NSString*) font fontSize: (CGFloat)size buttonType: (UIButtonType) buttonType backgroundColor: (UIColor*)backgroundColor foreColor:(UIColor*)foreColor  imageName:(NSString*)image highlightedImageName:(NSString*)highlightedImage target:(id) target selector:(SEL) selector
{
    return [self CreateButton:title frame:frame font:font fontSize:size buttonType:buttonType backgroundColor:backgroundColor foreColor:foreColor image: image != nil ? [UIImage imageNamed:image] : nil highlightedImage: highlightedImage != nil ? [UIImage imageNamed:highlightedImage] : nil target:target selector:selector];
}

+(UIButton*) CreateButton:(NSString*)title frame:(CGRect)frame font:(NSString*) font fontSize: (CGFloat)size buttonType: (UIButtonType) buttonType backgroundColor: (UIColor*)backgroundColor foreColor:(UIColor*)foreColor  image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id) target selector:(SEL) selector
{
    UIButton *myButton = [UIButton buttonWithType:buttonType];
    
    myButton.frame = frame; // position in the parent view and set the size of the button
    
    if (backgroundColor != nil) {
        myButton.backgroundColor = backgroundColor;
    }
    
    if (foreColor != nil) {
        [myButton setTitleColor: foreColor forState:UIControlStateNormal];
    }
    
    if ( [StringLib IsValid:font] && size > 0 ) {
        myButton.titleLabel.font = [UIFont fontWithName:font size:size];
    }else if(size > 0){
        myButton.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    
    myButton.titleLabel.numberOfLines = 0;
    myButton.userInteractionEnabled = YES;
    
    if (title != nil) {
        [myButton setTitle:title forState:UIControlStateNormal];
    }
    
    
    if (selector != nil && target != nil) {
        [myButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (image != nil) {
        [myButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (highlightedImage != nil) {
        [myButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    return myButton;
}

+(UIButton*) CreateButtonWithImageName:(NSString*)image highlightedImageName:(NSString*)highlightedImage target:(id) target selector:(SEL) selector
{
    UIImage* img = [UIImage imageNamed:image];
    
    return [CommonLib CreateButton:nil frame:CGRectMake(0, 0, img.size.width, img.size.height) font:nil fontSize:18 buttonType:UIButtonTypeCustom backgroundColor:nil foreColor:nil imageName:image highlightedImageName:highlightedImage target:target selector:selector];
}

+(UIButton*) CreateButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id) target selector:(SEL) selector
{
    return [CommonLib CreateButton:nil frame:CGRectMake(0, 0, image.size.width, image.size.height) font:nil fontSize:18 buttonType:UIButtonTypeCustom backgroundColor:nil foreColor:nil image:image highlightedImage:highlightedImage target:target selector:selector];
}




+(void) AlertWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:container
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    
    if (otherButtonTitles != nil)
    {
        [alert addButtonWithTitle:otherButtonTitles];
        
        va_list args;
        va_start(args, otherButtonTitles);
        NSString* name;
        while ((name = va_arg(args, NSString*))) {
            if (name != nil && ![name isEqualToString:@""]) {
                [alert addButtonWithTitle: name];
            }
        }
        
        
        
        
        va_end(args);
    }
    
    [alert show];
    
}

+(void) AlertWithTitle:(NSString*) title message:(NSString*) message
{
    [CommonLib AlertWithTitle:title message:message container:nil cancelButtonTitle:LocalizedText(@"OK",nil) otherButtonTitles:nil];
    
}

+(void) Alert:(NSString*) message
{
    [CommonLib AlertWithTitle: LocalizedText(@"Message",nil) message:message container:nil cancelButtonTitle: LocalizedText(@"OK",nil) otherButtonTitles:nil];
}

+(UIAlertView*) AlertLoginBoxWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:container
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    if (otherButtonTitles != nil) {
        va_list args;
        va_start(args,otherButtonTitles);
        NSString* name = va_arg(args, NSString*);
        if (name != nil && ![name isEqualToString:@""]) {
            [alert addButtonWithTitle: name];
        }
        va_end(args);
    }
    
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [alert show];
    
    return alert;
}

+(UIAlertView*) AlertInputBoxWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:container
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    if (otherButtonTitles != nil) {
        va_list args;
        va_start(args,otherButtonTitles);
        NSString* name = va_arg(args, NSString*);
        if (name != nil && ![name isEqualToString:@""]) {
            [alert addButtonWithTitle: name];
        }
        va_end(args);
    }
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    [alert show];
    
    return alert;
}

+(UIAlertView*) AlertSecureInputBoxWithTitle:(NSString*) title message:(NSString*) message container:(id)container cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:container
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    if (otherButtonTitles != nil) {
        va_list args;
        va_start(args,otherButtonTitles);
        NSString* name = va_arg(args, NSString*);
        if (name != nil && ![name isEqualToString:@""]) {
            [alert addButtonWithTitle: name];
        }
        va_end(args);
    }
    
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    [alert show];
    
    return alert;
}


+(void) ActionSheetWithTitle:(NSString*) title container:(id) container cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSString*) otherButtonTitles,...
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:container
                                                    cancelButtonTitle: nil
                                               destructiveButtonTitle:destructiveButtonTitle
                                                    otherButtonTitles:otherButtonTitles,nil];
    
    if (otherButtonTitles != nil) {
        va_list args;
        va_start(args,otherButtonTitles);
        NSString* name = va_arg(args, NSString*);
        if (name != nil && ![name isEqualToString:@""]) {
            [actionSheet addButtonWithTitle: name];
        }
        va_end(args);
    }
    
    [actionSheet addButtonWithTitle:cancelButtonTitle];
    actionSheet.cancelButtonIndex = [actionSheet.subviews count] - 2;
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView: [container view]];
}

+(void) ActionSheetWithTitle:(NSString*) title container:(id) container cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitlesArray:(NSArray*)otherButtonTitles
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                             delegate: container
                                                    cancelButtonTitle: nil
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: nil];
    
    
    if ( [StringLib IsValid:destructiveButtonTitle] ) {
        [actionSheet addButtonWithTitle:destructiveButtonTitle];
        [actionSheet setDestructiveButtonIndex:0];
    }
    
    if (otherButtonTitles != nil) {
        for (NSString* name in otherButtonTitles) {
            [actionSheet addButtonWithTitle: name];
        }
    }
    
    [actionSheet addButtonWithTitle:cancelButtonTitle];
    [actionSheet setCancelButtonIndex: actionSheet.subviews.count - 2 ];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView: [container view]];
}

+(void) ActionSheetWithTitle:(NSString*) title container:(UIView*) container delegate:(id)delegate cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitlesArray:(NSArray*)otherButtonTitles
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                             delegate: delegate
                                                    cancelButtonTitle: nil
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: nil];
    
    
    if ( [StringLib IsValid:destructiveButtonTitle] ) {
        [actionSheet addButtonWithTitle:destructiveButtonTitle];
        [actionSheet setDestructiveButtonIndex:0];
    }
    
    if (otherButtonTitles != nil) {
        for (NSString* name in otherButtonTitles) {
            [actionSheet addButtonWithTitle: name];
        }
    }
    
    [actionSheet addButtonWithTitle:cancelButtonTitle];
    [actionSheet setCancelButtonIndex: actionSheet.subviews.count - 1 ];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView: container];
}

+(void)SetAppPreference:(NSString*) key value:(id)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(void)SetAppPreference:(NSString*) key boolValue:(BOOL)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+(id)GetAppPreference:(NSString*)key defaultValue:(id)defaultValue{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id value = [userDefaults objectForKey:key];
    
    if( value == nil && defaultValue != nil){
        [self SetAppPreference:key value:defaultValue];
        return defaultValue;
    }
    
    return value;
}



+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName{
    UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    return view;
}

+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName frame:(CGRect) frame{
    UIImageView* view = [self CreateImageViewWithNamed:imageName];
    view.frame = frame;
    return view;
}

+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName sideLength:(float) sideLength{
    UIImageView* view = [self CreateImageViewWithNamed:imageName];
    float scale = sideLength/view.image.size.width;
    view.frame = CGRectMake(0,0,view.image.size.width*scale, view.image.size.height*scale);
    return view;
}

+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName scale:(float) scale x:(float)x y:(float)y{
    UIImageView* view = [self CreateImageViewWithNamed:imageName];
    view.frame = CGRectMake(x,y,view.image.size.width*scale, view.image.size.height*scale);
    return view;
}

+(UIImageView*) CreateImageViewWithNamed:(NSString*) imageName scale:(float) scale center:(CGPoint)center{
    UIImageView* view = [self CreateImageViewWithNamed:imageName scale:scale x:0 y:0];
    view.center = center;
    return view;
}





+(void) SetLocationView:(UIView*)view x:(float) x y:(float)y{
    view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
}

+(void) SetScaleView:(UIView*) view scale:(float) scale alignCenter:(BOOL) alignCenter{
    if(alignCenter){
        CGPoint center = view.center;
        view.frame = CGRectMake(0,0,view.frame.size.width*scale, view.frame.size.height*scale);
        view.center = center;
    }else{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width*scale, view.frame.size.height*scale);
    }
}

+(void) SetCenterView:(UIView*) view center:(CGPoint) center padding:(CGPoint)padding{
    view.center = CGPointMake(center.x + padding.x , center.y + padding.y);
}



+(NSInteger) RandomFromInt:(NSInteger) from toInt:(NSInteger) to{
    return (( arc4random()%(to-from+1)) + from);
}

+(id) PopRandomItemFromArray:(NSMutableArray*) array
{
    id item;
    
    for (int i = 0; i <=[CommonLib RandomFromInt:0 toInt:array.count]; i++) {
        item = [array objectAtIndex:[CommonLib RandomFromInt:0 toInt:array.count-1]];
    }
    
    [array removeObject:item];
    return item;
}

+(id) PopFirstItemFromArray:(NSMutableArray*) array{
    if (array.count == 0) return nil;
    id item = [array objectAtIndex:0];
    [array removeObjectAtIndex:0];
    return item;
}

+(void) ShufflingArray:(NSMutableArray *) array
{
    NSInteger count = [array count];
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger swap = [CommonLib RandomFromInt:0 toInt:count-1];
        [array exchangeObjectAtIndex:swap withObjectAtIndex:i];
    }
}


+ (UIColor *)ColorFromHexString:(NSString *)hexString alpha:(float) alpha{
    unsigned rgbValue = 0;
    
    if ( [StringLib IndexOf:@"#" inString:hexString] != 0 ) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}



+(MBProgressHUD*)ShowInformBoxNoInternet:(UIView*)uiview
{
    return [self ShowInformBoxWithTitle:LocalizedText(@"No Internet",nil) detailText:LocalizedText(@"Please check your internet connection\nand try again.",nil) uiview:uiview delegate:nil];
}

+(MBProgressHUD*)ShowInformBoxNoInternetPullDownToRefresh:(UIView*)uiview
{
    return [self ShowInformBoxWithTitle:LocalizedText(@"No Internet",nil) detailText:LocalizedText(@"Please check your internet connection\nand pull down to refresh.",nil) uiview:uiview delegate:nil];
}

+(MBProgressHUD*)ShowInformBoxWithTitle:(NSString*)title detailText:(NSString*)detailText uiview:(UIView*)uiview delegate:(id<MBProgressHUDDelegate>) delegate
{
    MBProgressHUD* loading;
    NSInteger indicatorTag = 12345679;
    
    if ([uiview viewWithTag:indicatorTag]) {
        loading = (MBProgressHUD*)[uiview viewWithTag:indicatorTag];
    }else{
        loading = [[MBProgressHUD alloc] initWithView:uiview];
        [uiview addSubview:loading];
        if(delegate != nil) loading.delegate = delegate;
        loading.tag = indicatorTag;
        loading.mode = MBProgressHUDModeText;
        loading.animationType = MBProgressHUDAnimationFade;
    }
    
    loading.labelText = title == nil ? LocalizedText(@"Loading",nil) : title;
    loading.detailsLabelText = detailText == nil ? LocalizedText(@"please wait",nil) : detailText;
    [loading show:YES];
    
    return loading;
}

+(void) HideInformBox:(UIView*) uiview{
    [self HideInformBox:uiview afterDelay:0];
}

+(void) HideInformBox:(UIView*) uiview afterDelay:(NSTimeInterval) delay{
    MBProgressHUD* loading;
    NSInteger indicatorTag = 12345679;
    
    if ([uiview viewWithTag:indicatorTag]) {
        loading = (MBProgressHUD*)[uiview viewWithTag:indicatorTag];
        if (delay > 0) {
            [loading hide:YES afterDelay:delay];
        }else{
            [loading hide:YES];
        }
        
    }
}

+(void)ShowLoadingWhileExecuting:(SEL)method withObject:(id)object onTarget:(id)target displayOnView:(UIView*)uiview
{
    [self ShowLoadingWhileExecuting:method withObject:object onTarget:target title:nil detailText:nil displayOnView:uiview delegate:nil];
}

+(void)ShowLoadingWhileExecuting:(SEL)method withObject:(id)object onTargetAndViewController:(UIViewController*) controller
{
    [self ShowLoadingWhileExecuting:method withObject:object onTarget:controller title:nil detailText:nil displayOnView:controller.view delegate:nil];
}

+(void)ShowLoadingWhileExecuting:(SEL)method withObject:(id)object onTarget:(id)target title:(NSString*) title detailText:(NSString*)detailText displayOnView:(UIView*)uiview delegate:(id<MBProgressHUDDelegate>)delegate
{
    MBProgressHUD* loading = [[MBProgressHUD alloc] initWithView:uiview];
    [uiview addSubview:loading];
    
    if (delegate != nil) {
        loading.delegate = delegate;
    }
    
    loading.labelText = title == nil ? LocalizedText(@"Loading",nil) : title;
    loading.detailsLabelText = detailText == nil ? LocalizedText(@"please wait",nil) : detailText;
    loading.square = YES;
	
	[loading showWhileExecuting:method onTarget:target withObject:object animated:YES];
}

+(void)HideLoadingWithHUD:(MBProgressHUD*) loading{
    [loading hide:YES];
}

+(MBProgressHUD*)ShowLoadingWithTitle:(NSString*)title detailText:(NSString*)detailText uiview:(UIView*)uiview container:(id<MBProgressHUDDelegate>)container
{
    MBProgressHUD* loading;
    NSInteger indicatorTag = 12345678;
    
    if ([uiview viewWithTag:indicatorTag]) {
        loading = (MBProgressHUD*)[uiview viewWithTag:indicatorTag];
    }else{
        loading = [[MBProgressHUD alloc] initWithView:uiview];
        [uiview addSubview:loading];
        if(container != nil) loading.delegate = container;
        loading.tag = indicatorTag;
        loading.square = YES;
    }
    loading.square = YES;
    loading.labelText = title == nil ? LocalizedText(@"Loading",nil) : title;
    loading.detailsLabelText = detailText == nil ? LocalizedText( @"please wait" ,nil) : detailText;
    [loading show:YES];
    
    return loading;
}

+(MBProgressHUD*) ShowLoading:(UIView*) container{
    return [self ShowLoadingWithTitle:nil detailText:nil uiview:container container:nil];
}

+(void) HideLoading:(UIView*) container{
    MBProgressHUD* loading;
    NSInteger indicatorTag = 12345678;
    
    
    if ([container viewWithTag:indicatorTag]) {
        loading = (MBProgressHUD*)[container viewWithTag:indicatorTag];
        [loading hide:YES];
    }
}

+(void) AddObserverBecomeActiveForObject:(id) container activeSelector:(SEL)activeSelector {
    [[NSNotificationCenter defaultCenter] addObserver:container
                                             selector:activeSelector
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:Nil];
}


+(void) SlideViewUpForTextfield:(UITextField*) textField viewContainer:(UIView*)view isOn:(BOOL)isOn{
    
    const CGFloat KEYBOARD_ANIMATION_DURATION = 0.2;
    const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
    const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
    const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
    const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
    
    CGRect viewFrame = view.frame;
    
    if (isOn) {
        CGRect textFieldRect = [view.window convertRect:textField.bounds fromView:textField];
        CGRect viewRect = [view.window convertRect:view.bounds fromView:view];
        CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
        CGFloat heightFraction = numerator / denominator;
        
        
        
        if (heightFraction < 0.0) heightFraction = 0.0;
        else if (heightFraction > 1.0) heightFraction = 1.0;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGFloat subviewHeight = (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) ? PORTRAIT_KEYBOARD_HEIGHT : LANDSCAPE_KEYBOARD_HEIGHT;
        
        //neu co inputview (picker, datepicker) subview height ko doi so voi portrait height
        if (textField.inputView != Nil) {
            subviewHeight = PORTRAIT_KEYBOARD_HEIGHT;
        }
        
        // neu chu bi che thi cho animatedDistance = 0;
        if (view.bounds.size.height - subviewHeight > textFieldRect.origin.y) {
            subviewHeight = 0;
        }
        
        
        
        int animatedDistance = floor(subviewHeight * heightFraction);
        view.accessibilityHint = [NSString stringWithFormat:@"%d", animatedDistance];
        
        viewFrame.origin.y -= animatedDistance;
    }else{
        int animatedDistance = [view.accessibilityHint intValue];
        view.accessibilityHint = @"";
        viewFrame.origin.y += animatedDistance;
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [view setFrame:viewFrame];
    [UIView commitAnimations];
}

+(void) EmailWithAttachments:(NSMutableArray*) attachments viewContainer:(id)container delegate:(id<MFMailComposeViewControllerDelegate>) delegate{
    
    NSData *imageData;
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if(delegate != nil) [controller setMailComposeDelegate:delegate];
    
    NSInteger counter = 1;
    if (attachments != nil) {
        for (NSString* attachment in attachments) {
            imageData = [NSData dataWithContentsOfFile:attachment];
            [controller addAttachmentData:imageData
                                 mimeType:[NSString stringWithFormat:@"image/%@", [attachment.pathExtension.lowercaseString stringByReplacingOccurrencesOfString:@"jpg" withString:@"jpeg"]]
                                 fileName:[NSString stringWithFormat:@"Image_%ld.%@", (long)counter, attachment.pathExtension.lowercaseString]];
            counter++;
        }
    }
    
    [controller setMessageBody:@"Image attached" isHTML:NO];
    
    if ([container navigationController] != nil) {
        [[container navigationController] presentViewController:controller animated:YES completion:nil];
    }
}



+(BOOL) AlertInternetConnectionStatusWithTitle:(NSString*) title message:(NSString*)message{
    if (![NetLib IsInternetAvailable]) {
        [CommonLib AlertWithTitle: title == nil ? LocalizedText(@"Connection error",nil) : title message: message == nil ? LocalizedText(@"Unable to connect with the server.\nCheck your internet connection and try again.",nil) : message ];
        return NO;
    }
    return YES;
}

+(BOOL) AlertInternetConnectionStatus{
    return [self AlertInternetConnectionStatusWithTitle:nil message:nil];
}

+(NSArray*) AlertUpgrageFeaturesWithContainer:(id)container isIncludeRestoreButton:(BOOL)isIncludeRestoreButton{
    [CommonLib AlertWithTitle:LocalizedText( @"Upgrage Required" ,nil) message:LocalizedText( @"To unlock this feature you need to upgrade to pro version. Would you like to upgrade now?" ,nil) container:container cancelButtonTitle:LocalizedText( @"Later" ,nil) otherButtonTitles:LocalizedText( @"Yes, upgrade now" ,nil), isIncludeRestoreButton ? LocalizedText( @"Restore purchases" ,nil) : nil, nil];
    return @[LocalizedText( @"Yes, upgrade now" ,nil), LocalizedText( @"Restore purchases" ,nil)];
}

+(NSArray*) AlertUpgrageFeaturesUnlimitWithContainer:(id)container limitMessage:(NSString*)limitMessage isIncludeRestoreButton:(BOOL)isIncludeRestoreButton
{
    NSString* message = LocalizedText(@"To use unlimited features you need to upgrade to pro version. Would you like to upgrade now?",nil);
    if ( [StringLib IsValid:limitMessage] ) {
        message = [NSString stringWithFormat:@"%@\n%@",limitMessage, message];
    }
    
    
    [CommonLib AlertWithTitle:LocalizedText(@"Upgrage Required",nil) message: message container:container cancelButtonTitle:LocalizedText(@"Later",nil) otherButtonTitles:LocalizedText(@"Yes, upgrade now",nil), isIncludeRestoreButton ? LocalizedText(@"Restore purchases",nil) : nil, nil];
    
    return @[LocalizedText(@"Yes, upgrade now",nil), LocalizedText(@"Restore purchases",nil)];
}

+(NSArray*) AlertUpgrageProVersionWithContainer:(id)container featuresMessage:(NSString*)featuresMessage isIncludeRestoreButton:(BOOL)isIncludeRestoreButton
{
    NSString* message = LocalizedText(@"Purchase to unlock following features?",nil);
    
    if ( [StringLib IsValid:featuresMessage] ) {
        message = [NSString stringWithFormat:@"%@\n%@", message, featuresMessage];
    }else{
        message = LocalizedText(@"Purchase to unlock full features?",nil);
    }
    
    
    [CommonLib AlertWithTitle:LocalizedText(@"Upgrage to Pro Version",nil) message: message container:container cancelButtonTitle:LocalizedText(@"Later",nil) otherButtonTitles:LocalizedText(@"Yes, upgrade now",nil), isIncludeRestoreButton ? LocalizedText(@"Restore purchases",nil) : nil, nil];
    
    return @[LocalizedText(@"Yes, upgrade now",nil), LocalizedText(@"Restore purchases",nil)];
}

+(NSArray*) SortArrayIndexPath:(NSArray*) arr ascending:(BOOL) ascending{
    NSArray* sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger r1 = [obj1 row];
        NSInteger r2 = [obj2 row];
        
        if (r1 < r2) {
            return ascending ? (NSComparisonResult)NSOrderedAscending : (NSComparisonResult)NSOrderedDescending;
        }
        if (r1 > r2) {
            return ascending ? (NSComparisonResult)NSOrderedDescending : (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}

+(void) CreateSnowInView:(UIView*)view{
    //snow builder
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer]; // 1
    emitterLayer.emitterPosition = CGPointMake(view.bounds.size.width / 2, view.bounds.origin.y - 300); // 2
    emitterLayer.emitterZPosition = 10; // 3
    emitterLayer.emitterSize = CGSizeMake(view.bounds.size.width, 0); // 4
    emitterLayer.emitterShape = kCAEmitterLayerSphere; // 5
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
    emitterCell.scale = 0.2; // 7
    emitterCell.scaleRange = 0.7; // 8
    emitterCell.emissionRange = (CGFloat)M_PI_2; // 9
    emitterCell.lifetime = 100.0; // 10
    emitterCell.birthRate = 40; // 11
    emitterCell.velocity = 10; // 12
    emitterCell.velocityRange = 300; // 13
    emitterCell.yAcceleration = 1; // 14
    
    emitterCell.contents = (id)[[UIImage imageNamed:@"CommonLib.bundle/snow"] CGImage]; // 15
    emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell]; // 16
    [view.layer addSublayer:emitterLayer]; // 17
}

+(UIDocumentInteractionController*) ShowOpenInWithFile:(NSString*)filePath container:(UIView*)container delegate:(id<UIDocumentInteractionControllerDelegate>)delegate
{
    
    
    if ( !IsOpenInAvailable(filePath) )
        return nil;
    
    UIDocumentInteractionController* documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    if(delegate != nil) documentController.delegate = delegate;
    
    Hashtable* identifier = [StringLib DeparseString:GC_OpenIn_Identifiers];
    
    
    documentController.UTI = [identifier Hashtable_GetValueForKey:[[filePath pathExtension] uppercaseString]] ;
    
    [documentController presentOpenInMenuFromRect:CGRectZero
                                           inView:container
                                         animated:YES];
    
    return documentController;
}

+(UIDocumentInteractionController*) ShowOpenInWithFile:(NSString*)filePath containerBarButton:(UIBarButtonItem*)container delegate:(id<UIDocumentInteractionControllerDelegate>)delegate
{
    
    
    if ( !IsOpenInAvailable(filePath) )
        return nil;
    
    UIDocumentInteractionController* documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    if(delegate != nil) documentController.delegate = delegate;
    
    Hashtable* identifier = [StringLib DeparseString:GC_OpenIn_Identifiers];
    
    
    documentController.UTI = [identifier Hashtable_GetValueForKey:[[filePath pathExtension] uppercaseString]] ;
    
    [documentController presentOpenInMenuFromBarButtonItem:container animated:YES];
    
    return documentController;
}

+(void) FixNavigationBarCoverContent:(UIViewController*) controller{
    [self FixNavigationBarCoverContent:controller isFixed:YES];
}

+(void) FixNavigationBarCoverContent:(UIViewController*) controller isFixed:(BOOL)isFixed{
    controller.navigationController.navigationBar.translucent = isFixed ? NO : YES;
    if ([controller respondsToSelector:@selector(edgesForExtendedLayout)])
        controller.edgesForExtendedLayout = isFixed ? UIRectEdgeNone : UIRectEdgeAll;
}

+(UIEdgeInsets) CollectionEdgeInsectFromHashString:(NSString*) hashString
{
    //structure hashString device = top, left, bottom, right
    //example @"iphonehd = 5, 20, 5, 20 & iphonehd5 = 5, 20, 5, 20 &...."
    
    Hashtable* hash = [StringLib DeparseString:hashString];
    
    NSString* rs = [hash Hashtable_GetValueForKey:GC_MobileAds_Device];
    
    if (rs == nil) {
        NSLog(@"CommonLib > GetCollectionEdgeInsectFromHashString > Cannot find EdgeInsect for device %@", GC_MobileAds_Device);
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    NSArray* parts = [rs componentsSeparatedByString:@","];
    
    CGFloat top = [parts[0] floatValue];
    CGFloat left = [parts[1] floatValue];
    CGFloat bottom = [parts[2] floatValue];
    CGFloat right = [parts[3] floatValue];
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

+(NSString*) SimulatorAppDirectoryPath{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject] path];
}

+(void) SetNavigationBarColorHex:(NSString*)hexcolor viewController:(UIViewController*)controller{
    [self SetNavigationBarColor:[self ColorFromHexString:hexcolor alpha:1] viewController:controller];
}

+(void) SetNavigationBarColor:(UIColor*)color viewController:(UIViewController*)controller
{
    [self SetNavigationBarColor:color tintColor:[UIColor whiteColor] foregroundColor:[UIColor whiteColor] viewController:controller];
}

+(void) SetNavigationBarColor:(UIColor*)color tintColor:(UIColor*)tintColor foregroundColor:(UIColor*)foregroundColor viewController:(UIViewController*)controller{
    [controller.navigationController.navigationBar setBarTintColor:color];
    [controller.navigationController.navigationBar setTintColor:tintColor];
    [controller.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : foregroundColor}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //View controller-based status bar appearance -> NO (INFO.PLIST)
}

+(void) SetToolbarColor:(UIColor*)color tintColor:(UIColor*)tintColor viewController:(UIViewController*)controller{
    [controller.navigationController.toolbar setBarTintColor:color];
    [controller.navigationController.toolbar setTintColor:[UIColor whiteColor]];
    
    //View controller-based status bar appearance -> NO (INFO.PLIST)
}

//check if this vc is root view controller or is push from navigation controller
+(BOOL) IsRootViewController:(UIViewController*)controller{
    UIViewController *vc = [[controller.navigationController viewControllers] firstObject];
    return [vc isEqual: controller];
}

+(void)BoldFontIOS7ForLabel:(UILabel *)label
{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}



+(void) DisplayPopoverController:(UIViewController*)view container:(UIViewController<UIPopoverControllerDelegate> *)container displayTarget:(id) displayTarget isIphonePushView:(BOOL) isIphonePushView
{
    [self DisplayPopoverController:view container:container displayTarget:displayTarget isIphonePushView:isIphonePushView isEmbedNavigationController:NO];
}

+(void) DisplayPopoverController:(UIViewController*)view container:(UIViewController<UIPopoverControllerDelegate> *)container displayTarget:(id) displayTarget isIphonePushView:(BOOL) isIphonePushView isEmbedNavigationController:(BOOL) isEmbedNavigationController
{
    [self DisplayPopoverController:view container:container displayTarget:displayTarget isIphonePushView:isIphonePushView isEmbedNavigationController:isIphonePushView customSize:CGSizeZero];
}

+(void) DisplayPopoverController:(UIViewController*)view container:(UIViewController<UIPopoverControllerDelegate> *)container displayTarget:(id) displayTarget isIphonePushView:(BOOL) isIphonePushView isEmbedNavigationController:(BOOL) isEmbedNavigationController customSize:(CGSize) customSize
{
    //using dispath_after to fix unshown problem in ios8
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (GC_Device_IsIpad)
        {
            UIPopoverController* aPopover = [[UIPopoverController alloc] initWithContentViewController: isEmbedNavigationController ? [[UINavigationController alloc] initWithRootViewController:view] : view ];
            
            aPopover.delegate = container;
            
            if ( !CGSizeEqualToSize(CGSizeZero, customSize) ) {
                [aPopover setPopoverContentSize: customSize];
            }else{
                [aPopover setPopoverContentSize: GC_Popover_Size];
            }
            
            
            
            [view setValue:aPopover forKey:@"popoverContainer"];
            [container setValue:aPopover forKey:@"popoverView"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([displayTarget isKindOfClass:[UIBarButtonItem class]]) {
                    [aPopover presentPopoverFromBarButtonItem:displayTarget permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }else{
                    [aPopover presentPopoverFromRect:[displayTarget bounds] inView:displayTarget permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }];
        }else{
            if (isIphonePushView) {
                [container.navigationController pushViewController:view animated:YES];
            }else{
                [container presentViewController:view animated:YES completion:nil];
            }
            
        }
    });
}

+ (NSString *) deviceModelType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+(NSString*)localizedText:(NSString*)text languageCode:(NSString*)code
{
    if (code == nil) {
        code = [self GetAppPreference:@"default_language_code" defaultValue:@"-"];
    }
    
    if (![StringLib IsValid:code] || [code isEqualToString:@"-"]) {
        return NSLocalizedString(text, nil);
    }
    
    NSString * path = [[NSBundle mainBundle] pathForResource:code ofType:@"lproj"];
    NSBundle * bundle = nil;
    if(path == nil){
        bundle = [NSBundle mainBundle];
    }else{
        bundle = [NSBundle bundleWithPath:path];
    }
    return [bundle localizedStringForKey:text value:text table:nil];
}

+(void)localizedDefaulLanguageCode:(NSString*)code
{
    [self SetAppPreference:@"default_language_code" value:code];
}

+(void)presentViewWithStorboardName:(NSString*)storyboardName storyboardViewID:(NSString*)viewID currentViewController:(UIViewController*)viewController displayStyle:(enum DisplayStyle) displayStyle prepareBlock:(void(^)(UIViewController* destinationVC))prepareBlock completeBlock:(void(^)())completeBlock
{
    UINavigationController* nav = (UINavigationController*) [viewController parentViewController];
    UIViewController* currentViewController = [nav.viewControllers firstObject];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController* nextViewController = [storyboard instantiateViewControllerWithIdentifier: viewID];
    
    if (prepareBlock != nil) {
        prepareBlock(nextViewController);
    }
    
    switch (displayStyle) {
        case DisplayStyleReplace:
            [nav setViewControllers:@[ nextViewController ]];
            [currentViewController.view removeFromSuperview];
            currentViewController = nil;
            if (completeBlock != nil) {
                completeBlock();
            }
            break;
            
        case DisplayStylePresent:
            [nav presentViewController:nextViewController animated:YES completion:completeBlock];
            break;
            
        case DisplayStylePush:
            [nav pushViewController:nextViewController animated:YES];
            if (completeBlock != nil) {
                completeBlock();
            }
            break;
    }
}



@end




