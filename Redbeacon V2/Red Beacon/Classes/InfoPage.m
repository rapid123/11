//
//  InfoPage.m
//  Red Beacon
//
//  Created by Runi Kovoor on 16/08/11.
//  Copyright 2011 Rapid Value Solution. All rights reserved.
//

#import "InfoPage.h"
#import "RBLoginHandler.h"
#import "LoginViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "Red_BeaconAppDelegate.h"
#import "Reachability.h"
#import "FlurryAnalytics.h"
#import "RBAlertMessageHandler.h"
#import "Reachability.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "SHK.h"
#import "HowItWorksSlideShow.h"

#define SHKTwitterClass  @"SHKTwitter"
#define TWITTER_SHARE_CONTENT @"Redbeacon's free iPhone app - Upload a video of the home service you need done. Sweet! http://redb.co/uqh4kD"

#define FACEBOOK_CONTENT @"Check out the free Redbeacon iPhone app. You can request a home service just by taking a short video of the work you need done around the house. Then Redbeacon sends you quotes from qualified pros. Try it the next time you need a job done. It’s so easy! You can get it now from http://redb.co/uqh4kD"

#define MAIL_SUBJECT @"Redbeacon iPhone app"

#define MAIL_CONTENT @"<html><body><p></p><p>Hey,                                                                                                        You’ve got to try the free Redbeacon iPhone app! You can request a home service just by taking a short video of the work you need done around the house. Then Redbeacon sends you quotes from qualified pros who want to do your job. It’s quick, easy, and actually kind of fun. Try it the next time you need a job done. You can get it now from</p><a href=\"http://redb.co/uqh4kD\">http://redb.co/uqh4kD</a></body></html>"


@interface InfoPage (Private)
   
- (void)mailComposer;
- (void)loadHowItWorks;
- (void)loadFAQ;
- (void)loadFeedbackScreen;
- (void)shareWithFriends;
- (void)signUp ;
-(void)showPublishFeedDialog;

-(void)settingsTopSection:(int)row;
-(void)settingsBottomSection:(int)row;

- (void)mailButtonClicked;
- (void)twitterButtonClicked;
- (void)FacebookButtonClicked;

@end

@implementation InfoPage

@synthesize loginOrLogoutButton, loginLogoutStatusLabel, usernameLabel;
@synthesize overlay;
@synthesize settingstable;
@synthesize facebook;

//to display on top of the LoginButton
NSString * kLoggedInButtonTitle = @"Logout";
NSString * kLoggedOutButtonTitle = @"Login or Signup";

//this function will return the nibName for this class
+ (NSString*)getNibName {
    
    return @"InfoPage";
}

//will setup the navigation bar, format the navigation items
- (void)setupNavigationBar 
{
    
    [self.navigationItem setRBIconImage];
    
    //adds the Close button
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.frame = CGRectMake(0, 0, 60, 30);
    closeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [closeButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"login_btn_selected.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(onTouchUpClose:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [closeButton release];
    closeButton = nil;
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    [closeButtonItem release];
    closeButtonItem = nil;
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,60, 30)];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;   
}


-(void)changeLoginStatus:(NSString *)string {
    if(!string) {
        
        NSArray *section2 = [[NSArray alloc] initWithObjects:@"Login",
                             @"Create an Account",
                             nil];
        [tableContent replaceObjectAtIndex:([tableContent count] - 1) withObject:section2];
        [section2 release];
        section2 = nil;
    }
    else{    
        NSArray *rowArray = [[NSArray alloc] initWithObjects:string, nil];
        [tableContent replaceObjectAtIndex:([tableContent count] - 1) withObject:rowArray];
        [rowArray release];
        rowArray = nil;
    }
}

