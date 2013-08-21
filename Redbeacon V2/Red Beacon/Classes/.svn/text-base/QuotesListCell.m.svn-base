//
//  QuotesListCell.m
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "QuotesListCell.h"


@implementation QuotesListCell

@synthesize quotesListCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tzvFrame = CGRectMake(0.0, 0.0, 
                                     self.contentView.bounds.size.width,
                                     self.contentView.bounds.size.height-1);
        quotesListCellView = [[QuotesListCellView alloc] initWithFrame:tzvFrame];
        quotesListCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:quotesListCellView];
        [quotesListCellView release];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        backgroundImageView  = [[UIImageView alloc] initWithImage:nil];
        backgroundImageView.frame = CGRectMake(0.0, 0.0, 
                                               self.contentView.bounds.size.width,
                                               79);
        [self addSubview:backgroundImageView];
       // [backgroundImageView release];
        
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

#pragma mark cell dispay

- (void)displayCellItems:(id)item{
    
    [quotesListCellView displayCellItems:item];
}

- (void)dealloc
{
    [backgroundImageView release];
    [super dealloc];
}

@end
