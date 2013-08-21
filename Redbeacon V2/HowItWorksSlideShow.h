

#import <UIKit/UIKit.h>

@interface HowItWorksSlideShow : UIViewController<UIScrollViewDelegate> {

    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *slideImageViews;
    BOOL pageControlUsed;
    int currentPage;
    
}

@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;
- (IBAction)gotoPreviousPage:(id)sender;
- (IBAction)gotoNextPage:(id)sender;

@end

