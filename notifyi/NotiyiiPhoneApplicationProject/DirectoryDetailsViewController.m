//
//  DirectoryDetailsViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectoryDetailsViewController.h"
#import "SendMessageViewController.h"
#import "StartDiscussionViewController.h"
#import "GeneralClass.h"
@interface DirectoryDetailsViewController ()
{
    IBOutlet UILabel *directoryLabel;
    NSNumber *currentPhysicianId;
}
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *communicationPrefLbl;
@property (weak, nonatomic) IBOutlet UILabel *practiceDetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *specialityDetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneDetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UIImageView *directoryImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *directoryScrollView;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *faxLabel;
@property (weak, nonatomic) IBOutlet UILabel *inboxLabel;
@property (weak, nonatomic) IBOutlet UILabel *coverageLabel;
@property (weak, nonatomic) IBOutlet UILabel *connecticutMedicalGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetAddressLabel;
@property (weak, nonatomic) IBOutlet UITextView *communicationPreferenceTextView;
@property (weak, nonatomic) IBOutlet UIImageView *faxStatusImage;
@property (weak, nonatomic) IBOutlet UIImageView *inboxStatusImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverageStatusImage;
@property (strong, nonatomic) Directory *directory;
@property (weak, nonatomic) IBOutlet UILabel *faxDetailsLbl;

- (IBAction)directoryComposeMailBtnTouched:(id)sender;
- (IBAction)startDiscussionBtnTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;
- (IBAction)callButtonTouched:(id)sender;
- (void)fontCustomization;
- (void)setValuesInView:(Directory *)directoryObj;
- (void)customizeTextView;

@end

@implementation DirectoryDetailsViewController
@synthesize backButton;
@synthesize communicationPrefLbl;
@synthesize practiceDetailsLbl;
@synthesize specialityDetailsLbl;
@synthesize phoneDetailsLbl;
@synthesize nameLabl;
@synthesize cityLbl;
@synthesize directoryImageView;
@synthesize directoryManagerArr;
@synthesize selectedDirectoryNumber;
@synthesize directory;
@synthesize faxDetailsLbl;
@synthesize directoryScrollView;
@synthesize statusLabel,hospitalLabel,connecticutMedicalGroupLabel;
@synthesize coverageLabel,faxLabel,inboxLabel,hospitalContentLabel;
@synthesize cityAddressLabel,streetAddressLabel;
@synthesize communicationPreferenceTextView;
@synthesize faxStatusImage;
@synthesize inboxStatusImage;
@synthesize coverageStatusImage;

#pragma mark- Initial Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fontCustomization];


    if([directoryManagerArr count] > 0)
    {
        directory = [directoryManagerArr objectAtIndex:selectedDirectoryNumber];
        currentPhysicianId = directory.physicianId;
        [self setValuesInView:[directoryManagerArr objectAtIndex:selectedDirectoryNumber]];
    }
    [self customizeTextView];
}

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
- (void)fontCustomization
{
    directoryLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    backButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    communicationPrefLbl.font = [GeneralClass getFont:titleFont and:regularFont];
    practiceDetailsLbl.font = [GeneralClass getFont:buttonFont and:regularFont];
    specialityDetailsLbl.font = [GeneralClass getFont:buttonFont and:regularFont];
    phoneDetailsLbl.font = [GeneralClass getFont:customNormal and:regularFont];
    faxDetailsLbl.font = [GeneralClass getFont:customNormal and:regularFont];
    nameLabl.font = [GeneralClass getFont:nameFont and:boldFont];
    nameLabl.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    cityLbl.font = [GeneralClass getFont:buttonFont and:regularFont];
    connecticutMedicalGroupLabel.font = [GeneralClass getFont: customRegular and:regularFont];
    cityAddressLabel.font =[GeneralClass getFont: customNormal and:regularFont];
    streetAddressLabel.font =[GeneralClass getFont: customNormal and:regularFont];
    hospitalLabel.font = [GeneralClass getFont: customRegular and:regularFont];
    statusLabel.font = [GeneralClass getFont: customRegular and:regularFont];
    faxLabel.font = [GeneralClass getFont: customRegular and:regularFont];
    inboxLabel.font = [GeneralClass getFont: customRegular and:regularFont];
    coverageLabel.font = [GeneralClass getFont: customRegular and:regularFont];
    hospitalContentLabel.font = [GeneralClass getFont: customNormal and:regularFont];

}

