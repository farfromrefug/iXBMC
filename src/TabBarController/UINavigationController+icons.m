#import "UINavigationController+icons.h"
#import "UIViewController+iconImage.h"

@implementation UINavigationController (BCTabBarController)

- (NSString *)iconTitle {
	return [[self.viewControllers objectAtIndex:0] iconTitle];
}

- (NSString *)iconImageName {
	return [[self.viewControllers objectAtIndex:0] iconImageName];
}

- (NSString *)selectedIconImageNameSuffix {
	return [[self.viewControllers objectAtIndex:0] selectedIconImageNameSuffix];
}

- (NSString *)landscapeIconImageNameSuffix {
	return [[self.viewControllers objectAtIndex:0] landscapeIconImageNameSuffix];
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
	[[self.viewControllers objectAtIndex:0] setTabBarButton:tabBarButton];
}
@end
