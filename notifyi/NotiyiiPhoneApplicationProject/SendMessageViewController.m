//
//  SendMessageViewController.m
//  SendMessage
//
//  Created by Amal T on 12/09/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "SendMessageViewController.h"
#import "DataManager.h"
#import <QuartzCore/Quartzcore.h>
#import "GeneralClass.h"
#import "NotifyiConstants.h"
#import "MsgRecipient.h"
#import "Directory.h"
#import "JSON.h"
#import "DateFormatter.h"

JsonParser *objParser;
@interface SendMessageViewController ()
{
    BOOL shouldMoveCursor;
    MsgRecipient *msgRecipient;
    int noteFieldup;
    int movFlag;
    CGPoint scrlvos;
    int globalReplyFag;
    int moveTxtViewToWriteFlag;
    DataManager *dataManager;
    UIView *patientView;
    UIView *syncView;
    BOOL isSendMessageBody;
    IBOutlet UIScrollView *sendMsgScrlview;
    IBOutlet UIButton *addPatentInfoBtn;
    IBOutlet UIView *patientInfoView;
    IBOutlet UIImageView *updownImgView;
    IBOutlet UIButton *backgroundBtn;
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *backButton;
    UIActionSheet * draftActionSheet;
    UIToolbar *keyboardToolbar ;
    BOOL isTo;
    BOOL isReplyAll;
    BOOL isDraft;
    BOOL invalidTo;
    BOOL invalidCc;
    BOOL isSaveDraft;
    NSString * thanksLabel;
    NSString * toFieldName;
    NSString * ccFieldName;
    UILabel *lbl;
    NSMutableArray * toValueIds;
    NSMutableArray * ccValueIds;
    int errorParseType;
}

@property (nonatomic, retain) IBOutlet UIToolbar *accessoryView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UILabel *patientInfoLabel;

-(BOOL)saveInboxMessageDetail:(Inbox *)inbox messageType:(int)messageID;
-(void)registerForKeyboardNotifications;
-(void)initializingKeyboardToolBar;
-(void)keyboardWillShow:(NSNotification*)aNotification;
-(void)dissmissKeyboard;
-(void)beginWithReplyAction:(int)replyFlag inbox:(Inbox *)inbox;
-(void)addRecipientList:(Inbox*)inbox;
-(void)fontCustomization;
-(void)setDelegates;
-(void)setDeleteButtonOnNavigationBar;
-(void)messageSending;
-(void)callComposeMessageAPI;
-(NSString *)toRecipients:(Inbox *)inbox;
-(NSString *)ccRecipients:(Inbox *)inbox;

-(NSMutableArray *)fetchToFieldValues;
-(NSMutableArray *)fetchCcFieldValues;
-(void)deleteDraftMessagesAPI:(Inbox *)inbox;
-(void)setCustomOverlay;
-(void)recipientsForDraftMessages;

-(UITextView *) makeScrollviewUp:(UITextView *)textView;
-(IBAction)backGroundBtnClicked:(id)sender;
-(IBAction)addPatientBtnClicked:(id)sender;
-(IBAction)searchParticipantsBtnTouched:(id)sender;
-(IBAction)searchCcButtonTouched:(id)sender;
-(IBAction)sendButtonTouched:(id)sender;
-(IBAction)BackBtnClicked:(id)sender;

-(IBAction)doneEditing:(id)sender;
-(IBAction)deleteButtonTouched:(id)sender;

-(BOOL)saveSendDetails;

@end

NSMutableArray * toDraftRecipientSelectedIdArray;
NSMutableArray * ccDraftRecipientSelectedIdArray;

NSArray *recipientObjects;
NSArray *toAddress;
NSArray *ccAddress;
@implementation SendMessageViewController

@synthesize toText,subjectText,ccText;
@synthesize inboxMsgObj;
@synthesize sendMsgBodyTxtView;
@synthesize addPatientTxtField;
@synthesize patientFirstNameTxtField;
@synthesize patientLastNameTxtField;
@synthesize patientDOBTxtField;
@synthesize sendMsg;
@synthesize recipientNameArray;
@synthesize ccRecipientNames;
@synthesize toRecipientSelectedIdArray;
@synthesize ccRecipientSelectedIdArray;
@synthesize datePickerView;
@synthesize deleteButton;
@synthesize accessoryView;
@synthesize selectedPhysicianId;
@synthesize patientInfoLabel;

#pragma mark- viewDidLoad
- (void)viewDidLoad

