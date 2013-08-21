//
//  AudioViewController.m
//  Red Beacon
//
//  Created by Joe on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioViewController.h"
#import "TextViewController.h"

@implementation AudioViewController
@synthesize selectedStatus;

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
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.text = @"Schedule";
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    
    [self addSegmentedControl];
    [self createCustomNavigationRightButton];
    [self createCustomNavigationLeftButton];
}

- (void)createCustomNavigationRightButton 
{
    [self.navigationItem hidesBackButton];
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
}

- (void)createCustomNavigationLeftButton 
{
    [self.navigationItem hidesBackButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

- (void) addSegmentedControl {
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Voice", @"Text", nil];
    segmentedControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] retain];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void) onSegmentedControlChanged:(UISegmentedControl *) sender {
    
    
    if (segmentedControl.selectedSegmentIndex == 0) 
    { 

        
    } else if (segmentedControl.selectedSegmentIndex == 1)
    {

        TextViewController *textViewController=[[TextViewController alloc]initWithNibName:@"TextViewController" bundle:nil];
        //[self.view removeFromSuperview];
        [self.view addSubview:textViewController.view];
        [textViewController release];
        textViewController = nil;
    }
    
}

#pragma mark- button action

-(IBAction)cancelButtonClicked:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
    
}

-(IBAction)doneButtonClicked:(id)sender
{
    
}




#pragma mark- memory release

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
    [segmentedControl release];
    segmentedControl = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
