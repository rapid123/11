//
//  settingsViewController.m
//  Red Beacon
//
//  Created by Runi Kovoor on 15/08/11.
//  Copyright 2011 Rapid Value Solution. All rights reserved.
//

#import "settingsViewController.h"
#import "RBAlertMessageHandler.h"

@implementation settingsViewController

@synthesize titleLabel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavigationRightButton];
}

- (void)createCustomNavigationRightButton 
{
    [self.navigationItem hidesBackButton];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 60, 30);
    cancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoButton.frame = CGRectMake(0, 0, 25, 25);
    infoButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" 
                                               size:12.0];  
    [infoButton setBackgroundImage:[UIImage imageNamed:@"settingBtn.png"] 
                          forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(onTouchUpInfoButton:) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoButtonItem;
    
    [cancelButtonItem release];
    cancelButtonItem = nil;
    [infoButtonItem release];
    infoButtonItem = nil;
    
    self.navigationItem.titleView = titleLabel;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark - button click

-(IBAction)doneButtonClicked:(id)sender
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)onTouchUpInfoButton:(id)sender {  
       
    InfoPage * infoController = 
    [[InfoPage alloc] initWithNibName:[InfoPage getNibName] 
                               bundle:nil];    
    [self.navigationController pushViewController:infoController animated:YES];
    [infoController release];
    infoController = nil;
}

- (IBAction)onTouchUpTellFriendAbout:(id)sender {
    
    [self mailComposer];
}

- (IBAction)onTouchUpSendFeedback:(id)sender {
    
    [self mailComposer];
}

#pragma mark - memory

#pragma mark - 

- (void)mailComposer 
{
    if ([MFMailComposeViewController canSendMail]) 
    {
        MFMailComposeViewController *picker = 
        [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;       
        NSString *emailBody = @"";
        [picker setMessageBody:emailBody isHTML:YES];
        [self.navigationController presentModalViewController:picker animated:YES];
        [picker release];
    }
    else 
    {
        
        [RBAlertMessageHandler showAlert:@"Please check your mail configuration. We can't send e-mail from your device."
                          delegateObject:nil];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
    [controller dismissModalViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.titleLabel = nil;
    [super dealloc];
}


@end
