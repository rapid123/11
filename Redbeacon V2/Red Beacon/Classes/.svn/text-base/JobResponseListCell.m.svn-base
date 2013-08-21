//
//  JobResponseListCell.m
//  Red Beacon
//
//  Created by Nithin George on 03/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobResponseListCell.h"
#import "RBAsyncImage.h"

@interface JobResponseListCell (Private)

-(NSString *)checkDisplayText:(JobResponseDetails *)jobResponse;
- (NSString *)getScheduledText:(JobResponseDetails *)jobResponse;
- (NSString *)getDesciptionText:(JobResponseDetails *)jobResponse;
-(void)showDefaultImage ;

@end

@implementation JobResponseListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
        backGroundView.backgroundColor=[UIColor whiteColor];
        [self addSubview:backGroundView];
        [backGroundView release];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self showDefaultImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//===========Job Response ListView========================

#define DEFAULT_LOCATION_IMAGE_NAME @"locationThumbImage.png"

#define LISTVIEW_COL_COUNT 1

#define LISTVIEW_SECTION_X 10
#define LISTVIEW_SECTION_Y 12
#define LISTVIEW_SECTION_SPACE 10
#define LISTVIEW_SECTION_WIDTH 50
#define LISTVIEW_SECTION_HEIGHT 50

//Header Label
#define LISTVIEW_SECTION_HEADERLABLEL_X 70
#define LISTVIEW_SECTION_HEADERLABLEL_Y 13
#define LISTVIEW_SECTION_HEADERLABLEL_WIDTH 175
#define LISTVIEW_SECTION_HEADERLABLEL_HEIGHT 25

// Date Label
#define LISTVIEW_SECTION_DATELABLEL_X 210
#define LISTVIEW_SECTION_DATELABLEL_Y 5
#define LISTVIEW_SECTION_DATELABLEL_WIDTH 100
#define LISTVIEW_SECTION_DATELABLEL_HEIGHT 18

// Subtitle Label
#define SUBTITLE_LABLEL_X 70
#define SUBTITLE_LABLEL_Y 38
#define SUBTITLE_WIDTH 230
#define SUBTITLE_HEIGHT 20

//Detail Label
#define LISTVIEW_SECTION_DETAILLABLEL_X 15
#define LISTVIEW_SECTION_DETAILLABLEL_Y 63
#define LISTVIEW_SECTION_DETAILLABLEL_WIDTH 235
#define LISTVIEW_SECTION_DETAILLABLEL_HEIGHT 20

//Job Request Text Details
#define LISTVIEW_REQ_TEXT_X 10
#define LISTVIEW_REQ_TEXT_Y 40
#define LISTVIEW_REQ_TEXT_WIDTH 175
#define LISTVIEW_REQ_TEXT_HEIGHT 62

//Job Request Location Details
#define LISTVIEW_REQ_LOCATION_IMAGE_X 265
#define LISTVIEW_REQ_LOCATION_IMAGE_Y 69
#define LISTVIEW_REQ_LOCATION_IMAGE_WIDTH 10
#define LISTVIEW_REQ_LOCATION_IMAGE_HEIGHT 10

//Job Request Location ID
#define LISTVIEW_REQ_LOCATION_TEXT_X 275
#define LISTVIEW_REQ_LOCATION_TEXT_Y 67
#define LISTVIEW_REQ_LOCATION_TEXT_WIDTH 35
#define LISTVIEW_REQ_LOCATION_TEXT_HEIGHT 15

//Job Request Schedule Details
#define LISTVIEW_REQ_SCHEDULE_X 15
#define LISTVIEW_REQ_SCHEDULE_Y 80
#define LISTVIEW_REQ_SCHEDULE_W 200
#define LISTVIEW_REQ_SCHEDULE_H 20

#define SCHEDULE_APPOINTMENT_NIL_TIME_DISPLAY_TEXT @"Appointment not set yet" 
#define SCHEDULE_APPOINTMENT_TIME_DISPLAY_TEXT @"Please confirm appointment" 

