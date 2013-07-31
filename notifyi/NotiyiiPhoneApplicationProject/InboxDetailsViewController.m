//
//  InboxDetailsViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InboxDetailsViewController.h"
#import "DataManager.h"
#import "SendMessageViewController.h"
#import "GeneralClass.h"
#import <QuartzCore/Quartzcore.h>
#import "AppDelegate.h"
#import "MsgRecipient.h"
#import "JSON.h"
#import "DateFormatter.h"

#define SMALLIMGVIEWHEIGHT 78
#define LARGEIMGVIEWHEIGHT 116
#define TXTVIEWHEIGHT 37

JsonParser *objParser;

@interface InboxDetailsViewController ()
{
    UIView *replyView;
    BOOL showDetailsFlag;
    IBOutlet UILabel *inboxDetailedToLabel;
    IBOutlet UILabel *inboxDetailedCcLabel;
    IBOutlet UILabel *inboxHideFromLabel;
    IBOutlet UILabel *inboxDetailedFromLabel;
    IBOutlet UILabel *inboxHidePatientLabel;
    IBOutlet UILabel *inboxDetailedPatientLabel;
    IBOutlet UILabel *inboxHideSubjectLabel;
    IBOutlet UILabel *inboxDetailedSubjectLabel;
    IBOutlet UILabel *inboxHideDateContentLabel;
    IBOutlet UILabel *inboxDetailedDateContentLabel;
    IBOutlet UIButton *backBtn;
    IBOutlet UILabel *inboxDetailedToColumnLabel;
    IBOutlet UILabel *inboxDetailedCcColumnLabel;
    IBOutlet UILabel *inboxHideFromColumnLabel;
    IBOutlet UILabel *inboxDetailedFromColumnLabel;
    IBOutlet UILabel *inboxHidePatientColumnLabel;
    IBOutlet UILabel *inboxDetailedPatientColumnLabel;
    IBOutlet UILabel *inboxHideSubjectColumnLabel;
    IBOutlet UILabel *inboxDetailedSubjectColumnLabel;
    IBOutlet UILabel *sentHideToLabel;
    IBOutlet UILabel *sentDetailedToLabel;
    IBOutlet UILabel *sentHideCcLabel;
    IBOutlet UILabel *sentDetailedCcLabel;
    IBOutlet UILabel *sentDetailedAlertLabel;
    IBOutlet UILabel *sentDetailedRouteLabel;
    IBOutlet UILabel *sentHidePatientLabel;
    IBOutlet UILabel *sentDetailedPatientLabel;
    IBOutlet UILabel *sentHideSubjectLabel;
    IBOutlet UILabel *sentDetailedSubjectLabel;
    IBOutlet UILabel *sentDetailedCoverageLabel;
    IBOutlet UIView *sentMailDetailedInfoView;
    IBOutlet UIView *sentMailHideInfoView;
    IBOutlet UIView *inboxMailDetailedInfoView;
    IBOutlet UIView *inboxMailHideInfoView;
    IBOutlet UILabel *sentHideToColumnLabel;
    IBOutlet UILabel *sentDetailedToColumnLabel;
    IBOutlet UILabel *sentHideSubjectColumnLabel;
    IBOutlet UILabel *sentDetailedSubjectColumnLabel;
    IBOutlet UILabel *sentHidePatientColumnLabel;
    IBOutlet UILabel *sentDetailedPatientColumnLabel;
    IBOutlet UILabel *sentDetailedRouteColumnLabel;
    IBOutlet UILabel *sentDetailedAlertColumnLabel;
    IBOutlet UILabel *sentDetailedCoverageColumnLabel;
    IBOutlet UILabel *sentHideCcColumnLabel;
    IBOutlet UILabel *sentDetailedCcColumnLabel;
    
    UIView *syncView;
    UIButton *inboxDetailsbtn;
    int errorParseType;
}

@property (strong, nonatomic) IBOutlet UILabel *inboxDetailedToLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxDetailedCcLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxHideFromLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxDetailedFromLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxHidePatientLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxDetailedPatientLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxHideSubjectLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *inboxDetailedSubjectLabelContent;
@property (strong, nonatomic) IBOutlet UITextView *messageBodyTextView;
@property (strong, nonatomic) IBOutlet UILabel *sentHideToLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedToLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedRouteLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentHideDateContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedDateContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *sentHidePatientLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedPatientLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentHideSubjectLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedSubjectLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedAlertLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedCoverageLabelContent;
@property (strong, nonatomic) IBOutlet UIImageView *navigationBarView;
@property (strong, nonatomic) IBOutlet UILabel *sentHideCcLabelContent;
@property (strong, nonatomic) IBOutlet UILabel *sentDetailedCcLabelContent;

-(void)updateReadStatus:(Inbox *)inbox;
-(void)deleteMessageStatus:(Inbox *)inbox;
-(void)setCustomOverlay;
-(void)performNavigationToCompose:(int)navigateFlag;
-(void)setupSwipe;
-(void)setValuesInView:(Inbox *)inboxObj;
-(void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)setanimationForSwipe:(int)type;
-(void)inboxMessageView;
-(void)sentMessageView;
-(void)setFontColorsForControllers;
-(void)setFontsForControllers;
-(void)fontColorForSentmailMessageView;
-(void)fontsForInboxMessageView;
-(void)fontColorForInboxMessageView;
-(void)fontColorForSentmailMessageView;
-(void)fontsForSentmailMessageView;
-(void)setInboxMessageDetails:(NSString *)patientDetails subjectInfo:(NSString *)subjectDetails dateInfo:(NSString *)dateDetails;
-(void)setSentMessageDetails:(NSString *)patientDetails subjectInfo:(NSString *)subjectDetails dateInfo:(NSString *)dateDetails;
-(void)setToCcFieldOfSentMessage:(NSMutableArray *)toDetails CcInfo:(NSMutableArray *)ccDetails;
-(void)setToCcFieldOfInboxMessage:(NSMutableArray *)toDetails CcInfo:(NSMutableArray *)ccDetails;
-(void)checkingMessageDetails:(Inbox *)inboxObj;

