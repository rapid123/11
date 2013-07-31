//
//  CustomTouchBaseDetailCell.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comments.h"
#import "TouchBase.h"

@interface CustomTouchBaseDetailCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *touchBaseStatusImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *commentActivityIndicator;

- (void)displayCommentsDetails:(Comments *)comments;
- (void)displayDiscussionDetails:(TouchBase *)touchBase;
//-(void)showNewCommentIndicator;

@end
