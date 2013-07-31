//
//  ProfileViewController.m
//  Profile
//
//  Created by Amal T on 13/09/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "ProfileViewController.h"
#import "SendMessageViewController.h"
#import "StartDiscussionViewController.h"
#import "DataManager.h"
#import "GeneralClass.h"
@interface ProfileViewController ()
{
    DataManager *dataManager;
}

@property (weak, nonatomic)IBOutlet UILabel *profileTitleLbl;
@property (weak, nonatomic)IBOutlet UIButton *backBtn;
@property (weak, nonatomic)IBOutlet UILabel *nameLbl;
@property (weak, nonatomic)IBOutlet UILabel *degreeNameLbl;
@property (weak, nonatomic)IBOutlet UILabel *specialityNameLbl;
@property (weak, nonatomic)IBOutlet UILabel *addressLbl;
@property (weak, nonatomic)IBOutlet UILabel *connecticutMedicalGrupTitleLbl;
@property (weak, nonatomic)IBOutlet UILabel *streetAddressLbl;
@property (weak, nonatomic)IBOutlet UILabel *cityAddressLbl;
@property (weak, nonatomic)IBOutlet UILabel *phoneNumberLbl;
@property (weak, nonatomic)IBOutlet UILabel *faxNumberLbl;
@property (weak, nonatomic)IBOutlet UILabel *hospitalTitleLbl;
@property (weak, nonatomic)IBOutlet UILabel *hospitalNameLbl;
@property (weak, nonatomic)IBOutlet UILabel *statusTitleLbl;
@property (weak, nonatomic)IBOutlet UILabel *statusFaxLbl;
@property (weak, nonatomic)IBOutlet UILabel *statusInboxLbl;
@property (weak, nonatomic)IBOutlet UILabel *communicationPreferanceTitleLbl;
@property (weak, nonatomic)IBOutlet UILabel *statusCoverageLbl;
@property (weak, nonatomic) IBOutlet UIImageView *faxTickImgView;
@property (weak, nonatomic) IBOutlet UIImageView *inboxtickImgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverageTickImgView;
@property (weak, nonatomic) IBOutlet UITextView *communicationPreferenceTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *profielImage;

-(void)fetchMyprofileValue:(MyProfile*)myprofile;
- (void)fontCustomization;
- (void)customizeCommunicationPrefTexrView;
- (IBAction)backButtonTouched:(id)sender;
- (IBAction)callButtonTouched:(id)sender;
- (IBAction)sendMsgButtonTouched:(id)sender;
- (IBAction)startDiscussionButtonTouched:(id)sender;

@end

@implementation ProfileViewController
@synthesize faxTickImgView;
@synthesize inboxtickImgView;
@synthesize coverageTickImgView;
@synthesize communicationPreferenceTextView;
@synthesize profileTitleLbl,nameLbl,degreeNameLbl;
@synthesize backBtn,specialityNameLbl;
@synthesize addressLbl,connecticutMedicalGrupTitleLbl,cityAddressLbl;
@synthesize streetAddressLbl,phoneNumberLbl,faxNumberLbl;
@synthesize hospitalTitleLbl,hospitalNameLbl;
@synthesize statusTitleLbl,statusFaxLbl,statusInboxLbl;
@synthesize communicationPreferanceTitleLbl;
@synthesize myProfile;
@synthesize statusCoverageLbl;
@synthesize profileScrollView;
@synthesize profielImage;
#pragma mark- Initial Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fontCustomization];
    self.communicationPreferenceTextView.editable = NO;
    self.navigationController.navigationBarHidden = YES;
    
    NSArray*profileDetails = [DataManager getWholeEntityDetails:MYPROFILE sortBy:@"userName"];
    NSLog(@"profileDetails===%@",profileDetails);
    if([profileDetails count])
    {
        self.myProfile = [profileDetails objectAtIndex:0];
        [self fetchMyprofileValue:self.myProfile];
        [self customizeCommunicationPrefTexrView];
    }
    else
    {
        NSLog(@"No profile count");
    }
    
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values:nil
 ********************************************************************************/