{
    [super viewDidLoad];
    
    isSaveDraft = NO;
    self.patientDOBTxtField.inputView = self.datePickerView;
    self.patientDOBTxtField.inputAccessoryView = self.accessoryView;
    patientInfoLabel.textColor = [UIColor grayColor];
    //setting starting date to theDatePicker.
    [datePickerView setDate:[DateFormatter getDateFromDateStringForDatepicker:@"06/01/1970" forFormat:@"MM/dd/yyyy"]];
    NSLog(@"todaysDate===%@",[NSDate date]);
    [datePickerView setMaximumDate:[NSDate date]];
    NSString * subUserName;
    NSString * user = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"];
    if ([user rangeOfString:@"@"].location == NSNotFound)
    {
        subUserName = user;
    }
    else
    {
        NSRange range = [user rangeOfString:@"@"];
        subUserName = [[user substringToIndex:(NSMaxRange(range))-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    thanksLabel = [@"\n\n\n\n\n\nThanks," stringByAppendingFormat:@"\n%@",subUserName];
    sendMsgBodyTxtView.text = thanksLabel;
    
    if(!toRecipientSelectedIdArray)
    {
        toRecipientSelectedIdArray = [[NSMutableArray alloc]init];
    }
    if(!ccRecipientSelectedIdArray)
    {
        ccRecipientSelectedIdArray = [[NSMutableArray alloc]init];
    }
    
    [self fontCustomization];
    [self setDelegates];
    
    [self registerForKeyboardNotifications];
    [self initializingKeyboardToolBar];
    
    addPatentInfoBtn.tag = 0;
    updownImgView.image = [UIImage imageNamed:@"rightArrow.png"];
    noteFieldup = 0;
    
    if(selectedPhysicianId)
    {
        NSLog(@"CAMES THROUGH DIRCTORY SELECTION %@",selectedPhysicianId);
        Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[selectedPhysicianId intValue]];
        toText.text = directory.physicianName;
        if(toRecipientSelectedIdArray)
        {
            toRecipientSelectedIdArray = nil;
        }
        toRecipientSelectedIdArray = [[NSMutableArray alloc]init];
        [toRecipientSelectedIdArray addObject:directory.physicianId];
    }
    
    [self setDeleteButtonOnNavigationBar];
}

-(void) viewDidAppear:(BOOL)animated {
    
    invalidTo = 0;
    invalidCc = 0;
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name:setDeleteButtonOnNavigationBar.
 *  Purpose: To Show TrashButton on SendMessage View.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)setDeleteButtonOnNavigationBar
{
    if([inboxMsgObj.messageType isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        self.deleteButton.hidden = NO;
    }
    else
    {
        self.deleteButton.hidden = YES;
    }
}

/*******************************************************************************
 *  Function Name:beginWithReplyAction.
 *  Purpose: To check whether reply/replyAll/forward Button Touched.
 *  Parametrs:replayflag as integer and InboxObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void) beginWithReplyAction:(int)replyFlag inbox:(Inbox *)inbox
{
    
    if(inboxMsgObj)
        inboxMsgObj = nil;
    inboxMsgObj = inbox;
    
    NSMutableArray *toEmailID;
    NSMutableArray *ccEmailID;
    
    
    if ([inboxMsgObj.messageType intValue] == draftMsgId)

        [self setDeleteButtonOnNavigationBar];
    
    NSString *messageContent;
    
    recipientObjects = [inboxMsgObj.recipientmessageID allObjects];
    
    NSPredicate *topredicate = [NSPredicate predicateWithFormat:@"SELF.isCC = 0"];
    toAddress = [recipientObjects filteredArrayUsingPredicate:topredicate];
    NSLog(@"toAddress === %@",toAddress);
    
    for (int i = 0; i < [toAddress count]; i++)
    {
        msgRecipient = [toAddress objectAtIndex:i];
        [toEmailID addObject:msgRecipient.docterName];
        if(![toRecipientSelectedIdArray containsObject:msgRecipient.recipientId] && (replyFlag != 3))
        {
            [toRecipientSelectedIdArray addObject:msgRecipient.recipientId];
        }
        NSLog(@"toRecipientSelectedIdArray == %@",toRecipientSelectedIdArray);
    }
    
    NSPredicate * ccPredicate = [NSPredicate predicateWithFormat:@"SELF.isCC = 1"];
    ccAddress = [recipientObjects filteredArrayUsingPredicate:ccPredicate];
    NSLog(@"ccAddress === %@",ccAddress);
    
    for (int i = 0; i < [ccAddress count]; i++)
    {
        msgRecipient = [ccAddress objectAtIndex:i];
        [ccEmailID addObject:msgRecipient.docterName];
        
        if(![ccRecipientSelectedIdArray containsObject:msgRecipient.recipientId] && (replyFlag != 3))
        {
            [ccRecipientSelectedIdArray addObject:msgRecipient.recipientId];
        }
    }
    
    NSLog(@"toRecipientSelectedIdArray == %@",toRecipientSelectedIdArray);
    NSLog(@"ccRecipientSelectedIdArray == %@",ccRecipientSelectedIdArray);
    
    globalReplyFag = replyFlag;
    NSLog(@"globalReplyFag === %d",globalReplyFag);
    NSString *appendStr;
    switch (globalReplyFag)
    {
        case 1://REPLAY
            isReplyAll = 0;
            appendStr = @"Re: ";
            [self addRecipientList:inboxMsgObj];
            [sendMsgBodyTxtView becomeFirstResponder];
            break;
            
        case 2://REPLAY ALL
            isReplyAll = 1;
            appendStr = @"Re: ";
            [sendMsgBodyTxtView becomeFirstResponder];
            [self addRecipientList:inboxMsgObj];
            break;
            
        case 3://FWD
            appendStr = @"Fwd: ";
            toText.text = @"";
            ccText.text = @"";
            [toText becomeFirstResponder];
            break;
            
        case 4://DRAFT
        {
            appendStr = @"";
            [self recipientsForDraftMessages];
            [toText becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
    shouldMoveCursor = YES;
    
    NSString * messageBody = inboxMsgObj.textMessageBody;
    
    if ([inboxMsgObj.messageType intValue] == draftMsgId)
    {
        sendMsgBodyTxtView.text = messageBody;
    }
    else
    {
        NSString * subUserName;
        NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        if ([user rangeOfString:@"@"].location == NSNotFound)
        {
            subUserName = user;
        }
        else
        {
            NSRange range = [user rangeOfString:@"@"];
            subUserName = [[user substringToIndex:(NSMaxRange(range))-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        NSString * signature = [@"Thanks," stringByAppendingFormat:@"\n%@",subUserName];
        sendMsgBodyTxtView.text = @"";
        if ([messageBody rangeOfString:signature].location == NSNotFound)    {
            sendMsgBodyTxtView.text = [NSString stringWithFormat:@"%@\n%@",messageBody,thanksLabel];
        }
        else
        {
            sendMsgBodyTxtView.text = messageBody;
        }
        messageContent = sendMsgBodyTxtView.text;
        if(globalReplyFag == 1  || globalReplyFag == 2)
        {
            NSString *replyHeading = @"-------------------- Original Message --------------------";
            NSString *fromContent = @"From: ";
            fromContent = [fromContent stringByAppendingFormat:@"%@",inboxMsgObj.senderName];
            NSString *sentDetail = @"Sent: ";
            sentDetail = [sentDetail stringByAppendingFormat:@"%@",[DateFormatter getDateStringFromDate:inboxMsgObj.date withFormat:@"MM/dd/yyyy HH:mm a"]];
            NSString* toContent = @"To: ";
            SendMessageViewController *sendViewController = [[SendMessageViewController alloc] init];
            toContent = [toContent stringByAppendingFormat:@"%@",[sendViewController toRecipients:inboxMsgObj]];
            NSString *subjectcontent = @"Subject: ";
            if([inboxMsgObj.subject isEqualToString:@"(null)"])
            {
                inboxMsgObj.subject = @"";
            }
            else
            {
                subjectcontent = [subjectcontent stringByAppendingFormat:@"%@",inboxMsgObj.subject];
            }
            NSString *textmessageContent = messageContent;
            [sendMsgBodyTxtView setText:@""];
            sendMsgBodyTxtView.text = [NSString stringWithFormat:@"%@ \n\n%@ \n%@ \n%@ \n%@ \n\n%@",replyHeading,fromContent,sentDetail,toContent,subjectcontent,textmessageContent];
            
        }
    }
    if([inboxMsgObj.subject isEqualToString:@"(null)"])
    {
        inboxMsgObj.subject = @"";
    }
    else
    {
        NSString *mainStr = [self removeAppendString:inboxMsgObj.subject];
        
        sendMsg.text = [NSString stringWithFormat:@"%@%@",appendStr,mainStr];
    }
    NSString *patientDOB = [DateFormatter getDateStringFromDate:inboxMsgObj.patientDOB withFormat:@"MM/dd/yyyy"];
    NSString *patientInfoStrng;
    
    if((inboxMsgObj.patientFirstName.length || inboxMsgObj.patientLastName.length)&&patientDOB.length)
    {
        patientInfoStrng = [NSString stringWithFormat:@"%@ %@, %@",inboxMsgObj.patientFirstName,inboxMsgObj.patientLastName,patientDOB];
        
    }
    else if ((inboxMsgObj.patientFirstName.length && inboxMsgObj.patientLastName.length)&&patientDOB.length)
    {
        patientInfoStrng = [NSString stringWithFormat:@"%@ %@, %@",inboxMsgObj.patientFirstName,inboxMsgObj.patientLastName,patientDOB];
        
    }
    else if (patientDOB.length)
    {
        patientInfoStrng = [NSString stringWithFormat:@"%@",patientDOB];
        
    }
    else if ((inboxMsgObj.patientFirstName.length || inboxMsgObj.patientLastName.length))
    {
        if(![inboxMsgObj.patientFirstName isEqualToString:@"(null)"] || ![inboxMsgObj.patientLastName isEqualToString:@"(null)"])
        {
            patientInfoStrng = [NSString stringWithFormat:@"%@ %@",inboxMsgObj.patientFirstName,inboxMsgObj.patientLastName];
        }else if([inboxMsgObj.patientFirstName isEqualToString:@"(null)"] && ![inboxMsgObj.patientLastName isEqualToString:@"(null)"]) {
            patientInfoStrng = [NSString stringWithFormat:@"%@",inboxMsgObj.patientLastName];
        }else if(![inboxMsgObj.patientFirstName isEqualToString:@"(null)"] && [inboxMsgObj.patientLastName isEqualToString:@"(null)"]) {
            patientInfoStrng = [NSString stringWithFormat:@"%@",inboxMsgObj.patientFirstName];
        }else{
            patientInfoStrng = @"";
        }
        //patientInfoStrng = [NSString stringWithFormat:@"%@ %@",inboxMsgObj.patientFirstName,inboxMsgObj.patientLastName];
    }
    else if (inboxMsgObj.patientFirstName.length && inboxMsgObj.patientLastName.length)
    {
        if(![inboxMsgObj.patientFirstName isEqualToString:@"(null)"] && ![inboxMsgObj.patientLastName isEqualToString:@"(null)"])
        {
            patientInfoStrng  = [NSString stringWithFormat:@"%@ %@",inboxMsgObj.patientFirstName,inboxMsgObj.patientLastName];
        }else{
            patientInfoStrng  = @"";
            
        }
       // patientInfoStrng = [NSString stringWithFormat:@"%@ %@",inboxMsgObj.patientFirstName,inboxMsgObj.patientLastName];
        
    }
    if([patientInfoStrng length])
    {
        patientInfoLabel.text = patientInfoStrng;
        patientFirstNameTxtField.text = inboxMsgObj.patientFirstName;
        patientLastNameTxtField.text = inboxMsgObj.patientLastName;
        patientDOBTxtField.text = patientDOB;
        patientInfoLabel.textColor = [UIColor blackColor];
    }
    else
    {
        patientInfoLabel.text = @"Add Patient Info";
        patientInfoLabel.textColor = [UIColor grayColor];
    }
    subjectText.text = sendMsg.text;
}

/*******************************************************************************
 *  Function Name:removeAppendString.
 *  Purpose: To Append String Re and Fwd to the Reply and Forward message subject.
 *  Parametrs:Subject as String.
 *  Return Values:String as Append subject.
 ********************************************************************************/
-(NSString *)removeAppendString:(NSString *)mainString
{
    NSString *replayAppendStr = @"Re: ";
    NSString *fwdAppendStr = @"Fwd: ";
    NSRange isRange1 = [mainString rangeOfString:replayAppendStr options:NSCaseInsensitiveSearch];
    NSRange isRange2 = [mainString rangeOfString:fwdAppendStr options:NSCaseInsensitiveSearch];
    if(isRange1.location == 0)
    {
        NSString *resultString = [mainString stringByReplacingOccurrencesOfString:replayAppendStr withString:@""];
        return resultString;
    }
    else if(isRange2.location == 0)
    {
        NSString *resultString = [mainString stringByReplacingOccurrencesOfString:fwdAppendStr withString:@""];
        return resultString;
    }
    else
    {
        return mainString;
    }
}
-(void)recipientsForDraftMessages
{
    if(recipientNameArray)
    {
        recipientNameArray = nil;
    }
    recipientNameArray = [[NSMutableArray alloc]init];
    
    for(int i = 0 ; i < [toAddress count]; i++)
    {
        msgRecipient = [toAddress objectAtIndex:i];
        if(msgRecipient.docterName)
        {
            [recipientNameArray addObject:msgRecipient.docterName];
        }
    }
    if(ccRecipientNames)    {
        ccRecipientNames = nil;
    }
    ccRecipientNames = [[NSMutableArray alloc]init];
    int recipientCount = [ccAddress count];
    
    for (int i = 0; i < recipientCount; i++)
    {
        msgRecipient = [ccAddress objectAtIndex:i];
        if(msgRecipient.docterName)
        {
            [ccRecipientNames addObject:msgRecipient.docterName];
        }
    }
   toText.text  = [recipientNameArray componentsJoinedByString:@", "];
   ccText.text  = [ccRecipientNames componentsJoinedByString:@", "];
}
/*******************************************************************************
 *  Function Name: toRecipients.
 *  Purpose: To get toField values of the current inboxobject.
 *  Parametrs:Current inbox object.
 *  Return Values: toValues as string.
 ********************************************************************************/
-(NSString *)toRecipients:(Inbox *)inbox
{
    
    if(recipientNameArray)
    {
        recipientNameArray = nil;
    }
    recipientNameArray = [[NSMutableArray alloc]init];
    
    for(int i = 0 ; i < [toAddress count]; i++)
    {
        msgRecipient = [toAddress objectAtIndex:i];
        if(msgRecipient.docterName)
        {
            [recipientNameArray addObject:msgRecipient.docterName];
        }
    }
    
    if(![inbox.messageType intValue] == draftMsgId)
    {
        //Remove if sender name in Tofield
        NSString* senderName = inboxMsgObj.senderName;
        int todetailsCount = [recipientNameArray count];
        for (int i =0; i<todetailsCount; i++)
        {
            NSString *toFieldContainsUser = [recipientNameArray objectAtIndex:i];
            if ([toFieldContainsUser isEqualToString:senderName]) {
                //            [recipientNameArray replaceObjectAtIndex:i withObject:[NSNull null]];
                [recipientNameArray removeObjectAtIndex:i];
            }
            
        }
        
    }
    NSString *torecipientString = [recipientNameArray componentsJoinedByString:@", "];
    
    return torecipientString;
}

/*******************************************************************************
 *  Function Name: ccRecipients.
 *  Purpose: To get ccField values of the current inboxobject.
 *  Parametrs: Current inbox Object.
 *  Return Values: ccValues as string.
 ********************************************************************************/
-(NSString *)ccRecipients:(Inbox *)inbox
{
    if(inboxMsgObj)
        inboxMsgObj = nil;
    inboxMsgObj = inbox;
    
    if(ccRecipientNames)    {
        ccRecipientNames = nil;
    }
    ccRecipientNames = [[NSMutableArray alloc]init];
    int recipientCount = [ccAddress count];
    
    for (int i = 0; i < recipientCount; i++)
    {
        msgRecipient = [ccAddress objectAtIndex:i];
        if(msgRecipient.docterName)
        {
            [ccRecipientNames addObject:msgRecipient.docterName];
        }
    }
    NSString * ccRecipientString = [ccRecipientNames componentsJoinedByString:@", "];
    
    return ccRecipientString;
}

/*******************************************************************************
 *  Function Name:addRecipientList.
 *  Purpose:This will add the list of recipients to the 'To' filed separated by commas.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)addRecipientList:(Inbox *)inbox
{
    if(inboxMsgObj)
        inboxMsgObj = nil;
    inboxMsgObj = inbox;
    
    //sent mail reply,replayall and forward button touch
    if (([inboxMsgObj.messageType intValue] ==sentMsgID) || (([inboxMsgObj.messageType intValue] ==3) && ([inboxMsgObj.deleteFrom intValue] ==0)))
    {
        if(!isReplyAll)
        {
            
            NSString *toRecipients = [self toRecipients:inboxMsgObj];
            toText.text = @"";
            toText.text = toRecipients;
            ccText.text = @"";
            [ccRecipientSelectedIdArray removeAllObjects];
        }
        else if(isReplyAll)
        {
            
            NSString *toRecipients = [self toRecipients:inboxMsgObj];
            toText.text = @"";
            toText.text = toRecipients;
            
            ccText.text = @"";
            NSString *ccRecipients = [self ccRecipients:inboxMsgObj];
            ccText.text = ccRecipients;
        }
    }
    //inbox mail reply,replayall and forward button touch
    else if (([inboxMsgObj.messageType intValue]==inboxMesgID) || (([inboxMsgObj.messageType intValue] ==3) && ([inboxMsgObj.deleteFrom intValue] ==1)))
    {
        if(!isReplyAll)
        {
            toText.text = inboxMsgObj.senderName;
            ccText.text = @"";
            [ccRecipientSelectedIdArray removeAllObjects];
        }
        else if(isReplyAll)
        {
            toText.text = inboxMsgObj.senderName;
            
            NSString *toRecipients = [self toRecipients:inboxMsgObj];
            NSString *ccRecipients = [self ccRecipients:inboxMsgObj];
            
            if([toRecipients isEqualToString:@""]&&![ccRecipients isEqualToString:@""])
            {
                ccText.text = [NSString stringWithFormat:@"%@",ccRecipients];
            }
            else if (![toRecipients isEqualToString:@""]&&[ccRecipients isEqualToString:@""])
            {
                ccText.text = [NSString stringWithFormat:@"%@",toRecipients];
            }
            else
            {
                ccText.text = [NSString stringWithFormat:@"%@, %@",toRecipients,ccRecipients];
                
            }
        }
        
    }
}

/*******************************************************************************
 *  Function Name:saveSendDetails.
 *  Purpose:To Save sent message to sentMail.
 *  Parametrs:nil.
 *  Return Values:BOOL.
 ********************************************************************************/
-(BOOL)saveSendDetails
{
    BOOL isSaved;
    
    if([inboxMsgObj.messageType intValue] == draftMsgId)
    {
        isSaved = YES;
    }
    else
    {
        //DataBase insertion
        Inbox *newInboxObj = [DataManager createEntityObject:@"Inbox"];
        
        if(inboxMsgObj)
            inboxMsgObj = nil;
        
        inboxMsgObj = newInboxObj;
        
        isSaved = [self saveInboxMessageDetail:newInboxObj messageType:draftMsgId];
    }
    return isSaved;
}

/*******************************************************************************
 *  Function Name:setValueToThePatientField.
 *  Purpose:To set Value to patientInfoField.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)setValueToThePatientField
{
    if(![patientFirstNameTxtField.text isEqualToString:@""] || ![patientLastNameTxtField.text isEqualToString:@""] || ![patientDOBTxtField.text isEqualToString:@""])
    {
        if(patientInfoView)
        {
            NSString *appendString;
            if([patientDOBTxtField.text isEqualToString:@""])
            {
                appendString = [NSString stringWithFormat:@"%@ %@",patientFirstNameTxtField.text,patientLastNameTxtField.text];
            }
            else if([patientFirstNameTxtField.text isEqualToString:@""] && [patientLastNameTxtField.text isEqualToString:@""] && ![patientDOBTxtField.text isEqualToString:@""])
            {
                appendString = [NSString stringWithFormat:@"%@",patientDOBTxtField.text];
                
            }
            else if(![patientFirstNameTxtField.text isEqualToString:@""] && ![patientLastNameTxtField.text isEqualToString:@""] && ![patientDOBTxtField.text isEqualToString:@""])
            {
                appendString = [NSString stringWithFormat:@"%@ %@, %@",patientFirstNameTxtField.text,patientLastNameTxtField.text,patientDOBTxtField.text];
                
            }
            else if((![patientFirstNameTxtField.text isEqualToString:@""] || ![patientLastNameTxtField.text isEqualToString:@""]) && ![patientDOBTxtField.text isEqualToString:@""])
            {
                appendString = [NSString stringWithFormat:@"%@ %@, %@",patientFirstNameTxtField.text,patientLastNameTxtField.text,patientDOBTxtField.text];
                
            }
            patientInfoLabel.text = appendString;
            patientInfoLabel.textColor = [UIColor blackColor];
        }
        else
        {
            patientInfoLabel.text = @"Add Patient Info";
            patientInfoLabel.textColor = [UIColor grayColor];
        }
    }
    else
    {
        patientInfoLabel.text = @"Add Patient Info";
        patientInfoLabel.textColor = [UIColor grayColor];
    }
    
}

/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose:To set Font for controllers.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)fontCustomization
{
    sendMsg.font = [GeneralClass getFont:titleFont and:boldFont];
    sendButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    backButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    self.toText.font = [GeneralClass getFont:customRegular and:regularFont];
    self.ccText.font = [GeneralClass getFont:customRegular and:regularFont];
    self.subjectText.font = [GeneralClass getFont:customRegular and:regularFont];
    patientFirstNameTxtField.font = [GeneralClass getFont:customRegular and:regularFont];
    patientLastNameTxtField.font = [GeneralClass getFont:customRegular and:regularFont];
    patientDOBTxtField.font = [GeneralClass getFont:customRegular and:regularFont];
    sendMsgBodyTxtView.layer.cornerRadius = 6;
    sendMsgBodyTxtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    sendMsgBodyTxtView.layer.borderWidth = 1.5f;
    sendMsgBodyTxtView.font = [GeneralClass getFont:customRegular and:regularFont];
    patientInfoLabel.font = [GeneralClass getFont:customRegular and:regularFont];
}

/*******************************************************************************
 *  Function Name: setDelegates.
 *  Purpose:To set delegates for textfield,textview and actionsheet.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)setDelegates
{
    toText.delegate = self;
    ccText.delegate = self;
    patientFirstNameTxtField.delegate = self;
    patientLastNameTxtField.delegate = self;
    patientDOBTxtField.delegate = self;
    subjectText.delegate = self;
    sendMsgBodyTxtView.delegate = self;
    draftActionSheet.delegate = self;
    sendMsgBodyTxtView.frame = CGRectMake(12.0,184.0, 296.0,156.0);
}
/*******************************************************************************
 *  Function Name: saveInboxMessageDetail.
 *  Purpose:To save InboxMessage details.
 *  Parametrs:Inbox Object and messageID as integer.
 *  Return Values: BOOL,if saved YES else NO.
 ********************************************************************************/
- (BOOL)saveInboxMessageDetail:(Inbox *)inbox messageType:(int)messageID
{
    NSLog(@"MESSAGE BODY::::::: %@",sendMsgBodyTxtView.text);
    
    inbox.patientFirstName = patientFirstNameTxtField.text;
    inbox.patientLastName = patientLastNameTxtField.text;
    
    if(dataManager)
    {
        dataManager = nil;
    }
    dataManager=[[DataManager alloc]init];
    
    //fetch the last messageID
    NSArray *inboxEntityObjs = [DataManager getWholeEntityDetails:INBOX sortBy:@"messageId"];
    int lastInboxMessageID = [inboxEntityObjs count] + 1;
    inbox.messageId = [NSNumber numberWithInt:lastInboxMessageID];
    inbox.senderName = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"];
    
    NSLog(@"patientDOBTxtField.text === %@",patientDOBTxtField.text);
    
    inbox.patientDOB = [DateFormatter getDateFromDateString:patientDOBTxtField.text forFormat:@"MM/dd/YYYY"];
    inbox.subject = subjectText.text;
    inbox.textMessageBody = sendMsgBodyTxtView.text;
    NSString *gateString = [DateFormatter getDateStringFromDate:[NSDate date] withFormat:@"MM/dd/YYYY"];
    inbox.date  = [DateFormatter getDateFromDateString:gateString forFormat:@"MM/dd/YYYY"];//[DateFormatter getDateInGMTFormat:[NSDate date]];
    NSLog(@"%@",inbox.date);
    //changing the message status
    inbox.messageType = [NSNumber numberWithInt:messageID];
    inbox.readStatus = [NSNumber numberWithInt:1];
    
    NSLog(@"toRecipientSelectedIdArray == %@",toRecipientSelectedIdArray);
    
    //recipient data saving
    int toFieldAddressCount = [toRecipientSelectedIdArray count];
    for (int i = 0; i< toFieldAddressCount; i++)
    {
        
        Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[[toRecipientSelectedIdArray objectAtIndex:i] intValue]];
        NSLog(@"directory == %@",directory);
        
        if (directory)
        {
            MsgRecipient * messageRecipient = [DataManager createEntityObject:@"MsgRecipient"];
            NSLog(@"DirectoryPhysicianName : %@",directory.physicianName);
            messageRecipient.docterName = directory.physicianName;
            messageRecipient.isCC = [NSNumber numberWithInt: 0];
            messageRecipient.recipientId = directory.physicianId ;
            
            [inbox addRecipientmessageIDObject:messageRecipient];
            [inbox addRecipientContactsObject:directory];
        }
    }
    
    int ccFieldAddressCount = [ccRecipientSelectedIdArray count];
    for (int j = 0; j< ccFieldAddressCount; j++)
    {
        Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[[ccRecipientSelectedIdArray objectAtIndex:j] intValue]];
        
        if (directory)
        {
            MsgRecipient * messageRecipient = [DataManager createEntityObject:@"MsgRecipient"];
            NSLog(@"DirectoryPhysicianName : %@",directory.physicianName);
            messageRecipient.docterName = directory.physicianName;
            messageRecipient.isCC = [NSNumber numberWithInt: 1];
            messageRecipient.recipientId = directory.physicianId ;
            
            [inbox addRecipientmessageIDObject:messageRecipient];
            [inbox addRecipientContactsObject:directory];
        }
    }
    
    //****** for the invalid To, Cc address recipient data saving
    if (messageID == draftMsgId)
    {
        int toFieldDraftInvalidAddressCount = [toDraftRecipientSelectedIdArray count];
        for (int i = 0; i< toFieldDraftInvalidAddressCount; i++)
        {
            NSString *invalidToFieldName = [toDraftRecipientSelectedIdArray objectAtIndex:i];
            MsgRecipient * messageRecipient = [DataManager createEntityObject:@"MsgRecipient"];
            messageRecipient.docterName = invalidToFieldName;
            messageRecipient.isCC = [NSNumber numberWithInt: 0];
            [inbox addRecipientmessageIDObject:messageRecipient];
        }
        
        int ccFieldDraftInvalidAddressCount = [ccDraftRecipientSelectedIdArray count];
        for (int j = 0; j< ccFieldDraftInvalidAddressCount; j++)
        {
            
            NSString *invalidCcFieldName = [ccDraftRecipientSelectedIdArray objectAtIndex:j];
            MsgRecipient * messageRecipient = [DataManager createEntityObject:@"MsgRecipient"];
            messageRecipient.docterName = invalidCcFieldName;
            messageRecipient.isCC = [NSNumber numberWithInt: 1];
            [inbox addRecipientmessageIDObject:messageRecipient];
            
        }
        inbox.textMessageBody = sendMsgBodyTxtView.text;
    }
    BOOL isSaved = [DataManager saveContext];
    NSLog(@"date == %@",inbox.patientDOB);
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
/*******************************************************************************
 *  Function Name: messageSending.
 *  Purpose: To Check whether To and Cc field entry is Valid or not.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)messageSending
{
    if (invalidTo)
    {
        NSLog(@"physician's name : %@",toFieldName);
        NSString * messageName = [NSString stringWithFormat:@"The email address %@ is not recognized. Please try again.",toFieldName];
        
        [GeneralClass showAlertView:nil
                                msg:messageName
                              title:@"Error"
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:noTag];
    }
    else if (invalidCc)
    {
        NSLog(@"physician's name : %@",ccFieldName);
        NSString * messageName = [NSString stringWithFormat:@"The email address %@ is not recognized. Please try again.",ccFieldName];
        
        [GeneralClass showAlertView:nil
                                msg:messageName
                              title:@"Error"
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:noTag];
    }
    else
    {
        BOOL isLocalSaveSuccess = [self saveSendDetails];
        
        if(isLocalSaveSuccess)
        {
            NSLog(@"Local Save SUCCESS");
            // for localy we are saving messageType as draft and for sending we are changing messageType as Sent
            inboxMsgObj.messageType = [NSNumber numberWithInt:sentMsgID];
            [self callComposeMessageAPI];
            
        }
        else
        {
            NSLog(@"Local Save FAILED");
        }
    }
}
/*******************************************************************************
 *  Function Name: fetchToFieldValues.
 *  Purpose: To Collect Tofield values.
 *  Parametrs: nil.
 *  Return Values: ToField values as Array.
 ********************************************************************************/
- (NSMutableArray *)fetchToFieldValues
{
    invalidTo = 0;
    toValueIds = [[NSMutableArray alloc]init];
    NSString * toTextValue = toText.text;
    NSLog(@"toTextValue==%@",toTextValue);
    if( [NSNull null]==(NSNull*)toTextValue || [toTextValue isEqualToString:@""] )
    {
        NSLog(@"To Field Null");
    }
    else
    {
        NSArray * toValues = [toTextValue componentsSeparatedByString:@","];
        int arrayCount = [toValues count];
        for(int i = 0; i < arrayCount; i++)
        {
            NSString * physicianName = [toValues objectAtIndex:i];
            physicianName = [physicianName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"physicianName==%@",physicianName);
            
            Directory * directoryObject = [DataManager fetchDirectoryObjectsForEntity:@"Directory" selectByName:physicianName];
            
            NSLog(@"directoryObject.physicianName==%@",directoryObject.physicianName);
            NSLog(@"directoryObject.physicianId==%@",directoryObject.physicianId);
            if(directoryObject.physicianId)
            {
                [toValueIds addObject:directoryObject.physicianId];
            }
            else
            {
                toFieldName = physicianName;
                [toDraftRecipientSelectedIdArray addObject:physicianName];
                invalidTo = 1;
            }
        }
    }
    return toValueIds;
}

/*******************************************************************************
 *  Function Name: fetchCcFieldValues.
 *  Purpose: To Collect Ccfield values.
 *  Parametrs: nil.
 *  Return Values: CcField values as Array.
 ********************************************************************************/
-(NSMutableArray *)fetchCcFieldValues
{
    invalidCc = 0;
    ccValueIds = [[NSMutableArray alloc]init];
    NSString * ccTextValue = ccText.text;
    if( [NSNull null]==(NSNull*)ccTextValue || [ccTextValue isEqualToString:@""] )
    {
        NSLog(@"Cc Field Null");
    }
    else
    {
        NSArray * ccValues = [ccTextValue componentsSeparatedByString:@","];
        int ccArrayCount = [ccValues count];
        for(int i = 0; i < ccArrayCount; i++)
        {
            NSString * ccRecipientName = [ccValues objectAtIndex:i];
            ccRecipientName = [ccRecipientName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            Directory * ccDirectoryObject = [DataManager fetchDirectoryObjectsForEntity:@"Directory" selectByName:ccRecipientName];
            if(ccDirectoryObject.physicianId)
            {
                [ccValueIds addObject:ccDirectoryObject.physicianId];
            }
            else
            {
                ccFieldName = ccRecipientName;
                [ccDraftRecipientSelectedIdArray addObject:ccRecipientName];
                invalidCc = 1;
            }
        }
    }
    return ccValueIds;
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

/*******************************************************************************
 *  Function Name: deleteDraftMessagesAPI.
 *  Purpose: To delete the draft.
 *  Parametrs: draft object.
 *  Return Values:nil.
 ********************************************************************************/
-(void)deleteDraftMessagesAPI:(Inbox *)inbox
{
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *messageType    = [NSString stringWithFormat:@"%d",[inboxMsgObj.messageType intValue]];
    NSString *messageID    = [NSString stringWithFormat:@"%d",[inboxMsgObj.messageId intValue]];
    NSString *operationType  = [NSString stringWithFormat:@"%d",DeleteMsgAPI];
 
    NSString *string = [NSString stringWithFormat:@"?userId=%@&MessageId=%@&MessageType=%@&operationType=%@",userID,messageID,messageType,operationType];
    
    [objParser parseJson:DeleteMsgAPI :string];
}

/*******************************************************************************
 *  Function Name: callComposeMessageAPI.
 *  Purpose: To call compose message API for new message.
 *  Parametrs: nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)callComposeMessageAPI
{
    [self setCustomOverlay];
    [sendMsgBodyTxtView resignFirstResponder];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    
    
    NSString *lastUpdatedDate = [DateFormatter getDateStringFromDate:[NSDate date] withFormat:@"MM/dd/yyyy hh:mm a"];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *operationType  = [NSString stringWithFormat:@"%d",ComposeAPI];
    NSString *messageSender = inboxMsgObj.senderName;
    NSString *patientFirstName =  inboxMsgObj.patientFirstName;
    NSString *PatientLastName =  inboxMsgObj.patientLastName;
    NSString *patientDOB;
    NSString *dateOfBirth =  [DateFormatter getDateStringFromDate:inboxMsgObj.patientDOB withFormat:@"MM/dd/YYYY"];

    if([dateOfBirth length])
    {
        patientDOB = dateOfBirth;
    }
    else
    {
        patientDOB = @"";
    }
    NSString *messageSubject = inboxMsgObj.subject;
    NSString *messageBody   = inboxMsgObj.textMessageBody;
    
    NSString *messageType    = [NSString stringWithFormat:@"%d",[inboxMsgObj.messageType intValue]];
    
    NSString *msgType   = @"5";//[NSString stringWithFormat:@"%d",[inboxMsgObj.msgType intValue]];
    NSString *toFields = [toRecipientSelectedIdArray componentsJoinedByString:@","];
    NSString *ccFields = [ccRecipientSelectedIdArray componentsJoinedByString:@","];
    
    NSString *messageId = [inboxMsgObj.messageId stringValue];

    NSString *string = [NSString stringWithFormat:@"?userId=%@&lastUpdatedDate=%@&operationType=%@&sendersName=%@&patientFirstName=%@&patientLastName=%@&patientDOB=%@&subject=%@&TextMessageBody=%@&ToFields=%@&MessageType=%@&CcFields=%@&MsgType=%@&MessageId=%@",userID,lastUpdatedDate,operationType,messageSender,patientFirstName,PatientLastName,patientDOB,messageSubject,messageBody,toFields,messageType,ccFields,msgType,messageId];
    
    NSLog(@"Compose message API URL request Body:::\n %@",string);
    [objParser parseJson:ComposeAPI :string];
    
}

#pragma mark- Button Actions
/*******************************************************************************
 *  To add PatientInformation.
 ********************************************************************************/
- (IBAction)addPatientBtnClicked:(id)sender
{
    if(addPatentInfoBtn.tag) // without patient onfo
    {
        addPatentInfoBtn.tag = 0;
        
        [self setValueToThePatientField];
        
        updownImgView.image = [UIImage imageNamed:@"rightArrow.png"];
        [patientInfoView removeFromSuperview];
        subjectText.frame = CGRectMake(subjectText.frame.origin.x, addPatentInfoBtn.frame.origin.y + addPatentInfoBtn.frame.size.height+10, subjectText.frame.size.width, subjectText.frame.size.height);
        sendMsgBodyTxtView.frame = CGRectMake(sendMsgBodyTxtView.frame.origin.x, subjectText.frame.origin.y+subjectText.frame.size.height+10, sendMsgBodyTxtView.frame.size.width, sendMsgBodyTxtView.frame.size.height);
        sendMsgScrlview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        backgroundBtn.frame = CGRectMake(0, 0, sendMsgScrlview.contentSize.width,sendMsgScrlview.contentSize.height);
    }
    else  // with patient info
    {
        
        addPatentInfoBtn.tag = 1;
        patientInfoLabel.text = @"Patient";
        updownImgView.image = [UIImage imageNamed:@"downArrow.png"];
        [sendMsgScrlview addSubview:patientInfoView];
        [sendMsgScrlview bringSubviewToFront:backButton];
        
        patientInfoView.frame = CGRectMake(0, 130, self.view.frame.size.width,147);
        
        subjectText.frame = CGRectMake(subjectText.frame.origin.x, patientInfoView.frame.origin.y+patientInfoView.frame.size.height, subjectText.frame.size.width, subjectText.frame.size.height);
        
        sendMsgBodyTxtView.frame = CGRectMake(sendMsgBodyTxtView.frame.origin.x, subjectText.frame.origin.y+subjectText.frame.size.height+10, sendMsgBodyTxtView.frame.size.width, sendMsgBodyTxtView.frame.size.height);
        
        sendMsgScrlview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *1.5);
        patientInfoLabel.textColor = [UIColor grayColor];
    }
    
    backgroundBtn.frame = CGRectMake(0, 0, sendMsgScrlview.contentSize.width,sendMsgScrlview.contentSize.height);
}

/*******************************************************************************
 *  datePicker Done button touch action
 ********************************************************************************/
- (IBAction)doneEditing:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
//    NSString *todaysdate = [DateFormatter getDateStringFromDate:[NSDate date] withFormat:@"MM/dd/yyyy"];

    self.patientDOBTxtField.text = [NSString stringWithFormat:@"%@",[df stringFromDate: datePickerView.date]];
    
    [self.patientDOBTxtField resignFirstResponder];
    [self.subjectText becomeFirstResponder];
}

/*******************************************************************************
 *  To field search button action, will move to the directory view to select people.
 ********************************************************************************/
- (IBAction)searchParticipantsBtnTouched:(id)sender
{
    if(toRecipientSelectedIdArray)
    {
        toRecipientSelectedIdArray = nil;
    }
    toRecipientSelectedIdArray = [self fetchToFieldValues];
    
    isTo = 1;
    NSLog(@"toRecipientSelectedIdArray === %@",toRecipientSelectedIdArray);
    DirectoryViewController *detailViewController=[[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController"
                                                                                            bundle:nil];
    [detailViewController beginWithAddParticipants:1];
    detailViewController.selectedPhysicianIdArray = toRecipientSelectedIdArray;
    detailViewController.toAndCcFlag = 0;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
}

/*******************************************************************************
 *  Cc field search button action, will move to the directory view to select people.
 ********************************************************************************/
- (IBAction)searchCcButtonTouched:(id)sender    {
    
    if(ccRecipientSelectedIdArray)
    {
        ccRecipientSelectedIdArray = nil;
    }
    ccRecipientSelectedIdArray = [self fetchCcFieldValues];
    
    isTo = 0;
    NSLog(@"ccRecipientSelectedIdArray === %@",ccRecipientSelectedIdArray);
    DirectoryViewController *detailViewController=[[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController"
                                                                                            bundle:nil];
    [detailViewController beginWithAddParticipants:1];
    detailViewController.toAndCcFlag = 1;
    detailViewController.selectedPhysicianIdArray = ccRecipientSelectedIdArray;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
}

/*******************************************************************************
 *  Will Store it into the DataBase.
 ********************************************************************************/
- (IBAction)sendButtonTouched:(id)sender
{
    
    NSString * toTextValue = toText.text;
    NSString * subjectTextValue = subjectText.text;
    
    //checking all the entered To field is valid, if valid add to the toRecipientSelectedIdArray
    if(toRecipientSelectedIdArray)
    {
        toRecipientSelectedIdArray = nil;
    }
    toRecipientSelectedIdArray = [self fetchToFieldValues];
    
    //checking all the entered Cc field is valid, if valid add to the ccRecipientSelectedIdArray
    if(ccRecipientSelectedIdArray)
    {
        ccRecipientSelectedIdArray = nil;
    }
    ccRecipientSelectedIdArray = [self fetchCcFieldValues];
    
    NSString * body = sendMsgBodyTxtView.text;
    body = [body stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([NSNull null]==(NSNull*)toTextValue || [toTextValue isEqualToString:@""])
    {
        
        [GeneralClass showAlertView:nil
                                msg:NSLocalizedString(@"NO RECIPIENT", nil)
                              title:nil
                        cancelTitle:@"OK"
                         otherTitle:nil
                                tag:noTag];
    }
    else if (([NSNull null]==(NSNull*)subjectTextValue || [subjectTextValue isEqualToString:@""]) && [body length] == 0)
    {
        
        [GeneralClass showAlertView:self
                                msg:NSLocalizedString(@"NO SUBJECT", nil)
                              title:nil
                        cancelTitle:@"Cancel"
                         otherTitle:@"OK"
                                tag:noSubjectTag];
    }
    else {
        [self backGroundBtnClicked:nil];
        [self messageSending];
    }
}

/*******************************************************************************
 *  Cancel button touch action.
 ********************************************************************************/
- (IBAction)BackBtnClicked:(id)sender
{
    draftActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete Draft"
                                         otherButtonTitles:@"Save Draft",nil];
    NSLog(@"CRASH SOLVED");
    [draftActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    draftActionSheet = nil;
    
}

/*******************************************************************************
 *  Trash button touch action.
 ********************************************************************************/
- (IBAction)deleteButtonTouched:(id)sender
{
    [GeneralClass showAlertView:self
                            msg:NSLocalizedString(@"DELETE MESSAGE FOREVER", nil)
                          title:nil
                    cancelTitle:@"Yes"
                     otherTitle:@"No"
                            tag:deleteForeverTag];
}

#pragma mark- TextView delegates
/*******************************************************************************
 *  UITextView delegates.
 ********************************************************************************/
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(globalReplyFag)
    {
        if(addPatentInfoBtn.tag)//came from reply option with patient info
        {
            [self makeScrollviewUp:textView];
            textView.frame = CGRectMake(12.0, subjectText.frame.origin.y + subjectText.frame.size.height + 20 , 296.0, 160);
            shouldMoveCursor = NO;
        }
        else
        {
            shouldMoveCursor = YES;
        }
    }
    else
    {
        NSLog(@"NORMAL CASE");
        [self makeScrollviewUp:textView];
        keyboardToolbar.hidden = NO;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, 296.0, 160);
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, 296.0, 160);
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    // Moving the cursor to the beginning of UITextView with new line character
    if((shouldMoveCursor && globalReplyFag)||isSendMessageBody)
    {
        NSRange beginningRange = NSMakeRange(0, 0);
        NSRange currentRange = [textView selectedRange];
        if(!NSEqualRanges(beginningRange, currentRange))
        {
            textView.text = [textView.text stringByReplacingCharactersInRange:beginningRange withString:@"\n"];
            [textView setSelectedRange:beginningRange];
        }
        shouldMoveCursor = NO;
        isSendMessageBody = NO;
        moveTxtViewToWriteFlag = 1;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(moveTxtViewToWriteFlag)
    {
        keyboardToolbar.hidden = NO;
        [self makeScrollviewUp:textView];
        moveTxtViewToWriteFlag = 0;
    }
}

#pragma mark- UITextField delegate
/*******************************************************************************
 *  UITextField delegates.
 ********************************************************************************/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(![textField isEqual:toText])
    {
        scrlvos = sendMsgScrlview.contentOffset;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:sendMsgScrlview];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
        [sendMsgScrlview setContentOffset:pt animated:YES];
    }
    keyboardToolbar.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:toText] && addPatentInfoBtn.tag)
    {
        [toText resignFirstResponder];
        [ccText becomeFirstResponder];
    }
    else if([textField isEqual:ccText] && addPatentInfoBtn.tag)
    {
        [ccText resignFirstResponder];
        [patientFirstNameTxtField becomeFirstResponder];
        
    }
    else if ([textField isEqual:toText] && !(addPatentInfoBtn.tag))
    {
        [toText resignFirstResponder];
        [ccText becomeFirstResponder];
    }
    else if([textField isEqual:ccText] && !(addPatentInfoBtn.tag))
    {
        [ccText resignFirstResponder];
        [subjectText becomeFirstResponder];
    }
    else if ([textField isEqual:patientFirstNameTxtField])
    {
        [patientFirstNameTxtField resignFirstResponder];
        [patientLastNameTxtField becomeFirstResponder];
    }
    else if([textField isEqual:patientLastNameTxtField])
    {
        [patientLastNameTxtField resignFirstResponder];
        [patientDOBTxtField becomeFirstResponder];
    }
    else if([textField isEqual:patientDOBTxtField])
    {
        [patientDOBTxtField resignFirstResponder];
        [subjectText becomeFirstResponder];
    }
    else if([textField isEqual:subjectText])
    {
        [subjectText resignFirstResponder];
        isSendMessageBody = YES;
        [sendMsgBodyTxtView becomeFirstResponder];
    }
    [sendMsgScrlview setContentOffset:scrlvos animated:YES];
    
    return TRUE;
}

