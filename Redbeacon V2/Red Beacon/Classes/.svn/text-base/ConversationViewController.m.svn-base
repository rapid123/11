//
//  ConversationViewController.m
//  Red Beacon
//
//  Created by Nithin George on 13/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConversationViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBAlertMessageHandler.h"
#import "RBCurrentJobResponse.h"
#import "RBAlertMessageHandler.h"


#define ALERT_CONVERSATION_SUCCESS_TAG 0
#define ALERT_CONVERSATION_FAIL_TAG 1

#define AS_CONVERSATION_SUCCESS_ALERT_MESSAGE @"Conversation is successful"  
#define AS_CONVERSATION_FAILED_ALERT_MESSAGE @"Conversation is failed. Do you want to continue?" 

#define NavigationButtonBackgroundImage @"navigationButton_background.png"

#define kImageWidth   42
#define kImageHeight  29

#define kBlueLeftCapWidth  19
#define kBlueRightCapWidth (kImageWidth - kBlueLeftCapWidth - 1)

#define kGreenLeftCapWidth  14
#define kGreenRightCapWidth (kImageWidth - kGreenLeftCapWidth - 1)

#define kTopCapHeight    15
#define kBottomCapHeight (kImageHeight - kTopCapHeight - 1)

#define kMaxMessageContentWidth (320 - 17 - 14 - 20)

#define kTimeStampHeight 21

#define kAContentOffset 6
#define kBContentOffset kAContentOffset - 3

#define kBlueLeftContentOffset  (kBlueLeftCapWidth  - kAContentOffset)
#define kBlueRightContentOffset (kBlueRightCapWidth - kBContentOffset)

#define kGreenLeftContentOffset  (kGreenLeftCapWidth  - kBContentOffset)
#define kGreenRightContentOffset (kGreenRightCapWidth - kAContentOffset)

#define kTopContentOffset    (0)
#define kBottomContentOffset (3)

#define kNonContentWidth  (kImageWidth  - kAContentOffset - kBContentOffset)
#define kNonContentHeight (kImageHeight - kTopContentOffset - kBottomContentOffset)

#define kBubbleImageViewTag  1
#define kContentLabelTag     2
#define kTimestampLabelTag   3

#define THIS_FILE   @"ChatViewController"
#define THIS_METHOD NSStringFromSelector(_cmd)

#define CALL_BTN_IMAGE @"jobButton.png"

#define kNoQuotes 90

@interface ConversationViewController (Private)

- (void)setupNavigationBar;
-(void)adjustScrollView;
-(void)RestoreScrollview;
- (void)scrollTable;
-(void)startAnimateScrollview:(int)iVal;

- (void)handleConversationAPI;
- (void)hideOverlay;
- (void)setChatContentValues:(NSString *)chatText withDate:(NSDate *)date;

- (CGSize)sizeForMessageIndexPath:(NSIndexPath *)indexPath;
- (UIFont *)messageFont;
- (UITableViewCell *)newMessageBubbleCellWithIdentifier:(NSString *)cellIdentifier;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeForMessageIndexPath:(NSIndexPath *)indexPath;

- (IBAction)conversationButtonClicked:(id)sender;
@end

@implementation ConversationViewController

@synthesize conversationScrollView;
@synthesize conversationTable;
@synthesize conversationContent;
@synthesize txtConversation;
@synthesize jobBid, jobQAS;
@synthesize overlay;
@synthesize jobRequestResponse;
@synthesize sendButton;
@synthesize isFromScheduleView;

#pragma mark -

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
    self.jobBid                 = nil;
    self.conversationScrollView = nil;
    self.conversationTable      = nil;
    self.conversationContent    = nil;
    self.txtConversation        = nil;
    [conversationTextResponse release];
    conversationTextResponse = nil;
    self.overlay = nil;
    self.sendButton = nil;
    [super dealloc];
   
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - initialize navigation bar

- (void)setupNavigationBar
{
    
    //to adjust the title position
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 30)];//jvcBarButtonItemFrame
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [rightButton release];
    rightButton = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
}

-(void)initializeButtons {
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,40)];
    [buttonView setBackgroundColor:[UIColor clearColor]];
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callButton.frame = CGRectMake(25, 5,120, 30);
    [callButton setTitle:@"Call" forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:callButton];
    callButton = nil; 
    
    UIButton *quoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quoteButton.frame = CGRectMake(175, 5,120, 30);
    [quoteButton setTitle:@"View Quote" forState:UIControlStateNormal];
    [buttonView addSubview:quoteButton];
    [quoteButton addTarget:self action:@selector(viewQuatesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    quoteButton = nil;
    
    conversationTable.tableHeaderView = buttonView;
    [buttonView release];
    buttonView = nil;
    
}


-(NSString *)getTimeToDisplay:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateAndTimeString = [formatter stringFromDate:date];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:@" "];
    [formatter setDateFormat:@"h:mmaa"];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:[formatter stringFromDate:date]];
    [formatter release];
    return dateAndTimeString;
}

