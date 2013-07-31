//
//  TouchBaseDetailsViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchBaseDetailsViewController.h"
#import "TouchBase.h"
#import "DiscussionParticipants.h"
#import "DataManager.h"
#import "GeneralClass.h"
#import <QuartzCore/Quartzcore.h>
#import "JSON.h"
#import "TouchBaseViewController.h"
#import "DateFormatter.h"
@interface TouchBaseDetailsViewController ()
{
    Comments *comments;
    DiscussionParticipants *discussionParticipants;
    JsonParser *objParser;
    
    CGPoint scrlvos;
    IBOutlet UITextView *commentTextView;
    IBOutlet UILabel *topicLabel;
    IBOutlet UILabel *commentsLabel;
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *touchBaseLabel;
    IBOutlet UILabel *subjectLabel;
    IBOutlet UILabel *subjectContentLabel;
    IBOutlet UILabel *participantsLabel;
    IBOutlet UILabel *participantsListLabel;
    NSMutableArray *participantNameArray;
    IBOutlet UIButton *backGroundTouchBtn;
    IBOutlet UIButton *touchBaseRefreshButton;
    NSMutableArray *newParticipentsArray;
    UIView *syncView;
    int errorEparseType;
    int readCommentObject;
}
@property (nonatomic, strong) TouchBase *touchBase;
@property (nonatomic, strong) NSArray *CommentsDataManagerArray;
@property (nonatomic, strong) IBOutlet UITableView *touchBaseDetailTableView;
@property (nonatomic, strong) IBOutlet CustomTouchBaseDetailCell *customTouchBaseDetailCell;
@property (nonatomic, strong) IBOutlet UIScrollView *touchBaseDetailsScrollview;
@property (nonatomic, strong) IBOutlet UITextView *participentDetailsTextView;
@property (assign) CGPoint startPosition;

- (void)updateCommetsReadStatus:(TouchBase *)touchBase;
-(void)setFontForTouchBase;
-(void)setanimationForSwipe:(int)type;
-(void)addSwipeFunctionality;
-(void)getTouchBaseDetailInformation;
-(void)setValuesInView:(TouchBase *)touchBaseObj;
-(void)viewFlipAnimation;
-(BOOL)saveNewCommentDetails:(NSArray *)result;
-(UITextView *) makeScrollviewUp:(UITextView *)textView;
- (void)setCustomOverlay;
- (void)callNewCommentsAPI;
- (void)callAddParticipantAPI:(NSMutableArray *)participents;
- (void)callRemoveMeAPI;
-(void)callReadCommentAPI:(int)presentCommentObject;

-(IBAction)backGroundTouchBtn:(id)sender;
-(IBAction)removeMeButtonTouched:(id)sender;
-(IBAction)sendButtonTouched:(id)sender;
-(IBAction)touchBaseRefreshBtnTouched:(id)sender;
-(IBAction)addParticipantsButtonTouched:(id)sender;
-(IBAction)backButtonTouched:(id)sender;
-(void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void) getrecipientAddressObjectsAndNames:(TouchBase *)touchBaseMainObject;
-(void)storeAddedParticipentToDB:(NSArray *)newParticipents object: (TouchBase *)touch;
-(void)callReadDiscussionAPI;

@end

BOOL isRefreshButtonTouched;

@implementation TouchBaseDetailsViewController

@synthesize touchBaseDetailTableView;
@synthesize customTouchBaseDetailCell;
@synthesize touchBaseManagerArr;
@synthesize swipeCount;
@synthesize touchBase;
@synthesize CommentsDataManagerArray;
@synthesize touchBaseDetailsScrollview;
@synthesize startPosition;
@synthesize recipientAddressObjects;
@synthesize participentDetailsTextView;
#pragma mark- Init Load
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isRefreshButtonTouched = NO;
    [self setFontForTouchBase];
    [self addSwipeFunctionality];
    
    if(recipientAddressObjects)
    {
        recipientAddressObjects = nil;
    }
    recipientAddressObjects = [[NSMutableArray alloc]init];
    
    [self getrecipientAddressObjectsAndNames:[touchBaseManagerArr objectAtIndex:swipeCount]];
    //    [self callReadDiscussionAPI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getTouchBaseDetailInformation];
    [self customizeTextView];
    
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name: setFontForTouchBase.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void) setFontForTouchBase
{
    commentTextView.layer.cornerRadius = 6;
    commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    commentTextView.layer.borderWidth = 1.5f;
    topicLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    touchBaseLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    commentsLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    sendButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    backButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    subjectLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    //    participentDetailsTextView.backgroundColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    subjectContentLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    participantsLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    participentDetailsTextView.font = [GeneralClass getFont:customNormal and:boldFont];
    
    participantsListLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    commentTextView.font = [GeneralClass getFont:customNormal and:boldFont];
    touchBaseDetailsScrollview.delegate = self;
    commentTextView.delegate = self;
}

