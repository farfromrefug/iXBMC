
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class RecentMovieViewController;
@interface RecentlyAddedViewController : TTViewController <UIScrollViewDelegate>
{   
    NSMutableArray *viewControllers;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    NSArray* _movies;

    NSTimer * _rotateTimer;
	
	
	
//    UIScrollView *pagingScrollView;
    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	// these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
//    int           firstVisiblePageIndexBeforeRotation;
//    CGFloat       percentScrolledIntoFirstVisiblePage;
}
@property (nonatomic, retain)   NSArray* movies;
@property (nonatomic, retain)  UIScrollView* scrollView;
@property (nonatomic, retain)  UIPageControl* pageControl;

@property (nonatomic, retain) NSMutableArray *viewControllers;

-(int) nbMovies;
//- (void)setCenterPageIndex:(NSInteger)centerPageIndex;
//- (IBAction)changePage:(id)sender;
//- (void)stopRotate;

- (void)configurePage:(RecentMovieViewController *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (RecentMovieViewController *)dequeueRecycledPage;



@end