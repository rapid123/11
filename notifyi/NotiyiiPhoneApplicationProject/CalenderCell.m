//
//  CalenderCell.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalenderCell.h"
#import "GeneralClass.h"
@interface CalenderCell ()
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

-(void)fontCustomization;
@end

@implementation CalenderCell
@synthesize dayLabel;
@synthesize timeLabel;
@synthesize nameLabel;

#pragma mark- Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark- Display
/*******************************************************************************
 *  Function Name: displayDetails.
 *  Purpose: To display calender details.
 *  Parametrs: Coverage calender Object.
 *  Return Values: nil.
 ********************************************************************************/
-(void)displayDetails:(CoverageCalendar *)coverageCalendar
{
    [self fontCustomization];
    if (coverageCalendar) 
    {
        self.dayLabel.text = coverageCalendar.title;
        self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",coverageCalendar.startTime,coverageCalendar.endTime];
        self.nameLabel.text = coverageCalendar.details;
    }
}

/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)fontCustomization
{
    dayLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    dayLabel.font  = [GeneralClass getFont:customNormal  and:boldFont];
    timeLabel.font  = [GeneralClass getFont:customNormal and:boldFont];
    nameLabel.font  = [GeneralClass getFont:customNormal and:boldFont];
}

@end