-(void)setChatPrivateMessages:(JobPrivateMessage *)pvtMessage {
    
    NSString *text = [pvtMessage message];
    int type = pvtMessage.is_provider;
    
    NSString *timePosted = [self getTimeToDisplay:pvtMessage.timeCreated];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    [result setValue:[NSNumber numberWithBool:type] forKey:@"Type"];
    [result setObject:text forKey:@"Chat"];
    [result setObject:timePosted forKey:@"Time"];
    [self.conversationContent addObject:result];
    [result release];
    
    [self.conversationTable reloadData];
}

-(void)startNotifications {
    
    // register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:self.view.window];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:self.view.window];
}


-(void)addDescriptionToChat {
    
    [self setChatContentValues:jobBid.description withDate:nil];
}

-(void)retrievePrivateMessagesAndAddToChat {
    
    for (int i= 0; i < [jobBid.privateMessages count]; i++) {

        JobPrivateMessage *privateMessage  = [jobBid.privateMessages objectAtIndex:i] ;
        [self setChatPrivateMessages:privateMessage];
    }
}


- (void)setQASChat:(JOBQAS *)qas {
    
    NSString *question = qas.question;
    NSString *answer = qas.answer;
    NSString *timeQuestioned = [self getTimeToDisplay:qas.time_created];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    [result setValue:[NSNumber numberWithBool:1] forKey:@"Type"];
    [result setObject:question forKey:@"Chat"];
    [result setObject:timeQuestioned forKey:@"Time"];
    [self.conversationContent addObject:result];
    [result release];
    
    if(answer && qas.time_answered) {
        NSString *timeanswered = [self getTimeToDisplay:qas.time_answered];
        NSMutableDictionary *result1 = [[NSMutableDictionary alloc]init];
        [result1 setObject:[NSNumber numberWithBool:0] forKey:@"Type"];
        [result1 setObject:answer forKey:@"Chat"];
        [result1 setObject:timeanswered forKey:@"Time"];
        [self.conversationContent addObject:result1];
        [result1 release];
        
    }
    [self.conversationTable reloadData];
}


-(void)addQASToChat {
    
    for (int i= 0; i < [jobQAS count]; i++) {
        
        JOBQAS *qas  = [jobQAS objectAtIndex:i] ;

        [self setQASChat:qas];
    }
}


-(void)initializeContentsToDisplay {
    
    if(jobBid){
        if([jobBid hasJobDetail])
            [self addDescriptionToChat];

        if([jobBid hasPrivateMessages])
            [self retrievePrivateMessagesAndAddToChat];
    }
    else
        [self addQASToChat];
    
    [self scrollTable];
}

-(void)setTitleForView {
    
    NSString *titleText = @"Public Question";
    if(jobBid)
        titleText = jobBid.jobProfile.best_name;
    [self.navigationItem setRBTitle:titleText
                       withSubTitle:@"Conversation"];
    
}

- (BOOL)isValidText:(UITextField *)textField {    
    BOOL isValid = NO;
    NSString * jDescription = textField.text;
    jDescription = [jDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([jDescription length]>0){	        
        isValid = YES;
    }
    return isValid;    
}

-(void)sendButtonActivated:(UITextField *)textField {

    BOOL textEntered = [self isValidText:textField];
    [sendButton setEnabled:textEntered];
}



-(void)initializeDefaultViews {
    
    [self sendButtonActivated:NO];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleForView];
    [self initializeDefaultViews];
    [self setupNavigationBar];
    
    if(!isFromScheduleView)
        [self initializeButtons];
    
    [self startNotifications];
    
    self.conversationScrollView.contentSize = CGSizeMake(0, 460);
    self.conversationScrollView.scrollEnabled = YES;
    NSMutableArray *tempConversationContent = [[NSMutableArray alloc]init];
    self.conversationContent    = tempConversationContent;
    [tempConversationContent release];
    tempConversationContent = nil;
    
    [self initializeContentsToDisplay];
    
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


#pragma mark - scrolling handling

- (void)keyboardWillHide:(NSNotification *)obj_notification{
	if(bcontentflag)
	{
		icontentsize=460;
		self.conversationScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=NO;
	}
	[self RestoreScrollview];
}

- (void)keyboardWillShow:(NSNotification *)obj_notification{
	[self adjustScrollView];
}


-(void)RestoreScrollview{
    CGPoint pt;
    pt.x = 0 ;
    pt.y = 0 ;
    [self.conversationScrollView setContentOffset:pt animated:YES];
}

-(void)adjustScrollView{		
	if(!bcontentflag)
	{
		icontentsize=270;
		self.conversationScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=YES;
	}
	
}

-(void)startAnimateScrollview:(int)iVal{
    CGRect rc = [self.conversationScrollView bounds];
    rc = [self.conversationScrollView convertRect:rc toView:self.view];
    CGPoint pt = rc.origin ;
    pt.x = 0 ;
    pt.y -= iVal*(-1) ;
    [self.conversationScrollView setContentOffset:pt animated:YES];
}


-(void)scrollTable {
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:([conversationContent count] - 1) inSection:0];
    if(-1!=index.row)
    {
        [self.conversationTable scrollToRowAtIndexPath:index
                                      atScrollPosition:UITableViewScrollPositionBottom 
                                              animated:YES];
    }
}