//checks the login status and displays corresponding title on top of the button
- (void)showLoginStatusAsButtonTitle 
{
    if ([RBBaseHttpHandler isSessionInfoAvailable])
    {
        NSString * username = nil;
        if([[RBDefaultsWrapper standardWrapper] FBUserName]) {
            
            username = [[RBDefaultsWrapper standardWrapper] FBUserName];
        }
        else
            username = [[RBDefaultsWrapper standardWrapper] currentUserName];

        loginLogoutStatusLabel.frame = CGRectMake(42, 350, 242, 23);
        [loginLogoutStatusLabel setText:kLoggedInButtonTitle];
        [usernameLabel setText:username];
        
        if(username) {
            NSString *loggedInAs = [NSString stringWithFormat:@"Log out (%@)",username];
            [self changeLoginStatus:loggedInAs];
        }
    }
    else
    {
        loginLogoutStatusLabel.frame = CGRectMake(44, 348, 242, 45);
        [loginLogoutStatusLabel setText:kLoggedOutButtonTitle];
        [usernameLabel setText:@""];
        [self changeLoginStatus:nil];
    }
    
    [settingstable reloadData];
    
}



-(void)loadTableContent {
    
    if(!tableContent)
        tableContent = [[NSMutableArray alloc] init];
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"How it Works",
                         @"FAQ",
                         @"Give us your Feedback",
                         @"Share with Friends",
                         nil];
    
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"Login",
                         @"Create an Account",
                         nil];
    
    [tableContent addObject:section1];
    [tableContent addObject:section2];
    
    [section1 release];
    section1 = nil;
    
    [section2 release];
    section2 = nil;
    
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [settingstable setBackgroundColor:[UIColor clearColor]];
    [self loadTableContent];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];    
    [self showLoginStatusAsButtonTitle];
    [FlurryAnalytics logEvent:@"View - Info"];    
}

- (void)logout 
{
     NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    loginHandler = [[RBLoginHandler alloc] init];
    loginHandler.delegate = self;
    [loginHandler sendLogoutRequest];
    [pool drain];
}

#pragma mark - Button Action Methods
- (IBAction)onTouchUpLoginOrLogout:(id)sender 
{
    if (![RBBaseHttpHandler isSessionInfoAvailable]) 
    {        
        LoginViewController *loginViewController = [[LoginViewController alloc]
                                                    initWithNibName:@"LoginViewController" 
                                                    bundle:nil];

        [self.navigationController pushViewController:loginViewController animated:YES];
        [loginViewController hideLoginLabel:YES];
        [loginViewController release];
        loginViewController = nil;

    }
    else
    {
        if ([Reachability connected]) {
            
            Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
            self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                              withMessage:@"Logging out..." 
                                                 animated:YES];
            [NSThread detachNewThreadSelector:@selector(logout) 
                                     toTarget:self 
                                   withObject:nil];
        }       
        
    }
    [self showLoginStatusAsButtonTitle];
}

- (IBAction)onTouchUpCancel:(id)sender
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)onTouchUpClose:(id)sender 
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (void)removeOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    [self removeOverlay];
    RBDefaultsWrapper * sharedWrapper = [RBDefaultsWrapper standardWrapper];
    [sharedWrapper clearUserInformation];
    NSLog(@"Logout succesful");
    [self showLoginStatusAsButtonTitle];
    [loginHandler release];
    loginHandler = nil;
    
}

#pragma mark - HTTP Delegate method
- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request
{
    [self removeOverlay];
    
    //error occured while logging out
    NSLog(@"Logout error");
    [self showLoginStatusAsButtonTitle];
    [loginHandler release];
    loginHandler = nil;
    
}

#pragma mark - button clicks

