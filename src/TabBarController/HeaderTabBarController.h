#import <Three20/Three20.h>
#import "MyTabBarController.h"
//#import "CustomTabBarViewController.h"

@class ConnectionActivityLabel;
@class NPWidgetController;
@interface HeaderTabBarController : UIViewController {
    ConnectionActivityLabel* _connectionlabel;
    
    MyTabBarController* _tabBarController;
	
	NPWidgetController* _bottomViewController;
//    CustomTabBarViewController* _tabBarController;
    
    BOOL _headerVisible;
	BOOL _bottomViewVisible;
}
@property (nonatomic) BOOL headerVisible;

- (void)setDisconnectedHeader;

- (void)setTabURLs:(NSArray*)URLs;
- (void)showHeader;
- (void)hideHeader;

- (void)showBottomView;
- (void)hideBottomView;

@end
