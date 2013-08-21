//
//  QuotesListCell.h
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuotesListCellView.h"

@interface QuotesListCell : UITableViewCell {
    
    QuotesListCellView *quotesListCellView;
    UIImageView *backgroundImageView;
}

@property(nonatomic, retain) QuotesListCellView *quotesListCellView;

- (void)displayCellItems:(id)item;

@end