- (IBAction)callButtonClick:(id)sender
{
    [FlurryAnalytics logEvent:@"Call Redbeacon Button"];
    [[UIApplication sharedApplication] 
     openURL:[NSURL URLWithString:@"tel:1-855-723-2266"]];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    int numberOfSections = [tableContent count] + 1;
    return numberOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRows = (section == [tableContent count]) ? 0 : [[tableContent objectAtIndex:section] count];
    return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    NSArray *rowArray = [tableContent objectAtIndex:indexPath.section];
    NSString *text = [rowArray objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    if(section == [tableContent count]){  // only for the last index
        NSString *version = [NSString stringWithFormat:SETTING_PAGE_TEXT,
                             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
        headerTitle.textColor =	[UIColor whiteColor];
        headerTitle.font=[UIFont systemFontOfSize:12];
#ifdef PROD_CONFIG
        headerTitle.text = version;
#else
        headerTitle.text = [NSString stringWithFormat:@"%@\n%@", version, DEV_BUILD_TEXT];
#endif
        headerTitle.backgroundColor = [UIColor clearColor];
        headerTitle.textAlignment = UITextAlignmentCenter;
        headerTitle.lineBreakMode = UILineBreakModeWordWrap;
        headerTitle.numberOfLines = 0;
        [headerView addSubview:headerTitle];
        [headerTitle release];
        headerTitle=nil;
    }
    
    return [headerView autorelease];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        [self settingsTopSection:indexPath.row];
    }
    else if(indexPath.section == 1){
        
        [self settingsBottomSection:indexPath.row];   
    }
    else
        return;
    
}

-(void)settingsBottomSection:(int)row {
    
    switch (row) {
        case 0:
            [self onTouchUpLoginOrLogout:nil];
            break;
        case 1:
            [self signUp];
            break;
    }
}

-(void)settingsTopSection:(int)row {
    
    switch (row) {
        case 0:
            [self loadHowItWorks];
            break;
        case 1:
            [self loadFAQ];
            break;
        case 2:
            [self loadFeedbackScreen];
            break;
        case 3:
            [self shareWithFriends];
            break;
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.loginOrLogoutButton = nil;
    self.loginLogoutStatusLabel = nil;
    self.usernameLabel = nil;
}


- (void)dealloc
{
    [loginOrLogoutButton release];
    loginOrLogoutButton = nil;
    self.loginLogoutStatusLabel = nil;
    self.usernameLabel = nil;
    self.overlay = nil;
    
    self.settingstable.delegate = nil;
    self.settingstable.dataSource = nil;
    self.settingstable = nil;
    
    if(objRBFAQandHowItWorksViewController){
        
        [objRBFAQandHowItWorksViewController release];
        objRBFAQandHowItWorksViewController = nil;
    }
    
    [super dealloc];
}


#pragma mark - 

- (void)mailComposer:(BOOL)isFeedback
{
    if ([MFMailComposeViewController canSendMail]) 
    {
        MFMailComposeViewController *picker = 
        [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;    
        if(isFeedback)
            [picker.visibleViewController.navigationItem setRBTitle:@"Give us Feedback"];
        else
            [picker.visibleViewController.navigationItem setRBTitle:@"Tell a Friend"];

        NSString *emailBody = @"";
        
        [picker setMessageBody:MAIL_CONTENT isHTML:YES];
        [picker setSubject:MAIL_SUBJECT];
        if(isFeedback)
        {
           [picker setToRecipients:[NSArray arrayWithObjects:@"customercare@redbeacon.com",nil]];
           [picker setMessageBody:emailBody isHTML:YES];
        }
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

- (void)loadHowItWorks {
    
    HowItWorksSlideShow *browser = [[HowItWorksSlideShow alloc] init];
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];  
    browser = nil;
}

- (void)loadFAQ {
    
    if(!objRBFAQandHowItWorksViewController)
        objRBFAQandHowItWorksViewController = [[RBFAQandHowItWorksViewController alloc] init];
    
    [objRBFAQandHowItWorksViewController setIsFAQ:YES];
    [self.navigationController pushViewController:objRBFAQandHowItWorksViewController animated:YES];
}

- (void)loadFeedbackScreen {
    
    [self mailComposer:TRUE];
}

- (void)shareWithFriends {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@" Tells your Friends about Redbeacon" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"'Tell a Friend' via E-mail",@"Post on Twitter",@"Share on Facebook",nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

-(void)signUp {
    
    LoginViewController *loginViewController = [[LoginViewController alloc]
                                                initWithNibName:@"LoginViewController" 
                                                bundle:nil];
    
    loginViewController.isDefaultSignUp = YES;
    [self.navigationController pushViewController:loginViewController animated:YES];
    [loginViewController hideLoginLabel:YES];
    
    [loginViewController release];
    loginViewController = nil;
}

#pragma mark Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //share Action sheet
    if (0 == actionSheet.tag)
    {
        
        if ([Reachability connected])
        {
            if (0 == buttonIndex)
            {
                [self mailButtonClicked];   
            }
            else if(1 == buttonIndex)
            {
                [self twitterButtonClicked];
            }
            else if(2 == buttonIndex)
            {
                [self FacebookButtonClicked];
            }
        }
    }
}

- (void)mailButtonClicked
{
    [self mailComposer:FALSE];
}
- (void)twitterButtonClicked

{
    NSString *shareTwitterContent = [NSString stringWithFormat:TWITTER_SHARE_CONTENT];
    [[SHK currentHelper]setRootViewController:nil];
    SHKItem *item = [SHKItem text:shareTwitterContent];
    [NSClassFromString(SHKTwitterClass) performSelector:@selector(shareItem:) withObject:item];
}
- (void)FacebookButtonClicked
{

    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *result = nil;
#ifdef PROD_CONFIG
    result = kFacebookPROD;
#else
    result = kFacebookQA;
#endif
    
    facebook = [[Facebook alloc] initWithAppId:result andDelegate:self];
    NSArray *permissions = [[[NSArray alloc] initWithObjects:
                            @"user_likes", 
                            @"read_stream",
                            nil] retain];
    
    facebook.userFlow = YES;
    appDelegate.logindelegate = self.facebook;
    
   //[facebook logout:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [facebook authorize:permissions];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    }   

//    
//    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    NSString *result = nil;
//#ifdef PROD_CONFIG
//    result = kFacebookPROD;
//#else
//    result = kFacebookQA;
//#endif
//    if(facebook){
//        
//        [facebook release];
//        facebook = nil;
//        appDelegate.logindelegate = nil;
//    }
//    facebook = [[Facebook alloc] initWithAppId:result andDelegate:self];
//    facebook.userFlow = NO;
//    appDelegate.logindelegate = self.facebook;
//       
//    NSArray *permissions = [[NSArray arrayWithObjects:@"email", @"read_stream", @"publish_stream", nil] retain];
//    
//    if (![facebook isSessionValid]) {
//        [facebook authorize:permissions];
//    }
}


- (void)fbDidLogin
{
     NSLog(@"FB SUCCESS");

    NSMutableDictionary *params =  
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Redbeacon", @"name",
     MAIL_CONTENT, @"caption",
     FACEBOOK_CONTENT, @"description",
     @"https://m.facebook.com/apps/YOUR_APP_NAMESPACE/", @"link",
     @"http://a5.mzstatic.com/us/r1000/061/Purple/c9/ae/45/mzl.zbdovmzt.175x175-75.jpg", @"picture",
     nil];  
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];

}

-(void)showPublishFeedDialog {
    
    if (fbStreamDialog) {
        fbStreamDialog.delegate = nil;
        [fbStreamDialog release];
        fbStreamDialog = nil;
    }
    
    fbStreamDialog = [[FBStreamDialog alloc] init];
    fbStreamDialog.delegate = self;
    //fbStreamDialog.userMessagePrompt = @"";
    
    fbStreamDialog.attachment=[NSString stringWithFormat:@"{\"description\":\"%@\"}",FACEBOOK_CONTENT];
            
    [fbStreamDialog show];
}


- (void)fbDidLogout
{
    
    NSLog(@"FB ERROR");
    
}


- (void)dialogDidComplete:(FBDialog *)dialog {
    
    NSLog(@"DIALOG DID COMPLETE");
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    
    NSLog(@"DIALOG DID not COMPLETE");
}

@end