/*******************************************************************************
 *  Function saveNewCommentDetails.
 *  Purpose: Save the comment to database.
 *  Parametrs: nil.
 *  Return Values: BOOL,return YES if saved else NO.
 ********************************************************************************/
-(BOOL)saveNewCommentDetails:(NSArray *)result
{
    //DataBase insertion
    BOOL isSaved = 0;
    int newlyAddedCommentId = [[result valueForKey:@"CommentId"] intValue];
    
    NSString *discussionStringID = [result valueForKey:@"discussionId"];
    
    TouchBase *newlyAddedCommetsTouchBase = [DataManager fetchExistingEntityTouchBaseObject:TOUCHBASE discussionId:discussionStringID];
    
    if (newlyAddedCommetsTouchBase)
    {
        Comments *commentsObj = [DataManager createEntityObject:@"Comments"];
        commentsObj.comments = commentTextView.text;
        commentsObj.commentsId = [NSNumber numberWithInt:newlyAddedCommentId];
        NSString *gateString = [DateFormatter getDateStringFromDate:[NSDate date] withFormat:@"MM/dd/yyyy hh:mm a"];        
        commentsObj.commentDate  = [DateFormatter getDateFromDateStringBasedOnDeviceTimeZone:gateString forFormat:@"MM/dd/yyyy hh:mm a"];
        commentsObj.commentPersonName = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"];
        commentsObj.commentStatus = @"1";
        [newlyAddedCommetsTouchBase addCommentIDObject:commentsObj];
    }
    
    isSaved = [DataManager saveContext];
    
    return isSaved;
}


