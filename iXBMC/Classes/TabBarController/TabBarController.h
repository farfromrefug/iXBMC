#import <Three20/Three20.h>
#import "MyTabBarController.h"
//#import "CustomTabBarViewController.h"

@class ConnectionActivityLabel;
@interface TabBarController : UIViewController<UIAlertViewDelegate> {
    ConnectionActivityLabel* _connectionlabel;
    
    MyTabBarController* _tabBarController;
//    CustomTabBarViewController* _tabBarController;
    
    BOOL _headerVisible;
}
@property (nonatomic) BOOL headerVisible;

- (void)setDisconnectedHeader;

- (void)setTabURLs:(NSArray*)URLs;
- (void)showHeader;
- (void)hideHeader;
@end
