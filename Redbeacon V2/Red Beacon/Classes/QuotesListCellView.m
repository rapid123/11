//
//  QuotesListCellView.m
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "QuotesListCellView.h"
#import "JobBids.h"

#define SCORE_RECT CGRectMake(15, 20, 50, 30);
#define SCORE_RECT_LABEL CGRectMake(19, 50, 80, 30);
#define ACCEPTED_TAG_FRAME CGRectMake(245,0,70,20)


@implementation QuotesListCellView

@synthesize content;
@synthesize editing;

NSString * jobStatusBackgroundImagename = @"quotesBackground";
NSString * imageTypeOfBackground = @"png";

int UPPER_ROW_TOP = 10;
int LOWER_ROW_TOP = 30;
int TIME_ROW_TOP = 5;

int LEFT_COLUMN_OFFSET = 80;
int LEFT_COLUMN_WIDTH = 190;

int LEFT_COLUMN_OFFSET_WITH_DOLLAR = 90;

int RIGHT_COLUMN_OFFSET = 230;
int RIGHT_COLUMN_WIDTH = 70;

int LOWER_LEFT_HEIGHT = 27;
int LOWER_LEFT_WIDTH = 212;

int MIN_MESSAGE_FONT_SIZE = 12;
int MIN_NAME_FONT_SIZE = 10;
int MIN_TIME_FONT_SIZE = 10;

int BACKGROUND_IMAGE_OFFSET = 15;
int BACKGROUND_IMAGE_WIDTH = 0;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString * pathToImage;
        pathToImage = [[NSBundle mainBundle] pathForResource:jobStatusBackgroundImagename 
                                                      ofType:imageTypeOfBackground];
        jobStatusBackground = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
    }
    return self;
}


#pragma mark display View methods

-(void)displayRejectedTag {
    
    CGRect rect = ACCEPTED_TAG_FRAME;
    NSString * pathToImage;
    pathToImage = [[NSBundle mainBundle] pathForResource:@"rejected_Tag" 
                                                  ofType:@"png"];
    UIImage *rejectedImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    [rejectedImage drawInRect:rect];
    [rejectedImage release];
    rejectedImage=nil;
}

-(void)displayAppointedTag {
    
    CGRect rect = ACCEPTED_TAG_FRAME;
    NSString * pathToImage;
    pathToImage = [[NSBundle mainBundle] pathForResource:@"accepted_tag" 
                                                  ofType:@"png"];
    UIImage *acceptedImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    [acceptedImage drawInRect:rect];
    [acceptedImage release];
    acceptedImage=nil;
    
}

