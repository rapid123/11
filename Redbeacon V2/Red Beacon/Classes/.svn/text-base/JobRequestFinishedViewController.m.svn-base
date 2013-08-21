//
//  JobRequestFinishedViewController.m
//  Red Beacon
//
//  Created by Joe on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobRequestFinishedViewController.h"


@implementation JobRequestFinishedViewController

@synthesize topLabel;
@synthesize bottomLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	topLabel.lineBreakMode = UILineBreakModeWordWrap;
	topLabel.numberOfLines = 2;
	[topLabel setText:@"We [email/text/email and text] you quotes as they arrive"];
	
	bottomLabel.lineBreakMode = UILineBreakModeWordWrap;
	bottomLabel.numberOfLines = 3;
	[bottomLabel setText:@"We collect quotes for up to 48 hours from quality [job name] and contact you by [email/text] as they arrive"];
    
    [self createCustomNavigationLeftButton];
}


- (void)createCustomNavigationLeftButton 
{
    [self.navigationItem hidesBackButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:kBackToHomeTitle forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

#pragma mark-
-(IBAction)cancelButtonClicked:(id)sender
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    
}


#pragma mark-

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.topLabel = nil;
    self.bottomLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.topLabel = nil;
    self.bottomLabel = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