/*******************************************************************************
 *  Function Name: setValuesInView.
 *  Purpose: To Set Values to the textView/textField from database.
 *  Parametrs: directory Object.
 *  Return Values: nil
 ********************************************************************************/
-(void) setValuesInView:(Directory *)directoryObj
{
    NSLog(@"currentPhysicianId === %@",currentPhysicianId);
    NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg",directoryObj.physicianName,directoryObj.physicianId];
    BOOL imgExist = [self existImage:imgName];
    if(imgExist)
    {
        NSString *path = [self getPathDocAppendedBy:imgName];
        UIImage *img=[UIImage imageWithContentsOfFile:path];
        NSLog(@"img == %@",img);
        directoryImageView.image=img;
    }
    [directoryImageView setContentMode:UIViewContentModeScaleAspectFit];
    nameLabl.text = directoryObj.physicianName;
    
    if([directoryObj.city isEqualToString:@""] && [directoryObj.state isEqualToString:@""])
    {
        cityLbl.text = @"";
    }
    else if ([directoryObj.city isEqualToString:@""] && ![directoryObj.state isEqualToString:@""])
    {
        cityLbl.text = [NSString stringWithFormat:@"%@",directoryObj.city];
    }
    else if (![directoryObj.city isEqualToString:@""] && [directoryObj.state isEqualToString:@""])
    {
        cityLbl.text = [NSString stringWithFormat:@"%@",directoryObj.state];
    }
    else
    {
         cityLbl.text = [NSString stringWithFormat:@"%@, %@",directoryObj.city,directoryObj.state];
    }
    
    specialityDetailsLbl.text = directoryObj.speciality;
    phoneDetailsLbl.text = [NSString stringWithFormat:@"(P) %@",directoryObj.phone];
    faxDetailsLbl.text = [NSString stringWithFormat:@"(F) %@",directoryObj.faxNumber];
    practiceDetailsLbl.text = directoryObj.practice;
    streetAddressLabel.text = directoryObj.contactInfo;
    cityAddressLabel.text = cityLbl.text;
    hospitalContentLabel.text = directoryObj.hospitalName;
    communicationPreferenceTextView.text = directoryObj.communicationPreference;
    if ([communicationPreferenceTextView.text isEqualToString:@""])
    {
        communicationPreferenceTextView.text = @"" ;//[NSString stringWithFormat:@"No Faxmessage"];
    }
    UIImage *activeIcon = [UIImage imageNamed:@"active_icon"];
    if([directoryObj.inboxStatus isEqualToNumber:[NSNumber numberWithInt:1]])
    {
      [inboxStatusImage setImage:activeIcon];
    }
    else
    {
        [inboxStatusImage setBackgroundColor:[UIColor clearColor]]; 
    }
    if([directoryObj.faxStatus isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [faxStatusImage setImage:activeIcon];
    }
    else
    {
        [faxStatusImage setBackgroundColor:[UIColor clearColor]];

    }
    if([directoryObj.coverageStatus isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [coverageStatusImage setImage:activeIcon];
    }
    else
    {
        [coverageStatusImage setBackgroundColor:[UIColor clearColor]];
    }
    NSLog(@"currentPhysicianId === %@",currentPhysicianId);
}

/*******************************************************************************
 *  Function Name: existImage.
 *  Purpose: To check image is exixsting in Cache??.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
-(BOOL)existImage:(NSString *)name
{
    NSString *path = [self getPathDocAppendedBy:name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return fileExists;
}

/*******************************************************************************
 *  Function Name: getPathDocAppendedBy.
 *  Purpose: To Get the Cache path.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
-(NSString *)getPathDocAppendedBy:(NSString *)_appString
{
	NSString* documentsPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"IMAGES"];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:_appString];
	return foofile;
}

/*******************************************************************************
 *  Function Name: customizeTextView.
 *  Purpose: To customize text view to the content size.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
- (void)customizeTextView
{
    int customTextViewHeight = 0;
    int customScrollViewHeight = 0;

    communicationPreferenceTextView.editable = NO;
    NSLog(@"DirectoryDetails");
    
    CGSize constraintSize = CGSizeMake(communicationPreferenceTextView.frame.size.width, communicationPreferenceTextView.contentSize.height);
    
    NSString * text = communicationPreferenceTextView.text;
    
   // if ([text isEqualToString:@"No Faxmessage"])
    if ([text isEqualToString:@""])
    {
        customTextViewHeight = 105;
    }
    else
    {
        customTextViewHeight = 90;
    }
    text = [text stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if([text stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding])
    {
        text = [text stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    }
    
    // Note that in the below line you must use the font as exact as you use for textview
    
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize: 16] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    NSString *size = NSStringFromCGSize(labelSize);
    if([size isEqualToString:@"{0, 0}"])
    {
        customScrollViewHeight = 90;
    }
    else
    {
        customScrollViewHeight = 70;
    }
    communicationPreferenceTextView.frame = CGRectMake(communicationPreferenceTextView.frame.origin.x,communicationPreferenceTextView.frame.origin.y,communicationPreferenceTextView.frame.size.width,labelSize.height + customTextViewHeight);
    
    directoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+communicationPreferenceTextView.contentSize.height+customScrollViewHeight);
}

#pragma mark- Button Actions
/*******************************************************************************
 *  Start compose mail to the selected physician
 ********************************************************************************/
- (IBAction)directoryComposeMailBtnTouched:(id)sender
{
    SendMessageViewController *sendMessageViewController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController"
                                                                                                       bundle:nil];
    NSLog(@"currentPhysicianId === %@",currentPhysicianId);
    sendMessageViewController.selectedPhysicianId = currentPhysicianId;
    [self.navigationController pushViewController:sendMessageViewController animated:YES];
    sendMessageViewController = nil;
}

/*******************************************************************************
 *  To start a new discussion with the selected physician.
 ********************************************************************************/
- (IBAction)startDiscussionBtnTouched:(id)sender
{
    StartDiscussionViewController *startDiscussionViewController = [[StartDiscussionViewController alloc] initWithNibName:@"StartDiscussionViewController"
                                                                                                                   bundle:nil];
    startDiscussionViewController.selectedPhysicianId = currentPhysicianId;
    [self.navigationController pushViewController:startDiscussionViewController animated:YES];
    startDiscussionViewController = nil;
}

/*******************************************************************************
 *  Back button touch action.
 ********************************************************************************/
-(IBAction)backButtonTouched:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************
 *  To make a call to the selected physician.
 ********************************************************************************/
- (IBAction)callButtonTouched:(id)sender {
    NSString *deviceType = [UIDevice currentDevice].model;
    NSLog(@"Device Type===%@",deviceType);

    if([deviceType isEqualToString:@"iPhone"]||[deviceType isEqualToString:@"iPad"] )
    {
        NSString * phoneNumber = phoneDetailsLbl.text;
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(P) "
                                                             withString:@""];
        NSLog(@"phoneNumber==%@",phoneNumber);
        NSString *phoneNo = [NSString stringWithFormat:@"telprompt:%@",phoneNumber];
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:phoneNo]];
    }
    else {
        //iPod Touch and iPhone simulator
        [GeneralClass showAlertView:nil
                                 msg:@"Device not supported"
                               title:nil
                         cancelTitle:@"OK"
                          otherTitle:nil
                                 tag:noTag];
    }
}
#pragma mark- Unload
- (void)viewDidUnload
{
    [self setCommunicationPrefLbl:nil];
    [self setPracticeDetailsLbl:nil];
    [self setSpecialityDetailsLbl:nil];
    [self setPhoneDetailsLbl:nil];
    [self setCityLbl:nil];
    [self setBackButton:nil];
    [self setDirectoryImageView:nil];
    [self setFaxStatusImage:nil];
    [self setInboxStatusImage:nil];
    [self setCoverageStatusImage:nil];
    [self setFaxDetailsLbl:nil];
    [super viewDidUnload];
}
#pragma mark-Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
