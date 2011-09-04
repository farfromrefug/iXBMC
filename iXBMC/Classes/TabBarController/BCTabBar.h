@class BCTab;

@protocol BCTabBarDelegate;

@interface BCTabBarArrow : UIView {
}
@end

@interface BCTabBar : UIView {
	NSArray *tabs;
	BCTab *selectedTab;
	UIImage *backgroundImage;
	BCTabBarArrow *arrow;
	id <BCTabBarDelegate> delegate;
}

- (id)initWithFrame:(CGRect)aFrame;
- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated;

@property (nonatomic, retain) NSArray *tabs;
@property (nonatomic, retain) BCTab *selectedTab;
@property (nonatomic, assign) id <BCTabBarDelegate> delegate;
@property (nonatomic, retain) BCTabBarArrow *arrow;
@property (nonatomic, assign) BOOL isInvisible;
@end

@protocol BCTabBarDelegate
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;
@end