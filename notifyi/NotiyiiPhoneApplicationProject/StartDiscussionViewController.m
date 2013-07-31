//
//  TouchBaseViewController.m
//  SendMessage
//
//  Created by Amal T on 13/09/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "StartDiscussionViewController.h"
#import "SendMessageViewController.h"
#import "DirectoryViewController.h"
#import "TouchBase.h"
#import "DataManager.h"
#import <QuartzCore/Quartzcore.h>
#import "GeneralClass.h"
#import "Directory.h"
#import "DiscussionParticipants.h"
#import "JSON.h"
#import "Comments.h"
#import "DateFormatter.h"
@interface StartDiscussionViewController ()
{
    CGPoint scrlvos;
    int globalReplyFag;
    int moveTxtViewToWriteFlag;
    BOOL shouldMoveCursor;
    UIToolbar *keyboardToolbar;
    DataManager *dataManager;
    NSMutableArray *recipientNameArray;
    BOOL isInvalidTo;
    NSString * toFieldName;
    NSMutableArray * toValueIds;
    JsonParser *objParser;
    int errorEparseType;
    UIView *syncView;
    UIAlertView *alert;
}

@property(weak,nonatomic)IBOutlet UILabel *touchBaseLbl;
@property(weak,nonatomic)IBOutlet UIButton *backBtn;
@property(weak,nonatomic)IBOutlet UIButton *sendBtn;
@property(weak,nonatomic)IBOutlet UITextField *toTextField;
@property(weak,nonatomic)IBOutlet UITextField *subjectTextField;
@property(weak, nonatomic)IBOutlet UITextView *sendMsgBodyTextView;
@property(strong, nonatomic)IBOutlet UIScrollView *startDiscsnScrolView;

-(void)fontCustomization;
-(void)normalViewOfStartDiscussionController;
-(void)registerForKeyboardNotifications;
-(void)initializingCustomKeyboardToolBar;
-(void)dissmissKeyboard;
-(void)setDelegate;
-(void)keyboardWillShow:(NSNotification*)aNotification;
-(void)keyboardWillHide:(NSNotification*)aNotification;
- (void)callStartDiscussionMsgAPI:(NSMutableArray *)selectedRecipentAddress;
- (void)setCustomOverlay;

-(BOOL)saveNewDiscussionDetails;
-(BOOL)saveTouchBaseDetail:(TouchBase *)touchBase messageType:(int)messageID;



-(NSMutableArray *)fetchToFieldValues;

-(IBAction)backButtonTouched:(id)sender;
-(IBAction)searchParticipantsButtonTouched:(id)sender;
-(IBAction)backGroundButtonTouched:(id)sender;

@end

@implementation StartDiscussionViewController

@synthesize touchBaseLbl;
@synthesize backBtn;
@synthesize sendBtn;
@synthesize toTextField;
@synthesize subjectTextField;
@synthesize sendMsgBodyTextView;
@synthesize startDiscsnScrolView;
@synthesize recipientAddressObjectIDs;
@synthesize selectedPhysicianId;
@synthesize toRecipientSelectedIdArray;

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark- Initial Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate];
    [self fontCustomization];
    [self normalViewOfStartDiscussionController];
    [self registerForKeyboardNotifications];
    [self initializingCustomKeyboardToolBar];
    
    recipientAddressObjectIDs = [[NSMutableArray alloc]init];
    toRecipientSelectedIdArray = [[NSMutableArray alloc]init];
    
    
    if(selectedPhysicianId)
    {
        NSLog(@"CAMES THROUGH DIRCTORY SELECTION %@",selectedPhysicianId);
        Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[selectedPhysicianId intValue]];
        toTextField.text = directory.physicianName;
        if(recipientAddressObjectIDs)
        {
            recipientAddressObjectIDs = nil;
        }
        recipientAddressObjectIDs = [[NSMutableArray alloc]init];
        [recipientAddressObjectIDs addObject:directory.physicianId];
    }
    
}
-(void) viewDidAppear:(BOOL)animated {
    
    isInvalidTo = 0;
}