-(IBAction)deleteButtonTouched:(id)sender;
-(IBAction)backButtonTouhed:(id)sender;
-(IBAction)inboxDetailsBtnTouched:(id)sender;
-(IBAction)forwardButtonTouched:(id)sender;
-(IBAction)replyAllButtonTouched:(id)sender;
-(IBAction)replyButtonTouched:(id)sender;

@end

@implementation InboxDetailsViewController

@synthesize swipeCount;
@synthesize inboxManagerArr;
@synthesize inboxDetailedCcLabelContent;
@synthesize inboxDetailedToLabelContent;
@synthesize inboxHideFromLabelContent,inboxDetailedFromLabelContent;
@synthesize inboxHidePatientLabelContent,inboxDetailedPatientLabelContent;
@synthesize inboxHideSubjectLabelContent,inboxDetailedSubjectLabelContent;
@synthesize messageBodyTextView;
@synthesize messageTypeID;
@synthesize sentDetailedAlertLabelContent;
@synthesize sentDetailedCoverageLabelContent,sentHideDateContentLabel,sentHidePatientLabelContent,sentDetailedRouteLabelContent,sentDetailedDateContentLabel,sentDetailedPatientLabelContent;
@synthesize sentHideSubjectLabelContent,sentHideToLabelContent,sentDetailedSubjectLabelContent,sentDetailedToLabelContent;
@synthesize navigationBarView;
@synthesize sentHideCcLabelContent,sentDetailedCcLabelContent;

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setFontsForControllers];
    messageBodyTextView.Editable = NO;
    NSLog(@"swipeCount : %d",swipeCount);
    NSLog(@"inboxManagerArr : %@",inboxManagerArr);
    
    if([inboxManagerArr count] > 0)
    {
        [self setValuesInView:[inboxManagerArr objectAtIndex:swipeCount]];
    }
    [self setupSwipe];
    NSLog(@"swipeCount === %d",swipeCount);
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name:setFontsForControllers.
 *  Purpose: setting font for Controllers.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void) setFontsForControllers
{
    backBtn.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    [self fontsForInboxMessageView];
    [self fontsForSentmailMessageView];
    [self setFontColorsForControllers];
}
/*******************************************************************************
 *  Function Name:fontsForInboxMessageView.
 *  Purpose: setting font for inboxmail View.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)fontsForInboxMessageView
{
    inboxHideFromLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedFromLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHidePatientLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedPatientLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHideSubjectLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedSubjectLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    
    inboxHideFromColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedFromColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHidePatientColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedPatientColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHideSubjectColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedSubjectColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHideFromLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedFromLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHidePatientLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedPatientLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHideSubjectLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedSubjectLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxDetailedToLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedCcLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxDetailedToColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedCcColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxDetailedToLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxHidePatientLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedPatientLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    messageBodyTextView.font = [GeneralClass getFont:customRegular and:regularFont];
    inboxDetailsbtn.titleLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    inboxHideDateContentLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    inboxDetailedDateContentLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    inboxDetailedCcLabelContent.font = [GeneralClass getFont:buttonFont and:boldFont];
    
}
/*******************************************************************************
 *  Function Name:fontsForSentmailMessageView.
 *  Purpose: setting font for sentmail View.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)fontsForSentmailMessageView
{
    sentHideToLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedToLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHideCcLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedCcLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHidePatientLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedPatientLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHideSubjectLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedSubjectLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentDetailedAlertLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedCoverageLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedRouteLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHideToColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedToColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHideCcColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedCcColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHidePatientColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedPatientColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentHideSubjectColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedSubjectColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    
    sentDetailedAlertColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedCoverageColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentDetailedRouteColumnLabel.font = [GeneralClass getFont:buttonFont and:boldFont];
    sentHideToLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    
    sentDetailedToLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    
    sentHideCcLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    sentDetailedCcLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    
    sentHideSubjectLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    sentDetailedSubjectLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    
    sentHidePatientLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    sentDetailedPatientLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    
    sentDetailedAlertLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    sentDetailedCoverageLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    sentDetailedRouteLabelContent.font = [GeneralClass getFont:customNormal and:boldFont];
    sentHideDateContentLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    sentDetailedDateContentLabel.font = [GeneralClass getFont:customNormal and:boldFont];
}

/*******************************************************************************
 *  Function Name:setFontColorsForControllers.
 *  Purpose: setting fontColor for inbox and sentmail View.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)setFontColorsForControllers
{
    [self fontColorForInboxMessageView];
    [self fontColorForSentmailMessageView];
}

/*******************************************************************************
 *  Function Name:fontColorForInboxMessageView.
 *  Purpose: setting fontColor for inboxmail View.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)fontColorForInboxMessageView
{
    
    inboxHideFromLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    inboxDetailedFromLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    inboxHidePatientLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    inboxDetailedPatientLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    inboxHideSubjectLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    inboxDetailedSubjectLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    inboxDetailedToLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    inboxDetailedCcLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    inboxHideDateContentLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    inboxDetailedDateContentLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    inboxHideFromLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedFromLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxHidePatientLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedPatientLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxHideSubjectLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedSubjectLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxDetailedToLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedCcLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxHideFromColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedFromColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxHidePatientColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedPatientColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxHideSubjectColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedSubjectColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    inboxDetailedToColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    inboxDetailedCcColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
}

/*******************************************************************************
 *  Function Name:fontColorForSentmailMessageView.
 *  Purpose: setting fontColor for sentmail View.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)fontColorForSentmailMessageView
{
    sentHideToLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedToLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentHideToLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedToLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    sentHideCcLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedCcLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentHidePatientLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedPatientLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentHideSubjectLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedSubjectLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentDetailedAlertLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedCoverageLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedRouteLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    
    sentHideToColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedToColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentHideCcColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedCcColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentHidePatientColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedPatientColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentHideSubjectColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedSubjectColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    sentDetailedAlertColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedCoverageColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    sentDetailedRouteColumnLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    
    
    sentHideSubjectLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedSubjectLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentHideCcLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedCcLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    sentDetailedPatientLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    
    sentHidePatientLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedAlertLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedCoverageLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedRouteLabelContent.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentDetailedDateContentLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    sentHideDateContentLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
}

/*******************************************************************************
 *  Function Name:setValuesInView
 *  Purpose: Setting Values to the textView/textField from database.
 *  Parametrs:inboxObject
 *  Return Values:nil
 ********************************************************************************/
