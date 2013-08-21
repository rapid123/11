//
//  LocationViewController.m
//  Red Beacon
//
//  Created by Nithin George on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "JobRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "Red_BeaconAppDelegate.h"
#import "ManagedObjectContextHandler.h"
#import "RBAlertMessageHandler.h"
#import "FlurryAnalytics.h"


#define INVALID_ZIP_CODE_ALERT_MESSAGE @"Enter 5 digit Zip code"
@interface LocationViewController (Private)

- (void)setupNavigationBar;
- (void)setUpLocationContainer;
- (void)populateZipCode;
- (void)enableGPSMode;
- (void)enableCustomZipCodeMode;
- (void)hideOverlay;

- (void)doneButtonClicked:(id)sender;
- (void)cancelButtonClicked:(id)sender;
- (IBAction)onTouchUpCustomZipCode:(id)sender;
- (IBAction)onTouchUpGPSLocation:(id)sender;

@end

@implementation LocationViewController

@synthesize zipCodeTextField, locationContainer;
@synthesize customZipcodeButton, gpsModeButton;
@synthesize overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.zipCodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self setupNavigationBar];
    [self setUpLocationContainer];
    [self populateZipCode];
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    self.locationContainer = nil;
    self.zipCodeTextField = nil;
    self.gpsModeButton = nil;
    self.customZipcodeButton = nil;
}
- (void)dealloc {
    
    [overlay release];
    
    self.zipCodeTextField = nil;
    self.locationContainer = nil;
    self.gpsModeButton = nil;
    self.customZipcodeButton = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupNavigationBar {
    
    [self.navigationItem setRBTitle:kLVCPageTitle];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
    
}

- (void)setUpLocationContainer {
    locationContainer.layer.cornerRadius = 5.0;
    
}

- (void)populateZipCode 
{    
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * lType = [jRequest.location valueForKey:KEY_LOCATION_TYPE];
    if ([lType isEqualToString:LOCATION_TYPE_CUSTOM]) 
    {
        [self enableCustomZipCodeMode];
        [zipCodeTextField becomeFirstResponder];
    }
    else
    {
        [self enableGPSMode];
    }
}

//will switch to GPS Scan mode
- (void)enableGPSMode {    

    [self.zipCodeTextField resignFirstResponder];
    
    //make the tick position
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:locationModeSelectedTickImageName 
                                                           ofType:kRBImageType];
    UIImage * tick = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [gpsModeButton setImage:tick forState:UIControlStateNormal];
    [customZipcodeButton setImage:nil forState:UIControlStateNormal];
    [tick release];
    
    
    isGPSMode = YES;
}

- (void)enableCustomZipCodeMode {  
    
    Red_BeaconAppDelegate * delegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate stopGPSScan];
    
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * zipCode = [jRequest.location valueForKey:KEY_LOCATION_ZIP];
    self.zipCodeTextField.text = zipCode;
    
    //make the tick position
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:locationModeSelectedTickImageName 
                                                           ofType:kRBImageType];
    UIImage * tick = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [customZipcodeButton setImage:tick forState:UIControlStateNormal];
    [gpsModeButton setImage:nil forState:UIControlStateNormal];

    [tick release];
    
    isGPSMode = NO;
    
}

#pragma mark - Button Actions
- (void)doneButtonClicked:(id)sender
{
    Red_BeaconAppDelegate * delegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    
   if (!isGPSMode)
   {
       
       //if ([delegate isValidZipCode:self.zipCodeTextField.text]) {
       if ([self.zipCodeTextField.text length]>4 && [self.zipCodeTextField.text length] <9) {
           
           NSString * cityName = [[ManagedObjectContextHandler sharedInstance] getCityNameForZipcode:self.zipCodeTextField.text];
           
           if ([cityName isEqualToString:@""]) {
               cityName = EMPTY_CITY_NAME;
               [FlurryAnalytics logEvent:@"Serviced Location Error"
                          withParameters:[NSDictionary dictionaryWithObjectsAndKeys:self.zipCodeTextField.text, @"zipcode", nil]];
           } else {
               [FlurryAnalytics logEvent:@"Serviced Location OK"
                          withParameters:[NSDictionary dictionaryWithObjectsAndKeys:cityName, @"city", nil]];
           }
           
           JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
           [jRequest.location setValue:self.zipCodeTextField.text forKey:KEY_LOCATION_ZIP];
           [jRequest.location setValue:LOCATION_TYPE_CUSTOM forKey:KEY_LOCATION_TYPE];
           [jRequest.location setValue:cityName forKey:KEY_LOCATION_CITYNAME];
           [[self navigationController] popViewControllerAnimated:YES];
       }
       else {
           NSString * title = @"Redbeacon";
           [RBAlertMessageHandler showAlertWithTitle:title
                                             message:INVALID_ZIP_CODE_ALERT_MESSAGE 
                                      delegateObject:self
                                             viewTag:0 
                                    otherButtonTitle:@"OK" 
                                          showCancel:NO];
       }
     //  }        
    }
   else {
       
       self.overlay = 
       [RBLoadingOverlay loadOverView:delegate.window
                          withMessage:@"Finding the current location..." 
                             animated:YES];
       
       //start GPS Scan
       [delegate startGPSScan];
       delegate.delegate = self;
       
   }
    
}

- (void)cancelButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)onTouchUpGPSLocation:(id)sender
{
    [self enableGPSMode];
    
}

- (IBAction)onTouchUpCustomZipCode:(id)sender 
{
    [zipCodeTextField becomeFirstResponder];
    [self enableCustomZipCodeMode];
}

#pragma mark - textfield Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    [self enableCustomZipCodeMode];
    return YES;
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

#pragma mark- GPRS Location response delegate
/*hiding overlay needs to be done here, else if the zipcode which we do not
 serve comes during location fetching, its alert will be shown below the overlay
 */
- (void)locationFetchCompletedSuccessfully {
    [self hideOverlay];
}
- (void)locationFetchCompletedWithErrors
{
    [self hideOverlay];  
    [self enableCustomZipCodeMode];
}

- (void)newLocationDidSaved {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