#pragma mark- Button Actions
/*******************************************************************************
 * back button touch action.
 ********************************************************************************/
-(IBAction)backButtonTouched:(id)sender
{
	[self normalViewOfStartDiscussionController];
    [self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************
 * To search participants for discussion.
 ********************************************************************************/
-(IBAction)searchParticipantsButtonTouched:(id)sender
{
    if(toRecipientSelectedIdArray)
    {
        [toRecipientSelectedIdArray removeAllObjects];
    }
    //fetching tofield from the To fields, so we can display the address with tick mark in directory
    toRecipientSelectedIdArray = [self fetchToFieldValues];
    
    NSLog(@"recipientSelectedIdArray === %@",toRecipientSelectedIdArray);
    
    DirectoryViewController *detailViewController=[[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController" bundle:nil];
    [detailViewController beginWithAddParticipants:1];
    detailViewController.selectedPhysicianIdArray = toRecipientSelectedIdArray;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
}


-(IBAction)backGroundButtonTouched:(id)sender
{
    [self normalViewOfStartDiscussionController];
    [startDiscsnScrolView setContentOffset:CGPointMake(self.view.frame.origin.x,self.view.frame.origin.y) animated:YES];
}


- (IBAction)sendDiscussionBtnTouched:(id)sender
{
    NSString * toTextValue = toTextField.text;
    NSString * subjectTextValue = subjectTextField.text;
    NSString * discussionText = sendMsgBodyTextView.text;
    NSLog(@"To Address Count ::: %d\n Array ::: %@",[recipientAddressObjectIDs count],recipientAddressObjectIDs);
    
    //To
    if(toRecipientSelectedIdArray)
    {
        [toRecipientSelectedIdArray removeAllObjects];
    }
    if (recipientAddressObjectIDs)
    {
        [recipientAddressObjectIDs removeAllObjects];
    }
    
    toRecipientSelectedIdArray = [self fetchToFieldValues];
    
    
    if( [toTextValue isEqualToString:@""]||toTextValue==nil || [NSNull null]==(NSNull*)toTextValue )
    {
        [GeneralClass showAlertView:nil
                                msg:NSLocalizedString(@"NO RECIPIENT", nil)
                              title:nil
                        cancelTitle:nil
                         otherTitle:@"OK"
                                tag:noTag];
    }
    else if ([NSNull null]==(NSNull*)subjectTextValue || [subjectTextValue isEqualToString:@""])
    {
        
        [GeneralClass showAlertView:nil
                                msg:@"Please enter subject for discussion"
                              title:nil
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:noTag];
    }
    else if([NSNull null]==(NSNull*)discussionText || [discussionText isEqualToString:@""])
    {
        [GeneralClass showAlertView:nil
                                msg:@"Please enter your comment for discussion"
                              title:nil
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:noTag];
 
    }
    else
    {
        if (isInvalidTo)
        {
            NSLog(@"physician's name : %@",toFieldName);
            NSString * messageName = [NSString stringWithFormat:@"The email address %@ is not recognized. Please try again.",toFieldName];
            
            [GeneralClass showAlertView:nil
                                    msg:messageName
                                  title:@"Error"
                            cancelTitle:@"OK"
                             otherTitle:nil
                                    tag:noTag];
            isInvalidTo = 0;
        }
        else
        {
            BOOL sendBool = [self saveNewDiscussionDetails];
            if(sendBool)
            {
                NSLog(@"local save SUCCESS");
                [self normalViewOfStartDiscussionController];
                [self callStartDiscussionMsgAPI:recipientAddressObjectIDs];
            }
            else
            {
                NSLog(@"local save FAILED");
            }            
        }
    }
}

#pragma mark- Contact Address Select Delegate
/*******************************************************************************
 *  Function Name: selectedContacts.
 *  Purpose: It's a delegate for the directory selection.
 *  Parametrs: selected contacts as array.
 *  Return Values:nil
 ********************************************************************************/
- (void)selectedContacts:(NSMutableArray *)contacts
{
    NSLog(@"contacts === %@",contacts);
    if (contacts)
    {
        if(recipientAddressObjectIDs)
        {
            [recipientAddressObjectIDs removeAllObjects];;
        }
        recipientAddressObjectIDs = [[NSMutableArray alloc]init];
        
        recipientAddressObjectIDs = contacts;
        if(recipientNameArray)
        {
            recipientNameArray = nil;
        }
        recipientNameArray = [[NSMutableArray alloc]init];
        NSLog(@"contacts count === %d",[contacts count]);
        NSLog(@"newlyAddedRecipientNames ::  %@",recipientAddressObjectIDs);
        int recipientAddressObjectIDsCount = [recipientAddressObjectIDs count];
        for (int i = 0; i < recipientAddressObjectIDsCount; i++)
        {
            Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[[recipientAddressObjectIDs objectAtIndex:i] intValue]];
            if(directory.physicianName)
            {
                [recipientNameArray addObject:directory.physicianName];
                
            }
        }
        NSString *recipeientString = [recipientNameArray componentsJoinedByString:@", "];
        toTextField.text = recipeientString;
    }
    NSLog(@"recipient==%@",recipientAddressObjectIDs);
}
#pragma mark- Local Saving to the coredata
/*******************************************************************************
 *  Function Name: saveNewDiscussionDetails.
 *  Purpose: To save the discussion to touchbase entity.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
-(BOOL)saveNewDiscussionDetails
{
    NSLog(@"%@",recipientAddressObjectIDs);
    BOOL isSaved = 0;
    
    if(toRecipientSelectedIdArray)
    {
        [toRecipientSelectedIdArray removeAllObjects];
    }
    if (recipientAddressObjectIDs)
    {
        [recipientAddressObjectIDs removeAllObjects];
    }
    
    toRecipientSelectedIdArray = [self fetchToFieldValues];
    
    //DataBase insertion
    TouchBase *newTouchBaseObj = [DataManager createEntityObject:@"TouchBase"];
    
    int tofieldCount = [toRecipientSelectedIdArray count];
    for (int i = 0; i< tofieldCount; i++)
    {
        
        DiscussionParticipants *discussionParticipantsObj = [DataManager createEntityObject:@"DiscussionParticipants"];
        
        Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[[toRecipientSelectedIdArray objectAtIndex:i] integerValue]];
        NSLog(@"directory==%@",directory);
        NSLog(@"directory.physicianId==%@",directory.physicianId);
        discussionParticipantsObj.participantId = directory.physicianId;
        discussionParticipantsObj.participantName = directory.physicianName;
        
        [newTouchBaseObj addParticipantsIDObject:discussionParticipantsObj];
    }
    isSaved = [self saveTouchBaseDetail:newTouchBaseObj messageType:sentMsgID];
    return isSaved;
}

- (BOOL)saveTouchBaseDetail:(TouchBase *)touchBase messageType:(int)messageID
{
    if(dataManager)
    {
        dataManager = nil;
    }
    dataManager=[[DataManager alloc]init];
    
    touchBase.discussionId = @"NewlyAddedDiscussionID";
    touchBase.subject = subjectTextField.text;
    touchBase.discussionOwner = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"];
    
    Comments *comments = [DataManager createEntityObject:@"Comments"];
    comments.comments = sendMsgBodyTextView.text;
    comments.commentPersonName = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"];
    comments.commentStatus = @"1";
    
    NSString *gateString = [DateFormatter getDateStringFromDate:[NSDate date] withFormat:@"MM/dd/yyyy hh:mm a"];
    comments.commentDate  = [DateFormatter getDateFromDateStringBasedOnDeviceTimeZone:gateString forFormat:@"MM/dd/yyyy hh:mm a"];
    
    //take last comment id from Db, increment 1 and save as new new commentId in new disscussion
    NSArray * totalCommentsArray =[DataManager getWholeEntityDetails:@"Comments" sortBy:@"comments"];
    if([totalCommentsArray count])
    {
        NSSortDescriptor *commentIdSort = [NSSortDescriptor sortDescriptorWithKey:@"commentsId" ascending:YES];
        NSArray *sortedCommentsArray = [totalCommentsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:commentIdSort]];
        NSArray * lastCommentDetailsArray = [sortedCommentsArray lastObject];
        NSNumber * lastcommentID =[lastCommentDetailsArray valueForKey:@"commentsId"];
        NSNumber * nextCommentID = [NSNumber numberWithInt:[lastcommentID intValue] + 1];
        NSLog(@"NewDiscussionCommentID===%i",[nextCommentID intValue]);
        comments.commentsId = [NSNumber numberWithInt:[nextCommentID intValue]];
    }
    [touchBase addCommentIDObject:comments];
    [DataManager saveContext];

    BOOL isSaved = [DataManager saveContext];
    if(isSaved)
    {
        NSLog(@"INSERTION SUCCESS");
        isSaved = YES;
    }
    else
    {
        NSLog(@"INSERTION FAILED");
        isSaved = NO;
    }
    return isSaved;
}
#pragma mark- UITextField delegates
/*******************************************************************************
 *  UITextField delegates
 ********************************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:toTextField])
    {
        [toTextField resignFirstResponder];
        [subjectTextField becomeFirstResponder];
    }
    else if ([textField isEqual:subjectTextField])
    {
        [subjectTextField resignFirstResponder];
        [sendMsgBodyTextView  becomeFirstResponder];
    }
    
    else if([textField isEqual:sendMsgBodyTextView])
    {
        [sendMsgBodyTextView resignFirstResponder];
    }
    [startDiscsnScrolView setContentOffset:scrlvos animated:YES];
    
   	return TRUE;
}
-(id)fetchEntityObjectForComments:(NSString *)entityName selectBy:(int)commentsID
{
    id managedObject = nil;
    
    managedObject = [DataManager fetchExistingEntityObject:entityName attributeName:@"commentsId" selectBy:commentsID];
    if (!managedObject)
    {
        managedObject = [DataManager createEntityObject:entityName];
    }
    else
    {
        
    }
    
    return managedObject;
}
#pragma mark- UITextView delegates
/*******************************************************************************
 *  UITextView delegates
 ********************************************************************************/
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"NORMAL CASE");
    scrlvos = startDiscsnScrolView.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:startDiscsnScrolView];
    pt = rc.origin;
    pt.x = 0;
    pt.y += 0;
    [startDiscsnScrolView setContentOffset:pt animated:YES];
    textView.frame = CGRectMake(13.0,104.0, 295.0, 161.0);
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [startDiscsnScrolView setContentOffset:CGPointMake(self.view.frame.origin.x,self.view.frame.origin.y) animated:YES];
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    scrlvos = startDiscsnScrolView.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:startDiscsnScrolView];
    pt = rc.origin;
    pt.x = 0;
    pt.y += 0;
    [startDiscsnScrolView setContentOffset:pt animated:YES];
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)fontCustomization
{
    touchBaseLbl.font = [GeneralClass getFont:titleFont and:boldFont];
    backBtn.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    sendBtn.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];;
    toTextField.font = [GeneralClass getFont:customRegular and:regularFont];
    subjectTextField.font = [GeneralClass getFont:customRegular and:regularFont];
    sendMsgBodyTextView.layer.cornerRadius = 6;
    sendMsgBodyTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    sendMsgBodyTextView.layer.borderWidth = 1.0f;
}

