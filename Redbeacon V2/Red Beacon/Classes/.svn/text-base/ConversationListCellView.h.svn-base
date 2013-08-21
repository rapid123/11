//
//  ConversationListCellView.h
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobBids.h"
#import "JobResponseDetails.h"

@interface ConversationListCellView : UIView {
    
    JobBids *content;
    JOBQAS *jobQAS;
    JobResponseDetails *jobResponse;
    UIImage * readImage;
    
    
    BOOL editing;
}
@property(nonatomic, retain) JobBids *content;
@property (nonatomic, getter=isEditing) BOOL editing;


- (void)setCellForDisplay:(id)contents;

@end
