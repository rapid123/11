//
//  CustomDirectoryCell.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomDirectoryCell.h"
#import "GeneralClass.h"

@implementation CustomDirectoryCell
@synthesize thumbImageView;
@synthesize nameLabel,specialityLabel,cityLabel;

#pragma mark- Init Load
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/*******************************************************************************
 *  Function Name: awakeFromNib.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values: nil
 ********************************************************************************/
-(void)awakeFromNib
{
    self.nameLabel.font = [GeneralClass getFont:  customRegular and:boldFont];
    self.specialityLabel.font = [GeneralClass getFont:  buttonFont and:regularFont];
    self.cityLabel.font = [GeneralClass getFont:  customNormal and:regularFont];
    self.nameLabel.textColor = [UIColor blackColor];
    self.specialityLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    self.cityLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
}

#pragma mark- Display
/*******************************************************************************
 *  Function Name: displayDetails.
 *  Purpose: To display the directory details.
 *  Parametrs: directory Object.
 *  Return Values: nil
 ********************************************************************************/
-(void)displayDetails:(Directory *)directory
{      
    if (directory)
    {
        NSLog(@"physicianName==%@",directory.physicianName);
        Directory * directoryObject;
        directoryObject = directory;
        nameLabel.text = directoryObject.physicianName;
        specialityLabel.text = directory.speciality;
        if([directory.city isEqualToString:@"NULL"] && [directory.state isEqualToString:@"NULL"])
        {
            cityLabel.text = @"";
        }
        else if ([directory.city isEqualToString:@"NULL"] && ![directory.state isEqualToString:@"NULL"])
        {
            cityLabel.text = [NSString stringWithFormat:@"%@",directory.state];
        }
        else if (![directory.city isEqualToString:@"NULL"] && [directory.state isEqualToString:@"NULL"])
        {
            cityLabel.text = [NSString stringWithFormat:@"%@",directory.city];
        }
        else
        {
            cityLabel.text = [NSString stringWithFormat:@"%@, %@",directory.city,directory.state];
        }

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
#pragma mark- Unload
-(void) dealloc
{
    [self setNameLabel:nil];
    [self setCityLabel:nil];
    [self setSpecialityLabel:nil];
}

@end