- (void)updateCommetsReadStatus:(TouchBase *)touchBase
{
    
}
- (void)callNewCommentsAPI
{
    //    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    NSString * messageContent = commentTextView.text;
    NSString * operationType = [NSString stringWithFormat:@"%i", NewCommentsAPI];
    NSString * discussionId = touchBase.discussionId;
    NSLog(@"discussionId==%@",discussionId);
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&MessageContent=%@&operationType=%@&discussionId=%@",userId,messageContent,operationType,discussionId];
    
    NSLog(@"NewCommentsAPIParameters==%@",string);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewComments"];
    [objParser parseJson:NewCommentsAPI :string];
}
- (void)callAddParticipantAPI:(NSMutableArray *)participents
{
    [self setCustomOverlay];
    
    [newParticipentsArray addObjectsFromArray:participents];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    
    NSArray *selectedOrRemovedParticipentArray = [[NSArray alloc]initWithArray:participents];
    NSMutableArray *removedParticipentArray = [[NSMutableArray alloc]init];
    NSMutableArray *newlyAddedParticipentArray = [[NSMutableArray alloc]init];
    
    TouchBase *touch = [touchBaseManagerArr objectAtIndex:swipeCount];
    
    NSArray *oldParticipentsArray = [touch.participantsID allObjects];
    
    DiscussionParticipants *oldDiscussionParticipantObj;
    DiscussionParticipants *newlyAddedDiscussionParticipantObj;
    
    int oldParticipentsArrayCount = [oldParticipentsArray count];
    for (int i = 0; i < oldParticipentsArrayCount ; i ++)
    {
        oldDiscussionParticipantObj = [oldParticipentsArray objectAtIndex:i];
        
        int removedParticipentID = [oldDiscussionParticipantObj.participantId intValue];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.participantId = %d",removedParticipentID];
        NSArray *participentEntityObject = [selectedOrRemovedParticipentArray filteredArrayUsingPredicate:predicate];
        
        if ([participentEntityObject count] == 0)
        {
            [removedParticipentArray addObject:[NSNumber numberWithInt:removedParticipentID]];
        }
        else
        {
            DiscussionParticipants *oldDiscussionParticipantObjNew = [participentEntityObject objectAtIndex:0];
            [participents removeObject:oldDiscussionParticipantObjNew];
            //            newltAddedDiscussionParticipantObj = [participents objectAtIndex:i];
            //            [newlyAddedParticipentArray addObject:newltAddedDiscussionParticipantObj.participantId];
            
        }
        
    }
    
    int newParticipentsCount = [participents count];
    
    if([participents count])
    {
        for (int i=0; i<newParticipentsCount; i++)
        {
            newlyAddedDiscussionParticipantObj = [participents objectAtIndex:i];
            [newlyAddedParticipentArray addObject:newlyAddedDiscussionParticipantObj.participantId];
        }
    }
    
    NSLog(@"RemovedParticipents==%@",removedParticipentArray);
    NSLog(@"NewlyAddedParticipents==%@",newlyAddedParticipentArray);
    
    if([removedParticipentArray count] || [newlyAddedParticipentArray count])
    {
        NSString * operationType = [NSString stringWithFormat:@"%d", AddParticipantAPI];
        NSString * discussionId = touchBase.discussionId;
        NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
        NSString * addedIds = [newlyAddedParticipentArray componentsJoinedByString:@","];
        NSString * removedIds = [removedParticipentArray componentsJoinedByString:@","];
        
        NSString *string = [NSString stringWithFormat:@"?userId=%@&participantsIDs=%@&IDToRemove=%@&operationType=%@&discussionId=%@",userId,addedIds,removedIds,operationType,discussionId];
        
        NSLog(@"AddPartcipentAPIParameters==%@",string);
        
        [objParser parseJson:AddParticipantAPI :string];
        
    }
    else
    {
        [syncView removeFromSuperview];
        objParser.delegate = nil;
        objParser = nil;
        
    }
}
- (void)callRemoveMeAPI
{
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    NSString * operationType = [NSString stringWithFormat:@"%d", RemoveMeAPI];
    NSString * discussionId = touchBase.discussionId;
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&operationType=%@&discussionId=%@",userId,operationType,discussionId];
    
    NSLog(@"callRemoveMeURL==%@",string);
    
    [objParser parseJson:RemoveMeAPI :string];
    
}
-(void)callReadCommentAPI:(int)presentCommentObject
{
    readCommentObject = presentCommentObject;
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString * operationType  = [NSString stringWithFormat:@"%d",ReadCommentAPI];
    NSString * discussionId = touchBase.discussionId;
    NSLog(@"PresentCommentDetails==%@",[CommentsDataManagerArray objectAtIndex:presentCommentObject]);
    if([CommentsDataManagerArray count])
    {
        NSString * commentId = [[CommentsDataManagerArray objectAtIndex:presentCommentObject] valueForKey:@"commentsId"];
        NSLog(@"commentId==%@",commentId);
        
        NSString * readStatus = [[CommentsDataManagerArray objectAtIndex:presentCommentObject] valueForKey:@"commentStatus"];;
        NSString * string = [NSString stringWithFormat:@"?userId=%@&operationType=%@&discussionId=%@&commentsId=%@&readStatus=%@",userID,operationType,discussionId,commentId,readStatus];
        NSLog(@"ReadCommentURL==%@",string);
        
        [objParser parseJson:ReadCommentAPI :string];
        
    }
}
#pragma mark- Fetch TouchBase Detail Information
/*******************************************************************************
 *  Function Name: setFontForTouchBase.
 *  Purpose: To getTouchBaseDetailInfo from DataBase.
 *  Parametrs: nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)getTouchBaseDetailInformation
{
    
    NSLog(@"swipeCount == %d",swipeCount);
    if([touchBaseManagerArr count] > 0)
    {
        touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
        [self setValuesInView:touchBase];
        NSLog(@"CommentsDataManagerArray Before Sort === %@",[touchBase.commentID allObjects]);
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"commentDate" ascending:YES];
        CommentsDataManagerArray = [[touchBase.commentID allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
    }
    NSLog(@"CommentsDataManagerArray After Sort=== %@",CommentsDataManagerArray);
    [self.touchBaseDetailTableView reloadData];
    
    if(isRefreshButtonTouched)
    {
        [self performSelector:@selector(viewFlipAnimation) withObject:nil afterDelay:1.0 ];
    }
    int lastRowNumber = [self.touchBaseDetailTableView numberOfRowsInSection:0] - 1;
    NSLog(@"%d",lastRowNumber);
    if(lastRowNumber>=0)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.touchBaseDetailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
}
/*******************************************************************************
 *  Function Name: viewFlipAnimation.
 *  Purpose: To show a transition flip from right for view.
 *  Parametrs: nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)viewFlipAnimation
{
    [syncView removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)forView:self.view cache:YES];
    [UIView commitAnimations];
    
    isRefreshButtonTouched = NO;
    [touchBaseRefreshButton setUserInteractionEnabled:YES];
    [self.touchBaseDetailTableView reloadData];
    
}
- (void)customizeTextView
{
    
    participentDetailsTextView.editable = NO;
    NSLog(@"DirectoryDetails");
    
    CGSize constraintSize = CGSizeMake(participentDetailsTextView.frame.size.width, participentDetailsTextView.contentSize.height);
    
    NSString * text = participentDetailsTextView.text;
    
    text = [text stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if([text stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding])
    {
        text = [text stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    }
    
    // Note that in the below line you must use the font as exact as you use for textview
    
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize: 16] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    //    participentDetailsTextView.frame = CGRectMake(participentDetailsTextView.frame.origin.x,participentDetailsTextView.frame.origin.y,participentDetailsTextView.frame.size.width,labelSize.height + customTextViewHeight);
    // participentDetailsTextView.frame = CGRectMake(participentDetailsTextView.frame.origin.x,participentDetailsTextView.frame.origin.y,participentDetailsTextView.frame.size.width,labelSize.height+5);
    
    //    touchBaseDetailTableView.frame = CGRectMake(touchBaseDetailTableView.frame.origin.x, touchBaseDetailTableView.frame.origin.y + participentDetailsTextView.frame.size.height , touchBaseDetailTableView.frame.size.width, touchBaseDetailTableView.frame.size.height);
    //
    //touchBaseDetailsScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+participentDetailsTextView.contentSize.height);
}

/*******************************************************************************
 *  Function Name: getrecipientAddressObjectsAndNames.
 *  Purpose: To get list Of recipients participated in discussion.
 *  Parametrs: TouchBaseObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void) getrecipientAddressObjectsAndNames:(TouchBase *)touchBaseMainObject
{
    NSArray *participantObjects = [touchBaseMainObject.participantsID allObjects];
    
    NSMutableArray *discussionNameArray;
    if(discussionNameArray)
    {
        discussionNameArray = nil;
    }
    discussionNameArray = [[NSMutableArray alloc]init];
    
    
    if(recipientAddressObjects)
    {
        recipientAddressObjects = nil;
    }
    recipientAddressObjects = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < [participantObjects count]; i++)
    {
        DiscussionParticipants *discussionParticipantsObj = [participantObjects objectAtIndex:i];
        
        if(![recipientAddressObjects containsObject:discussionParticipantsObj.participantId])
        {
            if(discussionParticipantsObj)
            {
                if(discussionParticipantsObj.participantId)
                {
                    [recipientAddressObjects addObject:discussionParticipantsObj.participantId];
                    [discussionNameArray addObject:discussionParticipantsObj.participantName];
                }
            }
        }
    }
    
    NSString *discussionParticipantStr = [discussionNameArray componentsJoinedByString:@", "];
    //participantsListLabel.text = discussionParticipantStr;
    participentDetailsTextView.text = discussionParticipantStr;
    NSLog(@"discussionNameArray nil");
    discussionNameArray = nil;
}
/*******************************************************************************
 *  Function Name: storeAddedParticipentToDB.
 *  Purpose: To store particpants list to the DB.
 *  Parametrs: participients list as array and touchbase Object.
 *  Return Values:nil.
 ********************************************************************************/