-(UITextView *) makeScrollviewUp:(UITextView *)textView
{
    scrlvos = sendMsgScrlview.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:sendMsgScrlview];
    pt = rc.origin;
    pt.x = 0;
    pt.y += 0;
    
    [sendMsgScrlview setContentOffset:pt animated:YES];
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
    
    [syncView removeFromSuperview];
    
    if ([result count]>0)
    {
        if(eparseType == DeleteMsgAPI)
        {
            BOOL isDeleted = [DataManager deleteMangedObject:inboxMsgObj];
            if (isDeleted)
            {
                [DataManager saveContext];
                [GeneralClass showAlertView:self
                                        msg:@"Message successfully deleted"
                                      title:nil
                                cancelTitle:@"OK"
                                 otherTitle:nil
                                        tag:deleteForeverSuccessAPITag];
            }
            else
            {
                NSLog(@"Error");
            }
        }
        else if(eparseType == ComposeAPI)
        {
            
            NSDictionary *composeMessageDictresult = [result objectAtIndex:0];
            NSString * messageType = [[composeMessageDictresult valueForKey:@"MessageType"] stringValue];
            if([messageType isEqualToString:@"0"])
            {
                if(inboxMsgObj)
                {
                    inboxMsgObj.messageType = [NSNumber numberWithInt:sentMsgID];
                    inboxMsgObj.messageId   = [composeMessageDictresult valueForKey:@"messageId"];
                    //NSString *updatedDate = [composeMessageDictresult valueForKey:@"lastUpdatedDate"];
                    //inboxMsgObj.date = [DateFormatter getDateFromDateString:updatedDate forFormat:@"MM/dd/yyyy"];
                    //NSLog(@"%@",inboxMsgObj.date);
                    BOOL isSaveMessage = [DataManager saveContext];
                    if(isSaveMessage)
                    {
                        
                        [GeneralClass showAlertView:self
                                                msg:@"Message successfully sent"
                                              title:nil
                                        cancelTitle:@"OK"
                                         otherTitle:nil
                                                tag:sentSuccessfullTag];
                    }
                    else
                    {
                        NSLog(@"Error Saving message");
                    }
                }
                
            }
            else if([messageType isEqualToString:@"2"])
            {
                if(inboxMsgObj)
                {
                    inboxMsgObj.messageType = [NSNumber numberWithInt:draftMsgId];
                    inboxMsgObj.messageId   = [composeMessageDictresult valueForKey:@"messageId"];
                    NSString *updatedDate = [composeMessageDictresult valueForKey:@"lastUpdatedDate"];
                    inboxMsgObj.date = [DateFormatter getDateFromDateString:updatedDate forFormat:@"MM/dd/yyyy"];
                    [DataManager saveContext];
                }
                
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
    errorParseType = eparseType;
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
        
        errorParseType = [[result valueForKey:@"operationType"] integerValue];
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

#pragma mark- Alertview delegates
/*******************************************************************************
 *  UIAlertview delegates.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == sentSuccessfullTag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag == deleteForeverTag)
    {
        if (buttonIndex == 0)
        {
            [self deleteDraftMessagesAPI:inboxMsgObj];
        }
        
        else
        {
            NSLog(@"NO Button");
        }
    }
    else if (alertView.tag == deleteForeverSuccessAPITag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag == noSubjectTag)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"cancel Button Click");
        }
        else
        {
            NSLog(@"Ok button click");
            [self messageSending];
        }
    }
    else if (alertView.tag == parseErrorTag)
    {
        NSLog(@"errorEparseType===%d",errorParseType);
        if(errorParseType == DeleteMsgAPI)
        {
            if(buttonIndex == 0)
            {
                [self deleteDraftMessagesAPI:inboxMsgObj];
            }
            else
            {
                [syncView removeFromSuperview];
            }
            
        }
        else if (errorParseType == ComposeAPI)
        {
            if(buttonIndex == 0)
            {
                [self callComposeMessageAPI];
            }
            else
            {
                [syncView removeFromSuperview];
                //                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
    alertView = nil;
}
#pragma mark- Action Delegates
/*******************************************************************************
 *  UIActionsheet delegates.
 ********************************************************************************/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    BOOL isSaved = NO;
    switch (buttonIndex) {
        case 0: //delete draft
        {
            [sendMsgBodyTxtView resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1://save draft
        {
            isSaveDraft = YES;
            toDraftRecipientSelectedIdArray = nil;
            ccDraftRecipientSelectedIdArray = nil;
            toDraftRecipientSelectedIdArray = [[NSMutableArray alloc]init];
            ccDraftRecipientSelectedIdArray = [[NSMutableArray alloc]init];
            
            //for finding the draft To, Cc invalid fields and assigning only the valid To, Cc fields.
//            if([toRecipientSelectedIdArray count])
//            {
//                [toRecipientSelectedIdArray removeAllObjects];
//            }
            toRecipientSelectedIdArray = [self fetchToFieldValues];
//            if([ccRecipientSelectedIdArray count])
//            {
//                [ccRecipientSelectedIdArray removeAllObjects];
//            }
            ccRecipientSelectedIdArray = [self fetchCcFieldValues];
            
            if([toRecipientSelectedIdArray count]||[ccRecipientSelectedIdArray count]){
                if ([inboxMsgObj.messageType intValue] == draftMsgId){
                    NSLog(@"existing Draft");
                    //delete that object locally create new
                    [DataManager deleteMangedObject:inboxMsgObj];
                    Inbox *newInboxObj = [DataManager createEntityObject:@"Inbox"];
                    isSaved = [self saveInboxMessageDetail:newInboxObj messageType:draftMsgId];
                    inboxMsgObj = newInboxObj;
                }
                else{
                    NSLog(@"new draft");
                    Inbox *newInboxObj = [DataManager createEntityObject:@"Inbox"];
                    isSaved = [self saveInboxMessageDetail:newInboxObj messageType:draftMsgId];
                    inboxMsgObj = newInboxObj;
                }
                
                if(isSaved){
                    //inboxMsgObj.messageType = [NSNumber numberWithInt:draftMsgId];
                    NSLog(@"local save success");
                    [self callComposeMessageAPI];
                    
                }
                
                else{
                    NSLog(@"error in local Saving");
                }
            }
            else{
                
                [GeneralClass showAlertView:nil
                                        msg:@"Recipient is required"
                                      title:nil
                                cancelTitle:@"OK"
                                 otherTitle:nil
                                        tag:noTag];
            }
        }
            break;
        default:
            break;
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
    if (contacts)
    {
        if(isTo)
        {
            if(toRecipientSelectedIdArray)
            {
                toRecipientSelectedIdArray = nil;
            }
            toRecipientSelectedIdArray = [[NSMutableArray alloc]init];
            
            toRecipientSelectedIdArray = contacts;
            
            if(recipientNameArray)
            {
                recipientNameArray = nil;
            }
            recipientNameArray = [[NSMutableArray alloc]init];
            
            NSLog(@"toRecipientSelectedIdArray count === %d",[toRecipientSelectedIdArray count]);
            NSLog(@"toRecipientSelectedIdArray ::  %@",toRecipientSelectedIdArray);
            
            for (int i = 0; i < [toRecipientSelectedIdArray count]; i++)
            {
                Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[[toRecipientSelectedIdArray objectAtIndex:i] intValue]];
                if(directory.physicianName)
                {
                    [recipientNameArray addObject:directory.physicianName];
                }
            }
            NSString *recipeientString = [recipientNameArray componentsJoinedByString:@", "];
            
            toText.text = recipeientString;
        }
        
        else
        {
            if(ccRecipientSelectedIdArray)
            {
                ccRecipientSelectedIdArray = nil;
            }
            ccRecipientSelectedIdArray = [[NSMutableArray alloc]init];
            
            ccRecipientSelectedIdArray = contacts;
            
            if(recipientNameArray)
            {
                recipientNameArray = nil;
            }
            recipientNameArray = [[NSMutableArray alloc]init];
            
            NSLog(@"ccRecipientSelectedIdArray count === %d",[ccRecipientSelectedIdArray count]);
            NSLog(@"ccRecipientSelectedIdArray ::  %@",ccRecipientSelectedIdArray);
            
            for (int i = 0; i < [ccRecipientSelectedIdArray count]; i++)
            {
                Directory *directory = [DataManager fetchDirectoryObjectForEntity:@"Directory" selectBy:[[ccRecipientSelectedIdArray objectAtIndex:i] intValue]];
                if(directory.physicianName)
                {
                    [recipientNameArray addObject:directory.physicianName];
                }
            }
            NSString *recipeientString = [recipientNameArray componentsJoinedByString:@", "];
            ccText.text = recipeientString;
        }
    }
}

#pragma mark- keybord animation handling methods
/*******************************************************************************
 *  Function Name: registerForKeyboardNotifications.
 *  Purpose: To register a Keyboard notification for initializing Custom keyboard ToolBar.
 *  Parametrs: nil.
 *  Return Values: nil.
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
 *  Return Values: nil.
 ********************************************************************************/
-(void)initializingKeyboardToolBar
{
    if(keyboardToolbar == nil)
    {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,416,320,40)];
        keyboardToolbar.barStyle = UIBarStyleDefault;
        keyboardToolbar.hidden = YES;
        
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
    [self backGroundBtnClicked:nil];
}

#pragma mark- BackGroundTouch Actions
/*******************************************************************************
 *  Background button touch action.
 ********************************************************************************/
- (IBAction)backGroundBtnClicked:(id)sender
{
    NSLog(@"Background touched ");
    [toText resignFirstResponder];
    [subjectText resignFirstResponder];
    [ccText resignFirstResponder];
    [patientFirstNameTxtField resignFirstResponder];
    [patientLastNameTxtField resignFirstResponder];
    [patientDOBTxtField resignFirstResponder];
    [sendMsgBodyTxtView resignFirstResponder];
    [sendMsgScrlview setContentOffset:CGPointMake(self.view.frame.origin.x,self.view.frame.origin.y) animated:YES];
    sendMsgBodyTxtView.frame = CGRectMake(sendMsgBodyTxtView.frame.origin.x, subjectText.frame.origin.y+subjectText.frame.size.height+10, sendMsgBodyTxtView.frame.size.width, sendMsgBodyTxtView.frame.size.height);
}

/*******************************************************************************
 *  Function Name:touchesBegan.
 *  Purpose: To delegate back ground touch events.
 *  Parametrs:event.
 *  Return Values:nil.
 ********************************************************************************/
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"Background touched");
    [sendMsgBodyTxtView resignFirstResponder];
    [self backGroundBtnClicked:nil];
}

#pragma mark viewDidUnload
- (void)viewDidUnload
{
    [self setDeleteButton:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    NSLog(@"dealloc in sendMsg == %@",sendMsg.text);
    [self setSubjectText:nil];
    [self setToText:nil];
    [self setInboxMsgObj:nil];
    [self setSendMsgBodyTxtView:nil];
    [self setAddPatientTxtField:nil];
    [self setPatientFirstNameTxtField:nil];
    [self setPatientLastNameTxtField:nil];
    [self setPatientDOBTxtField:nil];
    [self setSendMsg:nil];
    toValueIds = nil;
    ccValueIds = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
