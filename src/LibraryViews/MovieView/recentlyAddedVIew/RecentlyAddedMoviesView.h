
@interface RecentlyAddedMoviesView : TTView {
    UIScrollView* _scrollView;
    UIPageControl* _pageControl;
}
@property (nonatomic, retain)   UIScrollView* scrollView;
@property (nonatomic, retain)   UIPageControl* pageControl;

@end