/*******************************************************************************
 *  Function Name: setDelegate.
 *  Purpose: To set delegate for textview,scrolview and textfield.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
-(void)setDelegate
{
    sendMsgBodyTextView.delegate = self;
    startDiscsnScrolView.delegate = self;
    toTextField.delegate = self;
    subjectTextField.delegate = self;
}

/*******************************************************************************
 *  Function Name: normalViewOfStartDiscussionController.
 *  Purpose: Initial View of StartDiscussionController.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
-(void)normalViewOfStartDiscussionController
{
    [toTextField resignFirstResponder];
    [subjectTextField resignFirstResponder];
    [sendMsgBodyTextView resignFirstResponder];
    self.sendMsgBodyTextView.frame = CGRectMake(13.0,104.0, 295.0, 248.0);
}

/*******************************************************************************
 *  Function Name: registerForKeyboardNotifications.
 *  Purpose: To register a Keyboard notification for initializing Custom keyboard ToolBar.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

/*******************************************************************************
 *  Function Name: initializingCustomKeyboardToolBar.
 *  Purpose: To Add a Toolbar on top of Keyboard.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
-(void)initializingCustomKeyboardToolBar
{
    if(keyboardToolbar == nil)
    {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,416,320,40)];
		keyboardToolbar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(dissmissKeyboard)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        NSArray *items = [[NSArray alloc] initWithObjects:flexibleSpace,done, nil];
        [keyboardToolbar setItems:items];
        
	}
}

/*******************************************************************************
 *  Function Name: keyboardWillShow.
 *  Purpose: To Show Custom keyboard ToolBar.
 *  Parametrs: notification object.
 *  Return Values: nil
 ********************************************************************************/