#pragma mark - textField delegates

-(void) textFieldDidBeginEditing:(UITextField *)textField {
	
    [self adjustScrollView];
	float fval;
	
	if(textField == self.txtConversation ) {
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
            [self startAnimateScrollview:(int)((fval-165))];
            
		}
	}
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {  
    
   //BOOL textEntered = [self isValidText:theTextField];
    [self performSelector:@selector(sendButtonActivated:) 
                 withObject:theTextField afterDelay:0.1];
   //[self sendButtonActivated:textEntered];
    
   return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - set chat dictionary

- (void)setChatContentValues:(NSString *)chatText withDate:(NSDate *)date
{

    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    [result setValue:[NSNumber numberWithBool:0] forKey:@"Type"];
    [result setObject:chatText forKey:@"Chat"];
    if (date == nil) {
        [result setValue:[NSNumber numberWithBool:1] forKey:@"Type"];
    }
    else
        [result setObject:[self getTimeToDisplay:date] forKey:@"Time"];
    [self.conversationContent addObject:result];
    [result release];
    
    [self.conversationTable reloadData];
   
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath    {

    CGSize cellSize = [self sizeForMessageIndexPath:indexPath];
	
	return cellSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.conversationContent count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ChatViewController_Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[self newMessageBubbleCellWithIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma mark -
#pragma mark table cell initialization


- (UITableViewCell *)newMessageBubbleCellWithIdentifier:(NSString *)cellIdentifier
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
	                                               reuseIdentifier:cellIdentifier];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor colorWithRed:(219/255.0) green:(226/255.0) blue:(237/255.0) alpha:1.0];
	
	UILabel *timestampLabel;
	UILabel *contentLabel;
	UIImageView *bubbleImageView;
	
    // Add text label for timestamp
    timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width , kTimeStampHeight)];
    timestampLabel.font = [UIFont systemFontOfSize:12];
    timestampLabel.textAlignment = UITextAlignmentCenter;
    timestampLabel.backgroundColor = [UIColor clearColor];//cell.backgroundColor;
    timestampLabel.opaque = YES;
    timestampLabel.tag = kTimestampLabelTag;
    timestampLabel.shadowOffset = CGSizeMake(0,1);
    timestampLabel.textColor = [UIColor colorWithRed:(33/255.0F) green:(40/255.0F) blue:(53/255.0F) alpha:1.0F];
    timestampLabel.shadowColor = [UIColor whiteColor];
	timestampLabel.text = @"Time";
    
    int x=0;

	contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(x, 20, 100, 25);
	contentLabel.font = [self messageFont];
    contentLabel.numberOfLines = 0;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.tag = kContentLabelTag;
	contentLabel.text = @"Content";
    
    bubbleImageView = [[UIImageView alloc] initWithImage:nil];
    bubbleImageView.tag = kBubbleImageViewTag;
    
    // Note: Order matters - The contentLabel must be above the bubbleImageView
	[cell.contentView addSubview:timestampLabel];
	[cell.contentView addSubview:bubbleImageView];
	[cell.contentView addSubview:contentLabel];
    
	[timestampLabel release];
	[contentLabel release];
	[bubbleImageView release];
	
    return cell;
}

- (UIFont *)messageFont
{
    return [UIFont systemFontOfSize:14];
	//return [UIFont systemFontOfSize:([UIFont systemFontSize] - 1.0F)];
}

