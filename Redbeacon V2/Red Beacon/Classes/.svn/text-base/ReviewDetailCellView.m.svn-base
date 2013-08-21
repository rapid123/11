//
//  ReviewDetailCellView.m
//  Red Beacon
//
//  Created by sudeep on 21/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ReviewDetailCellView.h"


#define GRAPH_BAR_ORIGINAL_WIDTH 220
#define STAR_RATING_LABEL_RECT CGRectMake(20,10,280,20)

#define STAR_SINGLE_RATE_RECT CGRectMake(5,30,20,20)

#define REVIEW_TEXT_RECT CGRectMake(15,40,280,55)
#define SUBMIT_TEXT_RECT CGRectMake(130,10,170,20)
#define PLACE_TEXT_RECT CGRectMake(150,20,150,20)

@implementation ReviewDetailCellView

@synthesize content;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIColor * labelColor = [UIColor grayColor];
    
    UIFont * reviewsTextFont = [UIFont boldSystemFontOfSize:11];
    UIFont *smallFont = [UIFont systemFontOfSize:10];
    
    //**********************DRAWING THE BACKGROUND IMAGE**********************
    [labelColor set];
    
    if(!content){ // draw the contents for the graph cell
        
        UIFont * ratingFont = [UIFont boldSystemFontOfSize:11];
        UIFont * smallFont = [UIFont boldSystemFontOfSize:9];
        
        CGRect rect = STAR_RATING_LABEL_RECT;
        [@"Star Ratings" drawInRect:rect withFont:ratingFont lineBreakMode: UILineBreakModeClip 
                          alignment: UITextAlignmentCenter];
        
        
        //**************************** the labels in both sides of the bar *****************************
        
        int offsetY = 0;
        int offsetX = 265;
        for(int i = 1;i <= 5 ; i++) {
            
            //left side
            rect = STAR_SINGLE_RATE_RECT;
            rect.origin.y = rect.origin.y + offsetY;
            NSString *rateNumber = [NSString stringWithFormat:@"%d",i];
            [rateNumber drawInRect:rect withFont:smallFont lineBreakMode: UILineBreakModeClip 
                              alignment: UITextAlignmentCenter];
            
            // right side
            rect.origin.x = rect.origin.x + offsetX;
            NSString *rateCount = [NSString stringWithFormat:@"%d",i*3];
            [rateCount drawInRect:rect withFont:smallFont lineBreakMode: UILineBreakModeClip 
                         alignment: UITextAlignmentRight];

            offsetY = offsetY + 20 ;
        }
               
        return;
    }
    
    // draw the contents for the reviews cells
    
    //****************************STARS DISPLAY*****************************

    int starCount = [[content objectForKey:@"stars"] intValue];

    CGPoint point;
    int startOffset = 15 ;
    int STAR_IMAGE_OFFSET_Y = 10;
    int STAR_IMAGE_OFFSET_WIDTH = 17;
    
    // draw the stars
    for(int i=0;i<starCount;i++){
        
        NSString * starImagename = @"star";
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
    
    
    //****************************DATE DISPLAY*****************************
    
    rect = SUBMIT_TEXT_RECT;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];  
     NSString *submitDate = [NSString stringWithFormat:@"%@ ",[formatter stringFromDate:[content objectForKey:@"date"]]];
    [formatter release];
    formatter=nil;
    
    NSString *submitplace = [NSString stringWithFormat:@"%@ By %@",submitDate,[content objectForKey:@"author"]];
    [submitplace drawInRect:rect withFont:smallFont lineBreakMode: UILineBreakModeWordWrap 
                 alignment: UITextAlignmentRight];
    //****************************REVIEW TEXT DISPLAY*****************************
    
    [[UIColor blackColor] set];
    rect = REVIEW_TEXT_RECT;
    rect.size.height = self.frame.size.height - 20;
    NSString *reviewText = [NSString stringWithFormat:@"\"%@\"",[content objectForKey:@"review"]];
    [reviewText drawInRect:rect withFont:reviewsTextFont lineBreakMode: UILineBreakModeWordWrap 
                 alignment: UITextAlignmentLeft];
        
}

- (void)dealloc
{
    self.content = nil;
    [super dealloc];
}

-(void)displayGraph:(id)rateDistribution {

    int offsetY = 30;
    int offsetX = 30;

    int barWidth = 0;
    //****************************CREATE AND SUBVIEW THE BAR - GRAPH *****************************
    
    for(int i = 1;i <= 5 ; i++) {
        barWidth = GRAPH_BAR_ORIGINAL_WIDTH/i;
        UILabel *graphLabel = [[UILabel alloc] init];
        graphLabel.frame = CGRectMake(offsetX, offsetY, barWidth, 15);
        [graphLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        [self addSubview:graphLabel];
        [graphLabel release];
        graphLabel = nil;
        
        offsetY = offsetY + 20;
    }
}


- (void)displayCellItems:(id)item {
    
    [content release];
    content = [item retain];
    
    
    [self setNeedsDisplay];
}

@end
