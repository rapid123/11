//
//  AppDelegate.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MobileSettingsViewController.h"
#import "JsonParser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,JsonParserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) UINavigationController *navigationControllerInbox;
@property (strong, nonatomic) UINavigationController *navigationControllerTouchBase;
@property (strong, nonatomic) UINavigationController *navigationControllerDirectory;
@property (strong, nonatomic) MobileSettingsViewController *mobileSettings;
@property (strong, nonatomic) UINavigationController *navigationControllerMore;
@property (strong, nonatomic) id delegate;

-(void)addTabBarToDisplay;
- (void)setTabTabBarBadge:(int)badgeValue;
-(void)logOutButtonTouched;
@end
