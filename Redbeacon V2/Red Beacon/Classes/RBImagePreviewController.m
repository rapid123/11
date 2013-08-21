//
//  RBImagePreviewController.m
//  Red Beacon
//
//  Created by Jayahari V on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBImagePreviewController.h"
#import "JobRequest.h"
#import "RBImageProcessor.h"
#import "RBSavedStateController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBAlertMessageHandler.h"

@interface RBImagePreviewController (Private) 

- (void)showImage;
- (void)popToHome;

//removes the image and all its related files
- (void)deleteImages;

- (IBAction)onTouchUpRetake:(id)sender;
- (IBAction)onTouchUpDelete:(id)sender;

@end

@implementation RBImagePreviewController
@synthesize preview, parent;

NSString * const AS_CONFIRM_PHOTO_DELETE_TITLE = @"Discard Photo?";
NSString * const AS_CONFIRM_PHOTO_DELETE_MESSAGE = @"Are you sure you want to delete this photo?";
+ (NSString*)getnibName {    
    return @"RBImagePreviewController";
}

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
    self.parent = nil;
    self.preview = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNavigationBar {
    
    [self.navigationItem setRBTitle:@"Photo Preview"];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [button release];
    button=nil;
    [item release];
    item = nil;
    
    button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 60, 30);
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [button release];
    button=nil;
    [item release];
    item = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showImage];
    [self setupNavigationBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    preview.image = nil;
    self.preview = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showImage {
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * imagePath = [jobRequest getFirstImagePath];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    preview.image = image;
    [image release];
       
}

//removes the image and all its related files
- (void)deleteImages {
    
    //removes all physical files
    RBImageProcessor * processor = [[RBImageProcessor alloc] init];
    [processor deleteAllImages];
    [processor release];
    
    //removes  the image_Ids
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [jobRequest removeAllImages];

}

- (IBAction)onTouchUpRetake:(id)sender {
    [parent ImageDidRetake];
    [self performSelector:@selector(popToHome) 
               withObject:nil 
               afterDelay:0.4];
}

- (IBAction)onTouchUpDelete:(id)sender {    
    [RBAlertMessageHandler showDiscardAlertWithTitle:AS_CONFIRM_PHOTO_DELETE_TITLE
                                             message:AS_CONFIRM_PHOTO_DELETE_MESSAGE
                                      delegateObject:self 
                                             viewTag:1];
}

- (void)popToHome {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self deleteImages];
        [self popToHome];
    }
}


@end