-(void)storeAddedParticipentToDB:(NSArray *)newParticipents object: (TouchBase *)touch
{
    NSLog(@"%@",newParticipents);
    NSArray *containParticipnatsArray = [touch.participantsID allObjects];
    
    int newparticipentCount = [newParticipents count];
    BOOL isSaved;
    for (int i = 0; i < newparticipentCount; i ++)
    {
        DiscussionParticipants *discussionParticipantsObj;
        
        NSLog(@"%d",[[newParticipents objectAtIndex:i] intValue ]);
        
        int newlyAddedParticipentID = [[newParticipents objectAtIndex:i] intValue];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"participantId = %d",newlyAddedParticipentID];
        NSArray *participentEntityObject = [containParticipnatsArray filteredArrayUsingPredicate:predicate];
        
        if ([participentEntityObject count] == 0)
        {
            //no existing object
            discussionParticipantsObj = [DataManager createEntityObject:DISCUSSIONPARTICIPANTS];
        }
        
        else
        {
            discussionParticipantsObj = [participentEntityObject lastObject];
        }
        
        Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:newlyAddedParticipentID];
        
        if (directory)
        {
            discussionParticipantsObj.participantId = directory.physicianId;
            discussionParticipantsObj.participantName = directory.physicianName;
            [touchBase addParticipantsIDObject:discussionParticipantsObj];
            isSaved = [DataManager saveContext];
        }
    }
    
}

