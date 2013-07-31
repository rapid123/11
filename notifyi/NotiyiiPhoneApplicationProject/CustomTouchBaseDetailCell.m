//
//  CustomTouchBaseDetailCell.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTouchBaseDetailCell.h"
#import "GeneralClass.h"
#import "Utilities.h"
#import "DateFormatter.h"

@implementation CustomTouchBaseDetailCell
@synthesize touchBaseStatusImageView;
@synthesize commentActivityIndicator;
@synthesize nameLabel,bodyTextView,dateLabel;



#pragma mark- Init Load
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.nameLabel.font = [GeneralClass getFont:customRegular and:boldFont];
    self.bodyTextView.font = [GeneralClass getFont:customNormal and:regularFont];
    self.dateLabel.font = [GeneralClass getFont:customMedium and:boldFont];
    self.dateLabel.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    self.nameLabel.textColor = [UIColor blackColor];
    self.bodyTextView.textColor = [UIColor blackColor];
    self.bodyTextView.delegate = self;
    self.bodyTextView.keyboardAppearance = NO;
    self.bodyTextView.editable = NO;
}

#pragma mark- Display
/*******************************************************************************
 *  Function Name: displayCommentsDetails.
 *  Purpose: To display comments details.
 *  Parametrs: comments Object.
 *  Return Values:nil
 ********************************************************************************/
- (void)displayCommentsDetails:(Comments *)comments
{
    //    NSString * user = comments.commentPersonName;
    //    if ([user rangeOfString:@"@"].location == NSNotFound)
    //    {
    //        nameLabel.text = user;
    //    }
    //    else
    //    {
    //        NSRange range = [user rangeOfString:@"@"];
    //        user = [[user substringToIndex:(NSMaxRange(range))-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //        nameLabel.text = user;
    //    }
    nameLabel.text = comments.commentPersonName;
    NSLog(@"comments === %@",comments);
    
    if([comments.commentStatus isEqualToString:@""])
    {
        
        if([comments.commentPersonName isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"]])
        {
            if([comments.commentStatus intValue] == 1)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"directory_table.png"];
            }
            else if([comments.commentStatus intValue] == 0)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"directory_table.png"];
            }
            else if([comments.commentStatus intValue] == 2)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"directory_table.png"];
            }
        }
        else
        {
            bodyTextView.textColor = [UIColor blackColor];
            if([comments.commentStatus intValue] == 1)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"whiteBackGround.png"];
            }
            else if([comments.commentStatus intValue] == 0)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"whiteBackGround.png"];
                
            }
            else if([comments.commentStatus intValue] == 2)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"whiteBackGround.png"];
            }
        }
    }
    else
    {
        if([comments.commentPersonName isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileUserName"]])
        {
            if([comments.commentStatus intValue] == 1)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"sentStrip.png"];
            }
            else if([comments.commentStatus intValue] == 0)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"readStrip.png"];
                
            }
            else if([comments.commentStatus intValue] == 2)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"failStrip.png"];
            }
        }
        else
        {
            bodyTextView.textColor = [UIColor blackColor];
            if([comments.commentStatus intValue] == 1)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"user_sent.png"];
            }
            else if([comments.commentStatus intValue] == 0)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"user_read.png"];
                
            }
            else if([comments.commentStatus intValue] == 2)
            {
                touchBaseStatusImageView.image = [UIImage imageNamed:@"user_fail.png"];
            }
            
        }
    }
    NSLog(@"commentsDate : %@",comments.commentDate);
    dateLabel.text = [DateFormatter displayConvertedDateAsPerDeviceZone:comments.commentDate withFormat:@"MM/dd/yyyy hh:mm a"];
    NSLog(@"discussionDateLabel : %@",dateLabel.text);
    bodyTextView.text = comments.comments;
}

/*******************************************************************************
 *  Function Name: displayDiscussionDetails.
 *  Purpose: To display discussion details.
 *  Parametrs: touchBase Object.
 *  Return Values:nil
 ********************************************************************************/
- (void)displayDiscussionDetails:(TouchBase *)touchBase
{
    nameLabel.text = touchBase.discussionOwner;
    NSString * dateString = [DateFormatter displayConvertedDateAsPerDeviceZone:touchBase.discussionDate withFormat:@"MM/dd/yyyy hh:mm a"];
    dateLabel.text = dateString;
    NSLog(@"discussionDateLabel : %@",dateLabel.text);
    
    bodyTextView.text = touchBase.textDiscussion;
    touchBaseStatusImageView.image = [UIImage imageNamed:@"directory_table.png"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
