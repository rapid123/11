//
//  ConversationListCell.m
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ConversationListCell.h"


@implementation ConversationListCell

@synthesize conversationListCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tzvFrame = CGRectMake(0.0, 0.0, 
                                     self.contentView.bounds.size.width,
                                     self.contentView.bounds.size.height);
        conversationListCellView = [[ConversationListCellView alloc] initWithFrame:tzvFrame];
        conversationListCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:conversationListCellView];
        [conversationListCellView release];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        backgroundImageView  = [[UIImageView alloc] initWithImage:nil];
        backgroundImageView.frame = CGRectMake(0.0, 0.0, 
                                               self.contentView.bounds.size.width,
                                               65);

        [self addSubview:backgroundImageView];
    }
        
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        //backgroundImageView.frame= self.frame;
        [backgroundImageView setBackgroundColor:[UIColor lightGrayColor]];
        [backgroundImageView setAlpha:0.5];
    }
    else    {
        [backgroundImageView setBackgroundColor:[UIColor clearColor]];
    }
    // Configure the view for the selected state
}

- (void)setCellForDisplay:(id)content {

    [conversationListCellView setCellForDisplay:content];    
    
}

- (void)dealloc
{
    [backgroundImageView release];
    [conversationListCellView removeFromSuperview];
    [super dealloc];
}

@end
