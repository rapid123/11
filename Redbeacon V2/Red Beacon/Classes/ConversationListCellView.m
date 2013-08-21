//
//  ConversationListCellView.m
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ConversationListCellView.h"

#define UPPER_ROW_TOP 10
#define LOWER_ROW_TOP 30
#define TIME_ROW_TOP 5

#define LEFT_COLUMN_OFFSET 27
#define LEFT_COLUMN_WIDTH 190

#define RIGHT_COLUMN_OFFSET 200
#define RIGHT_COLUMN_WIDTH 100

#define LOWER_LEFT_HEIGHT 27
#define LOWER_LEFT_WIDTH 212

#define MIN_MESSAGE_FONT_SIZE 12
#define MIN_NAME_FONT_SIZE 10
#define MIN_TIME_FONT_SIZE 10

#define READ_IMAGE_OFFSET 10
#define READ_IMAGE_WIDTH 20

@implementation ConversationListCellView

@synthesize content;
@synthesize editing;

NSString * readImageName = @"unreadIndicator";
NSString * imageType = @"png";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString * pathToImage;
        pathToImage = [[NSBundle mainBundle] pathForResource:readImageName 
                                                      ofType:imageType];
        readImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSString *)dateToString:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd"];  
    NSString* dateAndTimeString = [formatter stringFromDate:date];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:@" @ "];
    [formatter setDateFormat:@"h:mmaa"];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:[formatter stringFromDate:date]];
    [formatter release];
    return dateAndTimeString;
    
}


-(NSString *)lastQASTextDate {
    
    NSString *text = @"";
    if(jobQAS.answer)
        text = [self dateToString:jobQAS.time_answered];
    else
        text = [self dateToString:jobQAS.time_created];
    
    return text;
}

-(NSString *)lastQAStext {
    
    NSString *text = @"";
    if(jobQAS.answer)
        text = jobQAS.answer;
    else
        text = jobQAS.question;
    
    return text;
        
}

- (void)drawRect:(CGRect)rect {
    
   
    // set up #define constants and fonts here ...
    UIFont * normalFont = [UIFont systemFontOfSize:12.0];
    UIFont * boldFont = [UIFont boldSystemFontOfSize:16.0];
    UIFont * timeFont = [UIFont boldSystemFontOfSize:12.0];

    UIColor * blackColor = [UIColor blackColor];
    UIColor * backgroundColor = [UIColor whiteColor];
    UIColor * timeColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0];
    UIColor * subTitleColor = [UIColor grayColor];
    
    CGRect contentRect = self.bounds;
    
    if (!self.editing) {    
        CGFloat boundsX = contentRect.origin.x;
        CGPoint point;
        CGRect rect;
        
        [backgroundColor set];
        UIRectFill(contentRect);
        
        [blackColor set];        
        
        NSString *textToDisplay = @"";
        
        // draw name here
        if(content)
            textToDisplay =content.jobProfile.best_name;
        else
            textToDisplay = @"Public Question";
        
        point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP);
        [textToDisplay drawAtPoint:point 
                           forWidth:LEFT_COLUMN_WIDTH 
                           withFont:boldFont 
                        minFontSize:MIN_NAME_FONT_SIZE 
                     actualFontSize:NULL 
                      lineBreakMode:UILineBreakModeWordWrap 
                 baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // draw time here
        
        [timeColor set];
        
        if(content)
            textToDisplay =[content lastPrivatemessageDate];
        else
            textToDisplay = [self lastQASTextDate];
        
        point = CGPointMake(boundsX + RIGHT_COLUMN_OFFSET, TIME_ROW_TOP);
        [textToDisplay drawAtPoint:point
                               forWidth:RIGHT_COLUMN_WIDTH 
                               withFont:timeFont 
                            minFontSize:MIN_TIME_FONT_SIZE
                         actualFontSize:NULL
                          lineBreakMode:UILineBreakModeTailTruncation 
                     baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // draw message here
        
        
        [subTitleColor set];
        if(content) {
            textToDisplay = [content lastPrivateMessage];
        }
        else
            textToDisplay = [self lastQAStext];
        
        rect = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP, 
                          LOWER_LEFT_WIDTH, LOWER_LEFT_HEIGHT);
        [textToDisplay drawInRect:rect withFont:normalFont];
        
        
        // for read / unread  ******************** TO DO in V2.1
        

        if ([self.content messageReadStatus]) {

            point = CGPointMake(READ_IMAGE_OFFSET, READ_IMAGE_WIDTH);
            [readImage drawAtPoint:point];
        }

        
//        if(content){
//            NSArray *privatemessages = [content privateMessages];
//            JobPrivateMessage *privateMessage = [privatemessages lastObject];
//            if(privateMessage.has_been_read_by_consumer) 
//                readFlag = YES;
//        }
//        else {
//            if (jobQAS.has_been_read_by_consumer) 
//                readFlag = YES;
//        }
//        
//        if(!readFlag){
//            point = CGPointMake(READ_IMAGE_OFFSET, READ_IMAGE_WIDTH);
//            [readImage drawAtPoint:point];
//        }
        
        UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0 , self.frame.size.height- 1, 320, 1)];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:linelabel];
        [linelabel release];
        linelabel=nil;
    }
}




- (void)setCellForDisplay:(id)contents {
    
    if([contents isKindOfClass:[JobBids class]]){
        [content release];
        content = [contents retain];
    }
    else {
        
        [jobQAS release];
        jobQAS = [[contents lastObject] retain];
    }
    
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [readImage release];
    readImage = nil;
    [super dealloc];
}

@end
