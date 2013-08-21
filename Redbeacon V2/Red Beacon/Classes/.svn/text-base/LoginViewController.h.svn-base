//
//  LoginViewController.h
//  Red Beacon
//
//  Created by Joe on 12/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RBLoginHandler.h"
#import "RBSignUpHandler.h"
#import "RBDefaultsWrapper.h"
#import "RBLoadingOverlay.h"
#import "Red_BeaconAppDelegate.h"
#import "RBFacebookHandler.h"
#import "RBFacebookLoginDialog.h"
#import "FBConnect.h"

@protocol RBLoginDelegate <NSObject>
- (void)loginSuccessful;
- (void)loginCancelled;
@end

@interface LoginViewController : UIViewController <UITextFieldDelegate,RBFacebookLoginDialogDelegate,FBSessionDelegate> 
{
    UISegmentedControl *segmentedControl;
    
    UIView *hiddenContainer;
    
    UIImageView *loginImage;
    UIImageView *loginLabelArrow;
    UITableView *loginTable;
    UILabel *loginLabel;

    //Login IBOutlets
    UITextField * usernameTextField;
    UITextField * passwordTextField;
    //Navigation BackButton
    UIButton *button;
    
    NSString* username;
    NSString* password;
    NSString* email;
    NSString* telephone;
    
    RBBaseHttpHandler * loginHandler;

    id<RBLoginDelegate> delegate;

    UITextField * userNameAtSignUpTextField;
    UITextField * passwordAtSignUpTextField;
    UITextField * telephoneSignUpTextField;
    UITextField *txtField;
    
    RBBaseHttpHandler * signUpHandler;
    RBFacebookHandler *facebookHandler;
    
    RBLoadingOverlay * overlay;
    BOOL loginLabelStatus;
    
    //FB
    UIView *_loginDialogView;
    
    Facebook *facebook;

    BOOL isDefaultSignUp;
    NSMutableDictionary *tableContentsLogin;
    NSMutableDictionary *tableContentsSignup;
}

@property (nonatomic, retain) NSMutableDictionary *tableContentsLogin;
@property (nonatomic, retain) NSMutableDictionary *tableContentsSignup;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* telephone;
@property (nonatomic, retain) IBOutlet UIImageView *loginImage;
@property (nonatomic, retain) IBOutlet UIImageView *loginLabelArrow;
@property (nonatomic, retain) IBOutlet UITableView *loginTable; 
@property (nonatomic, retain) IBOutlet UILabel *loginLabel; 
@property (nonatomic, retain) IBOutlet UIView  * hiddenContainer;
@property (nonatomic, retain) IBOutlet UIButton *forgotPasswordButton; 
@property (retain) IBOutlet UIView *loginDialogView;
@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic) BOOL isDefaultSignUp;


- (BOOL)segmentClickIdentification;
- (void)setupNavigationBar;
- (void)addSegmentedControl;
- (void)hideLoginLabel:(BOOL)status;
- (void)FacebookLoginWithAceessTocken;

- (IBAction)forgotPasswordButtonClicked:(id)sender;
- (IBAction)facebookButtonPresssed:(id)sender;
- (IBAction)loginButtonPresssed:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;



@end
