#import <Foundation/Foundation.h>

@class BCTab;
@interface UINavigationController (BCTabBarController)

- (NSString *)iconTitle;
- (NSString *)iconImageName;
- (NSString *)selectedIconImageNameSuffix;
- (NSString *)landscapeIconImageNameSuffix;
- (void)setTabBarButton:(BCTab*) tabBarButton;
@end