-(void) setValuesInView:(Inbox *)inboxObj
{
    //change the status to read and core data saving
    NSLog(@"inboxObj readstatus === %@",inboxObj.readStatus);
    
    if ([inboxObj.messageType intValue] == inboxMesgID)
    {
        if ([inboxObj.readStatus intValue])
        {
            NSLog(@"read message");
        }
        else
        {
            NSLog(@"unread message");
            [self updateReadStatus:inboxObj];
            
            inboxObj.readStatus = [NSNumber numberWithInt:1];
            
            [DataManager saveContext];
        }
    }
    else if([inboxObj.messageType intValue] == sentMsgID)
    {
        [self updateReadStatus:inboxObj];
        
    }
    
    self.messageTypeID = [inboxObj.messageType intValue];
    
    NSMutableArray * toName = [[NSMutableArray alloc]init];
    NSMutableArray * toNameId = [[NSMutableArray alloc]init];
    NSMutableArray * ccName = [[NSMutableArray alloc]init];
    NSMutableArray * ccNameId = [[NSMutableArray alloc]init];
    NSArray *recipientList = [inboxObj.recipientmessageID allObjects];
    NSLog(@"recipientList : %@",recipientList);
    
    for (int i = 0; i < [recipientList count]; i++)
    {
        NSPredicate * toPredicate = [NSPredicate predicateWithFormat:@"SELF.isCC = 0"];// 0 means Sender(To Address)
        NSArray * toAddress = [recipientList filteredArrayUsingPredicate:toPredicate];
        for(int k = 0; k < [toAddress count]; k++)
        {
            MsgRecipient * msgObject = [toAddress objectAtIndex:k];
            if([toAddress count] > 0)
            {
                if(![toNameId containsObject:msgObject.recipientId])
                {
                    [toName addObject:msgObject.docterName];
                    [toNameId addObject:msgObject.recipientId];
                }
            }
        }
        NSPredicate * ccPredicate = [NSPredicate predicateWithFormat:@"SELF.isCC = 1"];
        NSArray * fromAddress = [recipientList filteredArrayUsingPredicate:ccPredicate];
        for(int j = 0; j < [fromAddress count]; j++)
        {
            MsgRecipient * msgRecipientObject = [fromAddress objectAtIndex:j];
            if([fromAddress count] > 0)
            {
                if(![ccNameId containsObject:msgRecipientObject.recipientId])
                {
                    [ccName addObject:msgRecipientObject.docterName];
                    [ccNameId addObject:msgRecipientObject.recipientId];
                }
            }
        }
    }
    
    //Setting the Tabbar unread message badge count(Only for Inbox message Details)
    if ([inboxObj.messageType intValue] ==1)
    {
        [backBtn setTitle:@"  Inbox" forState:UIControlStateNormal];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.readStatus = 0"];
        NSArray *unReadMessages = [inboxManagerArr filteredArrayUsingPredicate:predicate];
        
        AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app setTabTabBarBadge:[unReadMessages count]];
        
        [self inboxMessageView];
        [self checkingMessageDetails:inboxObj];
        [self setToCcFieldOfInboxMessage:toName CcInfo:ccName];
    }
    //sent mail details
    else if ([inboxObj.messageType intValue] ==0)
    {
        [backBtn setTitle:@"  Sent" forState:UIControlStateNormal];
        [self sentMessageView];
        [self checkingMessageDetails:inboxObj];
        [self setToCcFieldOfSentMessage:toName CcInfo:ccName];
    }
    //Trash Message Details
    else if ([inboxObj.messageType intValue] ==3)
    {
        NSLog(@"deletefrom==%@",inboxObj.deleteFrom);
        [backBtn setTitle:@" Trash" forState:UIControlStateNormal];
        //TrashMessage from inbox
        if([inboxObj.deleteFrom intValue] ==1)
        {
            [self inboxMessageView];
            [self checkingMessageDetails:inboxObj];
            [self setToCcFieldOfInboxMessage:toName CcInfo:ccName];
        }
        //TrashMessage from sentmail
        else if([inboxObj.deleteFrom intValue]==0)
        {
            [self sentMessageView];
            [self checkingMessageDetails:inboxObj];
            [self setToCcFieldOfSentMessage:toName CcInfo:ccName];
        }
    }
    NSLog(@"hide button label==%@",inboxDetailsbtn.titleLabel.text);
    if([inboxDetailsbtn.titleLabel.text isEqualToString:@"Details"])
    {
        showDetailsFlag = 1;
        NSLog(@"ShowDetails Flag==%d",showDetailsFlag);
    }
    else
    {
        showDetailsFlag = 0;
        NSLog(@"ShowDetails Flag==%d",showDetailsFlag);
    }
    toName = nil;
    toNameId = nil;
    ccName = nil;
    ccNameId = nil;
}
/*******************************************************************************
 *  Function Name: updateReadStatus.
 *  Purpose: To call ReadMessage API.
 *  Parametrs: current Inbox Obj.
 *  Return Values: nil.
 ********************************************************************************/