#define SCHEDULE_URGENT_TEXT @"Urgent Schedule"
#define SCHEDULE_FLEXIBLE_TEXT @"Flexible Schedule"
 
#define NEW_DISPLAY_TEXT_WITH_ONE_QUOTES    @"quote received"
#define NEW_DISPLAY_TEXT_WITH_MORETHAN_ONE_QUOTES    @"quotes received"
#define NEW_DISPLAY_TEXT_WITHOUT_QUOTES @"Getting quotes..."
#define DONE_DISPLAY_TEXT               @"Completed on"
#define UNSERVICED_AREA @"Sorry, no service in"

#define JOB_CANCELLED_MESSAGE @"Job cancelled by consumer"
#define JOB_REVIEWED_MESSAGE @"Reviewed job"
#define JOB_EXPIRED_MESSAGE @"Expired job"

#define ASYNC_IMAGE_TAG 9999
#define DEFAULT_IMAGE_TAG 888

-(NSString *)checkForThumbnails:(JobResponseDetails *)jobResponse {
    
    NSString *urlString=@"";
    NSArray *documents = jobResponse.jobDocuments;
    for (int i=0; i<[documents count]; i++) {

        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"video"]) {
            urlString=jobdocument.thumbnailUrl;
            if([urlString isKindOfClass:[NSNull class]])
                urlString=jobdocument.urlOfImage;
            jobResponse.hasVideo = YES;
            break;
        }
    }
    if ([urlString isEqualToString:@""]) {
        NSArray *jobImages = jobResponse.jobImages;
        if([jobImages count]>0){
            JobImages *jobImage=[jobImages objectAtIndex:0];
            urlString=jobImage.thumbnailUrl;
            if(![urlString isKindOfClass:[NSNull class]])
                urlString=jobImage.urlOfImage;
        }
        else
            urlString = nil;
    }
    return urlString;
}


-(void)showImageFromURL:(JobResponseDetails *)jobResponse {
    
    RBAsyncImage * asyncImageView = (RBAsyncImage *)[self viewWithTag:ASYNC_IMAGE_TAG];
    if(!asyncImageView){
        asyncImageView = [[RBAsyncImage alloc] init];
        asyncImageView.tag=ASYNC_IMAGE_TAG;
        asyncImageView.frame=CGRectMake(3 , 2 , 44 , 47 );
        
        UIImageView *defaultImageView = (UIImageView * )[self viewWithTag:DEFAULT_IMAGE_TAG];
        [defaultImageView addSubview:asyncImageView]; 
        
    }
        
    if (!jobResponse.jobIcon)
    {
        NSString *thumbnailUrl = [self checkForThumbnails:jobResponse];
        if (!([thumbnailUrl isKindOfClass:[NSNull class]] )) {
            if(thumbnailUrl) {
                NSString *urlpath=thumbnailUrl;
                NSURL *url = [[NSURL alloc] initWithString:urlpath];
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [asyncImageView setJobResponseDetail:jobResponse];
                [url release];
                url = nil;
            }
        }
        else
            NSLog(@"NULL VALUE");
    }
    else
    {
        [asyncImageView loadExistingImage:jobResponse.jobIcon];
        if([jobResponse isVideoDescriptionPresent]){
            [asyncImageView showVideoIcon];
        }
    }
    [asyncImageView release];
    asyncImageView = nil;
    
}


-(void)showDefaultImage {
    
    UIImageView *imageThumbnail=[[UIImageView alloc]init];
    imageThumbnail.frame=CGRectMake(LISTVIEW_SECTION_X, LISTVIEW_SECTION_Y, LISTVIEW_SECTION_WIDTH,LISTVIEW_SECTION_HEIGHT);
    imageThumbnail.backgroundColor=[UIColor clearColor];
    imageThumbnail.image=[UIImage imageNamed:DEFAULT_THUMBNAIL_IMAGE]; 
    [imageThumbnail setContentMode:UIViewContentModeScaleAspectFit];
    imageThumbnail.tag  = DEFAULT_IMAGE_TAG;
    [self addSubview:imageThumbnail];
    [imageThumbnail release];
    imageThumbnail=nil;
}

