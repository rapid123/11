//
//  QuotesViewController.m
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "QuotesViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "QuotesListCell.h"
#import "DetailQuotesViewController.h"
#import "Red_BeaconAppDelegate.h"
#import "RBCurrentJobResponse.h"
#import "FlurryAnalytics.h"


@interface QuotesViewController (Private)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation QuotesViewController

@synthesize jobDetail;
@synthesize quotesTable;
@synthesize tableContent;
@synthesize noQuotesToDisplayImg;
@synthesize indexPathToJump;
@synthesize notServicedImg;
@synthesize giveUsFeedbackButton;

static NSString* kTitle = @"Quotes";

int const quotesCellHeight = 80;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)selectTableIndex:(int)index {
    
    self.indexPathToJump = [NSIndexPath indexPathForRow:index inSection:0];
}

#pragma mark - memory management

- (void)dealloc
{
    if(jobDetail)
        self.jobDetail = nil;
    
    self.quotesTable.delegate = nil;
    self.quotesTable.dataSource = nil;
    self.quotesTable = nil;

    self.noQuotesToDisplayImg = nil;
    self.tableContent = nil;
    self.notServicedImg = nil;
    self.giveUsFeedbackButton = nil;    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

#pragma mark- navigation button clicks

-(void)backButtonClick:(id)sender {
    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setTabbarViewControllers:nil];
    [appDelegate selectTabbarIndex:0];  // select home tabbar as default when going back
}

#pragma mark - button clicks 

-(IBAction)sendUsFeedbackClick:(id)sender
{
    NSString *url = [NSString stringWithString: @"mailto:customercare@redbeacon.com?cc=&subject=Redbeacon%20Iphone%20App%20Customer%20Feedback&body="];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];    
}

#pragma mark - navigation view

- (void)createCustomNavigationLeftButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 65, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:kBackToHomeTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [button setBackgroundImage:[UIImage imageNamed:NavigationButtonBackgroundImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}

- (void)setupNavigationBar {
    
    self.title=kTitle;
    [self.navigationItem setRBTitle:jobDetail.jobRequestName withSubTitle:kTitle];
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:rightBarButtonItemFrame];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
    
    [self createCustomNavigationLeftButton];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    
    [self setupNavigationBar];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [FlurryAnalytics logEvent:@"View - Job Quotes"];
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    
    int numberOfRows = jobDetail.bid_count;
    if(numberOfRows==0){
        if(jobDetail.location_in_launched_zips)
        {
           [noQuotesToDisplayImg setHidden:NO];
           [quotesTable setHidden:YES];
           [notServicedImg setHidden:YES];
           [giveUsFeedbackButton setEnabled:NO];
           [giveUsFeedbackButton setHidden:YES]; 
        }
        else
        {
            [noQuotesToDisplayImg setHidden:YES];
            [quotesTable setHidden:YES];
            [notServicedImg setHidden:NO];
            [giveUsFeedbackButton setEnabled:YES];
            [giveUsFeedbackButton setHidden:NO];             
        }
    }
    else{
        [noQuotesToDisplayImg setHidden:YES];
        [quotesTable setHidden:NO];
        [notServicedImg setHidden:YES];
        [giveUsFeedbackButton setEnabled:NO];
        [giveUsFeedbackButton setHidden:YES];
    }
        
    if (indexPathToJump) {
        [self tableView:quotesTable didSelectRowAtIndexPath:indexPathToJump];
        self.indexPathToJump = nil;
    }
    
    [quotesTable reloadData];
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRows = jobDetail.bid_count;
    return numberOfRows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString *headerTitlerText = @"You're covered with our Home Service Guarantee";
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_red_background.png"]];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    headerTitle.textColor =	[UIColor whiteColor];
    headerTitle.font=[UIFont boldSystemFontOfSize:11];
    
    headerTitle.text=headerTitlerText;
    headerTitle.backgroundColor= [UIColor clearColor];
    headerTitle.textAlignment=UITextAlignmentCenter;
    [headerImage addSubview:headerTitle];
    [headerTitle release];
    headerTitle=nil;
    
    return [headerImage autorelease];
    
}  


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    QuotesListCell *quotesListCell = (QuotesListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (quotesListCell == nil) {
        quotesListCell = [[QuotesListCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                           reuseIdentifier:cellIdentifier];
        [quotesListCell autorelease];
        quotesListCell.frame = CGRectMake(0.0, 0.0, 320.0, quotesCellHeight);
    }
    
    [quotesListCell displayCellItems:[jobDetail.jobBids objectAtIndex:indexPath.row]];
  
    return quotesListCell;  
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailQuotesViewController *detailQuotesViewController = [[DetailQuotesViewController alloc] init];

    detailQuotesViewController.selectedBidIndex = indexPath.row;
    [detailQuotesViewController setJobBid:[jobDetail.jobBids objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detailQuotesViewController animated:YES];
    [detailQuotesViewController release];
    detailQuotesViewController=nil;
    
}

@end
