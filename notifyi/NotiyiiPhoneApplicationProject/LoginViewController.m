//
//  LoginViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NotifyiConstants.h"
#import "GeneralClass.h"
#import "SBJSON.h"
#import "JSON.h"
#import "Reachability.h"
#import "MyProfile.h"
#import "DataManager.h"
UIView *syncView;
SyncManager *syncManager;

@interface LoginViewController ()

-(void)setFontForControlls;
-(void)callLoginAPI;
-(void)startSyncing;
-(void)setCustomOverlay;
-(BOOL)isLoginSuccess;

@property(strong,nonatomic)IBOutlet UITextField *userNameTextField;
@property(strong,nonatomic)IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController
@synthesize userNameTextField;
@synthesize passwordTextField;

#pragma mark- Init Load
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logged_in"];
    passwordTextField.secureTextEntry = YES;
    userNameTextField.delegate = self;
    passwordTextField.delegate = self;
    
    [self setFontForControlls];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"USERNAME"]);
    userNameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERNAME"];
//    userNameTextField.text = @"notiadmin";
//    passwordTextField.text = @"notipassword";
}
#pragma mark- Methods
/*******************************************************************************
 *  Function Name:isLoginSuccess.
 *  Purpose: To Validate Username and Password.
 *  Parametrs:nil.
 *  Return Values:BOOL,if valid return YES else NO.
 ********************************************************************************/
-(BOOL)isLoginSuccess
{
    BOOL result;
    NSLog(@"Username===%@",userNameTextField.text);
    NSLog(@"Password===%@",passwordTextField.text);
    if([userNameTextField.text length]==0 && [passwordTextField.text length] ==0)
    {
        NSLog(@"Invalid Login");
        [GeneralClass showAlertView:self
                                 msg:NSLocalizedString(@"ENTER USERNAME AND PASSWORD MESSAGE", nil)
                               title:nil//NSLocalizedString(@"PLEASE CHECK YOUR DETAILS",nil)
                         cancelTitle:@"OK"
                          otherTitle:nil
                                 tag:invalidUsernameOrPasswordTag];
        result=NO;
    }
    else if([NSNull null]==(NSNull*)userNameTextField.text || [userNameTextField.text isEqualToString:@""])
    {
        [GeneralClass showAlertView:nil
                                 msg:NSLocalizedString(@"ENTER USERNAME MESSAGE", nil)
                               title:nil//NSLocalizedString(@"PLEASE CHECK YOUR DETAILS",nil)
                         cancelTitle:@"OK"
                          otherTitle:nil
                                 tag:noTag];
        
        result=NO;
        
    }
    else if([NSNull null]==(NSNull*)passwordTextField.text || [passwordTextField.text isEqualToString:@""])
    {
        [GeneralClass showAlertView:nil
                                 msg:NSLocalizedString(@"ENTER PASSWORD MESSAGE", nil)
                              title:nil//NSLocalizedString(@"PLEASE CHECK YOUR DETAILS",nil)
                         cancelTitle:@"OK"
                          otherTitle:nil
                                 tag:noTag];
        result=NO;
    }
    else
    {
//        result = [GeneralClass emailValidation:userNameTextField.text];
        result = YES;
    }
    
    //[loginButton setUserInteractionEnabled:YES];
    return result;
}

/*******************************************************************************
 *  Function Name:setFontForControlls.
 *  Purpose: To set font for Controllers.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void) setFontForControlls
{
    userNameTextField.font = [GeneralClass getFont:titleFont and:regularFont];
    passwordTextField.font = [GeneralClass getFont:titleFont and:regularFont];
    loginButton.titleLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    forgotPasswordButton.titleLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    contactUsButton.titleLabel.font =  [GeneralClass getFont:buttonFont and:boldFont];
}

/*******************************************************************************
 *  Function Name: setCustomOverlay.
 *  Purpose: To init syncing.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)setCustomOverlay
{
    if(!syncView)
    {
        syncView = [[UIView alloc]init];
        syncView.frame = self.view.frame;
        UIActivityIndicatorView *syncingActivityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(60, 140, 200, 200)];
        syncingActivityIndicator.backgroundColor = [UIColor clearColor];
        syncingActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [syncingActivityIndicator startAnimating];
        [syncView addSubview:syncingActivityIndicator];
    }
    
    [self.view addSubview:syncView];
}
/*******************************************************************************
 *  Function Name: startSyncing.
 *  Purpose: To start syncing.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)startSyncing
{
    //signature at inbox
    NSString * email = userNameTextField.text;
   [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"USERNAME"];
    //password lock
    NSString * passwordLockKey = passwordTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:passwordLockKey forKey:@"PASSWORD"];
    
    syncManager = nil;
    if (!syncManager)
    {
        syncManager = [[SyncManager alloc]init];
        syncManager.delegate = self;
    }
    syncView.backgroundColor = [UIColor clearColor];
    [syncManager inboxParsing];
}
/*******************************************************************************
 *  Function Name: callLoginAPI.
 *  Purpose: To start Login Parsing.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)callLoginAPI
{
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *URLParameters = [NSString stringWithFormat:@"?Username=%@&Password=%@",userName,password];
    JsonParser *objParser=[[JsonParser alloc] init];
    
    objParser.delegate=self;
    [objParser parseJson:LoginAPI:URLParameters];
}
#pragma mark- Button Actions
/*******************************************************************************
 *  ContactUs button Touch action.
 ********************************************************************************/
