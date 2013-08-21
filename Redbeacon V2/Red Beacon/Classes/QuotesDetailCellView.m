//
//  QuotesDetailCellView.m
//  Red Beacon
//
//  Created by sudeep on 04/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "QuotesDetailCellView.h"

#pragma mark -
#pragma mark QuotesDetailFeatureView


@interface QuotesDetailFeatureView : UIView {
    JobBids *jobBid;
}

@property (nonatomic,retain) JobBids *jobBid;

@end

@implementation QuotesDetailFeatureView

@synthesize jobBid;

#define RB_SCORE_RECT CGRectMake(10, 25, 45, 30);
#define SCORE_RECT_DETAIL CGRectMake(10, 5, 45,30); 

#define INSURED_RECT CGRectMake(62, 25, 45, 30);
#define INSURED_IMAGE_RECT CGRectMake(65, 7, 25, 15);

#define LICENCED_RECT CGRectMake(105, 25, 50, 30);
#define LICENCED_IMAGE_RECT CGRectMake(112, 7, 25, 15);

#define BONDED_RECT CGRectMake(152, 25, 50, 30);
#define BONDED_IMAGE_RECT CGRectMake(163, 7, 10, 15);

NSString * bondedImageEnabled = @"bonded_enabled";
NSString * bondedImageDisabled = @"bonded_disabled";

NSString * licensedImageEnabled = @"licence_enabled";
NSString * licensedImageDisabled = @"licence_disabled";

NSString * insuredImageEnabled = @"insured_enabled";
NSString * insuredImageDisabled = @"insured_disabled";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGRect contentRect = self.bounds;

    UIColor * backgroundColor = [UIColor clearColor];
    UIColor * labelColor = [UIColor grayColor];
    UIColor * scoreColor = [UIColor blackColor];

    UIFont * labelFont = [UIFont boldSystemFontOfSize:9];
    UIFont * scoreFont = [UIFont boldSystemFontOfSize:16];
    
    NSString * score = [NSString stringWithFormat:@"%d",jobBid.jobProfile.rbScore.total];
    BOOL isInsured = jobBid.jobProfile.is_insured;
    BOOL isLicenced = jobBid.jobProfile.is_licensed;
    BOOL isBonded = jobBid.jobProfile.is_bonded;
    
    NSString *imageName;
       
    [backgroundColor set];
    UIRectFill(contentRect);

    //**********************CREATING THE LABELS**********************
    [labelColor set];
    rect = RB_SCORE_RECT;
    [RBSCORE_LABEL drawInRect:rect withFont:labelFont];
    
    rect = INSURED_RECT;
    [INSURED_LABEL drawInRect:rect withFont:labelFont];
    
    rect = LICENCED_RECT;
    [LICENCED_LABEL drawInRect:rect withFont:labelFont];
    
    rect = BONDED_RECT;
    [BONDED_LABEL drawInRect:rect withFont:labelFont];
    
    
    //**********************DRAWING THE RBSCORE**********************
    [scoreColor set];
    rect = SCORE_RECT_DETAIL;
    [score drawInRect: rect withFont: scoreFont lineBreakMode: UILineBreakModeClip 
              alignment: UITextAlignmentCenter];
    
    //**********************DRAWING THE BONDED IMAGE**********************
    if(isBonded)
        imageName = bondedImageEnabled;
    else
        imageName = bondedImageDisabled;
    
    rect = BONDED_IMAGE_RECT;
    NSString * pathToImage;
    pathToImage = [[NSBundle mainBundle] pathForResource:imageName 
                                                  ofType:@"png"];
    UIImage *bondedImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    [bondedImage drawInRect:rect];
    [bondedImage release];
    bondedImage=nil;
    //**********************DRAWING THE INSURED IMAGE**********************
    if(isInsured)
        imageName = insuredImageEnabled;
    else
        imageName = insuredImageDisabled;
    rect = INSURED_IMAGE_RECT;
    pathToImage = [[NSBundle mainBundle] pathForResource:imageName 
                                                  ofType:@"png"];
    UIImage *insureImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    [insureImage drawInRect:rect];
    [insureImage release];
    insureImage=nil;
    //**********************DRAWING THE LICENCED IMAGE**********************
    if(isLicenced)
        imageName = licensedImageEnabled;
    else
        imageName = licensedImageDisabled;
    rect = LICENCED_IMAGE_RECT;
    pathToImage = [[NSBundle mainBundle] pathForResource:imageName 
                                                  ofType:@"png"];
    UIImage *licenceImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    [licenceImage drawInRect:rect];
    [licenceImage release];
    licenceImage=nil;
}

