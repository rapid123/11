//
//  DetailQuotesViewController.m
//  Red Beacon
//
//  Created by sudeep on 04/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "DetailQuotesViewController.h"
#import "Red_BeaconAppDelegate.h"
#import "UINavigationItem + RedBeacon.h"
#import "QuotesDetailCellView.h"
#import "RBAsyncImage.h"
#import "ConformAppointmentViewController.h"
#import "ProfileDetailViewController.h"
#import "ReviewsDetailViewController.h"
#import "ConversationViewController.h"
#import "RBCurrentJobResponse.h"
#import "ClassFinder.h"
#import "FlurryAnalytics.h"


#define barAdjustButtonFrame CGRectMake(0, 0, 40, 25)
#define MAKE_SCHEDULE_FRAME CGRectMake(40, 310, 240, 40)
#define QUOTE_REJECTED_FRAME CGRectMake(8, 312, 300, 30)
#define ASYNC_IMAGE_TAG 111
#define schedule_button_tag 100
#define rejected_label_tag 101

@class Red_BeaconAppDelegate;

@interface DetailQuotesViewController (Private)

- (void)createCustomNavigationRightButton;
- (void)setButtonEnability;
- (void)createNavigationBarTittle;
-(void)retrieveJobProfileDescription;
- (IBAction)forwordButtonClicked:(id)sender;
- (IBAction)backWordButtonClicked:(id)sender;
- (void)hideOverlay;
-(void)showTheDetailView;

@end

@implementation DetailQuotesViewController

@synthesize jobBid;
@synthesize reviewView,quoteImageView;
@synthesize viewBackground;
@synthesize whiteBackground;
@synthesize detailQuoteTable,quoteImage;
@synthesize quoteServiceName;
@synthesize jobDetail;
@synthesize selectedBidIndex;
@synthesize overlay;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - memory management

- (void)dealloc
{    
    self.jobBid                     = nil;
    self.detailQuoteTable.delegate  =nil;
    self.detailQuoteTable           = nil;
    
    self.viewBackground.image       =nil;
    self.viewBackground             =nil;
    
    self.whiteBackground.image      =nil;
    self.whiteBackground            =nil;
    
    self.reviewView                 =nil;
    
    self.quoteImage.image           =nil;
    self.quoteImage                 =nil;
    
    self.quoteImageView             =nil;
    self.quoteServiceName           =nil;
    
    self.overlay                    = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark initializing methods


-(void)createTheRejectedBand {
    
    UILabel *rejectedlabel = [[UILabel alloc] initWithFrame:QUOTE_REJECTED_FRAME];
    rejectedlabel.backgroundColor = [UIColor redColor];
    rejectedlabel.textColor = [UIColor whiteColor];
    rejectedlabel.font = [UIFont boldSystemFontOfSize:15];
    rejectedlabel.text = @"Rejected Quote";
    rejectedlabel.tag = rejected_label_tag;
    rejectedlabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:rejectedlabel];
    [rejectedlabel release];
    rejectedlabel = nil;
}

-(void)createTheScheduleButton {

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=MAKE_SCHEDULE_FRAME;
    button.tag = schedule_button_tag;
    [button addTarget:self
               action:@selector(clickOnScheduleAppointment:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"schedule_appointment_bg.png"] forState:UIControlStateNormal];
    [button setTitle:@"Make Appointment" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:button];
    button=nil;
    
}

-(void)removeTagsForQuotes {
    
    UILabel *rejectedLabel = (UILabel *)[self.view viewWithTag:rejected_label_tag];
    if(rejectedLabel)
        [rejectedLabel removeFromSuperview];
    
    UIButton *scheduleButton = (UIButton *)[self.view viewWithTag:schedule_button_tag];
    if(scheduleButton)
        [scheduleButton removeFromSuperview];
}

-(void)initializeView {
    
    self.quoteServiceName.text = jobBid.jobProfile.best_name;
    [self removeTagsForQuotes];
    
    if([jobDetail.jobType isEqualToString:NEW] || [jobDetail isJobExpired]) { // if its schedule section we dont need appointment button
        
        if(!jobBid.rejected_by_consumer) {
            if(![jobBid appointedDate])
                [self createTheScheduleButton];
        }
//        else
//            [self createTheRejectedBand];
    }
    
    if(jobBid.rejected_by_consumer)
        [self createTheRejectedBand];
}

-(void)initializeContents {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    jobBid = [jobDetail.jobBids objectAtIndex:selectedBidIndex];
}