- (void)updateReadStatus:(Inbox *)inbox
{
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        
        objParser.delegate=self;
    }
    NSString *messageId =  [NSString stringWithFormat:@"%d",[inbox.messageId intValue]];
    NSString *messageType = [NSString stringWithFormat:@"%d",[inbox.messageType intValue]];
    NSString *readStatus = [NSString stringWithFormat:@"%d",[inbox.readStatus intValue]];
    
    NSString *string=[NSString stringWithFormat:@"&MessageId=%@&MessageType=%@&readStatus=%@",messageId,messageType,readStatus];
    
    [objParser parseJson:ReadMessageAPI :string];
}

/*******************************************************************************
 *  Function Name: deleteMessageStatus.
 *  Purpose: To call DeleteMessage API.
 *  Parametrs: Inbox Obj to delete.
 *  Return Values: nil.
 ********************************************************************************/
-(void)deleteMessageStatus:(Inbox *)inbox
{
    [self setCustomOverlay];
    
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *messageType = [NSString stringWithFormat:@"%d",[inbox.messageType intValue]];
    NSString *messageID = [NSString stringWithFormat:@"%d",[inbox.messageId intValue]];
    NSString *operationType = [NSString stringWithFormat:@"%d",DeleteMsgAPI];
    
    NSString *string = [NSString stringWithFormat:@"?userId=%@&MessageId=%@&MessageType=%@&operationType=%@",userID,messageID,messageType,operationType];
    
    [objParser parseJson:DeleteMsgAPI :string];
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
        syncView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *syncingActivityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(60, 140, 200, 200)];
        syncingActivityIndicator.backgroundColor = [UIColor clearColor];
        syncingActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [syncingActivityIndicator startAnimating];
        [syncView addSubview:syncingActivityIndicator];
    }
    [self.view addSubview:syncView];
}

/*******************************************************************************
 *  Function Name:setToCcFieldOfSentMessage
 *  Purpose: Setting Values to the To and Cc textfield of sentmessage.
 *  Parametrs:To and Cc details as Array
 *  Return Values:nil
 ********************************************************************************/
-(void)setToCcFieldOfSentMessage:(NSMutableArray *)toDetails CcInfo:(NSMutableArray *)ccDetails
{
    sentHideToLabelContent.text = [toDetails componentsJoinedByString:@", "];
    sentDetailedToLabelContent.text = [toDetails componentsJoinedByString:@", "];
    
    sentHideCcLabelContent.text = [ccDetails componentsJoinedByString:@", "];
    sentDetailedCcLabelContent.text = [ccDetails componentsJoinedByString:@", "];
}

/*******************************************************************************
 *  Function Name:setToCcFieldOfInboxMessage.
 *  Purpose: Setting Values to the To and Cc textfield of inboxmessage.
 *  Parametrs:To and Cc details as Array
 *  Return Values:nil
 ********************************************************************************/
-(void)setToCcFieldOfInboxMessage:(NSMutableArray *)toDetails CcInfo:(NSMutableArray *)ccDetails
{
    Inbox * inboxObj = [inboxManagerArr objectAtIndex:swipeCount];
    inboxHideFromLabelContent.text = inboxObj.senderName ;
    inboxDetailedFromLabelContent.text = inboxObj.senderName;
    
    NSString* user = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"];
    
    int todetailsCount = [toDetails count];
    for (int i =0; i<todetailsCount; i++)
    {
        NSString *toFieldContainsUser = [toDetails objectAtIndex:i];
        if ([toFieldContainsUser isEqualToString:user])
        {
            [toDetails replaceObjectAtIndex:i withObject:@"Me"];
        }
        
    }
    inboxDetailedToLabelContent.text = [toDetails componentsJoinedByString:@", "];
    int ccdetailsCount = [ccDetails count];
    for (int i =0; i<ccdetailsCount; i++)
    {
        NSString *ccFieldContainsUser = [ccDetails objectAtIndex:i];
        if ([ccFieldContainsUser isEqualToString:user])
        {
            [ccDetails replaceObjectAtIndex:i withObject:@"Me"];
        }
        
    }
    inboxDetailedCcLabelContent.text = [ccDetails componentsJoinedByString:@", "];
}