#pragma mark- valueSetUp
/*******************************************************************************
 *  Function Name: setValuesInView.
 *  Purpose: To set values in touchBase entity.
 *  Parametrs: touchbase Object.
 *  Return Values:nil.
 ********************************************************************************/
-(void) setValuesInView:(TouchBase *)touchBaseObj
{
    [self callReadDiscussionAPI];
    subjectContentLabel.text = touchBaseObj.subject;
    
    [self getrecipientAddressObjectsAndNames:[touchBaseManagerArr objectAtIndex:swipeCount]];
    
    [self.touchBaseDetailTableView reloadData];
    [self customizeTextView];
}
-(void)callReadDiscussionAPI
{
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString * operationType  = [NSString stringWithFormat:@"%d",ReadDiscussionAPI];
    NSString * discussionId = touchBase.discussionId;
    NSString * string = [NSString stringWithFormat:@"?userId=%@&operationType=%@&discussionId=%@",userID,operationType,discussionId];
    NSLog(@"ReadDiscussionURL==%@",string);
    
    [objParser parseJson:ReadDiscussionAPI :string];
    
    
}
#pragma mark- Swipe SetUp
/*******************************************************************************
 *  Function Name: addSwipeFunctionality.
 *  Purpose: To set up swipe function.
 *  Parametrs: nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void) addSwipeFunctionality
{
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [touchBaseDetailsScrollview addGestureRecognizer:rightRecognizer];
    rightRecognizer = nil;
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [touchBaseDetailsScrollview addGestureRecognizer:leftRecognizer];
    leftRecognizer = nil;
}

/*******************************************************************************
 *  Function Name: rightSwipeHandle.
 *  Purpose: To set up right swipe function.
 *  Parametrs: gestureRecognizer.
 *  Return Values:nil.
 ********************************************************************************/
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"******RIGHT******");
    if(swipeCount < [touchBaseManagerArr count] && (swipeCount > 0))
    {
        [self setanimationForSwipe:0];
        swipeCount = swipeCount - 1;
        
        touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"commentDate" ascending:YES];
        CommentsDataManagerArray = [[touchBase.commentID allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
        
        [self setValuesInView:touchBase];
    }
    else
    {
        NSLog(@"No Data To Swipe");
    }
}

/*******************************************************************************
 *  Function Name: leftSwipeHandle.
 *  Purpose: To set up left swipe function.
 *  Parametrs: gestureRecognizer.
 *  Return Values:nil.
 ********************************************************************************/
- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"******LEFT******");
    if(swipeCount >= 0)
    {
        if(swipeCount<[touchBaseManagerArr count]-1)
        {
            [self setanimationForSwipe:1];
            swipeCount = swipeCount + 1;
            
            touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
            NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"commentDate" ascending:YES];
            CommentsDataManagerArray = [[touchBase.commentID allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
            
            [self setValuesInView:touchBase];
        }
    }
    else
    {
        NSLog(@"No Data To Swipe");
    }
}
/*******************************************************************************
 *  Function Name:setanimationForSwipe.
 *  Purpose: Animation For swipe (Here curl up and curl down).
 *  Parametrs: 0 for right swipe and 1 for left swipe as integer.
 *  Return Values:nil
 ********************************************************************************/
-(void)setanimationForSwipe:(int)type
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    if(type)
    {
        [UIView setAnimationTransition:(UIViewAnimationTransitionCurlUp)forView:self.view cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:(UIViewAnimationTransitionCurlDown)forView:self.view cache:YES];
    }
    [UIView commitAnimations];
}
/*******************************************************************************
 *  Function Name: setCustomOverlay.
 *  Purpose: To init syncing.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)setCustomOverlay
{
    if(!syncView)
    {
        syncView = [[UIView alloc]init];
        syncView.frame = self.view.frame;
        UIActivityIndicatorView *syncingActivityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(60, 140, 200, 200)];
        syncingActivityIndicator.backgroundColor = [UIColor clearColor];
        syncingActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [syncingActivityIndicator startAnimating];
        [syncView addSubview:syncingActivityIndicator];
    }
    
    [self.view addSubview:syncView];
}
#pragma mark- Button Actions
/*******************************************************************************
 *  Back button touch action
 ********************************************************************************/
