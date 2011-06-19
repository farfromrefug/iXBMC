
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class RecentEpisodeViewController;
@interface RecentlyAddedEpisodesViewController : TTViewController <UIScrollViewDelegate>
{   
    NSMutableArray *viewControllers;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    NSArray* _episodes;

    NSTimer * _rotateTimer;
	
	
	BOOL _forceUpdate;
    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
}
@property (nonatomic, retain)   NSArray* episodes;
@property (nonatomic, retain)  UIScrollView* scrollView;
@property (nonatomic, retain)  UIPageControl* pageControl;

@property (nonatomic, retain) NSMutableArray *viewControllers;

-(int) nbEpisodes;

- (void)configurePage:(RecentEpisodeViewController *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (RecentEpisodeViewController *)dequeueRecycledPage;



@end