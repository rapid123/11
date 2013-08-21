//
//  RVSlider.h
//  Sample
//
//  Created by sudeep on 03/05/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VImageView.h"

@protocol RVSliderDelegate;

@interface RVSlider : UIScrollView <UIScrollViewDelegate,VImageViewDelegate> {

	id<RVSliderDelegate> sliderDelegate;
	NSMutableArray *urls;
	int focusedIndex;
	int currentIndex;
	BOOL autoScrollStarted;

}

@property (nonatomic, assign) id<RVSliderDelegate> sliderDelegate;
@property (nonatomic, readonly) int currentIndex;

- (id) initWithFrame: (CGRect) frame playables: (NSArray*) playables tag: (int) tag;
- (void) scrollToIndex: (int) index animated: (BOOL) animated;
- (void) scrollToOffset: (float) offset animated: (BOOL) animated;
- (void) startAutoScroll;

@end

@protocol RVSliderDelegate
@optional
- (void) slider: (RVSlider*) slider thumbnailClicked: (int) index;
@end