/*******************************************************************************
 *  Function Name:checkingMessageDetails
 *  Purpose: Validating patientinformation,date and messagebody.
 *  Parametrs:inboxObject.
 *  Return Values:nil
 ********************************************************************************/
-(void)checkingMessageDetails:(Inbox *)inboxObj
{
    NSString *patientInfoString;
    NSString *subjectInfoString;
    NSString *dateInfoString;
    
    NSString *patientDOB = [DateFormatter getDateStringFromDate:inboxObj.patientDOB withFormat:@"MM/dd/yyyy"];
    
    if((inboxObj.patientFirstName.length || inboxObj.patientLastName.length)&& patientDOB.length)
    {
        patientInfoString = [NSString stringWithFormat:@"%@ %@, %@",inboxObj.patientFirstName,inboxObj.patientLastName,patientDOB];
        
    }
    else if ((inboxObj.patientFirstName.length && inboxObj.patientLastName.length)&&patientDOB.length)
    {
        patientInfoString = [NSString stringWithFormat:@"%@ %@, %@",inboxObj.patientFirstName,inboxObj.patientLastName,patientDOB];
        
    }
    else if (patientDOB.length)
    {
        patientInfoString = [NSString stringWithFormat:@"%@",patientDOB];
    }
    else if ((inboxObj.patientFirstName.length || inboxObj.patientLastName.length))
    {
       if(![inboxObj.patientFirstName isEqualToString:@"(null)"] || ![inboxObj.patientLastName isEqualToString:@"(null)"])
       {
           patientInfoString = [NSString stringWithFormat:@"%@ %@",inboxObj.patientFirstName,inboxObj.patientLastName];
       }else if([inboxObj.patientFirstName isEqualToString:@"(null)"] && ![inboxObj.patientLastName isEqualToString:@"(null)"]) {
            patientInfoString = [NSString stringWithFormat:@"%@",inboxObj.patientLastName];
       }else if(![inboxObj.patientFirstName isEqualToString:@"(null)"] && [inboxObj.patientLastName isEqualToString:@"(null)"]) {
           patientInfoString = [NSString stringWithFormat:@"%@",inboxObj.patientFirstName];
       }else{
           patientInfoString = @"";
 
       }        
    }
    else if (inboxObj.patientFirstName.length && inboxObj.patientLastName.length)
    {
        if(![inboxObj.patientFirstName isEqualToString:@"(null)"] && ![inboxObj.patientLastName isEqualToString:@"(null)"])
        {
            patientInfoString = [NSString stringWithFormat:@"%@ %@",inboxObj.patientFirstName,inboxObj.patientLastName];
        }else{
            patientInfoString = @"";

        }
    }
    if(inboxObj.subject.length)
    {
        if(![inboxObj.subject isEqualToString:@"(null)"])
        {
            subjectInfoString = [NSString stringWithFormat:@"%@,",inboxObj.subject];
        }
        else {
            subjectInfoString = @""; 
        }
        
    }
    else
    {
        subjectInfoString = @"";
        
    }
    dateInfoString = [DateFormatter getDateStringFromDate:inboxObj.date withFormat:@"MM/dd/yyyy hh:mm a"];//, HH:mma
    
    if(([inboxObj.messageType intValue] == 0) || (([inboxObj.messageType intValue] ==3) && ([inboxObj.deleteFrom intValue] ==0)))
    {
        sentDetailedAlertLabelContent.text = inboxObj.alert;
        sentDetailedCoverageLabelContent.text = inboxObj.coverage;
        sentDetailedRouteLabelContent.text = inboxObj.route;
        
        [self setSentMessageDetails:patientInfoString subjectInfo:subjectInfoString dateInfo:dateInfoString];
        
    }
    else if(([inboxObj.messageType intValue] ==1 ) || (([inboxObj.messageType intValue] ==3) && ([inboxObj.deleteFrom intValue] ==1)))
    {
        [self setInboxMessageDetails:patientInfoString subjectInfo:subjectInfoString dateInfo:dateInfoString];
        
    }
    if(![inboxObj.textMessageBody isEqualToString:@"(null)"])
    {
        messageBodyTextView.text = [NSString stringWithFormat:@"\n\n\n\n\n\n %@",inboxObj.textMessageBody];
 
    }
    else{
        messageBodyTextView.text = @"";
    }
}

/*******************************************************************************
 *  Function Name:setInboxMessageDetails.
 *  Purpose: setting patientinformation,subject and date details Of inboxMessage
 *  Parametrs:patientdetails,sujectdetails and date details as string.
 *  Return Values:nil
 ********************************************************************************/
- (void)setInboxMessageDetails:(NSString *)patientDetails subjectInfo:(NSString *)subjectDetails dateInfo:(NSString *)dateDetails
{
    inboxHideSubjectLabelContent.text = subjectDetails;
    inboxDetailedSubjectLabelContent.text = subjectDetails;
    
    inboxHideDateContentLabel.text = dateDetails;
    inboxDetailedDateContentLabel.text = dateDetails;
    
    inboxHidePatientLabelContent.text = patientDetails;
    inboxDetailedPatientLabelContent.text = patientDetails;
    
}

