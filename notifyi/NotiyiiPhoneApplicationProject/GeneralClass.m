//
//  GeneralClass.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeneralClass.h"
#import <QuartzCore/CoreAnimation.h>

UIAlertView *alertview;

@implementation GeneralClass


#pragma mark- set font size
/*******************************************************************************
 *  Function Name:getFont.
 *  Purpose: setting font for controllers.
 *  Parametrs:font size and font name.
 *  Return Values:UIfont with given font size and name.
 ********************************************************************************/
+(UIFont *)getFont:(float)size and: (NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:size];
    return font;
}

#pragma mark- set searchBar background color
/*******************************************************************************
 *  Function Name:searchBarBackGroundColorSetting.
 *  Purpose: setting background for UIsearchBar.
 *  Parametrs:UIsearchBar Object.
 *  Return Values:UIsearchBar with given background.
 ********************************************************************************/
-(UISearchBar *) searchBarBackGroundColorSetting:(UISearchBar *)searchBar
{
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIView *bg = [[UIView alloc] initWithFrame:subview.frame];
            bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchBackGround"]];
            [searchBar insertSubview:bg aboveSubview:subview];
            [subview removeFromSuperview];
            return searchBar;
            break;
        }
    }
    return 0;
}

#pragma mark- To show an AlertView
/*******************************************************************************
 *  Function Name:showAlertView.
 *  Purpose: To show an AlertView.
 *  Parametrs:Alertview delegate as self,Alertmessage as String,Alerttitle as String,cancel button title as String,Other button title as String.
 *  Return Values:nil.
 ********************************************************************************/
+(void)showAlertView:(id)delegateValue msg:(NSString *)message title:(NSString *)titleMessage cancelTitle:(NSString *)cancelMessage otherTitle:(NSString *)otherMessage tag:(int)tagValue
{
    NSLog(@"showAlertView");
    //Checking any alertview is present in views Please remove it and create new one.
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView *subView in [window subviews])
        {
            if ([subView isKindOfClass:[UIAlertView class]])
            {
                NSLog(@"has AlertView");
                [alertview dismissWithClickedButtonIndex:-1 animated:YES];
            }
            else
            {
                NSLog(@"No AlertView");
            }
        }
    }
    alertview=[[UIAlertView alloc]initWithTitle:titleMessage
                                        message:message
                                       delegate:delegateValue
                              cancelButtonTitle:cancelMessage
                              otherButtonTitles:otherMessage, nil];
    
    alertview.tag = tagValue;
    [alertview show];    
}


#pragma mark- To Validate an emailAddress.
/*******************************************************************************
 *  Function Name:emailValidation.
 *  Purpose: To validate an emailAddress.
 *  Parametrs:email Address as String.
 *  Return Values:BOOL,if valid return YES else NO.
 ********************************************************************************/
+(BOOL)emailValidation:(NSString *)email
{
    BOOL result;
    NSLog(@"Message checking :%@",email);
    //checking email validation for @,. and com
    NSString *emailRegEx = @"[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:email] == YES)
    {
        NSLog(@"Valid email address");
        result=YES;
    }
    else
    {
        NSLog(@"Invalid email address");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PLEASE CHECK YOUR DETAILS",nil)
                                                        message:@"Enter valid username"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
        result=NO;
    }
    
    return result;
}

#pragma mark- To load a Webview.
/*******************************************************************************
 *  Function Name:clickableLinkMethod.
 *  Purpose: To load a webview with a url.
 *  Parametrs: url as String.
 *  Return Values:nil.
 ********************************************************************************/
+(void)clickableLinkMethod:(NSString*)link
{
    if (link)
    {
        NSURL *url = [[ NSURL alloc]initWithString:link];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