- (IBAction)contactUsButtonTouched:(id)sender
{
    if ([Reachability connected]) 
    {
        [GeneralClass clickableLinkMethod:NSLocalizedString(@"CONTACT US", nil)];
    }
    else 
    {
        [self netWorkNotReachable];
    }
 
}

/*******************************************************************************
 *  Forgot password button Touch action.
 ********************************************************************************/
- (IBAction)forgotPasswordButtonTouched:(id)sender
{
    if ([Reachability connected]) 
    {
        [GeneralClass clickableLinkMethod:NSLocalizedString(@"FORGOT PASSWORD", nil)];
    }
    else 
    {
        [self netWorkNotReachable];
    }
    
}

/*******************************************************************************
 *  Login button Touch action.
 ********************************************************************************/
- (IBAction)loginButtonTouched:(id)sender
{
   // [self startSyncing];
    [loginButton setUserInteractionEnabled:NO];
    BOOL isValidLogin = [self isLoginSuccess];
    if (isValidLogin)
    {
        [self setCustomOverlay];
        syncView.backgroundColor = [UIColor clearColor];
        [self callLoginAPI];
        
        
    }
    else
    {
        
    }
    
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}


#pragma mark- Parser delegates
/*******************************************************************************
 *  Function Name: parseCompleteSuccessfully,parseFailedWithError.
 *  Purpose: To delegate the json parser.
 *  Parametrs:Array of resulted parserObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void)parseCompleteSuccessfully:(ParseServiseType) eparseType:(NSArray *)result
{
    NSLog(@"Parse complete");
    [self startSyncing];
    
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    NSLog(@"Parse Error");
    [GeneralClass showAlertView:self
                            msg:nil
                          title:@"Parse with error. Try again?"
                    cancelTitle:@"YES"
                     otherTitle:@"NO"
                            tag:parseErrorTag];
}

/*******************************************************************************
 *  Function Name: invalidUserNameORPassword.
 *  Purpose: To Show an AlertView if User is Invalid.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)parseWithInvalidMessage:(NSArray *)result
{
    NSLog(@"parseWithInvalidMessage");

    if ([result count]>0) 
    {
        NSString *resultResponseCode = [result valueForKey:@"Message"];
        [GeneralClass showAlertView:self
                                msg:nil
                              title:resultResponseCode
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:jsonErrorMsgTag];
        
    }
    else
    {
        [self parseFailedWithError:0 :nil :0];
    }
}

-(void)netWorkNotReachable
{
    NSLog(@"NO NETWORK");
    [GeneralClass showAlertView:self
                            msg:NSLocalizedString(@"CHECK NETWORK CONNECTION", nil)
                          title:NSLocalizedString(@"NO NETWORK", nil)
                    cancelTitle:@"OK"
                     otherTitle:nil
                            tag:reachabilityTag];
   
}

#pragma mark- Sync Delegates
/*******************************************************************************
 *  Sync Delegates.
 ********************************************************************************/
- (void)SyncCompletedWithSuccess
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];
    
    //Extract user name and user state
    MyProfile * myProfile;
    NSArray*profileDetails = [DataManager getWholeEntityDetails:MYPROFILE sortBy:@"userName"];
    NSLog(@"profileDetails===%@",profileDetails);
    if([profileDetails count])
    {
        myProfile = [profileDetails objectAtIndex:0];
    }
    NSString *userName = myProfile.userName;
//    NSString *userContactInfo = myProfile.contactInfo;
    NSString *userState = myProfile.state;
    [[NSUserDefaults standardUserDefaults] setObject:userState forKey:@"UserState"];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"ProfileUserName"];
     NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"]);

    [loginButton setUserInteractionEnabled:NO];
    [syncView removeFromSuperview];
    
    AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app addTabBarToDisplay];
}
- (void)SyncCompletedWithError
{
    [loginButton setUserInteractionEnabled:NO];
}


#pragma mark- Touch Delegates
/*******************************************************************************
 *  Function Name: touchesBegan.
 *  Purpose: To delegate back ground touch events.
 *  Parametrs:event.
 *  Return Values:nil.
 ********************************************************************************/
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"Background touched ");
	[userNameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
    
}
#pragma mark- TextField delegate
/*******************************************************************************
 *  UITextField delegate.
 ********************************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 1) {
        // if Found next responder, so set it.
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:2];
        [nextTextField becomeFirstResponder];
    }
    else {
        // if Not found, so remove keyboard.
        [self loginButtonTouched:nil];
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark- UIAlertView delegate
/*******************************************************************************
 *  UIAlertView delegate.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [loginButton setUserInteractionEnabled:YES];
    [syncView removeFromSuperview];
    if(alertView.tag == invalidUsernameOrPasswordTag)
    {
        if (buttonIndex == 0)
        {
            userNameTextField.text = @"";
            passwordTextField.text = @"";
            
        }        
    }
    else if(alertView.tag == parseErrorTag)
    {
        if(buttonIndex == 0)
        {
            [self callLoginAPI];
            [userNameTextField resignFirstResponder];
            [passwordTextField resignFirstResponder];
            
        }
        else
        {
            userNameTextField.text = @"";
            passwordTextField.text = @"";
            
        }
    }
    else if(alertView.tag == reachabilityTag)
    {
        NSLog(@"No network");
        [syncView removeFromSuperview];
    }
    else if (alertView.tag == jsonErrorMsgTag)
    {
         passwordTextField.text = @"";
    }
    alertView = nil;
}
#pragma mark- Memory dealloc
- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