#pragma mark - Display list view

- (void)displayJobResponses:(JobResponseDetails *)jobResponse;
{
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0 , 109, 320, 1)];
    linelabel.backgroundColor = [UIColor lightGrayColor];
     [self addSubview:linelabel];
    [linelabel release];
    linelabel=nil;
    
    // Adds the ayncImageView
    if([jobResponse.jobType isEqualToString:SCHEDULE]) {  // its from schedule section
        
        UIImageView *defaultImage = (UIImageView *)[self viewWithTag:DEFAULT_IMAGE_TAG];
        defaultImage.image = [UIImage imageNamed:DEFAULT_THUMBNAIL_IMAGE_SCHEDULE];
    }
    else
        [self showImageFromURL:jobResponse];
      
    //List Heading
    UILabel *listHeading=[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_SECTION_HEADERLABLEL_X, LISTVIEW_SECTION_HEADERLABLEL_Y, LISTVIEW_SECTION_HEADERLABLEL_WIDTH, LISTVIEW_SECTION_HEADERLABLEL_HEIGHT)];
    listHeading.font=[UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    listHeading.textAlignment=UITextAlignmentLeft;
    listHeading.backgroundColor = [UIColor clearColor];
    listHeading.text= jobResponse.jobRequestName;
    [self addSubview:listHeading];
    [listHeading release];
    listHeading=nil;
    
    //List Date
    UILabel *listDate=[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_SECTION_DATELABLEL_X, LISTVIEW_SECTION_DATELABLEL_Y, LISTVIEW_SECTION_DATELABLEL_WIDTH, LISTVIEW_SECTION_DATELABLEL_HEIGHT)];
    listDate.font=[UIFont fontWithName:@"Helvetica-Bold" size:9.0];
    listDate.textAlignment=UITextAlignmentRight;
    listHeading.backgroundColor = [UIColor blueColor];
    listDate.text = jobResponse.time_begin_fuzzy;
    [self addSubview:listDate];
    [listDate release];
    listDate=nil;
    
    
    //Section listDescription
    UILabel *subTitle=[[UILabel alloc]initWithFrame:CGRectMake(SUBTITLE_LABLEL_X, SUBTITLE_LABLEL_Y,SUBTITLE_WIDTH, SUBTITLE_HEIGHT)];
    subTitle.font=[UIFont fontWithName:@"Helvetica" size:13.0];
    subTitle.textAlignment=UITextAlignmentLeft;
    subTitle.textColor = [UIColor blackColor];
    
//    if ([jobResponse.jobType isEqualToString:SCHEDULE])
//    {      
//        //Condition for checking the job is Appointed or not
//        BOOL IsAppointmentAccepted  = jobResponse.appointmentAccepted;
//        if(!IsAppointmentAccepted)
//            subTitle.textColor = [UIColor redColor];
//        else {
//            if (jobResponse.appointmentedDate && [jobResponse.appointmentedDate compare:[NSDate date]] == NSOrderedAscending) 
//              {
//                  //less date
//                  subTitle.textColor = [UIColor redColor];
//              }
//        }
//    }
//        
    
    //if([jobResponse isJobCancelledOrKilled] || [jobResponse isJobExpired])