- (CGSize)sizeForMessageIndexPath:(NSIndexPath *)indexPath
{
    
	NSMutableDictionary *message = [conversationContent objectAtIndex:indexPath.row];
	NSString *content = [message valueForKey:@"Chat"];
	
	UIFont *font = [self messageFont];
	
	CGSize maxContentSize = CGSizeMake(kMaxMessageContentWidth, INFINITY);
	CGSize contentSize = [content sizeWithFont:font constrainedToSize:maxContentSize];
	
	CGSize cellSize = contentSize;
	
    cellSize.width  = MAX(contentSize.width + kNonContentWidth, kImageWidth);
	cellSize.height = MAX(contentSize.height + kNonContentHeight, kImageHeight);
	
    // Add room for timestamp
	cellSize.height += kTimeStampHeight;
	
	
	return cellSize;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	
	cell.userInteractionEnabled = NO;
    // Get message and cell views
    
	UILabel     *timeStampLabel  =     (UILabel *)[cell viewWithTag:kTimestampLabelTag];
	UILabel     *contentLabel    =     (UILabel *)[cell viewWithTag:kContentLabelTag];
	UIImageView *bubbleImageView = (UIImageView *)[cell viewWithTag:kBubbleImageViewTag];
	
	
    // Configure frames for everything
	
    CGSize messageSize = [self sizeForMessageIndexPath:indexPath];
	
    CGRect textFrame;
	CGRect bubbleFrame;
	
    NSMutableDictionary *message = [conversationContent objectAtIndex:indexPath.row];
	BOOL content = [[message valueForKey:@"Type"] boolValue];
    
	if(content) 
	{
        // Outgoing = GreenBubble (Right Side)
		
		timeStampLabel.textAlignment = UITextAlignmentCenter;
		bubbleFrame.origin.x = cell.frame.size.width - messageSize.width;
		bubbleFrame.origin.y = 0;
		bubbleFrame.size.width = messageSize.width;
		bubbleFrame.size.height = messageSize.height;
		
		textFrame.origin.x = bubbleFrame.origin.x + kGreenLeftContentOffset;
		textFrame.origin.y = bubbleFrame.origin.y + kTopContentOffset;
		textFrame.size.width = messageSize.width - kGreenLeftContentOffset - kGreenRightContentOffset;
		textFrame.size.height = messageSize.height - kTopContentOffset - kBottomContentOffset;
	}
	if(!content)
	{
        // Incoming = BlueBubble (Left Side)
		
		timeStampLabel.textAlignment = UITextAlignmentCenter;
		bubbleFrame.origin.x = 0;
		bubbleFrame.origin.y = 0;
		bubbleFrame.size.width = messageSize.width;
		bubbleFrame.size.height = messageSize.height;
		
		textFrame.origin.x = bubbleFrame.origin.x + kBlueLeftContentOffset;
		textFrame.origin.y = bubbleFrame.origin.y + kTopContentOffset;
		textFrame.size.width = messageSize.width - kBlueLeftContentOffset - kBlueRightContentOffset;
		textFrame.size.height = messageSize.height - kTopContentOffset - kBottomContentOffset;
	}
	
    // Timestamp
	
	textFrame.size.height -= kTimeStampHeight;
	textFrame.origin.y += kTimeStampHeight;
	
	bubbleFrame.origin.y += kTimeStampHeight;
	bubbleFrame.size.height -= kTimeStampHeight;
	
	timeStampLabel.hidden = NO;
	timeStampLabel.text = [message objectForKey:@"Time"];
	
    // Content
    NSMutableDictionary *messageText = [conversationContent objectAtIndex:indexPath.row];

	contentLabel.text = [messageText valueForKey:@"Chat"];
    contentLabel.font = [self messageFont];
	
    // Bubble Image
	
	if(message) 
	{
		UIImage *img = [[UIImage imageNamed:@"GreenBubble.png"] stretchableImageWithLeftCapWidth:kGreenLeftCapWidth
		                                                                            topCapHeight:kTopCapHeight];
		bubbleImageView.image = img;
        contentLabel.textAlignment = UITextAlignmentRight;
    }
    if(!content)
    {
		UIImage *img = [[UIImage imageNamed:@"BlueBubble.png"] stretchableImageWithLeftCapWidth:kBlueLeftCapWidth
		                                                                           topCapHeight:kTopCapHeight];
        bubbleImageView.image = img;
        contentLabel.textAlignment = UITextAlignmentLeft;
    }
	
	contentLabel.frame = textFrame;
    bubbleImageView.frame = bubbleFrame;
}