/*******************************************************************************
 *  Function Name:setSentMessageDetails.
 *  Purpose: setting patientinformation,subject and date details Of sentMessage
 *  Parametrs:patientdetails,sujectdetails and date details as string.
 *  Return Values:nil
 ********************************************************************************/
- (void)setSentMessageDetails:(NSString *)patientDetails subjectInfo:(NSString *)subjectDetails dateInfo:(NSString *)dateDetails
{
    sentHidePatientLabelContent.text = patientDetails;
    sentDetailedPatientLabelContent.text = patientDetails;
    
    sentHideSubjectLabelContent.text = subjectDetails;
    sentDetailedSubjectLabelContent.text = subjectDetails;
    
    sentHideDateContentLabel.text = dateDetails;
    sentDetailedDateContentLabel.text = dateDetails;
}

/*******************************************************************************
 *  Function Name:inboxMessageView.
 *  Purpose: adding inboxmail hide and detailed information views as subview.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)inboxMessageView
{
    [sentMailDetailedInfoView removeFromSuperview];
    [sentMailHideInfoView removeFromSuperview];
    [inboxMailHideInfoView removeFromSuperview];
    [inboxMailDetailedInfoView removeFromSuperview];
    
    Inbox * inboxObj = [inboxManagerArr objectAtIndex:swipeCount];
    if (([inboxObj.messageType intValue] ==1 ) || (([inboxObj.messageType intValue] ==3) && ([inboxObj.deleteFrom intValue] ==1)))
    {
        if([inboxDetailsbtn.titleLabel.text isEqualToString:@"Details"])
        {
            [self.view addSubview:inboxMailHideInfoView];
            inboxMailHideInfoView.frame = CGRectMake(inboxMailHideInfoView.frame.origin.x,navigationBarView.frame.size.height,inboxMailHideInfoView.frame.size.width,inboxMailHideInfoView.frame.size.height);
            [self.view bringSubviewToFront:inboxDetailsbtn];
            messageBodyTextView.frame = CGRectMake(messageBodyTextView.frame.origin.x, inboxMailHideInfoView.frame.size.height, messageBodyTextView.frame.size.width, messageBodyTextView.frame.size.height);
            
            [inboxMailDetailedInfoView removeFromSuperview];
            [sentMailDetailedInfoView removeFromSuperview];
            [sentMailHideInfoView removeFromSuperview];
            
            showDetailsFlag = 1;
            
        }
        else if([inboxDetailsbtn.titleLabel.text isEqualToString:@"Hide Details"])
        {
            [self.view addSubview:inboxMailDetailedInfoView];
            inboxMailDetailedInfoView.frame = CGRectMake(inboxMailDetailedInfoView.frame.origin.x,navigationBarView.frame.size.height,inboxMailDetailedInfoView.frame.size.width,inboxMailDetailedInfoView.frame.size.height);
            [self.view bringSubviewToFront:inboxDetailsbtn];
            messageBodyTextView.frame = CGRectMake(messageBodyTextView.frame.origin.x, inboxMailDetailedInfoView.frame.size.height, messageBodyTextView.frame.size.width, messageBodyTextView.frame.size.height);
            [inboxMailHideInfoView removeFromSuperview];
            [sentMailDetailedInfoView removeFromSuperview];
            [sentMailHideInfoView removeFromSuperview];
            
            showDetailsFlag = 0;
        }
    }
}

/*******************************************************************************
 *  Function Name:sentMessageView.
 *  Purpose: adding sentmail hide and detailed information views as subview.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)sentMessageView
{
    [sentMailDetailedInfoView removeFromSuperview];
    [sentMailHideInfoView removeFromSuperview];
    [inboxMailDetailedInfoView removeFromSuperview];
    [inboxMailHideInfoView removeFromSuperview];
    
    Inbox * inboxObj = [inboxManagerArr objectAtIndex:swipeCount];
    if (([inboxObj.messageType intValue] == 0) || (([inboxObj.messageType intValue] ==3) && ([inboxObj.deleteFrom intValue] ==0)))
    {
        if([inboxDetailsbtn.titleLabel.text isEqualToString:@"Details"])
        {
            [self.view addSubview:sentMailHideInfoView];
            sentMailHideInfoView.frame = CGRectMake(sentMailHideInfoView.frame.origin.x,navigationBarView.frame.size.height,sentMailHideInfoView.frame.size.width,sentMailHideInfoView.frame.size.height);
            [self.view bringSubviewToFront:inboxDetailsbtn];
            messageBodyTextView.frame = CGRectMake(messageBodyTextView.frame.origin.x, sentMailHideInfoView.frame.size.height, messageBodyTextView.frame.size.width, messageBodyTextView.frame.size.height);
            
            [sentMailDetailedInfoView removeFromSuperview];
            [inboxMailDetailedInfoView removeFromSuperview];
            [inboxMailHideInfoView removeFromSuperview];
            
            showDetailsFlag = 1;
            
        }
        else if([inboxDetailsbtn.titleLabel.text isEqualToString:@"Hide Details"])
        {
            [self.view addSubview:sentMailDetailedInfoView];
            sentMailDetailedInfoView.frame = CGRectMake(sentMailDetailedInfoView.frame.origin.x,navigationBarView.frame.size.height,sentMailDetailedInfoView.frame.size.width,sentMailDetailedInfoView.frame.size.height);
            [self.view bringSubviewToFront:inboxDetailsbtn];
            messageBodyTextView.frame = CGRectMake(messageBodyTextView.frame.origin.x, sentMailDetailedInfoView.frame.size.height, messageBodyTextView.frame.size.width, messageBodyTextView.frame.size.height);
            
            [sentMailHideInfoView removeFromSuperview];
            [inboxMailDetailedInfoView removeFromSuperview];
            [inboxMailHideInfoView removeFromSuperview];
            
            showDetailsFlag = 0;
        }
    }
}

#pragma mark - Swipe Function
/*******************************************************************************
 *  Function Name:setupSwipe.
 *  Purpose: setup swipe to get the Next/Previos message details.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void) setupSwipe
{
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(rightSwipeHandle:)];
    
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:rightRecognizer];
    
    rightRecognizer = nil;
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(leftSwipeHandle:)];
    
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:leftRecognizer];
    
    leftRecognizer = nil;
}

#pragma mark  - UISwipeGestureRecognizer delegate
/*******************************************************************************
 *  Function: rightSwipeHandle.
 *  Purpose: Right swipe handler (GO TO PREV).
 *  Parametrs: gestureRecognizer.
 *  Return Values: nil
 ********************************************************************************/
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(swipeCount < [inboxManagerArr count] && (swipeCount > 0))
    {
        [self setanimationForSwipe:0];
        swipeCount = swipeCount - 1;
        [self setValuesInView:[inboxManagerArr objectAtIndex:swipeCount]];
    }
    else
    {
        NSLog(@"No Data To Swipe");
    }
}