//    if([jobResponse isJobExpired])
//         subTitle.textColor = [UIColor redColor];
    
    subTitle.numberOfLines = 0;
    subTitle.text=[self checkDisplayText:jobResponse];
    [self addSubview:subTitle];
    [subTitle release];
    subTitle=nil;
    
    
    //list description
    UILabel *listDescription=[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_SECTION_DETAILLABLEL_X, LISTVIEW_SECTION_DETAILLABLEL_Y, LISTVIEW_SECTION_DETAILLABLEL_WIDTH, LISTVIEW_SECTION_DETAILLABLEL_HEIGHT)];
    listDescription.font=[UIFont fontWithName:@"Helvetica" size:13.0];
    listDescription.textAlignment=UITextAlignmentLeft;
    listDescription.textColor = [UIColor grayColor];
    listDescription.text=[self getDesciptionText:jobResponse];
    [self addSubview:listDescription];
    [listDescription release];
    listDescription=nil;

    //location image
    UIImageView *locationThumbnail=[[UIImageView alloc]init];
    locationThumbnail.frame=CGRectMake(LISTVIEW_REQ_LOCATION_IMAGE_X,LISTVIEW_REQ_LOCATION_IMAGE_Y, LISTVIEW_REQ_LOCATION_IMAGE_WIDTH,LISTVIEW_REQ_LOCATION_IMAGE_HEIGHT);
    locationThumbnail.backgroundColor=[UIColor clearColor];
    locationThumbnail.image=[UIImage imageNamed:DEFAULT_LOCATION_IMAGE_NAME]; 
    [locationThumbnail setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:locationThumbnail];
    [locationThumbnail release];
    locationThumbnail=nil;
    
    //location ID
    UILabel *locationID =[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_REQ_LOCATION_TEXT_X, LISTVIEW_REQ_LOCATION_TEXT_Y, LISTVIEW_REQ_LOCATION_TEXT_WIDTH, LISTVIEW_REQ_LOCATION_TEXT_HEIGHT)];
    locationID.font=[UIFont fontWithName:@"Helvetica-Bold" size:10.0];
    locationID.textAlignment=UITextAlignmentRight;
    locationID.textColor = [UIColor grayColor];
    NSArray *zipCode     = [jobResponse.jobLocationID componentsSeparatedByString:@" "];
    locationID.text=[zipCode lastObject];
    [self addSubview:locationID];
    [locationID release];
    locationID=nil;
    
    // schedule description
    UILabel *scheduleDesription =[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_REQ_SCHEDULE_X, LISTVIEW_REQ_SCHEDULE_Y, LISTVIEW_REQ_SCHEDULE_W, LISTVIEW_REQ_SCHEDULE_H)];
    scheduleDesription.font=[UIFont fontWithName:@"Helvetica" size:11.0];
    scheduleDesription.textAlignment=UITextAlignmentLeft;
    scheduleDesription.textColor = [UIColor darkGrayColor];
    scheduleDesription.text=[self getScheduledText:jobResponse];
    [self addSubview:scheduleDesription];
    [scheduleDesription release];
    scheduleDesription=nil;
    
}


- (NSString *)getDesciptionText:(JobResponseDetails *)jobResponse {
    
    NSString *audioOnly = @"Audio Description"; 
    NSString *videoOnly = @"Video Description";
    NSString *audioAndVideo = @"Audio and Video Description";
    
    NSString *displayText=@"";
    if([jobResponse.winningBidNames count]>0) {
        
        NSString *jobServiceName = [jobResponse jobServicerName];
        return jobServiceName;
    }
    
    if (![jobResponse.jodDetails isEqualToString:@""]) {
        displayText = [NSString stringWithFormat:@"\"%@\"",jobResponse.jodDetails];
        return displayText;
    }
    
    NSArray *jobDocuments = jobResponse.jobDocuments;
    switch ([jobDocuments count]) {
        case 0:
            break;
        case 1:{
            NSString *fileDuration = [jobResponse getFileDuration];
            if([jobResponse.jobDocument.file_type isEqualToString:@"audio"])
                displayText = [NSString stringWithFormat:@"%@%@",fileDuration,audioOnly];
            else
                displayText = [NSString stringWithFormat:@"%@%@",fileDuration,videoOnly];
            break;}
            
        case 2:
            displayText = [NSString stringWithFormat:@"%@",audioAndVideo];
            break;
        default:
            break;
    }
    return displayText;
}



