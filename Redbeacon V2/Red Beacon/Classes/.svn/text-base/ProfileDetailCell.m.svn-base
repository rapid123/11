//
//  ProfileDetailCell.m
//  Red Beacon
//
//  Created by sudeep on 13/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ProfileDetailCell.h"


@implementation ProfileDetailCell

@synthesize profileDetailCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tzvFrame = CGRectMake(0.0, 0.0, 
                                     self.contentView.bounds.size.width,
                                     self.contentView.bounds.size.height);
        profileDetailCellView = [[ProfileDetailCellView alloc] initWithFrame:tzvFrame];
        profileDetailCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:profileDetailCellView];
        [profileDetailCellView release];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark cell dispay

- (void)displayCellWithDetails:(id)item withKey:(NSString *)key{
    
    [profileDetailCellView displayCellItems:item withKey:key];
}



@end