- (void)dealloc
{
    self.jobBid= nil;
    [super dealloc];
}
@end    


#pragma mark -
#pragma mark QuotesDetailReviewsView

@interface QuotesDetailReviewsView : UIView {
 
    int starCount;
    int reviewCount;
    JobBids *jobBid;
}

@property (nonatomic,retain) JobBids *jobBid;

-(void)setStarCount:(int)starCount andReviewCount:(int)rwCount;

@end


#define REVIEWS_LABEL_RECT CGRectMake(10, 15, 50, 30);
#define NO_REVIEWS_RECT CGRectMake(55, 13, 100, 30);
#define STARS_RECT CGRectMake(65, 30, 45, 30);

@implementation QuotesDetailReviewsView

@synthesize jobBid;

NSString * starImagename = @"star";
int STAR_IMAGE_OFFSET = 60;
int STAR_IMAGE_OFFSET_Y = 13;
int STAR_IMAGE_OFFSET_WIDTH = 17;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(void)setStarCount:(int)stCount andReviewCount:(int)rwCount {
    
    starCount=stCount;
    reviewCount=rwCount;
}

- (void)drawRect:(CGRect)rect {
    
    //CGRect contentRect = self.bounds;
    
    UIColor * labelColor = [UIColor grayColor];
    UIFont * labelFont = [UIFont boldSystemFontOfSize:10];
    UIFont * reviewCountFont = [UIFont boldSystemFontOfSize:12];
    UIFont * noReviewsFont = [UIFont boldSystemFontOfSize:14];
    
    CGPoint point;
    
    int startOffset = STAR_IMAGE_OFFSET;
    [labelColor set];
    if(reviewCount==0){
        // No reviews
        rect = NO_REVIEWS_RECT;
        [jobBid.jobProfile.text_rating drawInRect:rect withFont:noReviewsFont];
    }
    
    else {
        
        //draw the review label
        rect = REVIEWS_LABEL_RECT;
        [@"Reviews" drawInRect:rect withFont:labelFont];
        
        // draw the stars
        for(int i=0;i<starCount;i++){
            
            NSString * pathToImage;
            pathToImage = [[NSBundle mainBundle] pathForResource:starImagename 
                                                          ofType:@"png"];
            UIImage *star = [[UIImage alloc] initWithContentsOfFile:pathToImage];
            point = CGPointMake(startOffset, STAR_IMAGE_OFFSET_Y);
            [star drawAtPoint:point];
            startOffset = startOffset + STAR_IMAGE_OFFSET_WIDTH;
            [star release];
            star=nil;
        }
          
        // draw the review count
        startOffset = startOffset + STAR_IMAGE_OFFSET_WIDTH/2; 
        NSString *reviewDisplay;
        reviewDisplay = [NSString stringWithFormat:@"(%d)",reviewCount];
        rect = CGRectMake(startOffset, STAR_IMAGE_OFFSET_Y, 50, 30);
        [reviewDisplay drawInRect:rect withFont:reviewCountFont];
    }    
    
}

- (void)dealloc
{
    self.jobBid = nil;
    [super dealloc];
}
@end  


#pragma mark -
#pragma mark QuotesDetailConversationView

@interface QuotesDetailConversationView : UIView {
    JobBids *jobBid;
}

@property (nonatomic,retain) JobBids *jobBid;
@property(nonatomic, retain) NSString *conversationContent;
@end


#define CONVERSATION_LABEL_RECT CGRectMake(10, 5, 250, 40);

@implementation QuotesDetailConversationView

@synthesize conversationContent;
@synthesize jobBid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGRect contentRect = self.bounds;
    
    UIColor * backgroundColor = [UIColor clearColor];
    UIColor * labelColor = [UIColor grayColor];
    UIFont * labelFont = [UIFont systemFontOfSize:12];

    [backgroundColor set];
    UIRectFill(contentRect);
    
    // draw the conversation Content
    [labelColor set];
    rect = CONVERSATION_LABEL_RECT;
    
    CGFloat fontHeight = labelFont.pointSize;
    CGFloat yOffset = (rect.size.height - fontHeight) / 2.0;
    CGRect textRect = CGRectMake(0, yOffset, rect.size.width, fontHeight);
    
    [conversationContent drawInRect: textRect withFont: labelFont lineBreakMode: UILineBreakModeClip 
        alignment: UITextAlignmentLeft];

    