-(void)loadQuoteImage {
    
    quoteImage.image=[UIImage imageNamed:DEFAULT_THUMBNAIL_IMAGE];
    
    RBAsyncImage * oldAsyncImageView = (RBAsyncImage *)[quoteImageView viewWithTag:ASYNC_IMAGE_TAG];
    if(oldAsyncImageView)
        [oldAsyncImageView removeFromSuperview];
    
    RBAsyncImage * asyncImageView = [[RBAsyncImage alloc] init];
    CGRect rect = CGRectMake(6,3,75,70);
    
    asyncImageView.frame=rect;
    asyncImageView.tag= ASYNC_IMAGE_TAG;
    [quoteImageView addSubview:asyncImageView];  
    NSString *urlpath=jobBid.jobProfile.avatar_url;
    urlpath = [urlpath stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
    //removing double-escaped
    urlpath = [urlpath stringByReplacingOccurrencesOfString:@"%252F" withString:@"%2F"];
    NSURL *url = [[NSURL alloc] initWithString:urlpath];
    [asyncImageView loadImageFromURL:url isFromHome:NO];
    [url release];
    url = nil;
    [asyncImageView release];
    
}

-(void)showDetailProfile {
    
    if(jobBid.jobProfile.workImages)
        [self showTheDetailView];
    else 
        [self retrieveJobProfileDescription];
}

#pragma mark - button Click

-(void)clickOnScheduleAppointment:(id)sender {
    
    ConformAppointmentViewController *objConformAppointment = [[ConformAppointmentViewController alloc] initWithNibName:@"ConformAppointmentViewController" bundle:nil];
    
    objConformAppointment.jobBid = self.jobBid;
    objConformAppointment.zipCode = jobDetail.jobLocationID;
    objConformAppointment.jobID  = jobDetail.jobID;
    
    RBNavigationController *conformAppointmentNavigationController = [[RBNavigationController alloc]
                                                                      initWithRootViewController:objConformAppointment];
    [self.navigationController presentModalViewController:conformAppointmentNavigationController animated:YES];
    
    [conformAppointmentNavigationController release];
    conformAppointmentNavigationController = nil;
    
    [objConformAppointment release];
    objConformAppointment = nil; 
}


-(UIView *)createCellDisplayForIndex:(int)index {
    
    QuotesDetailCellView *quotesDetailCellView=[[[QuotesDetailCellView alloc] init] autorelease];
    [quotesDetailCellView setJobBid:jobBid];
    UIView *cellView = nil;
    switch (index) {
        case 0:
            cellView = (UIView *)[quotesDetailCellView createCellWithType:kQuoteReviews];
            break;
        case 1:
            cellView = (UIView *)[quotesDetailCellView createCellWithType:kQuoteFeatures];
            break;
        case 2:
            cellView = (UIView *)[quotesDetailCellView createCellWithType:kQuoteConversation];
            break;
        case 3:
            cellView = (UIView *)[quotesDetailCellView createCellWithType:kQuoteDetails];
            break;
        default:
            break;
    }
    return cellView;
}

- (void)setupNavigationBar {
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:barAdjustButtonFrame];
    UIBarButtonItem *spacebuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:spacebuttonItem];
    
    [spacebuttonItem release];
    spacebuttonItem=nil;
    [button release];
    button = nil;
    
}
- (void)createCustomNavigationRightButton {

    backwordBtn= [[UIButton alloc] initWithFrame:CGRectMake(0,0,32, 32)];
    backwordBtn.contentMode = UIViewContentModeScaleToFill;
    [backwordBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DownIcon"
                                                                                                     ofType:@"png"]]  forState:UIControlStateNormal];
    
    [backwordBtn setBackgroundImage:[UIImage imageNamed:@"DownIcon_disabled.png"] forState:UIControlStateDisabled];
    [backwordBtn addTarget:self action:@selector(backWordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    forwordBtn= [[UIButton alloc] initWithFrame:CGRectMake(32,0,32, 32)];
    forwordBtn.contentMode = UIViewContentModeScaleToFill;
    [forwordBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UpIcon"
                                                                                                    ofType:@"png"]]
                          forState:UIControlStateNormal];
    [forwordBtn setBackgroundImage:[UIImage imageNamed:@"UpIcon_disabled.png"] forState:UIControlStateDisabled];
    [forwordBtn addTarget:self action:@selector(forwordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *navigationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 32)];
    
    navigationView.backgroundColor=[UIColor clearColor];
    [navigationView addSubview:forwordBtn];
    [navigationView addSubview:backwordBtn];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithCustomView:navigationView];
    self.navigationItem.rightBarButtonItem =barButtonItem ;
    [barButtonItem release];
    barButtonItem= nil;
    
    [navigationView release];
    [forwordBtn release];
    [backwordBtn release];
}

- (void)setButtonEnability {
    
    if (self.selectedBidIndex == 0) {
        backwordBtn.enabled = NO;
        
    }
    if (self.selectedBidIndex == self.jobDetail.bid_count - 1) {
        
        forwordBtn.enabled = NO;
    }
    
    if (self.jobDetail.bid_count == 1) {
        
        backwordBtn.enabled = NO;
        forwordBtn.enabled = NO;
    }
}

