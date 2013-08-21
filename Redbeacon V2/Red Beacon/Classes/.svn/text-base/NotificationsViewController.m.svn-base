//
//  NotificationsViewController.m
//  Red Beacon
//
//  Created by sudeep on 30/09/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "NotificationsViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "ConversationListCell.h"
#import "Red_BeaconAppDelegate.h"
#import "ConversationViewController.h"
#import "RBCurrentJobResponse.h"

#define leftBarButtonItemFrame CGRectMake(0, 0, 85, 25) // to adjust the title centre

@implementation NotificationsViewController

@synthesize noConversationsToDisplayImg;
@synthesize notificationTable;
@synthesize tableContent;
@synthesize isConversation;
@synthesize jobDetail;
@synthesize overlay;
@synthesize jobRequestResponse;
@synthesize defaultImage;


int const cellHeight = 65;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark button Actions 

-(void)markAllRead:(id)sender {
    
    
}

-(void)backButtonClick:(id)sender {
    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setTabbarViewControllers:nil];
    [appDelegate selectTabbarIndex:0];  // select home tabbar as default when going back
}

#pragma mark- initialize navigation bar

- (void)createCustomNavigationRightButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rightBarButtonItemFrame;
    
    if(!isConversation)
        button.frame = CGRectMake(0, 0, 70, 30);
   
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    item = nil;
}

- (void)createCustomNavigationLeftButton {
    
    if(isConversation) {
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
    else {
        //to adjust the title position
        UIButton * button = [[UIButton alloc] initWithFrame:leftBarButtonItemFrame];
        UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self.navigationItem setLeftBarButtonItem:barbuttonItem];
        [button release];
        button = nil;
        [barbuttonItem release];
        barbuttonItem = nil;
    }
    
}

- (void)setupNavigationBar {
    
    if(!isConversation) // means id notification tab{
        [self.navigationItem setRBTitle:@"Notifications"];    
    else
        [self.navigationItem setRBTitle:jobDetail.jobRequestName withSubTitle:@"Conversations"];

    [self createCustomNavigationRightButton]; 
    [self createCustomNavigationLeftButton];
}

#pragma Initializing methods

-(void)changeTheNotificationBadge {
    
    UITabBarItem * tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:kNotificationTabIndex];
    int badgeValue=[tabBarItem.badgeValue intValue];
    if(badgeValue>1)
    	tabBarItem.badgeValue =[NSString stringWithFormat:@"%d",(badgeValue-1)];
    else
        tabBarItem.badgeValue = nil;
}


-(void)setContentForTable {
    
    tableContent = [[NSMutableArray alloc] init];
    
    if([jobDetail hasJobQAS]){
        [tableContent addObject:jobDetail.jobQAS];
    }
    
    for (int i =0; i < [jobDetail.jobBids count]; i++) {
        JobBids *jobBid = [jobDetail.jobBids objectAtIndex:i];
        if([jobBid hasPrivateMessages] || [jobBid hasJobDetail])
            [tableContent addObject:jobBid];
    }
}


#pragma mark - refresh table content

-(void)refreshConversationChatListView {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    
    [self setContentForTable];
    [self.notificationTable reloadData];
    
    if([tableContent count] == 0) {
        self.notificationTable.hidden = YES;
        [self.noConversationsToDisplayImg setHidden:NO];
    }
    else{
        self.notificationTable.hidden = NO;
        [self.noConversationsToDisplayImg setHidden:YES];
    }
}


-(void)refreshTheConversationContents {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    rBCurrentJobResponse.delegate = self;
    if(!jobRequestResponse)
        jobRequestResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    
    jobRequestResponse.delegate = rBCurrentJobResponse;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Refreshing conversations..." 
                                         animated:YES];
    
    [NSThread detachNewThreadSelector:@selector(getJobDetailsOfJobWithId:) 
                             toTarget:jobRequestResponse 
                           withObject:jobDetail.jobID];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    [self setupNavigationBar];

    [self refreshTheConversationContents];
}

-(void)viewWillAppear:(BOOL)animated {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    [self refreshConversationChatListView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overlay Method

- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}


#pragma mark -

-(void)parsingCompleted {
    
    //NSLog(@"Completed");
    [self hideOverlay];
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    rBCurrentJobResponse.delegate = nil;
    [self refreshConversationChatListView];
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRows = [tableContent count];
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    ConversationListCell *conversationListCell = (ConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (conversationListCell == nil) {
        conversationListCell = [[ConversationListCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                 reuseIdentifier:cellIdentifier];
        [conversationListCell autorelease];
        conversationListCell.frame = CGRectMake(0.0, 0.0, 320.0, cellHeight);
    }

    [conversationListCell setCellForDisplay:[tableContent objectAtIndex:indexPath.row]];
    return conversationListCell;  
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ConversationViewController *conversationViewController = [[ConversationViewController alloc]initWithNibName:@"ConversationViewController" bundle:nil];
  
    id content = [tableContent objectAtIndex:indexPath.row];
    if([content isKindOfClass:[JobBids class]])
        [conversationViewController setJobBid:content];
    else
        [conversationViewController setJobQAS:content];
       
    [conversationViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
    [conversationViewController release];
    conversationViewController = nil;
}

#pragma mark - memory management

- (void)dealloc
{
    if(tableContent){
        [tableContent release];
        tableContent = nil;
    }
    [super dealloc];
    self.defaultImage = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