//    [conversationContent drawInRect:rect withFont:labelFont 
//                      lineBreakMode:UILineBreakModeWordWrap 
//                          alignment:UITextAlignmentLeft];
    
}

- (void)dealloc
{
    self.jobBid= nil;
    self.conversationContent=nil;
    [super dealloc];
}
@end 


//************************************* QuotesDetailDescriptionView ************************

#pragma mark -
#pragma mark QuotesDetailDescriptionView

@interface QuotesDetailDescriptionView : UIView {
    
    JobBids *jobBid;
    NSMutableArray *descriptionArray;
}

@property (nonatomic,retain) JobBids *jobBid;
@property (nonatomic,retain) NSMutableArray *descriptionArray;
@end

#define APOINTMENT_RECT CGRectMake(0,95,300,30)
#define APPOINTMENT_TAG_FRAME CGRectMake(0,115,305,35)

@implementation QuotesDetailDescriptionView

@synthesize jobBid;
@synthesize descriptionArray;

NSString *onsite = @"Need to Meet";
NSString *flatRate = @"Flat Rate Quote";
NSString *hourlyRate = @"Hourly Rate Quote";
NSString *travelFee = @"Travel Fee";
NSString *excludesPart = @"Excludes parts";
NSString *fixedFee = @"Fixed Fee";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(void)displayTheRate {
    
    int LEFT_COLUMN_OFFSET = 10;
    int LEFT_COLUMN_OFFSET_WITH_DOLLAR = 25;
    int LOWER_LEFT_WIDTH = 212;
    int LOWER_ROW_TOP = 30;
    int LABEL_OFFSET_Y = 10;
    int LABEL_OFFSET_WIDTH = 120;
    
    int NORMAL_FONT_SIZE = 12;
    int MIN_NAME_FONT_SIZE = 10;
    
    CGPoint point;
    CGRect contentRect = self.bounds;
    CGFloat boundsX = contentRect.origin.x;
    UIFont * largeFont = [UIFont systemFontOfSize:32.0];
    UIFont * boldFont = [UIFont boldSystemFontOfSize:12.0];
    UIFont * onsiteFont = [UIFont boldSystemFontOfSize:17.0];
    //UIFont * mediumFont = [UIFont systemFontOfSize:28.0];
    UIFont * dollarFont = [UIFont systemFontOfSize:18];
    UIFont * appointmentFont = [UIFont systemFontOfSize:12];
    
    NSString *priceToDisplay;
    NSString *rateSpecificationLabel;
    
    
    if (jobBid.require_onsite) {
        
        priceToDisplay=@"Onsite Required";
        rateSpecificationLabel = onsite;
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LABEL_OFFSET_Y);
        [rateSpecificationLabel drawAtPoint:point 
                                 forWidth:LABEL_OFFSET_WIDTH 
                                 withFont:boldFont 
                              minFontSize:NORMAL_FONT_SIZE 
                           actualFontSize:NULL 
                            lineBreakMode:UILineBreakModeWordWrap 
                       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        
        [[UIColor blackColor] set];
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
        NSString *rate= priceToDisplay;
        [rate drawAtPoint:point 
                 forWidth:LOWER_LEFT_WIDTH 
                 withFont:onsiteFont 
              minFontSize:MIN_NAME_FONT_SIZE 
           actualFontSize:NULL 
            lineBreakMode:UILineBreakModeWordWrap 
       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        NSString *description ;
        if(!(jobBid.estimate_high==0.0)) {
            description = [NSString stringWithFormat:@"$%d - $%d Estimate",(int)jobBid.estimate_low,(int)jobBid.estimate_high];
            [self.descriptionArray addObject:description];
        }
        
        if(!(jobBid.flat_rate==0.0)) {
            description = [NSString stringWithFormat:@"$%d - %@",(int)jobBid.flat_rate,travelFee];
            [self.descriptionArray addObject:description];
        }
    }
    
    else{
        
        NSString *description ;
        int price;
        if(!(jobBid.flat_rate==0.0)){
            price=(int )jobBid.flat_rate;   // use flat rate as price
            rateSpecificationLabel = flatRate;
            
            if(jobBid.is_parts_excluded){
                description = [NSString stringWithFormat:@"%@",excludesPart];
                [self.descriptionArray addObject:description];
            }
        }
        else {
            price = jobBid.total_price;     // use total rate as price
            rateSpecificationLabel = hourlyRate;    
            
            description = [NSString stringWithFormat:@"$%d x %d hours estimated",(int)jobBid.hourly_rate,jobBid.number_of_hours];
            [self.descriptionArray addObject:description];
            
            if(!(jobBid.flat_rate==0.0)) {
                description = [NSString stringWithFormat:@"$%d - %@",(int)jobBid.flat_rate,fixedFee];
                [self.descriptionArray addObject:description];
            }
            if(jobBid.is_parts_excluded){
                description =[NSString stringWithFormat:@"%@",excludesPart];
                [self.descriptionArray addObject:description];
            }
        }
        
        priceToDisplay = [NSString stringWithFormat:@"%d.",price];
        
        //********************RATE SPECIFICATION LABEL ******************************
       
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LABEL_OFFSET_Y);
        [rateSpecificationLabel drawAtPoint:point 
                 forWidth:LABEL_OFFSET_WIDTH 
                 withFont:boldFont 
              minFontSize:NORMAL_FONT_SIZE 
           actualFontSize:NULL 
            lineBreakMode:UILineBreakModeWordWrap 
       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        //********************DOLLAR LABEL ******************************
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
        [@"$" drawAtPoint:point 
                 forWidth:10 
                 withFont:dollarFont 
              minFontSize:MIN_NAME_FONT_SIZE 
           actualFontSize:NULL 
            lineBreakMode:UILineBreakModeWordWrap 
       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        //********************PRICE AMOUNT LABEL ******************************
        
        [[UIColor blackColor] set];
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET_WITH_DOLLAR, LOWER_ROW_TOP);
        NSString *rate= priceToDisplay;
        [rate drawAtPoint:point 
                 forWidth:LOWER_LEFT_WIDTH 
                 withFont:largeFont 
              minFontSize:MIN_NAME_FONT_SIZE 
           actualFontSize:NULL 
            lineBreakMode:UILineBreakModeWordWrap 
       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
     
        //********************THE CENTS LABELS******************************
        
        [[UIColor grayColor] set];
        CGSize size = [rate sizeWithFont:largeFont minFontSize:MIN_NAME_FONT_SIZE actualFontSize:NULL forWidth:LOWER_LEFT_WIDTH lineBreakMode:UILineBreakModeWordWrap];
        int w=size.width;
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET_WITH_DOLLAR+w, LOWER_ROW_TOP);
        [@"00" drawAtPoint:point 
                  forWidth:20 
                  withFont:dollarFont 
               minFontSize:MIN_NAME_FONT_SIZE 
            actualFontSize:NULL 
             lineBreakMode:UILineBreakModeWordWrap 
        baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    }
    
    //********************APPOINTMENT LABEL ******************************
    
    [[UIColor grayColor] set];

    if([jobBid appointedDate]){
        
        NSString * appointmentAt = [NSString stringWithFormat:@"Appointment: %@",[jobBid appointedDate]];
        
        CGRect rect = APOINTMENT_RECT;
        [appointmentAt drawInRect:rect withFont:appointmentFont lineBreakMode: UILineBreakModeWordWrap
                        alignment: UITextAlignmentCenter];
    }
    else if([jobBid originalAppointmentDate]){
        
        NSString * appointmentAt = [NSString stringWithFormat:@"Appointment: %@",[jobBid originalAppointmentDate]];
        
        CGRect rect = APOINTMENT_RECT;
        [appointmentAt drawInRect:rect withFont:appointmentFont lineBreakMode: UILineBreakModeWordWrap
                        alignment: UITextAlignmentCenter];
    }
    
    
    //**********************************************************************
  
}

-(void)displayTheRateSpecifications {
    
    int LOWER_LEFT_WIDTH = 110;
    UIFont * mediumFont = [UIFont systemFontOfSize:13.0];
    int descriptionHeight = 35;
    int descriptionOffsetx = 160;
    int descriptionOffsety = 10;
    
    int bulletOffsetx = descriptionOffsetx -10;
    int bulletOffsety = 15;
    int bulletSize = 5;
    
    if([descriptionArray count]>0){
        int offset = 0;
        //CGPoint point;
        for (int i=0; i<[descriptionArray count]; i++) {
            
            CGRect rect = CGRectMake(bulletOffsetx, bulletOffsety + offset , bulletSize, bulletSize);
            NSString * pathToImage;
            pathToImage = [[NSBundle mainBundle] pathForResource:@"bullet_image" 
                                                          ofType:@"png"];
            UIImage *bondedImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
            [bondedImage drawInRect:rect];
            [bondedImage release];
            bondedImage=nil;
            
            
            rect = CGRectMake(descriptionOffsetx, descriptionOffsety + offset, LOWER_LEFT_WIDTH, descriptionHeight);
            NSString *rate= [descriptionArray objectAtIndex:i];
            [rate drawInRect:rect withFont:mediumFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
            
           offset=offset+35;
        }
    }
}

#pragma mark display View methods

-(void)displayAppointedTag {
    
    CGRect rect = APPOINTMENT_TAG_FRAME;
    NSString * pathToImage;
    pathToImage = [[NSBundle mainBundle] pathForResource:@"appointment_scheduled" 
                                                  ofType:@"png"];
    UIImage *acceptedImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    [acceptedImage drawInRect:rect];
    [acceptedImage release];
    acceptedImage=nil;
    
}


- (void)drawRect:(CGRect)rect {
    
    CGRect contentRect = self.bounds;
    
    UIColor * backgroundColor = [UIColor clearColor];
    UIColor * labelColor = [UIColor grayColor];

    [backgroundColor set];
    UIRectFill(contentRect);
    
    NSMutableArray *describeArray = [[NSMutableArray alloc] init];
    self.descriptionArray=describeArray;
    [describeArray release];
    describeArray = nil;

    [labelColor set];
    [self displayTheRate];
    
    [labelColor set];
    [self displayTheRateSpecifications];
    
    if([jobBid appointedDate]){
        
        [self displayAppointedTag];
    }
}

- (void)dealloc
{
    self.jobBid = nil;
    self.descriptionArray=nil;
    [super dealloc];
}
@end 


#pragma mark -
#pragma mark QuotesDetailCellView

@implementation QuotesDetailCellView

@synthesize jobBid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

#pragma mark -
#pragma mark cellViews

-(UIView *)createFeatureView {
    
    QuotesDetailFeatureView *featureView = [[QuotesDetailFeatureView alloc] initWithFrame:CGRectMake(90, 0, 250, 44)];
   [featureView setJobBid:jobBid];
    return (UIView *)[featureView autorelease];
    
}

-(UIView *)createReviewsView {
    
    QuotesDetailReviewsView *reviewsView = [[QuotesDetailReviewsView alloc] initWithFrame:CGRectMake(90, 0, 250, 44)];
    int starCount = [jobBid.jobProfile.average_rating intValue];
    int reviewCount = [jobBid.jobProfile.review_count intValue]; 
    [reviewsView setStarCount:starCount andReviewCount:reviewCount];
    [reviewsView setJobBid:jobBid];
    return (UIView *)[reviewsView autorelease];
}

-(UIView *)createConversationView {
    
    QuotesDetailConversationView *conversationView = [[QuotesDetailConversationView alloc] 
                                                      initWithFrame:CGRectMake(10, 0, 310, 44)];
    NSString *content=nil;
//    if(jobBid.description)
//        content = jobBid.description;
//    else if([jobBid.privateMessages count]>0){
//        JobPrivateMessage * privateMessage = [jobBid.privateMessages objectAtIndex:0];
//        content = privateMessage.message;
//    }
//    else    
//        content = @"";
    content =[jobBid lastPrivateMessage];
    [conversationView setConversationContent:content];
    [conversationView setJobBid:jobBid];
    
    return (UIView *)[conversationView autorelease];
}

-(UIView *)createDescriptionView {
    
    QuotesDetailDescriptionView *descriptionVIew = [[QuotesDetailDescriptionView alloc] initWithFrame:CGRectMake(0, 0, 315, 210)];
    [descriptionVIew setJobBid:jobBid];
    
    return (UIView *)[descriptionVIew autorelease];
}

#pragma mark -

-(QuotesDetailCellView *)createCellWithType:(BBQuoteCellType)type {
    
    switch (type) {
        case kQuoteFeatures:
            NSLog(@"index 1");
            self = (QuotesDetailCellView *)[self createFeatureView];
            break;
        case kQuoteReviews:
            NSLog(@"index 2");
            self = (QuotesDetailCellView *)[self createReviewsView];
            break;
        case kQuoteConversation:
            NSLog(@"index 3");
            self = (QuotesDetailCellView *)[self createConversationView];
            break;
        case kQuoteDetails:
            NSLog(@"index 4");
            self = (QuotesDetailCellView *)[self createDescriptionView];
            break;
        default:
            break;
    }
    
    return (QuotesDetailCellView *)self;
}

#pragma mark -
#pragma mark memory management


- (void)dealloc
{
    [super dealloc];
}

@end