- (void)keyboardWillShow:(NSNotification*)aNotification
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	CGRect rect = keyboardToolbar.frame;
	rect.origin.y = 204;
	keyboardToolbar.frame = rect;
	[self.view addSubview:keyboardToolbar];
	[UIView commitAnimations];
}

/*******************************************************************************
 *  Function Name: keyboardWillHide.
 *  Purpose: To Hide Custom keyboard ToolBar.
 *  Parametrs: notification object.
 *  Return Values: nil
 ********************************************************************************/
- (void)keyboardWillHide:(NSNotification*)aNotification
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	CGRect rect = keyboardToolbar.frame;
	rect.origin.y = 416;
	keyboardToolbar.frame = rect;
    [keyboardToolbar removeFromSuperview];
	[UIView commitAnimations];
}

/*******************************************************************************
 *  Function Name: dissmissKeyboard.
 *  Purpose: To Dismiss keyboard.
 *  Parametrs: notification object.
 *  Return Values: nil
 ********************************************************************************/
-(void)dissmissKeyboard
{
    [self normalViewOfStartDiscussionController];
}

/*******************************************************************************
 *  Function Name: fetchToFieldValues.
 *  Purpose: To Collect Tofield values.
 *  Parametrs: nil.
 *  Return Values: ToField values as Array.
 ********************************************************************************/
