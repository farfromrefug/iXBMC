
@class BCTab;
@interface UIViewController (BCTabBarController)

- (NSString *)iconTitle;
- (NSString *)iconImageName;
- (NSString *)selectedIconImageNameSuffix;
- (NSString *)landscapeIconImageNameSuffix;
- (void)setTabBarButton:(BCTab*) tabBarButton;
@end