-(void)displayTheRate {
    
    CGPoint point;
    CGRect contentRect = self.bounds;
    CGFloat boundsX = contentRect.origin.x;
    UIFont * largeFont = [UIFont systemFontOfSize:30.0];
    UIFont * onsiteFont = [UIFont boldSystemFontOfSize:20.0];
    UIFont * boldFont = [UIFont boldSystemFontOfSize:15.0];
    
    JobBids *jobbid = (JobBids *)content;
    
    NSString *priceToDisplay;
    if (jobbid.require_onsite) {
        
        priceToDisplay=@"Onsite Required";
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
        NSString *rate= priceToDisplay;
        [rate drawAtPoint:point 
                 forWidth:LOWER_LEFT_WIDTH 
                 withFont:onsiteFont 
              minFontSize:MIN_NAME_FONT_SIZE 
           actualFontSize:NULL 
            lineBreakMode:UILineBreakModeWordWrap 
       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    }
    
    else{
         
        int price;
        if(!(jobbid.flat_rate==0.0))
            price=(int )jobbid.flat_rate;   // use flat rate as price
        else    
            price = jobbid.total_price;     // use total rate as price
        priceToDisplay = [NSString stringWithFormat:@"%d.",price];
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
        [@"$" drawAtPoint:point 
                  forWidth:10 
                  withFont:boldFont 
               minFontSize:MIN_NAME_FONT_SIZE 
            actualFontSize:NULL 
             lineBreakMode:UILineBreakModeWordWrap 
        baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET_WITH_DOLLAR, LOWER_ROW_TOP);
        NSString *rate= priceToDisplay;
        [rate drawAtPoint:point 
                 forWidth:LOWER_LEFT_WIDTH 
                 withFont:largeFont 
              minFontSize:MIN_NAME_FONT_SIZE 
           actualFontSize:NULL 
            lineBreakMode:UILineBreakModeWordWrap 
       baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        CGSize size = [rate sizeWithFont:largeFont minFontSize:MIN_NAME_FONT_SIZE actualFontSize:NULL forWidth:LOWER_LEFT_WIDTH lineBreakMode:UILineBreakModeWordWrap];
        int w=size.width;
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET_WITH_DOLLAR+w, LOWER_ROW_TOP);
        [@"00" drawAtPoint:point 
                  forWidth:20 
                  withFont:boldFont 
               minFontSize:MIN_NAME_FONT_SIZE 
            actualFontSize:NULL 
             lineBreakMode:UILineBreakModeWordWrap 
        baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    }
}


- (void)drawRect:(CGRect)rect {
    
    // set up #define constants and fonts here ...
    UIFont * boldFont = [UIFont boldSystemFontOfSize:15.0];
    UIFont * scoreFont = [UIFont systemFontOfSize:24];
    UIFont * scoreLabelFont = [UIFont systemFontOfSize:10];
    
    // set up text colors for main and secondary text in normal and highlighted cell states...
    UIColor * blackColor = [UIColor blackColor];
    UIColor * backgroundColor = [UIColor whiteColor];
    UIColor * subTitleColor = [UIColor lightGrayColor];
    UIColor * scoreColor = [UIColor redColor];
    
    CGRect contentRect = self.bounds;
    
    
    JobBids *jobbid = (JobBids *)content;
    NSString *rbScore = [NSString stringWithFormat:@"%d",jobbid.jobProfile.rbScore.total];
    NSString *jobBidTitle = jobbid.jobProfile.best_name;
    
    if (!self.editing) {    
        CGFloat boundsX = contentRect.origin.x;
        CGPoint point;
        CGRect rect;
        
        [backgroundColor set];
        UIRectFill(contentRect);
        
        // The RB score display
        
        point = CGPointMake(BACKGROUND_IMAGE_OFFSET, BACKGROUND_IMAGE_WIDTH);
        [jobStatusBackground drawAtPoint:point];
        
        [scoreColor set];
        rect = SCORE_RECT;
        [rbScore drawInRect: rect withFont: scoreFont lineBreakMode: UILineBreakModeClip 
               alignment: UITextAlignmentCenter];
        
        [blackColor set];  
        rect = SCORE_RECT_LABEL;
        [@"RB Score" drawInRect:rect withFont:scoreLabelFont];
        
        // The table content and title
            
        float widtheOfthestring = [jobBidTitle sizeWithFont:boldFont].width;
        if(widtheOfthestring>150) {
            
            NSRange range = {[jobBidTitle length]-10, 10};

            NSString *string = [jobBidTitle stringByReplacingCharactersInRange:range withString:@" ..."];
            widtheOfthestring = 150;
            jobBidTitle = string;
            
            UILabel *listHeading=[[UILabel alloc]initWithFrame:CGRectMake(LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, widtheOfthestring, 20)];
            listHeading.font=boldFont;
            listHeading.textAlignment=UITextAlignmentLeft;
            listHeading.backgroundColor = [UIColor clearColor];
            listHeading.text= jobBidTitle;
            [self addSubview:listHeading];
            [listHeading release];
            listHeading=nil;
            
        }
        
        else {    
        
            point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP);
            [jobBidTitle drawAtPoint:point 
                                      forWidth:widtheOfthestring 
                                      withFont:boldFont 
                                   minFontSize:15 
                                actualFontSize:NULL 
                                 lineBreakMode:UILineBreakModeWordWrap 
                            baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        }
              
        // The subtitle view
        
        [subTitleColor set];
        [self displayTheRate];
        
        if([jobbid appointedDate]){
            
            [self displayAppointedTag];
        }
        else if(jobbid.rejected_by_consumer) {
         
            [self displayRejectedTag];
        }
    }
}




- (void)displayCellItems:(id)item{
    
    [content release];
    content = [item retain];
    
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [jobStatusBackground release];
    jobStatusBackground=nil;
    self.content=nil;
    [super dealloc];
}

@end