- (void)createNavigationBarTittle {
    
    NSString *labelString = @"";
    labelString = [labelString  stringByAppendingPathComponent:[NSString stringWithFormat:@"%d of %d",self.selectedBidIndex + 1,jobDetail.bid_count]];
    self.navigationItem.title = labelString;
    [self.navigationItem setRBTitle:labelString];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initializeContents];
    [self initializeView];
    [self setupNavigationBar];
    [self loadQuoteImage];
    
    [self createCustomNavigationRightButton];
    [self setButtonEnability];
    
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self initializeContents];
    
    [detailQuoteTable reloadData];
    [self createNavigationBarTittle];
    [FlurryAnalytics logEvent:@"View - Bid Details"];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    self.title = @"Back";
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)isAccessoryButtonRequiredForIndex:(NSIndexPath *)indexPath {
    
    BOOL accessoryRequired = NO;
    switch (indexPath.row) {
        case 0:{
            int reviewCount = [jobBid.jobProfile.review_count intValue]; 
            if(reviewCount!=0)
                accessoryRequired = YES;
            break;
              }
        case 1:
            accessoryRequired=YES;
            break;
        case 2:
            if([jobBid.privateMessages count]>0 || jobBid.description)
                accessoryRequired = YES;
            break;
        
        default:
            break;
    }
    
    return accessoryRequired;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //int numberOfRows = [tableContent count];
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
	// Return the height of rows in the section.
    if(indexPath.row==3)
        return 150;
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    headerView.backgroundColor=[UIColor lightGrayColor];
    
    return [headerView autorelease];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *tablecell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tablecell == nil) {
        tablecell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        tablecell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if ([tablecell.contentView subviews]){
        for (UIView *subview in [tablecell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    tablecell.accessoryType = UITableViewCellAccessoryNone;
    BOOL isAccessoryRequired = [self isAccessoryButtonRequiredForIndex:indexPath];
    if(isAccessoryRequired)
        tablecell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

   
    UIView *cellView = [self createCellDisplayForIndex:indexPath.row];
    [tablecell.contentView addSubview:cellView];
    
    return tablecell;  
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isAccessoryButtonPresent = [self isAccessoryButtonRequiredForIndex:indexPath];
    if(!isAccessoryButtonPresent)
        return;
    
    selectedIndex = indexPath.row;
    if(indexPath.row < 3) {
        [self showDetailProfile];
   }
}
 
#pragma mark - Button Actions

-(void)refreshView {
    
    [self setButtonEnability];
    [self createNavigationBarTittle];
    jobBid = [jobDetail.jobBids objectAtIndex:self.selectedBidIndex];
    
    [detailQuoteTable reloadData];
    [self initializeView];
    [self loadQuoteImage];
}

- (IBAction)backWordButtonClicked:(id)sender {
    
    //NSLog(@"cureent page number%d",self.selectedBidIndex);
    self.selectedBidIndex = self.selectedBidIndex - 1;
    forwordBtn.enabled = YES;
    [self refreshView];
}

- (IBAction)forwordButtonClicked:(id)sender {
    
   // NSLog(@"cureent page number%d",self.selectedBidIndex);
    self.selectedBidIndex = self.selectedBidIndex + 1;
    backwordBtn.enabled = YES;
    [self refreshView];
}

-(IBAction)profileImageClick:(id)sender {
    
    selectedIndex = 1;
    [self showDetailProfile];
}

-(IBAction)bidDetailCallButtonClicked:(id)sender 
{
    NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@",jobBid.jobProfile.phone];
    [[UIApplication sharedApplication] 
     openURL:[NSURL URLWithString:phoneNumber]];
}


#pragma mark - 

- (void)parseBidProfileDetails:(NSDictionary *)result
{
    JobBidProfile *jobBidProfile =  jobBid.jobProfile;
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    id workImages = [result objectForKey:@"work_images"];
    if(workImages){
        
        if([workImages isKindOfClass:[NSArray class]]){
            for (int i=0; i<[workImages count]; i++) {
                NSDictionary *workImageDict = [workImages objectAtIndex:i];
                WorkImage *workImage = [[WorkImage alloc] init];
                workImage.thumbnail_url = [workImageDict objectForKey:@"thumbnail_url"];
                workImage.image_url = [workImageDict objectForKey:@"image_url"];
                [images addObject:workImage];
                [workImage release];
            }
        }
        else{
            
            WorkImage *workImage = [[WorkImage alloc] init];
            workImage.thumbnail_url = [workImages objectForKey:@"thumbnail_url"];
            workImage.image_url = [workImages objectForKey:@"image_url"];
            [images addObject:workImage];
            [workImage release];
        }
    }

    jobBidProfile.workImages = images;
    [images release];
    images = nil;
    
    //*************************details***************
    
    id profileDetails = [result objectForKey:@"details"];
    if([profileDetails isKindOfClass:[NSArray class]]){
        NSMutableArray *details = [[NSMutableArray alloc] init];
        for (int i=0; i<[profileDetails count]; i++) {
            [details addObject:[profileDetails objectAtIndex:i]];
        }
        jobBidProfile.details = details;
        [details release];
        details = nil;
    }
    
    //*************************reviews***************
    
    id profileReviews = [result objectForKey:@"reviews"];
    if([profileReviews isKindOfClass:[NSArray class]]){
        NSMutableArray *reviews = [[NSMutableArray alloc] init];
        for (int i=0; i<[profileReviews count]; i++) {
            Review *objReview = [[Review alloc]init];
            
            objReview.rating        =  [[[profileReviews objectAtIndex:i] valueForKey:@"rating"]     intValue];
            objReview.review_id     =  [[[profileReviews objectAtIndex:i] valueForKey:@"review_id"]  intValue];
            objReview.profile_id    =  [[[profileReviews objectAtIndex:i] valueForKey:@"profile_id"] intValue];
            objReview.author        =  [[profileReviews objectAtIndex:i]  valueForKey:@"author"];
            objReview.content       =  [[profileReviews objectAtIndex:i]  valueForKey:@"content"];

            if ([[profileReviews objectAtIndex:i]  valueForKey:@"date"] != [NSNull null]) {
                
                int appointmentedDate = [[[profileReviews objectAtIndex:i]  valueForKey:@"date"] intValue];
                objReview.date   = [NSDate dateWithTimeIntervalSince1970:appointmentedDate]; 
            }
            
            [reviews addObject:objReview];
            [objReview release];
            objReview = nil;
        }
        jobBidProfile.reviews = reviews;
        [reviews release];
        reviews = nil;
    }
    
    //*************************rate distribution**********
    
    NSDictionary *rating_distribution = [result objectForKey:@"rating_distribution"];
    NSMutableDictionary *rateDistribution = [[NSMutableDictionary alloc] initWithDictionary:rating_distribution];
    jobBidProfile.rateDistribution = rateDistribution;
    [rateDistribution release];
    rateDistribution = nil;

}

-(void)showTheDetailView {
    
    id detailViewController = nil;
    switch (selectedIndex) {
        case 0:
            detailViewController = [[ReviewsDetailViewController alloc] init];
            break;
        case 1:
            [ClassFinder unload:@"ProfileDetailViewController"];
            detailViewController = LOCATE(ProfileDetailViewController);
            
            break;
        case 2:
            detailViewController = [[ConversationViewController alloc] init];
            [detailViewController setHidesBottomBarWhenPushed:YES];
            break;
        default:
            break;  
    }
    [detailViewController setJobBid:jobBid];

    [self.navigationController pushViewController:detailViewController animated:YES];

    if([detailViewController isKindOfClass:[ProfileDetailViewController class]]){
        return;
    }
    [detailViewController release];
    detailViewController=nil;
}

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    do
    {
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
       if (requestType == kBidDetails) 
       {
           NSString *responseString = [request responseString];
          // NSLog(@"Response ===%@",responseString);
           NSDictionary * responseDictionary = [responseString JSONValue];
           
           NSDictionary *profileDetails =[responseDictionary objectForKey:@"profile"];
           [self parseBidProfileDetails:profileDetails];
           
       }
    
    } while (0); 
    
    
    [self hideOverlay];
    
//    JobBidProfile *jobBidProfile1 =  jobBid.jobProfile;
//   // NSLog(@"images count =%d",[jobBidProfile1.workImages count]);
//    for (int i=0; i<[jobBidProfile1.workImages count]; i++) {
//        NSString *thumbnail = [[jobBidProfile1.workImages objectAtIndex:i] image_url];
//        //NSLog(@"%@",thumbnail);
//    }
    
    [self showTheDetailView];
    
}  
    
- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    
    //error in response
    
}


-(void)retrieveJobProfileDescription {
    
    if (!jobRequestResponse)
    {
        jobRequestResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    jobRequestResponse.delegate = self;
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Loading..." 
                                         animated:YES];
    
    NSString *bidId = [NSString stringWithFormat:@"%d",jobBid.bidID];
    [jobRequestResponse getBidDetailsWithJobId:jobDetail.jobID andBidId:bidId];
    
//    [NSThread detachNewThreadSelector:@selector(getJobDetailsOfJobWithId:) 
//                             toTarget:jobRequestResponse 
//                           withObject:[self readListViewItems:indexPath].jobID];
    
}


#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}



@end