- (void)fontCustomization
{
    backBtn.titleLabel.font =[GeneralClass getFont: buttonFont and:regularFont];
    profileTitleLbl.font = [GeneralClass getFont: titleFont and:boldFont];
    nameLbl.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    nameLbl.font = [GeneralClass getFont: nameFont and:boldFont];
    specialityNameLbl.font =[GeneralClass getFont: buttonFont and:regularFont];
    addressLbl.font =[GeneralClass getFont: buttonFont and:regularFont];
    connecticutMedicalGrupTitleLbl.font = [GeneralClass getFont:  customRegular and:regularFont];
    cityAddressLbl.font =[GeneralClass getFont: customNormal and:regularFont];
    streetAddressLbl.font =[GeneralClass getFont: customNormal and:regularFont];
    phoneNumberLbl.font =[GeneralClass getFont: customNormal and:regularFont];
    faxNumberLbl.font =[GeneralClass getFont: customNormal and:regularFont];
    hospitalTitleLbl.font =[GeneralClass getFont:  customRegular and:regularFont];
    hospitalNameLbl.font =[GeneralClass getFont: customNormal and:regularFont];
    statusTitleLbl.font = [GeneralClass getFont:  customRegular and:regularFont];
    statusFaxLbl.font = [GeneralClass getFont: customRegular and:regularFont];
    statusInboxLbl.font = [GeneralClass getFont: customRegular and:regularFont];
    statusCoverageLbl.font = [GeneralClass getFont: customRegular and:regularFont];
    communicationPreferanceTitleLbl.font = [GeneralClass getFont:titleFont and:regularFont];
    
}
/*******************************************************************************
 *  Function Name: customizeCommunicationPrefTexrView.
 *  Purpose: To set height of Textview to its size of content.
 *  Parametrs: nil.
 *  Return Values:nil
 ********************************************************************************/
- (void)customizeCommunicationPrefTexrView
{
    int customTextViewHeight = 0;
    int customScrollViewHeight = 0;
    CGSize constraintSize = CGSizeMake(communicationPreferenceTextView.frame.size.width, communicationPreferenceTextView.contentSize.height);
    
    NSString * text = communicationPreferenceTextView.text;
    //    if ([text isEqualToString:@"No Faxmessage"])
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
    
    profileScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+communicationPreferenceTextView.contentSize.height+customScrollViewHeight);
}
#pragma mark- DataBase Insertion
/*******************************************************************************
 *  Function Name: fetchMyprofileValue.
 *  Purpose: To set values of myprofile view.
 *  Parametrs: myprofile object.
 *  Return Values:nil
 ********************************************************************************/