/*******************************************************************************
 *  Function Name: leftSwipeHandle.
 *  Purpose: Left swipe handler (GO TO NEXT).
 *  Parametrs: gestureRecognizer.
 *  Return Values: nil
 ********************************************************************************/
- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(swipeCount >= 0)
    {
        if(swipeCount<[inboxManagerArr count]-1)
        {
            [self setanimationForSwipe:1];
            swipeCount = swipeCount + 1;
            [self setValuesInView:[inboxManagerArr objectAtIndex:swipeCount]];
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

#pragma mark- ButtonActions
/*******************************************************************************
 *  Currently the selected inbox details will delete from the database.
 ********************************************************************************/
- (IBAction)deleteButtonTouched:(id)sender
{
    Inbox *inboxMsgType = [inboxManagerArr objectAtIndex:swipeCount];
    NSLog(@"inboxMsgType == %@",inboxMsgType);
    NSString *alertMessage;
    
    if([inboxMsgType.readStatus isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        alertMessage = NSLocalizedString(@"DELETE MESSAGE FOREVER", nil);
    }
    else
    {
        alertMessage = NSLocalizedString(@"TRASH MESSAGE", nil);
    }
    [GeneralClass showAlertView:self
                            msg:alertMessage
                          title:nil
                    cancelTitle:@"Yes"
                     otherTitle:@"No"
                            tag:deleteMessageTag];
}

/*******************************************************************************
 *  Inbox and sent mail details will show and hide
 ********************************************************************************/
- (IBAction)inboxDetailsBtnTouched:(id)sender
{
    Inbox *inboxMsgType = [inboxManagerArr objectAtIndex:swipeCount];
    //hide the details view
    if(!showDetailsFlag)
    {
        showDetailsFlag = 1;
        [inboxDetailsbtn setTitle:@"Details" forState:UIControlStateNormal];
        
        //SentMail View
        if (([inboxMsgType.messageType intValue] ==0) || (([inboxMsgType.messageType intValue] ==3) && ([inboxMsgType.deleteFrom intValue] ==0)))
        {
            [self sentMessageView];
        }
        //InboxMail View
        else if (([inboxMsgType.messageType intValue]==1) || (([inboxMsgType.messageType intValue] ==3) && ([inboxMsgType.deleteFrom intValue] ==1)))
        {
            [self inboxMessageView];
        }
    }
    //show the details view
    else
    {
        showDetailsFlag = 0;
        [inboxDetailsbtn setTitle:@"Hide Details" forState:UIControlStateNormal];
        
        NSLog(@"i === %@",inboxMsgType);
        //detailed view of sentmail
        if (([inboxMsgType.messageType intValue] ==0) || (([inboxMsgType.messageType intValue] ==3) && ([inboxMsgType.deleteFrom intValue] ==0)))
        {
            [self sentMessageView];
        }
        //detailed view of inbox
        else if (([inboxMsgType.messageType intValue] ==1) || (([inboxMsgType.messageType intValue] ==3) && ([inboxMsgType.deleteFrom intValue] ==1)))
        {
            [self inboxMessageView];
        }
        
    }
}

/*******************************************************************************
 *  Reply To a particular Message.
 ********************************************************************************/
- (IBAction)replyButtonTouched:(id)sender
{
    [self performNavigationToCompose:replayID];
}

/*******************************************************************************
 *  ReplyAll To a particular Message.
 ********************************************************************************/
- (IBAction)replyAllButtonTouched:(id)sender
{
    [self performNavigationToCompose:replayAllID];
}

/*******************************************************************************
 *  Forward To a particular Message.
 ********************************************************************************/
- (IBAction)forwardButtonTouched:(id)sender
{
    [self performNavigationToCompose:forwordID];
}

#pragma mark- Compose view Navigation
/*******************************************************************************
 *  Function Name:performNavigationToCompose.
 *  Purpose: To show replay,replayAll,forward message details.
 *  Parametrs: 1 for replay,2 for replayAll and 3 for forward message as integer.
 *  Return Values:nil
 ********************************************************************************/
-(void) performNavigationToCompose:(int)navigateFlag
{
    SendMessageViewController *sendMessageViewController=[[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 20, 80);
    [UIView beginAnimations:@"ripple" context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationTransition:UIViewAnimationOptionRepeat
                           forView:self.view
                             cache:NO];
    sendMessageViewController.view.alpha = 1;
    sendMessageViewController.view.frame = CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+10, self.view.frame.size.width-20, self.view.frame.size.height-20);
    if([inboxManagerArr count] > 0)
        [sendMessageViewController beginWithReplyAction:navigateFlag inbox: [inboxManagerArr objectAtIndex:swipeCount]];
    [self.navigationController pushViewController:sendMessageViewController animated:YES];
    [UIView commitAnimations];
    sendMessageViewController = nil;
}

#pragma mark- UITextView delegates
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    
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
        if( eparseType == ReadMessageAPI)
        {
            [syncView removeFromSuperview];
            Inbox *inbox = [inboxManagerArr objectAtIndex:swipeCount];
            
            NSString *readmessageType = [result valueForKey:@"MessageType"];
            if([readmessageType isEqualToString:@"0"])
            {
                NSString *routeDetails = [result valueForKey:@"Route"];
                NSString *coverageDetails = [result valueForKey:@"coverage"];
                NSString * alertDetails = [result valueForKey:@"Alert"];
                NSLog(@"alertdetails==%@",alertDetails);
                inbox.alert = alertDetails;
                inbox.coverage = coverageDetails;
                inbox.route = routeDetails;
                [DataManager saveContext];
                [self checkingMessageDetails:inbox];
            }
            else if([readmessageType isEqualToString:@"1"])
            {
                inbox.readStatus = [NSNumber numberWithInt:1];
                
                [DataManager saveContext];
                
            }
            
        }
        else if(eparseType == DeleteMsgAPI)
        {
            [syncView removeFromSuperview];
            
            Inbox *inbox = [inboxManagerArr objectAtIndex:swipeCount];
            BOOL isDelete = [DataManager deleteMangedObject:inbox];
            if (isDelete)
            {
                [DataManager saveContext];
                [GeneralClass showAlertView:self
                                        msg:@"Message successfully deleted"
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
    if(eparseType == DeleteMsgAPI)
    {
        [GeneralClass showAlertView:self
                                msg:nil
                              title:@"Parse with error. Try again?"
                        cancelTitle:@"YES"
                         otherTitle:@"NO"
                                tag:parseErrorTag];
        errorParseType = eparseType;
    }
    else if (eparseType == ReadMessageAPI)
    {
        [syncView removeFromSuperview];
    }
}
-(void)parseWithInvalidMessage:(NSArray *)result
{
    errorParseType = [[result valueForKey:@"operationType"] integerValue];
    if(errorParseType == DeleteMsgAPI)
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
        }
        else
        {
            [self parseFailedWithError:0 :nil :0];
        }
    }
    else if (errorParseType == ReadMessageAPI)
    {
        [syncView removeFromSuperview];
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


#pragma mark- UIAlertView delegate
/*******************************************************************************
 *  UIAlertView delegate.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    Inbox *inbox = [inboxManagerArr objectAtIndex:swipeCount];
    
    if(alertView.tag == deleteMessageTag)
    {
        if (buttonIndex == 0)
        {
            if([inboxManagerArr count] > 0)
            {
                [self deleteMessageStatus:inbox];
            }
            else
            {
                alertView = nil;
            }
        }
        else
        {
            alertView = nil;
        }
    }
    else if(alertView.tag == parseErrorTag)
    {
        if (errorParseType == DeleteMsgAPI)
        {
            if(buttonIndex == 0)
            {
                [self deleteMessageStatus:inbox];
            }
            else
            {
                [syncView removeFromSuperview];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
    }
    else if(alertView.tag == reachabilityTag)
    {
        NSLog(@"No network");
        [syncView removeFromSuperview];
    }
    else if (alertView.tag == parseSuccessfullAPITag)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    alertView = nil;
}

#pragma mark- Go Back
/*******************************************************************************
 *  Backbutton touch action.
 ********************************************************************************/
-(IBAction)backButtonTouhed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Unload
- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)dealloc
{
    
    NSLog(@"Inside Inbox details dealloc");
    [self setInboxDetailedToLabelContent:nil];
    [self setInboxDetailedCcLabelContent:nil];
    [self setInboxHideFromLabelContent:nil];
    [self setInboxDetailedFromLabelContent:nil];
    [self setInboxHidePatientLabelContent:nil];
    [self setInboxDetailedPatientLabelContent:nil];
    [self setInboxHideSubjectLabelContent:nil];
    [self setInboxDetailedSubjectLabelContent:nil];
    [self setMessageBodyTextView:nil];
    [self setInboxManagerArr:nil];
    [self setSentHideToLabelContent:nil];
    [self setSentDetailedToLabelContent:nil];
    [self setSentHideSubjectLabelContent:nil];
    [self setSentDetailedSubjectLabelContent:nil];
    [self setSentDetailedRouteLabelContent:nil];
    [self setSentDetailedPatientLabelContent:nil];
    [self setSentHideDateContentLabel:nil];
    [self setSentDetailedDateContentLabel:nil];
    [self setSentDetailedCoverageLabelContent:nil];
    [self setSentDetailedAlertLabelContent:nil];
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
