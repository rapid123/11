//
//  ReviewDetailCell.m
//  Red Beacon
//
//  Created by sudeep on 21/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ReviewDetailCell.h"


@implementation ReviewDetailCell

@synthesize reviewDetailCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tzvFrame = CGRectMake(0.0, 0.0, 
                                     self.contentView.bounds.size.width,
                                     self.contentView.bounds.size.height);
        reviewDetailCellView = [[ReviewDetailCellView alloc] initWithFrame:tzvFrame];
        reviewDetailCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:reviewDetailCellView];
        [reviewDetailCellView release];
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

- (void)displayCellWithDetails:(id)item {
    
    [reviewDetailCellView displayCellItems:item];
}

- (void)displayGraph:(id)rateDistribution {
    
    [reviewDetailCellView displayGraph:rateDistribution];
}

@end