-(IBAction)backButtonTouched:(id)sender
{
    [commentTextView resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************
 *  Add participents for discussion button touch action
 ********************************************************************************/
- (IBAction)addParticipantsButtonTouched:(id)sender
{
    DirectoryViewController *detailViewController=[[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController" bundle:nil];
    [detailViewController beginWithAddParticipants:1];
    detailViewController.selectedPhysicianIdArray = recipientAddressObjects;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
}

/*******************************************************************************
 *  Refresh button touch action
 ********************************************************************************/
- (IBAction)touchBaseRefreshBtnTouched:(id)sender
{
    [commentTextView resignFirstResponder];
    commentTextView.text = @"";
    commentsLabel.hidden = NO;
    commentsLabel.text  =@"Comments";
    
    [self setCustomOverlay];
    isRefreshButtonTouched = YES;
    [touchBaseRefreshButton setUserInteractionEnabled:NO];
    TouchBaseViewController *touchBaseViewController = [[TouchBaseViewController alloc]initWithNibName:@"TouchBaseViewController" bundle:nil];
    [touchBaseViewController touchBaseDataRefreshing];
    [self getTouchBaseDetailInformation];
}

/*******************************************************************************
 *  Send button touch action
 ********************************************************************************/
- (IBAction)sendButtonTouched:(id)sender
{
    [commentTextView resignFirstResponder];
    
    NSString *commentTextValue = [commentTextView text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *blackSpace = [commentTextValue stringByTrimmingCharactersInSet:whitespace];
    
    if([commentTextView.text isEqualToString:@""] || [blackSpace length] == 0)
    {
        
        [GeneralClass showAlertView:self
                                msg:@"Please enter your comments"
                              title:nil
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:noCommentTag];
    }
    else
    {
        [self callNewCommentsAPI];
        
    }
}
/*******************************************************************************
 *  Remove participents button touch action
 ********************************************************************************/
- (IBAction)removeMeButtonTouched:(id)sender
{
    
    [GeneralClass showAlertView:self
                            msg:@"Do you want to delete this discussion?"
                          title:nil
                    cancelTitle:@"Yes"
                     otherTitle:@"No"
                            tag:removeParticipentTag];
}

/*******************************************************************************
 * Back ground button touch action
 ********************************************************************************/
-(IBAction)backGroundTouchBtn:(id)sender
{
    NSLog(@"Touched");
    [commentTextView resignFirstResponder];
}


#pragma mark- Contact Address Select Delegate
- (void)selectedContacts:(NSMutableArray *)contacts
{
    NSLog(@"contacts === %@",contacts);
    if (contacts)
    {
        DiscussionParticipants * discussionpartObj;
        
        NSMutableArray *result = [[NSMutableArray alloc]init];
        for (int i = 0; i < [contacts count]; i ++)
        {
            discussionpartObj = [DataManager createEntityObject:DISCUSSIONPARTICIPANTS];
            
            discussionpartObj.participantId = [contacts objectAtIndex:i];
            
            [result addObject:discussionpartObj];
        }
        
        [self callAddParticipantAPI:result];
        
    }
}

#pragma mark - Table view data source
/*******************************************************************************
 *  UITableView datasource.
 ********************************************************************************/
- (CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"COUNT %d",[CommentsDataManagerArray count]);
    return [CommentsDataManagerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomTouchBaseDetailCell *touchBaseDetailCell = (CustomTouchBaseDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (touchBaseDetailCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CustomTouchBaseDetailCell" owner:self options:nil];
        touchBaseDetailCell = customTouchBaseDetailCell;
        self.customTouchBaseDetailCell = nil;
    }
    //    if(indexPath.row == 0)
    //    {
    //        touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
    //        [touchBaseDetailCell displayDiscussionDetails:touchBase];
    //    }
    //    else
    //    {
    NSLog(@"swipeCount == %d",swipeCount);
    NSLog(@"indexPath.row-1 === %d",indexPath.row);
    touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
    NSLog(@"CommentsDataManagerArray count === %d",[CommentsDataManagerArray count]);
    if([CommentsDataManagerArray count] > indexPath.row)
    {
//        if([[NSUserDefaults standardUserDefaults] boolForKey:@"NewComments"])
//        {
//            touchBaseDetailCell.commentActivityIndicator.hidden = YES;
//            [touchBaseDetailCell.commentActivityIndicator startAnimating];
//        }
//        else
//        {
//            touchBaseDetailCell.commentActivityIndicator.hidden = NO;
//            [touchBaseDetailCell.commentActivityIndicator stopAnimating];
//            
//        }
        [touchBaseDetailCell displayCommentsDetails:[CommentsDataManagerArray objectAtIndex:indexPath.row]];
    }
    // }
    touchBaseDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return touchBaseDetailCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(indexPath.row !=0)
    //    {
    //        Comments *readComment = [CommentsDataManagerArray objectAtIndex:indexPath.row-1];
    //
    //        if([readComment.commentStatus isEqualToString:@"1"]||[readComment.commentStatus isEqualToString:@"2"]||[readComment.commentStatus isEqualToString:@""])
    //        {
    //            [self callReadCommentAPI:indexPath.row-1];
    //        }
    //        else
    //        {
    //            //Read Commment
    //        }
    //
    //    }
}
#pragma mark- TextView delegates
/*******************************************************************************
 *  UITextView delegates
 ********************************************************************************/
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self makeScrollviewUp:textView];
    commentsLabel.hidden = YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(![textView.text isEqualToString:@""])
    {
        commentsLabel.hidden = YES;
    }
    else
    {
        commentsLabel.hidden  = NO;
    }
    [touchBaseDetailsScrollview setContentOffset:scrlvos animated:YES];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(![textView.text isEqualToString:@""])
    {
        commentsLabel.hidden = YES;
    }
    else
    {
        commentsLabel.hidden  =NO;
    }
}
-(UITextView *) makeScrollviewUp:(UITextView *)textView
{
    scrlvos = touchBaseDetailsScrollview.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:touchBaseDetailsScrollview];
    pt = rc.origin;
    pt.x = 0;
    pt.y += -70;
    [touchBaseDetailsScrollview setContentOffset:pt animated:YES];
    return textView;
}

#pragma mark- Parser Delegates
/*******************************************************************************
 *  Function Name: parseCompleteSuccessfully,parseFailedWithError.
 *  Purpose: To delegate the json parser.
 *  Parametrs:Array of resulted parserObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void)parseCompleteSuccessfully:(ParseServiseType) eparseType:(NSArray *)result
{
    if([result count]>0)
    {
        if(eparseType == NewCommentsAPI)
        {
            [syncView removeFromSuperview];
            
            BOOL isSavedLocally = [self saveNewCommentDetails:result];
            if(isSavedLocally)
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NewComments"];
                [self getTouchBaseDetailInformation];
                commentTextView.text = nil;
                commentsLabel.hidden = NO;
                commentsLabel.text = @"Comments";
            }
            
        }
        else if(eparseType == AddParticipantAPI)
        {
            [syncView removeFromSuperview];
            
            NSArray *newParticipents = [result valueForKey:@"participantsId"];
            
            TouchBase *touchBaseObj = [touchBaseManagerArr objectAtIndex:swipeCount];
            
            [self storeAddedParticipentToDB:newParticipents object:touchBaseObj];
            
            [self getrecipientAddressObjectsAndNames:touchBaseObj];
            
        }
        else if (eparseType == RemoveMeAPI)
        {
            [syncView removeFromSuperview];
            
            if([touchBaseManagerArr count] > 0)
            {
                touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
                
                if (touchBase)
                {
                    BOOL isDeleted = [DataManager deleteMangedObject:touchBase];
                    if (isDeleted)
                    {
                        [DataManager saveContext];
                        [GeneralClass showAlertView:self
                                                msg:@"Successfully Removed"
                                              title:nil
                                        cancelTitle:@"OK"
                                         otherTitle:nil
                                                tag:parseSuccessfullAPITag];
                        errorEparseType = eparseType;
                        
                    }
                }
            }
        }
        else if (eparseType == ReadCommentAPI)
        {
            [syncView removeFromSuperview];
            Comments *readComment = [CommentsDataManagerArray objectAtIndex:readCommentObject];
            
            readComment.commentStatus = @"0";
            
            [DataManager saveContext];
            [self getTouchBaseDetailInformation];
            
        }
        else if (eparseType == ReadDiscussionAPI)
        {
            [syncView removeFromSuperview];
            touchBase = [touchBaseManagerArr objectAtIndex:swipeCount];
            touchBase.discussionId = [[result valueForKey:@"discussionId"]stringValue];
            [DataManager saveContext];
        }
    }
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    NSLog(@"Parse Error");
    
    NSLog(@"eparseType==%d",eparseType);
    errorEparseType = eparseType;
    
    if(eparseType == ReadDiscussionAPI)
    {
        NSLog(@"No Alert");
    }
    else
    {
        [GeneralClass showAlertView:self
                                msg:nil
                              title:@"Parse with error. Try again?"
                        cancelTitle:@"YES"
                         otherTitle:@"NO"
                                tag:parseErrorTag];
        
    }
}
-(void)parseWithInvalidMessage:(NSArray *)result
{
    if ([result count]>0)
    {
        errorEparseType = [[result valueForKey:@"operationType"] integerValue];
        if(errorEparseType == ReadDiscussionAPI)
        {
            NSLog(@"No Alert");
        }
        else
        {
            NSString *resultResponseCode = @"No data from server";
            resultResponseCode = [resultResponseCode stringByAppendingFormat:@"\nDo you want to continue?"];
            
            [GeneralClass showAlertView:self
                                    msg:nil //resultResponseCode
                                  title:resultResponseCode
                            cancelTitle:@"YES"
                             otherTitle:@"NO"
                                    tag:parseErrorTag];
            
        }
        
    }
    else
    {
        [self parseFailedWithError:0 :nil :0];
    }
    
}
-(void)netWorkNotReachable
{
    NSLog(@"NO NETWORK");
    [GeneralClass showAlertView:self
                            msg:NSLocalizedString(@"CHECK NETWORK CONNECTION", nil)
                          title:NSLocalizedString(@"NO NETWORK", nil)
                    cancelTitle:@"OK"
                     otherTitle:nil
                            tag:reachabilityTag];
}




#pragma mark- UIAlertView delegates
/*******************************************************************************
 *  UIAlerview delegates
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == removeParticipentTag)
    {
        if (buttonIndex == 0)
        {
            [self callRemoveMeAPI];
        }
        else
        {
            [syncView removeFromSuperview];
            objParser.delegate = nil;
            objParser = nil;
        }
    }
    else if (alertView.tag == reachabilityTag)
    {
        NSLog(@"No network");
        [syncView removeFromSuperview];
    }
    else if(alertView.tag == parseErrorTag)
    {
        if(errorEparseType == NewCommentsAPI)
        {
            if(buttonIndex == 0)
            {
                [self callNewCommentsAPI];
            }
            else
            {
                [syncView removeFromSuperview];
                Comments *readComment = [CommentsDataManagerArray objectAtIndex:readCommentObject];
                
                readComment.commentStatus = @"1";
                
                [DataManager saveContext];
                [self getTouchBaseDetailInformation];
                
            }
        }
        else if (errorEparseType == AddParticipantAPI)
        {
            if(buttonIndex == 0)
            {
                [self callAddParticipantAPI:newParticipentsArray];
            }
            else
            {
                [syncView removeFromSuperview];
                objParser.delegate = nil;
                objParser = nil;
            }
        }
        else if(errorEparseType == ReadDiscussionAPI)
        {
            if(buttonIndex == 0)
            {
                [self callReadDiscussionAPI];
            }
            else
            {
                [syncView removeFromSuperview];
                objParser.delegate = nil;
                objParser = nil;
                [syncView removeFromSuperview];
            }
        }
        else if(errorEparseType == RemoveMeAPI)
        {
            if(buttonIndex == 0)
            {
                [self callRemoveMeAPI];
            }
            else{
                [syncView removeFromSuperview];
            }
        }
        
    }
    else if (alertView.tag == parseSuccessfullAPITag)
    {
        if (errorEparseType == RemoveMeAPI)
        {
            
            if(buttonIndex ==0)
            {
                [self callRemoveMeAPI];
            }
            else
            {
                [syncView removeFromSuperview];
                objParser.delegate = nil;
                objParser = nil;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    else if (alertView.tag == noCommentTag)
    {
        commentTextView.text = nil;
        commentsLabel.hidden = NO;
        commentsLabel.text = @"Comments";
    }
    alertView = nil;
}

#pragma mark- Memory
- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark- Dealloc
-(void) dealloc
{
    [self setTouchBaseManagerArr:nil];
    [self setTouchBase:nil];
    [self setTouchBaseDetailTableView:nil];
    [self setCustomTouchBaseDetailCell:nil];
    [self setCommentsDataManagerArray:nil];
    [self setTouchBaseDetailsScrollview:nil];
    [self setSwipeCount:0];
}

#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