-(void)fetchMyprofileValue:(MyProfile*)myprofile
{
    NSNumber *myprofilePhysicianId;
    NSString * imageURL;
    NSString *imgName;
    NSString * physicianName = myprofile.userName;
    physicianName = [physicianName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"physicianName==%@",physicianName);
    
    Directory * directoryObject = [DataManager fetchDirectoryObjectsForEntity:@"Directory" selectByName:physicianName];
    
    NSLog(@"directoryObject.physicianName==%@",directoryObject.physicianName);
    NSLog(@"directoryObject.physicianId==%@",directoryObject.physicianId);
    
    if(directoryObject.physicianId){
        myprofilePhysicianId = directoryObject.physicianId;
    }
    imgName = [NSString stringWithFormat:@"%@_%@.jpg",myprofile.userName,[myprofilePhysicianId stringValue]];
    
    BOOL imgExist = [self existImage:imgName];
    if(imgExist)
    {
        NSString *path = [self getPathDocAppendedBy:imgName];
        UIImage *img=[UIImage imageWithContentsOfFile:path];
        NSLog(@"img == %@",img);
        profielImage.image=img;
    }
    else
    {
        imageURL = myprofile.imagepath;
        if([imageURL length])
        {
            NSArray * arrayOfThingsIWantToPassAlong = [NSArray arrayWithObjects:imageURL,imgName, nil];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [paths objectAtIndex:0];
            NSString *dataPath = [cachePath stringByAppendingPathComponent:@"IMAGES"];
            BOOL isDir = NO;
            NSError *error;
            if (! [[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDir] && isDir == NO)
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
            }
            
            cachePath =  [dataPath stringByAppendingPathComponent:imgName];
            
            NSURL *imageURL = [NSURL URLWithString:[arrayOfThingsIWantToPassAlong objectAtIndex:0]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            [imageData writeToFile:cachePath atomically:YES];
            
            BOOL imgExist = [self existImage:imgName];
            if(imgExist)
            {
                NSString *path = [self getPathDocAppendedBy:imgName];
                UIImage *img=[UIImage imageWithContentsOfFile:path];
                NSLog(@"img == %@",img);
                profielImage.image=img;
            }
        }
    }
    [profielImage setContentMode:UIViewContentModeScaleAspectFit];
    
    nameLbl.text = self.myProfile.userName;
    specialityNameLbl.text = self.myProfile.speciality;
    NSArray *contactInformation = [self.myProfile.contactInfo componentsSeparatedByString:@","];
    NSLog(@"contactInformation==%@",contactInformation);
    if([contactInformation count])
    {
        int contactInfoCount = [contactInformation count];
        for (int i=0; i<contactInfoCount; i++)
        {
            switch (i)
            {
                case 0:
                    streetAddressLbl.text = [contactInformation objectAtIndex:0];
                    break;
                case 1:
                    cityAddressLbl.text = [contactInformation objectAtIndex:1];
                    break;
                case 2:
                    phoneNumberLbl.text = [contactInformation objectAtIndex:2];
                    break;
                case 3:
                    faxNumberLbl.text = [contactInformation objectAtIndex:3];
                    break;
                    
                default:
                    break;
            }
        }
        
        addressLbl.text = cityAddressLbl.text;
    }
    else
    {
        
    }
    hospitalNameLbl.text = self.myProfile.hospital;
    NSLog(@"hospitalNameLbl.text==%@", hospitalNameLbl.text);
    communicationPreferenceTextView.text = self.myProfile.communicationPreference;
    if ([communicationPreferenceTextView.text isEqualToString:@""])
    {
        communicationPreferenceTextView.text = @"";//[NSString stringWithFormat:@"No Faxmessage"];
        NSLog(@"communicationPreferenceTextView.text==%@",communicationPreferenceTextView.text);
    }
    UIImage *activeIcon = [UIImage imageNamed:@"active_icon"];
    //    UIImage *inactiveIcon = [UIImage imageNamed:@"inactive_icon"];
    
    if([self.myProfile.inboxStatus isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [inboxtickImgView setImage:activeIcon];
    }
    else
    {
        //        [inboxtickImgView setImage:inactiveIcon];
        [inboxtickImgView setBackgroundColor:[UIColor clearColor]];
    }
    if([self.myProfile.faxStatus isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [faxTickImgView setImage:activeIcon];
    }
    else
    {
        //        [faxTickImgView setImage:inactiveIcon];
        [faxTickImgView setBackgroundColor:[UIColor clearColor]];
    }
    if([self.myProfile.coverageStatus isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [coverageTickImgView setImage:activeIcon];
    }
    else
    {
        //        [coverageTickImgView setImage:inactiveIcon];
        [coverageTickImgView setBackgroundColor:[UIColor clearColor]];
    }
    
    
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
#pragma mark- Button Actions
/*******************************************************************************
 *  Back button touch action.
 ********************************************************************************/
- (IBAction)backButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************
 *  To make a phone call.
 ********************************************************************************/
- (IBAction)callButtonTouched:(id)sender
{
    NSString *deviceType = [UIDevice currentDevice].model;
    NSLog(@"Device Type===%@",deviceType);
    if([deviceType isEqualToString:@"iPhone"]||[deviceType isEqualToString:@"iPad"] )
    {
        NSString * phoneNumber = phoneNumberLbl.text;
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(P)"
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

/*******************************************************************************
 *  Will navigate to send message view.
 ********************************************************************************/
- (IBAction)sendMsgButtonTouched:(id)sender
{
    SendMessageViewController *detailViewController=[[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController"
                                                                                                bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
    
}

/*******************************************************************************
 *  Will navigate to startDiscussion view.
 ********************************************************************************/
- (IBAction)startDiscussionButtonTouched:(id)sender
{
    StartDiscussionViewController *detailViewController=[[StartDiscussionViewController alloc] initWithNibName:@"StartDiscussionViewController"
                                                                                                        bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
    
}


#pragma mark- Unload
- (void)viewDidUnload
{
    [self setFaxTickImgView:nil];
    [self setInboxtickImgView:nil];
    [self setCoverageTickImgView:nil];
    [self setCommunicationPreferenceTextView:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [self setProfileTitleLbl:nil];
    [self setBackBtn:nil];
    [self setNameLbl:nil];
    [self setDegreeNameLbl:nil];
    [self setSpecialityNameLbl:nil];
    [self setAddressLbl:nil];
    [self setConnecticutMedicalGrupTitleLbl:nil];
    [self setCityAddressLbl:nil];
    [self setStreetAddressLbl:nil];
    [self setPhoneNumberLbl:nil];
    [self setFaxNumberLbl:nil];
    [self setHospitalTitleLbl:nil];
    [self setHospitalNameLbl:nil];
    [self setStatusTitleLbl:nil];
    [self setStatusFaxLbl:nil];
    [self setStatusInboxLbl:nil];
    [self setCommunicationPreferanceTitleLbl:nil];
}

#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
