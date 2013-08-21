//
//  InfoPage.h
//  Red Beacon
//
//  Created by Runi Kovoor on 16/08/11.
//  Copyright 2011 Rapid Value Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBLoginHandler.h"
#import "RBBaseHttpHandler.h"
#import "RBDefaultsWrapper.h"
#import "RBLoadingOverlay.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RBFAQandHowItWorksViewController.h"

#import "RBFacebookHandler.h"
#import "RBFacebookLoginDialog.h"
#import "FBConnect.h"
#import "FBStreamDialog.h"

@interface InfoPage : UIViewController<RBBaseHttpHandlerDelegate, MFMailComposeViewControllerDelegate,UIActionSheetDelegate,FBSessionDelegate, FBDialogDelegate>
{
    UIButton * loginOrLogoutButton;
    RBLoginHandler * loginHandler;
    RBLoadingOverlay * overlay;
    UILabel * loginLogoutStatusLabel;
    UILabel * usernameLabel;
    
    NSMutableArray *tableContent;
    RBFAQandHowItWorksViewController *objRBFAQandHowItWorksViewController;
 
    Facebook *facebook;
    FBStreamDialog *fbStreamDialog;
}

@property (nonatomic, retain) IBOutlet UIButton *loginOrLogoutButton;
@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property (nonatomic, retain) IBOutlet UILabel * loginLogoutStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel * usernameLabel;
@property (nonatomic, retain) IBOutlet UITableView * settingstable;
@property (nonatomic, retain) Facebook *facebook;

+ (NSString*)getNibName;
- (void)setupNavigationBar;
- (IBAction)onTouchUpLoginOrLogout:(id)sender;
- (IBAction)onTouchUpCancel:(id)sender;
- (IBAction)onTouchUpClose:(id)sender;

- (IBAction)callButtonClick:(id)sender;

@end
