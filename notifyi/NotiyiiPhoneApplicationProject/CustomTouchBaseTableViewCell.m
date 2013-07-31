//
//  CustomTouchBaseTableViewCell.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTouchBaseTableViewCell.h"
#import "Comments.h"
#import "DiscussionParticipants.h"
#import "GeneralClass.h"
#import "DateFormatter.h"
@interface CustomTouchBaseTableViewCell ()
{
    IBOutlet UILabel *discussionTopicLabel;
    IBOutlet UILabel *discussionPersonsLabel;
    IBOutlet UILabel *discussionSubjectLabel;
    IBOutlet UILabel *discussionLastUpdateLabel;
    IBOutlet UILabel *discussionDateLabel;
    IBOutlet UILabel *discussionDetailsLabel;
    
    NSMutableArray *discussionNameArray;
    Comments *comments;
    DiscussionParticipants *discussionParticipants;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)displayDetails:(TouchBase *)touchBase;

@end

@implementation CustomTouchBaseTableViewCell

#pragma mark- Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark- awakeFromNib
-(void)awakeFromNib
{
    discussionTopicLabel.font = [GeneralClass getFont:customNormal and:regularFont];
    discussionPersonsLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    discussionSubjectLabel.font = [GeneralClass getFont:customNormal and:regularFont];
    discussionLastUpdateLabel.font = [GeneralClass getFont:customMedium and:regularFont];
    discussionDateLabel.font = [GeneralClass getFont:customMedium and:regularFont];
    discussionDetailsLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    discussionTopicLabel.textColor = [UIColor blackColor];
    discussionSubjectLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    discussionLastUpdateLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    discussionDateLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    discussionPersonsLabel.textColor = [UIColor blackColor];
    discussionDetailsLabel.textColor = [UIColor colorWithRed:GreyBackGround_RedColor green:GreyBackGround_GreenColor blue:GreyBackGround_BlueColor alpha:1];
}

#pragma mark- Methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark- Display
/*******************************************************************************
 *  Function Name: displayDetails.
 *  Purpose: To display touchbase table cell details.
 *  Parametrs: TouchBase Object.
 *  Return Values:nil.
 ********************************************************************************/
- (void)displayDetails:(TouchBase *)touchBase
{
    if(touchBase)
    {
        discussionTopicLabel.text = touchBase.subject;
        discussionPersonsLabel.text = touchBase.subject;
        
        NSArray *CommentArr = [touchBase.commentID allObjects];
        
        NSLog(@"CommentArr : %@",CommentArr);
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"commentDate" ascending:NO];
        NSArray *commentTempArr = [CommentArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
        
        if([commentTempArr count] > 0)
        {
            Comments *obj = [commentTempArr objectAtIndex:0];
            NSLog(@"commentDate : %@",obj.commentDate);
            discussionDetailsLabel.text = obj.comments;
            NSString * dateString = [DateFormatter displayConvertedDateAsPerDeviceZone:obj.commentDate withFormat:@"MM/dd/yyyy hh:mm a"];
            discussionDateLabel.text = dateString;
            NSLog(@"discussionDateLabel : %@",discussionDateLabel.text);
        }
        else
        {
            discussionDetailsLabel.text = touchBase.textDiscussion;
            discussionDateLabel.text = [DateFormatter displayConvertedDateAsPerDeviceZone:touchBase.discussionDate withFormat:@"MM/dd/yyyy hh:mm a"];
            NSLog(@"discussionDateLabel : %@",discussionDateLabel.text);
        }
        if(discussionNameArray)
        {
            discussionNameArray = nil;
        }
        discussionNameArray = [[NSMutableArray alloc]init];
        
        
        NSArray *participantsArr = [touchBase.participantsID allObjects];
        
        for (int i = 0; i < [participantsArr count]; i++)
        {
            discussionParticipants = (DiscussionParticipants *)[participantsArr objectAtIndex:i];
            if(discussionParticipants.participantName)
            {
                [discussionNameArray addObject:discussionParticipants.participantName];
            }
        }
        
        NSString *discussionParticipantStr = [discussionNameArray componentsJoinedByString:@", "];
        discussionPersonsLabel.text = discussionParticipantStr;
        
    }
}
@end
