//
//  ForgotPasswordViewController.m
//  Red Beacon
//
//  Created by Nithin George on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBAlertMessageHandler.h"
#import "UserInformation.h"

#define SUCCESS_TAG 0
#define FAIL_TAG 1
#define SUCCESS_MESSAGE @"We've e-mailed %@ a link where you can create a new password"
#define FAIL_MESSAGE @"Password changed failed Do you want to continue"

NSString * const EMAIL_ADDRESS_EMPTY        = @"Email is empty";

@interface ForgotPasswordViewController (Private)

- (void)setupNavigationBar;
- (void)handleForgotPasswordAPI;
- (void)hideOverlay;

- (BOOL)isValidScheduleAppointmentUpDatas;
- (BOOL)isValidEmailAddress:(NSString*)emailAddress;
- (BOOL)isNonEmptyString:(NSString*)string;

@end

@implementation ForgotPasswordViewController


@synthesize logoImage; 
@synthesize tittle; 
@synthesize emailImage; 
@synthesize emailAddressText; 
@synthesize sendButton; 

@synthesize overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];

    self.logoImage      = nil;
    self.tittle          = nil;
    self.emailImage     = nil;
    self.emailAddressText = nil;
    self.sendButton     = nil;
    self.overlay        = nil;
    [forgotPasswordAPIHandler release];
    forgotPasswordAPIHandler = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setupNavigationBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:NavigationButtonBackgroundImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
    
    //to adjust the title position
    UIButton * AdjustSpacebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 30)];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:AdjustSpacebutton];
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [AdjustSpacebutton release];
    AdjustSpacebutton = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.emailAddressText setReturnKeyType:UIReturnKeyGo];
    [self.navigationItem setRBTitle:@"Forgot your password?"];
    self.tittle.text = @"We will send it to your email address ";
    [self setupNavigationBar];
    
    UserInformation *objUserInformation = LOCATE(UserInformation);
    self.emailAddressText.text = objUserInformation.email;
    
    [self.emailAddressText setClearButtonMode:UITextFieldViewModeWhileEditing];
}

#pragma mark - Button click

- (IBAction)sendButtonClicked:(id)sender
{
    [self.emailAddressText resignFirstResponder]; 
    
    if ([self isValidScheduleAppointmentUpDatas]) {
        
        [self handleForgotPasswordAPI];
    }
 
}
- (IBAction)backButtonClicked:(id)sender
{
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -

- (void)handleForgotPasswordAPI
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    
    if (!forgotPasswordAPIHandler)
    {
        forgotPasswordAPIHandler = [[RBSignUpHandler alloc] init];
    }
    
    forgotPasswordAPIHandler.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Resetting password..." 
                                             animated:YES];
    [forgotPasswordAPIHandler resetPasswordViaEmail:self.emailAddressText.text];

    
    if (pool) 
        [pool drain];

}


#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    
    //reload the table after the response complete
    do
    {
        NSString * title = @"Password Reset";
        NSString *message = @"";
        int alertTag = FAIL_TAG;
        BOOL IsCancelButton = NO;
        
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request]; 
        
        if (requestType == KResetPassword) 
        {
            // Use when fetching text data
            int responseCode = request.responseStatusCode;                    

            if (responseCode == 302) {
                
                message = [NSString stringWithFormat:SUCCESS_MESSAGE,self.emailAddressText.text];
                alertTag = SUCCESS_TAG;
                IsCancelButton = NO;
                
            }
            else if(responseCode == 200)
            {
                // Some error occurred
                [self hideOverlay];
                message = FAIL_MESSAGE;
                alertTag = FAIL_TAG;
                IsCancelButton = YES;
            }
        } 
        [RBAlertMessageHandler showAlertWithTitle:title
                                          message:message 
                                   delegateObject:self
                                          viewTag:alertTag 
                                 otherButtonTitle:@"OK" 
                                       showCancel:IsCancelButton]; 
        
    } while (0);  
    
    [self hideOverlay];
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    
    //error in response
    
}


#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}


#pragma mark -

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == FAIL_TAG) 
    {
        if (buttonIndex == 0)
        {
            [self handleForgotPasswordAPI];
        }
    }
    else if (alertView.tag ==  SUCCESS_TAG) 
    {
        if (buttonIndex == 0)
        {
             self.tittle.text = @"Password was send to your email ";
        }
    }
    
    self.emailAddressText.text = @"";
    
}

#pragma mark - change password
//email validation is done here
- (BOOL)isValidEmailAddress:(NSString*)emailAddress {
    
    BOOL isValid = NO;
    
    //email address format 
    NSString *emailRegex = @"^([_a-z0-9_+.]+)(\\.[_a-z0-9-]+)*@([a-z0-9-]+)(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    //evalute with the predicate
    if ([emailTest evaluateWithObject:emailAddress])
    {        
        //true, email
        isValid = YES;
    }	  
    
    return isValid; 
}
- (BOOL)isValidScheduleAppointmentUpDatas 

{
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:self.emailAddressText.text]) {
            alertMessage = EMAIL_ADDRESS_EMPTY;
            isValid = NO;
            break;
        }        

    } while (FALSE);
    
    if (!isValid) {
        [RBAlertMessageHandler showAlert:alertMessage 
                          delegateObject:nil];
    }
    
    return isValid;
}

#pragma mark - Validation Methods
#pragma mark - LOGIN

- (BOOL)isNonEmptyString:(NSString*)string {
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}


#pragma mark - TextField Delegate methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField 
{
    // [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [self.emailAddressText resignFirstResponder]; 
    return YES; 
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
