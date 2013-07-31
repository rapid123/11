//
//  InboxTableViewCell.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InboxTableViewCell.h"
#import "GeneralClass.h"
#import "MsgRecipient.h"
#import "DateFormatter.h"

@implementation InboxTableViewCell

@synthesize mailBoxImage;
@synthesize patientLabel,subjectLabel,pNameContentLabel,subjectContentLabel,dateLabel,fromLabel;

#pragma mark- Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark - awakeFromNib
-(void)awakeFromNib{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.patientLabel.font = [GeneralClass getFont:customNormal and:regularFont];
    patientLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    self.subjectLabel.font = [GeneralClass getFont:customNormal and:regularFont];
    subjectLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
    self.pNameContentLabel.font = [GeneralClass getFont:customNormal and:regularFont];
    self.subjectContentLabel.font = [GeneralClass getFont:customNormal and:regularFont];   
    self.dateLabel.font = [GeneralClass getFont:customNormal and:regularFont];
    self.fromLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    dateLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark- Display
/*******************************************************************************
 *  Function Name:displayDetails.
 *  Purpose: To Show Inbox Message details.
 *  Parametrs:Inbox Object.
 *  Return Values:nil.
 ********************************************************************************/
- (void)displayDetails:(Inbox *)inbox
{      
    if([inbox.readStatus intValue] == 0)//unread
    {
        mailBoxImage.image = [UIImage imageNamed:@"newMsgImage.png"];
    }
    else 
    {
        mailBoxImage.image = [UIImage imageNamed:@"oldMsgImage.png"];
    }
    if(![inbox.patientFirstName isEqualToString:@"(null)"] && ![inbox.patientLastName isEqualToString:@"(null)"])
    {
        pNameContentLabel.text = [NSString stringWithFormat:@"%@ %@",inbox.patientFirstName,inbox.patientLastName];
    }else if([inbox.patientFirstName isEqualToString:@"(null)"] && ![inbox.patientLastName isEqualToString:@"(null)"]) {
        pNameContentLabel.text = [NSString stringWithFormat:@"%@",inbox.patientLastName];
    }else if(![inbox.patientFirstName isEqualToString:@"(null)"] && [inbox.patientLastName isEqualToString:@"(null)"]) {
        pNameContentLabel.text = [NSString stringWithFormat:@"%@",inbox.patientFirstName];
    }else{
        pNameContentLabel.text = @"";
        
    }

    NSLog(@"Patient Name==%@",pNameContentLabel.text);
    if(![inbox.subject isEqualToString:@"(null)"])
    {
         subjectContentLabel.text = inbox.subject;
    }
    else{
        subjectContentLabel.text = @"";
    }
    //subjectContentLabel.text = inbox.subject;
    NSLog(@"Fromlabeltext ====%@",fromLabel.text);
    NSString * senderName = inbox.senderName;
    fromLabel.text = senderName;
    dateLabel.text = [DateFormatter displayConvertedDateAsPerDeviceZone:inbox.date withFormat:@"MM/dd/yyyy hh:mm a"];
    NSLog(@"date : %@",dateLabel.text);
}


#pragma mark- Unload
-(void) dealloc
{
    [self setMailBoxImage:nil];
    [self setPNameContentLabel:nil];
    [self setSubjectContentLabel:nil];
    [self setDateLabel:nil];
    [self setFromLabel:nil];
}

@end
