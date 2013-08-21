//
//  RVSlider.m
//  Sample
//
//  Created by sudeep on 03/05/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "RVSlider.h"
#import	 "VImageView.h"
#import "JobResponseDetails.h"
#import "JobBids.h"

#define SLIDER_THUMBNAIL_WIDTH 50
#define SLIDER_THUMBNAIL_HEIGHT 50
#define SLIDER_THUMBNAIL_INSET 6
#define SLIDER_LABEL_WIDTH SLIDER_THUMBNAIL_WIDTH
#define SLIDER_LABEL_HEIGHT 32
#define SLIDER_BACKGROUND_COLOR [UIColor whiteColor];
#define SLIDER_THUMBNAIL_OVERLAY_TAG 853373



@interface RVThumbnailContainer : UIView {
    VImageView* thumbnail;
}

@property (nonatomic, assign) VImageView* thumbnail;

@end

@implementation RVThumbnailContainer

@synthesize thumbnail;

- (void) dealloc {
    [thumbnail dealloc];
    [super dealloc];
}

@end


@implementation RVSlider


@synthesize sliderDelegate;
@synthesize currentIndex;

- (id) initWithFrame: (CGRect) frame playables: (NSArray*) playables tag: (int) tag {
    if ((self = [super initWithFrame: frame])) {
        self.opaque = NO;
        self.backgroundColor = SLIDER_BACKGROUND_COLOR;
        
        self.delegate = self;
        self.scrollEnabled = YES;
		self.directionalLockEnabled = YES;
		self.canCancelContentTouches = YES;
		self.delaysContentTouches = NO;
		self.scrollsToTop = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
        self.tag = tag;
		
        focusedIndex = -1;
		currentIndex = 0;
        
        // this is the entire slider - wide enough to hold all thumbnails
        self.contentSize = CGSizeMake ((SLIDER_THUMBNAIL_WIDTH * [playables count]) + frame.size.width - SLIDER_THUMBNAIL_WIDTH,
                                       SLIDER_THUMBNAIL_HEIGHT);
        
        urls = [[NSMutableArray alloc] initWithCapacity:[playables count]];
		
        for (WorkImage *image in playables) {
            [urls addObject:[image thumbnail_url] ? [image thumbnail_url] : @""];
        }
        
        for (int i = 0; i < [playables count]; i++) {
            //WorkImage *image = [playables objectAtIndex: i];
            CGRect containerFrame = CGRectMake (0, 0, SLIDER_THUMBNAIL_WIDTH , SLIDER_THUMBNAIL_HEIGHT );
            RVThumbnailContainer* container = [[RVThumbnailContainer alloc] initWithFrame: containerFrame];
            float x = (i * SLIDER_THUMBNAIL_WIDTH) + 80;
            container.center = CGPointMake (x, SLIDER_THUMBNAIL_HEIGHT / 2);
            container.tag = i;
            [self addSubview: container];
            [container release];
            
            CGRect thumbnailFrame = CGRectInset (CGRectMake (0, 0, SLIDER_THUMBNAIL_WIDTH , SLIDER_THUMBNAIL_HEIGHT), SLIDER_THUMBNAIL_INSET, SLIDER_THUMBNAIL_INSET);
            VImageView* thumbnail = [[VImageView alloc] initWithFrame: thumbnailFrame];
            thumbnail.delegate = self;
            [container addSubview: thumbnail];
            container.thumbnail = thumbnail;
            [thumbnail release];
            thumbnail.url = [urls objectAtIndex: i];
            [thumbnail materializeAtPriority: NSOperationQueuePriorityNormal];
            [thumbnail loadImageWithPath];
        }
    }
    return self;
}


- (void) startAutoScroll {
    if (!autoScrollStarted) {
        autoScrollStarted = YES;
        [self performSelector: @selector (autoScroll) withObject: nil afterDelay: 5.0];
    }
}

- (void) autoScroll {
    int next_index = currentIndex + 1;
    if (next_index >= [urls count]) next_index = 0;
	
    [self scrollToIndex: next_index animated: YES];
    [self performSelector: @selector (autoScroll) withObject: nil afterDelay: 5.0];
}

- (void) stopAutoScroll {
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector (autoScroll) object: nil];
}

- (int) selectedIndex {
	int index = (self.contentOffset.x + (SLIDER_THUMBNAIL_WIDTH / 2)) / SLIDER_THUMBNAIL_WIDTH;
    
	// Weird case when we really rubberband
	if (index >= urls.count) {
		return urls.count - 1;
	} else if (index < 0) {
		return 0;
	}
    
	return index;
}

- (void) snapToIndex: (int) index animated: (BOOL) animated {
    float x = trunc (index * SLIDER_THUMBNAIL_WIDTH);
    [self setContentOffset: CGPointMake (x, 0) animated: animated];
}

- (void) scrollToIndex: (int) index animated: (BOOL) animated {
    focusedIndex = index;
    currentIndex = index;
    [self snapToIndex: focusedIndex animated: animated];
}

- (void) setCurrentAsFocused: (BOOL) animated {
    [self scrollToIndex: [self selectedIndex] animated: animated];
}

- (void) setCurrentAsUnfocused: (BOOL) animated {
}

- (void) scrollToOffset: (float) offset animated: (BOOL) animated {
    [self setContentOffset: CGPointMake (offset, 0) animated: animated];
    [self scrollToIndex: [self selectedIndex] animated: animated];
}

- (void) didClickImageView: (VImageView*) thumbnailView {
    //[self stopAutoScroll];
	
    if ([((NSObject*) sliderDelegate) respondsToSelector: @selector (slider:thumbnailClicked:)]) {
        [sliderDelegate slider: self thumbnailClicked: thumbnailView.superview.tag];
    }
}

- (void) imageLoaded: (VImageView*) thumbnailView {
    UIView* overlay = [thumbnailView.superview viewWithTag: SLIDER_THUMBNAIL_OVERLAY_TAG];
    if (overlay != nil) {
        overlay.hidden = NO;
        [overlay.superview bringSubviewToFront: overlay];
    }
}

- (void) scrollViewWillBeginDragging: (UIScrollView*) scrollView {
    //[self stopAutoScroll];
    focusedIndex = -1;
}

- (void) scrollViewDidEndDragging: (UIScrollView*) scrollView willDecelerate: (BOOL) decelerate {
    if (!decelerate) {
        [self setCurrentAsFocused: YES];
    }
}

- (void) scrollViewDidEndDecelerating: (UIScrollView*) scrollView {
    [self setCurrentAsFocused: YES];
}

- (void) scrollViewDidScroll: (UIScrollView*) scrollView {
	
    int index = [self selectedIndex];
    
    if (index != currentIndex) {
        currentIndex = index;
    }
}

- (void) dealloc {
    [urls release];
    [super dealloc];
}

@end