- (NSString *)getScheduledText:(JobResponseDetails *)jobResponse{

    NSString *displayText=nil;
    NSString *jobAuctionType = jobResponse.auctionType;
    
    if([jobResponse.winningBidNames count]>0) {
        
         displayText = @"";
        return displayText;
    }
    
    if ([jobAuctionType isEqualToString: SCHEDULE_TYPE_FLEXIBLE]){
        displayText = SCHEDULE_FLEXIBLE_TEXT;
    }
    else if ([jobAuctionType isEqualToString: SCHEDULE_TYPE_DATE]){
               
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"MMM dd, yyyy"];  
       displayText = [NSString stringWithFormat:@"Scheduled for %@",[formatter stringFromDate:jobResponse.startDate]];
        [formatter release];
        formatter=nil;
    }
    else if ([jobAuctionType isEqualToString: SCHEDULE_TYPE_URGENT]){

        displayText= SCHEDULE_URGENT_TEXT;
    }
    
    return displayText;
}


- (NSString *)checkDisplayText:(JobResponseDetails *)jobResponse
{
    NSString *displayText=nil;
    NSString *jobResponseType = jobResponse.jobType;
    
    if ([jobResponseType isEqualToString:SCHEDULE])
    {
        //Condition for checking the job is Appointed or not
        BOOL IsAppointmentAccepted  = jobResponse.appointmentAccepted;
        BOOL isValidDate = NO;
        NSLog(@"Date %@",jobResponse.appointmentedDate);
        if(jobResponse.appointmentedDate)
            isValidDate = [jobResponse.appointmentedDate compare:[NSDate date]] == NSOrderedDescending;

        //date is YES and apointrd status is YES
        if (isValidDate && IsAppointmentAccepted)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yyyy"];  
            displayText = [NSString stringWithFormat:@"Confirmed for %@",[formatter stringFromDate:jobResponse.appointmentedDate]];
            [formatter release];
            formatter = nil;
        }
        //date IS YES and apointrd status is NO
        else if (!IsAppointmentAccepted) {
            
            NSLog(@"Appointed Date:- %@",jobResponse.appointmentedDate);
            displayText = isValidDate ? SCHEDULE_APPOINTMENT_TIME_DISPLAY_TEXT : SCHEDULE_APPOINTMENT_NIL_TIME_DISPLAY_TEXT ;
        }
        else
            displayText = SCHEDULE_APPOINTMENT_NIL_TIME_DISPLAY_TEXT;
    }

    else if ([jobResponseType isEqualToString:NEW])
    {
        if (jobResponse.bid_count == 1) {
            
           displayText = [NSString stringWithFormat:@"%d %@",jobResponse.bid_count,NEW_DISPLAY_TEXT_WITH_ONE_QUOTES];
        }
        else if (jobResponse.bid_count>1) {
            
            displayText = [NSString stringWithFormat:@"%d %@",jobResponse.bid_count,NEW_DISPLAY_TEXT_WITH_MORETHAN_ONE_QUOTES];
        }
        else if(!jobResponse.location_in_launched_zips)
        {
            displayText = [NSString stringWithFormat:@"%@ %@",UNSERVICED_AREA,jobResponse.jobLocationID];
        }
        else {
            displayText = NEW_DISPLAY_TEXT_WITHOUT_QUOTES;
        }
    }
    
    else if([jobResponseType isEqualToString:DONE])
    {    
        if([jobResponse isJobCancelledOrKilled])
            displayText = JOB_CANCELLED_MESSAGE;
        
        else if([jobResponse isReviewed]) 
            displayText = JOB_REVIEWED_MESSAGE;
        
        else if([jobResponse isJobExpired])
            displayText = JOB_EXPIRED_MESSAGE;
        
        else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yyyy"];  
            displayText = [DONE_DISPLAY_TEXT stringByAppendingFormat:@" %@",[formatter stringFromDate:jobResponse.endDate]];
            [formatter release];
            formatter=nil;
        }
    }
    return displayText;
}


- (void)dealloc
{
    [super dealloc];
}

@end
