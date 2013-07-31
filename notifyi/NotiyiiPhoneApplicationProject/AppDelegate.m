//
//  AppDelegate.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "InboxViewController.h"
#import "TouchBaseViewController.h"
#import "DirectoryViewController.h"
#import "MoreViewController.h"
#import "CoreDataHandler.h"
#import "MobileSettingsViewController.h"
#import "MyApplication.h"
#import "GeneralClass.h"


@interface AppDelegate ()
{
    InboxViewController *inboxViewController;
    TouchBaseViewController *touchBaseViewController;
    JsonParser *objParser;
    int applicationBadgeNo;
}
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;
@synthesize loginViewController;
@synthesize navigationControllerInbox;
@synthesize navigationControllerTouchBase;
@synthesize navigationControllerDirectory;
@synthesize navigationControllerMore;
@synthesize mobileSettings;
@synthesize delegate;

BOOL checkFlag;

#pragma mark- launch
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    checkFlag = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    inboxViewController = [[InboxViewController alloc]initWithNibName:@"InboxViewController"
                                                               bundle:nil];
    touchBaseViewController = [[TouchBaseViewController alloc]initWithNibName:@"TouchBaseViewController"
                                                                                                bundle:nil];
    DirectoryViewController *directoryViewController = [[DirectoryViewController alloc]initWithNibName:@"DirectoryViewController"
                                                                                                bundle:nil];
    MoreViewController *moreViewController = [[MoreViewController alloc]initWithNibName:@"MoreViewController"
                                                                                 bundle:nil];
    
    
    self.navigationControllerInbox = [[UINavigationController alloc]initWithRootViewController:inboxViewController];
    self.navigationControllerTouchBase = [[UINavigationController alloc]initWithRootViewController:touchBaseViewController];
    self.navigationControllerDirectory = [[UINavigationController alloc]initWithRootViewController:directoryViewController];
    self.navigationControllerMore = [[UINavigationController alloc]initWithRootViewController:moreViewController];
    
    
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationControllerInbox, navigationControllerTouchBase, navigationControllerDirectory, navigationControllerMore, nil];
    
    loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController"
                                                               bundle:nil];
    
    
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:applicationBadgeNo];

    //    [[UIApplication sharedApplication]
    //     registerForRemoteNotificationTypes:( UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    return YES;
}

#pragma mark- Login Success
-(void)addTabBarToDisplay
{
    self.window. backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
}

-(void)logOutButtonTouched
{
    [[tabBarController view] removeFromSuperview];
    self.window.rootViewController = self.loginViewController;
    [self application:nil didFinishLaunchingWithOptions:nil];
}
#pragma mark- Set Badge
- (void)setTabTabBarBadge:(int)badgeValue
{
    if (badgeValue > 0)
        [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d",badgeValue]];
    else
        [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:NULL];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application willResign");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SessionExpired"];
}
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    mobileSettings = [[MobileSettingsViewController alloc]initWithNibName:@"MobileSettingsViewController"
                                                                   bundle:nil];
    [mobileSettings checkSwitchPositions];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    
    mobileSettings = [[MobileSettingsViewController alloc]initWithNibName:@"MobileSettingsViewController"
                                                                   bundle:nil];
    [mobileSettings checkSwitchPositions];
//    [mobileSettings localNotificationForInboxMessageVibrate];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 0) //Inbox
    {
        //pass message to inbox view
        if (inboxViewController)
        {
            [inboxViewController inboxTabbarTouched];
        }
    }
}

#pragma mark push notifications
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self.delegate;
    }
    
    NSString *token = [[devToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> "]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"%@\n",token);
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *operationType  = [NSString stringWithFormat:@"%d",pushNotificationAPI];
    
    NSString *string = [NSString stringWithFormat:@"?userId=%@&operationType=%@&deviceToken=%@",userID,operationType,token];
    
    [objParser parseJson:pushNotificationAPI :string];
    
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"failed to regiser %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
    NSLog(@"Push Notification from Server \n%@", userInfo);

    if(userInfo && [[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"])
    {
        NSArray *pushNotificationResponse = [userInfo objectForKey:@"aps"];
        applicationBadgeNo = [[pushNotificationResponse valueForKey:@"badge"] intValue];
        
        NSString *resultResponseCode = [pushNotificationResponse valueForKey:@"alert"];
        /*Sound  settings */
        NSString *soundSettings = [pushNotificationResponse valueForKey:@"sound"];
        
        resultResponseCode = [resultResponseCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if([resultResponseCode isEqualToString:@"New Email"])
        {
            if (inboxViewController)
            {
                [inboxViewController inboxDataRefreshing];
                [inboxViewController getInboxInformation];
               
                if ([soundSettings isEqualToString:@"default"]) {
                    NSLog(@"No sound");
                }
                else{
                    NSLog(@"inboxDataRefreshing");
                     [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX SOUND", nil)
                                                                       object:nil ];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX VIBRATOR", nil)
                                                                   object:nil ];
            }
            
        }
        else if([resultResponseCode isEqualToString:@"New Email New TouchBase Message"])
        {
            if (inboxViewController)
            {
                [inboxViewController inboxDataRefreshing];
                [inboxViewController getInboxInformation];
                if ([soundSettings isEqualToString:@"default"]) {
                    NSLog(@"No sound");
                }
                else{
                NSLog(@"inboxDataRefreshing and touchBaseDataRefreshing");
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX SOUND", nil)
                                                                   object:nil ];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX VIBRATOR", nil)
                                                                   object:nil ];
            }
            if(touchBaseViewController)
            {
                [touchBaseViewController touchBaseDataRefreshing];
                [touchBaseViewController getTouchBaseInformation];
                if ([soundSettings isEqualToString:@"default"]) {
                    NSLog(@"No sound");
                }
                else{
                NSLog(@"inboxDataRefreshing and touchBaseDataRefreshing");
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE SOUND", nil) object:nil ];
                
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE VIBRATOR", nil) object:nil ];
                
            }

        }
        else if([resultResponseCode isEqualToString:@"New TouchBase Message"])
        {
            if(touchBaseViewController)
            {
                [touchBaseViewController touchBaseDataRefreshing];
                [touchBaseViewController getTouchBaseInformation];
                if ([soundSettings isEqualToString:@"default"]) {
                    NSLog(@"No sound");
                }
                else{
                NSLog(@"touchBaseDataRefreshing");
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE SOUND", nil) object:nil ];

                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE VIBRATOR", nil) object:nil ];
            }
        }
    }
}
-(void)parseCompleteSuccessfully:(ParseServiseType)eparseType :(NSArray *)result
{
    
}
-(void)parseFailedWithError:(ParseServiseType)eparseType :(NSError *)error :(int)errorCode
{
    
}
-(void)parseWithInvalidMessage:(NSArray *)result
{
    
}
-(void)netWorkNotReachable
{
    
}

@end