- (NSMutableArray *)fetchToFieldValues
{
    isInvalidTo = 0;
    toValueIds = [[NSMutableArray alloc]init];
    NSString * toTextValue = toTextField.text;
    
    if( [NSNull null]==(NSNull*)toTextValue || [toTextValue isEqualToString:@""] )
    {
        NSLog(@"To Field Null");
    }
    else
    {
        NSArray * toValues = [toTextValue componentsSeparatedByString:@","];
        NSLog(@"toValues==%@",toValues);
        int arrayCount = [toValues count];
        for(int i = 0; i < arrayCount; i++)
        {
            NSString * physician = [toValues objectAtIndex:i];
            physician = [physician stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            Directory * directoryObject = [DataManager fetchDirectoryObjectsForEntity:@"Directory" selectByName:physician];
            if(directoryObject.physicianId)
            {
                [toValueIds addObject:directoryObject.physicianId];
                [recipientAddressObjectIDs addObject:directoryObject.physicianId];
            }
            else
            {
                toFieldName = physician;
                isInvalidTo = 1;
            }
        }
    }
    return toValueIds;
}
/*******************************************************************************
 *  Function Name: callStartDiscussionMsgAPI.
 *  Purpose: To callStartDiscussionAPI.
 *  Parametrs: selected physicians for discussion.
 *  Return Values:nil.
 ********************************************************************************/
- (void)callStartDiscussionMsgAPI:(NSMutableArray *)selectedRecipentAddress
{
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    NSString * discussionSubject = subjectTextField.text;
    NSString * operationType = [NSString stringWithFormat:@"%d", StartDiscussionAPI];
    NSString * textDiscussionMsg = sendMsgBodyTextView.text;
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *participentsArray = [selectedRecipentAddress componentsJoinedByString:@","];
    
    NSString *string = [NSString stringWithFormat:@"?userId=%@&subject=%@&operationType=%@&TextDiscussionMessage=%@&participantsIDs=%@",userId,discussionSubject,operationType,textDiscussionMsg,participentsArray];
    
    NSLog(@"callStartDiscussionMsgAPIParameters==%@",string);
    [objParser parseJson:StartDiscussionAPI :string];
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

#pragma mark- Parser Delegates
/*******************************************************************************
 *  Function Name: parseCompleteSuccessfully,parseFailedWithError.
 *  Purpose: To delegate the json parser.
 *  Parametrs:Array of resulted parserObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void)parseCompleteSuccessfully:(ParseServiseType) eparseType:(NSArray *)result
{
    [syncView removeFromSuperview];
    if([result count]>0)
    {
        if(eparseType == StartDiscussionAPI)
        {
            NSString *discussionStringID = [result valueForKey:@"discussionId"];
            
            TouchBase *addedTouchBase = [DataManager fetchExistingEntityTouchBaseObject:TOUCHBASE discussionId:@"NewlyAddedDiscussionID"];
            
            if (addedTouchBase)
            {
                addedTouchBase.discussionId = discussionStringID;
            }
            
            BOOL isSaved = [DataManager saveContext];
            
            if (isSaved)
            {
                [GeneralClass showAlertView:self
                                        msg:@"Discussion successfully started"
                                      title:nil
                                cancelTitle:@"OK"
                                 otherTitle:nil
                                        tag:parseSuccessfullAPITag];
            }
        }
    }
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    NSLog(@"Parse Error");
    NSLog(@"eparseType==%d",eparseType);
    [GeneralClass showAlertView:self
                            msg:nil
                          title:@"Parse with error. Try again?"
                    cancelTitle:@"YES"
                     otherTitle:@"NO"
                            tag:parseErrorTag];
    errorEparseType = eparseType;
}
-(void)parseWithInvalidMessage:(NSArray *)result
{
    
    if ([result count]>0)
    {
        NSString *resultResponseCode = @"No data from server";
        resultResponseCode = [resultResponseCode stringByAppendingFormat:@"\nDo you want to continue?"];
        
        [GeneralClass showAlertView:self
                                msg:nil //resultResponseCode
                              title:resultResponseCode
                        cancelTitle:@"YES"
                         otherTitle:@"NO"
                                tag:parseErrorTag];

        errorEparseType = [[result valueForKey:@"operationType"] integerValue];
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

#pragma mark- UIAlertview delegates
/*******************************************************************************
 *  UIAlertview delegates.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == reachabilityTag)
    {
        NSLog(@"No network");
        [syncView removeFromSuperview];
    }
    else if(alertView.tag == parseErrorTag)
    {
        if(buttonIndex == 0)
        {
            [self callStartDiscussionMsgAPI:recipientAddressObjectIDs];
        }
        else
        {
            [syncView removeFromSuperview];
            TouchBase *addedTouchBase = [DataManager fetchExistingEntityTouchBaseObject:TOUCHBASE discussionId:@"NewlyAddedDiscussionID"];
            
            if (addedTouchBase)
            {
                [DataManager deleteMangedObject:addedTouchBase];
                [DataManager saveContext];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
    }
    else if(alertView.tag == parseSuccessfullAPITag)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    alertView = nil;
}
#pragma mark- Memory
- (void)viewDidUnload
{
    [self setTouchBaseLbl:nil];
    [self setBackBtn:nil];
    [self setSendBtn:nil];
    [self setToTextField:nil];
    [self setSubjectTextField:nil];
    [self setSendMsgBodyTextView:nil];
    [self setStartDiscsnScrolView:nil];
    toRecipientSelectedIdArray = nil;
    toValueIds = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