#pragma mark - button click actions

- (IBAction)conversationButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callButtonClicked:(id)sender
{
    if(jobBid){
        NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@",jobBid.jobProfile.phone];
        [[UIApplication sharedApplication] 
         openURL:[NSURL URLWithString:phoneNumber]];
    }
}

-(void)jumpToQuotesTab {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    int index = [jobDetail getBidIndexOfBidId:jobBid.bidID];
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    int indexOfQuotesTab = [appDelegate indexOfQuotestab];
    [appDelegate selectTabbarIndex:indexOfQuotesTab withTableIndex:index];
}

-(void)showPublicQuestionAlert {
    
    NSString * title = @"Redbeacon";
    [RBAlertMessageHandler showAlertWithTitle:title
                                      message:@"Its a Public Question" 
                               delegateObject:self
                                      viewTag:kNoQuotes 
                             otherButtonTitle:@"OK" 
                                   showCancel:YES];
}

- (IBAction)viewQuatesButtonClicked:(id)sender
{
    if(jobBid){
        [self jumpToQuotesTab];
    }
    else {
        [self showPublicQuestionAlert];
    }
}

- (IBAction)conversationSendButtonClicked:(id)sender
{
    [self.txtConversation resignFirstResponder]; 
    
    [self handleConversationAPI];
}


#pragma mark - conversation refreshing 

-(void)refreshTheConversationContents {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    rBCurrentJobResponse.delegate = self;
    if(!jobRequestResponse)
        jobRequestResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    
    jobRequestResponse.delegate = rBCurrentJobResponse;

    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    [NSThread detachNewThreadSelector:@selector(getJobDetailsOfJobWithId:) 
                             toTarget:jobRequestResponse 
                           withObject:jobDetail.jobID];
}




#pragma mark- API handling

- (void)handleConversationAPI
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    NSString *bidID = [NSString stringWithFormat:@"%d",jobBid.bidID];
    
    if (!conversationTextResponse)
    {
        conversationTextResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    conversationTextResponse.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Sending message..." 
                                         animated:YES];
    
    //private qustn.
    if (jobBid) {
        
        [conversationTextResponse askOrAnswerPrivetQuestionRequestWithBidId:bidID andMessage:self.txtConversation.text]; 
    }
    else
    {
        RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
        JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
        JOBQAS *qas = [jobQAS lastObject];
        
        NSString *questionId= [NSString stringWithFormat:@"%d",qas.question_id];
        
        [conversationTextResponse answerPublicQuestionRequestWithJobId:jobDetail.jobID questionId:questionId andAnswer:self.txtConversation.text];
    }
    
    if (pool) 
        [pool drain];
}


#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    //reload the table after the response complete
    do
    {
        NSString * title = @"Redbeacon";
        NSString *message;
        int alertTag;
        BOOL IsCancelButton;
        
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        if (requestType == kAskAnswerQuestion) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
            
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            BOOL response =[[responseDictionary objectForKey:@"success"] boolValue];
            if (response) {
                
                [self setChatContentValues:self.txtConversation.text withDate:[NSDate date]];
                self.txtConversation.text = @"";
//                message = AS_CONVERSATION_SUCCESS_ALERT_MESSAGE;
//                alertTag = ALERT_CONVERSATION_SUCCESS_TAG;
//                IsCancelButton = NO;
                
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                message = AS_CONVERSATION_FAILED_ALERT_MESSAGE;
                alertTag = ALERT_CONVERSATION_FAIL_TAG;
                IsCancelButton = YES;
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:message 
                                           delegateObject:self
                                                  viewTag:alertTag 
                                         otherButtonTitle:@"OK" 
                                               showCancel:IsCancelButton];  
            }
        } 

    } while (0);  
    
    //[self hideOverlay];
    [self refreshTheConversationContents];
    
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    
    //error in response
    
}


#pragma mark -
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == ALERT_CONVERSATION_SUCCESS_TAG) 
    {
        if (buttonIndex == 0)
        {
            [self setChatContentValues:self.txtConversation.text withDate:[NSDate date]];
             self.txtConversation.text = @"";
        }
        
    }
    else if(alertView.tag == ALERT_CONVERSATION_FAIL_TAG)
    {
        if (buttonIndex == 0)
        {
            [self handleConversationAPI];
        }
        else
        {
            
        }
    }
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
    
    [self sendButtonActivated:NO];
}



-(void)parsingCompleted {
    
   // NSLog(@"Completed");
    [conversationTable reloadData];
    [self scrollTable];
    [self hideOverlay];
    
}

@end
