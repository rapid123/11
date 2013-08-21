//
//  RBLoadingOverlay.h
//  Red Beacon
//
//  Created by Jayahari V on 7/31/10.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RBLoadingOverlay : UIView {
		
	UIView *childView;
	UILabel *message;
	UILabel *stickyMessage;
	UIActivityIndicatorView *indicator;
	
	BOOL pendingAnimation;
}

@property (nonatomic, retain) IBOutlet UIView *childView;
@property (nonatomic, retain) IBOutlet UILabel *stickyMessage;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

+(RBLoadingOverlay *)loadOverlayOnTopWithMessage:(NSString *)initialMessage animated:(BOOL)animated;
+(RBLoadingOverlay *)loadOverlayOnTopWithMessage:(NSString *)initialMessage title:(NSString *)title animated:(BOOL)animated;
+(RBLoadingOverlay *)loadOverView:(UIView *)baseView withMessage:(NSString *)initialMessage animated:(BOOL)animated;
+(RBLoadingOverlay *)loadOverView:(UIView *)baseView withMessage:(NSString *)initialMessage title:(NSString*)title animated:(BOOL)animated;
+(RBLoadingOverlay *)loadOverView:(UIView *)baseView 
					  withMessage:(NSString *)initialMessage 
							title:(NSString*)title 
						 animated:(BOOL)animated 
					centerMessage:(BOOL)centerMessage;
+(RBLoadingOverlay *)loadOverReportView:(UIView *)baseView withMessage:(NSString *)initialMessage animated:(BOOL)animated;
-(void)removeFromSuperview:(BOOL)animated;
-(void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)animateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;	
-(void)doRotation;
@end
