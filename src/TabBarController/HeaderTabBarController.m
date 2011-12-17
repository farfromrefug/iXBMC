#import "HeaderTabBarController.h"
#import "AppDelegate.h"
#import "StyleSheet.h"
#import "ConnectionActivityLabel.h"
#import "LibraryUpdater.h"
#import "NPWidgetController.h"

#define kBottomViewHeight     100

@implementation HeaderTabBarController
@synthesize headerVisible = _headerVisible;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController (TTCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)rootControllerForController:(UIViewController*)controller {
    if ([controller canContainControllers]) {
        return controller;
        
    } else {
        TTNavigationController* navController = [[[TTNavigationController alloc] init] autorelease];
        [navController pushViewController:controller animated:NO];
        return navController;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canContainControllers {
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)topSubcontroller {
    return _tabBarController.selectedViewController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated
              transition:(UIViewAnimationTransition)transition {
    _tabBarController.selectedViewController = controller;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)bringControllerToFront:(UIViewController*)controller animated:(BOOL)animated {
    _tabBarController.selectedViewController = controller;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)keyForSubcontroller:(UIViewController*)controller {
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)subcontrollerForKey:(NSString*)key {
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)persistNavigationPath:(NSMutableArray*)path {
    UIViewController* controller = _tabBarController.selectedViewController;
    [[TTNavigator navigator] persistController:controller path:path];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTabURLs:(NSArray*)URLs {
    [_tabBarController setTabURLs:URLs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
	_bottomViewVisible = FALSE;
	
    _tabBarController = [[MyTabBarController alloc] init];
    _tabBarController.view.frame = self.view.frame;
	[self setTabURLs:[NSArray arrayWithObjects:@"tt://gesture",
                      @"tt://library/movies/1",
                      @"tt://library/tvshows/1",
                      @"tt://videos",
                      @"tt://settings",
                      nil]];
    _tabBarController.surrogateParent  = self;
    [self.view addSubview:_tabBarController.view];
    
    _connectionlabel = [[ConnectionActivityLabel alloc] init];
    
    [_connectionlabel sizeToFit];
    const CGFloat headerViewHeight = TTSTYLEVAR(headerViewHeight);
    _connectionlabel.frame = CGRectMake(0, 0, self.view.width, headerViewHeight);
    
    _connectionlabel.userInteractionEnabled = NO;
    _connectionlabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                    | UIViewAutoresizingFlexibleTopMargin);
    [self.view insertSubview:_connectionlabel belowSubview:_tabBarController.view];

    _tabBarController.view.autoresizingMask = UIViewAutoresizingNone;
	
	_bottomViewController = [[NPWidgetController alloc] init];
    _bottomViewController.view.frame = CGRectMake(0, self.view.height, self.view.width, kBottomViewHeight);
    [self.view addSubview:_bottomViewController.view];
	
	UISwipeGestureRecognizer* recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer1.direction = UISwipeGestureRecognizerDirectionUp;
	UISwipeGestureRecognizer* recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer2.direction = UISwipeGestureRecognizerDirectionDown;
	
//    [_tabBarController.tabBar addGestureRecognizer:recognizer1];
//    [_tabBarController.tabBar addGestureRecognizer:recognizer2];
	
	for (BCTab *tab in _tabBarController.tabBar.tabs) {
		[_tabBarController.tabBar addGestureRecognizer:recognizer1];
		[_tabBarController.tabBar addGestureRecognizer:recognizer2];
	}
    [recognizer1 release];
    [recognizer2 release];
//	
//	UIButton *remoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	
//	[remoteButton setBackgroundColor:[UIColor clearColor]];
//    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(hostChanged:)
     name:@"hostChanged"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(disconnectedFromXBMC:)
     name:@"DisconnectedFromXBMC"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(connectedToXBMC:)
     name:@"ConnectedToXBMC"
     object:nil ];
 
    [center
     addObserver:self
     selector:@selector(libraryUpdateStarted:)
     name:@"updatingLibrary"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(libraryUpdateFinished:)
     name:@"updatedLibrary"
     object:nil ];
    
    if (self.navigationController) { 
        self.navigationController.navigationBar.tintColor = 
        TTSTYLEVAR(navigationBarTintColor); 
    } 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    [_connectionlabel removeFromSuperview];
    TT_RELEASE_SAFELY(_connectionlabel);
    [_tabBarController.view removeFromSuperview];
    TT_RELEASE_SAFELY(_tabBarController);
	[_bottomViewController.view removeFromSuperview];
    TT_RELEASE_SAFELY(_bottomViewController);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_connectionlabel);
    TT_RELEASE_SAFELY(_tabBarController);
    TT_RELEASE_SAFELY(_bottomViewController);
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tabBarController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [_tabBarController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    [_tabBarController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [_tabBarController viewDidDisappear:animated];
}

- (void)showHeaderMainThread
{
    if (_headerVisible) return;
    
    bool animated = true;
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:TT_TRANSITION_DURATION];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }
    _tabBarController.view.frame = CGRectMake(0, 
                                              TTSTYLEVAR(headerViewHeight)
                                              , self.view.width
                                              , self.view.height 
                                              - TTSTYLEVAR(headerViewHeight));
    if (animated) {
        [UIView commitAnimations];
    }
    _headerVisible = true;
}

- (void)showHeader
{
    // Hide the HUD in the main tread 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHeaderMainThread];
    });
}

- (void)hideHeaderMainThread
{
    if (_headerVisible)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:TT_TRANSITION_DURATION];
        _tabBarController.view.frame = CGRectMake(0, 
                                                  0
                                                  , self.view.width
                                                  , self.view.height);
        [UIView commitAnimations];
        _headerVisible = false;
    }
}

- (void)hideHeader
{
    // Hide the HUD in the main tread 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHeaderMainThread];
    });
}

- (void)setDisconnectedHeader
{
    [self showHeader];
    _connectionlabel.text = @"Disconnected";
    [_connectionlabel setIsAnimating:FALSE];
    
}

- (void)startConnectingAnimation 
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showConnectionFailure) object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults valueForKey:@"currenthost"]
        || ![[defaults objectForKey:@"hosts"] valueForKey:[defaults valueForKey:@"currenthost"]]) 
    {
        [self setDisconnectedHeader];
        
        return;
    }

    [self showHeader];
    [_connectionlabel setIsAnimating:TRUE];
    _connectionlabel.text = [NSString stringWithFormat:@"connecting to %@...", [defaults valueForKey:@"currenthost"]];
    [self performSelector:@selector(showConnectionFailure) withObject:nil afterDelay:10.0];
}

- (void)showConnectionFailure
{
    [self showHeader];
    _connectionlabel.text = @"Connection Failure";
    [_connectionlabel setIsAnimating:FALSE];
    [self performSelector:@selector(setDisconnectedHeader) withObject:nil afterDelay:1.0];
}



- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [self setDisconnectedHeader];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showConnectionFailure) object:nil];
    
    [self showHeader];
    if (![_connectionlabel.text isEqualToString:@"Updating Library..."])
    {
        _connectionlabel.text = @"Connected";
        [_connectionlabel setIsAnimating:FALSE];
        [self performSelector:@selector(hideHeader) withObject:nil afterDelay:1.0];
    }
}

- (void)hostChanged: (NSNotification *) notification
{
    [self startConnectingAnimation];
}

- (void) libraryUpdateStarted: (NSNotification *) notification 
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHeader) object:nil];
    
    [self showHeader];
    _connectionlabel.text = @"Updating Library...";
    [_connectionlabel setIsAnimating:TRUE];
}

- (void) libraryUpdateFinished: (NSNotification *) notification 
{
    [self hideHeader];
    [_connectionlabel setIsAnimating:FALSE];

}

- (void)handleTap:(UILongPressGestureRecognizer *)recognizer 
{
	if ([_tabBarController selectedIndex] == 0)
	{
		[[[self topSubcontroller] topSubcontroller].navigationController popViewControllerAnimated:YES];
//		[_tabBarController.selectedViewController.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		[_tabBarController setSelectedIndex:0];
	}
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) 
    {
//        [XBMCCommand send:@"down"];
		[self hideBottomView];
		
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) 
    {
		[self showBottomView];
//        [XBMCCommand send:@"up"];
		
//		[_tabBarController.tabBarView setNeedsLayout];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
    {
//        [XBMCCommand send:@"left"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) 
    {
//        [XBMCCommand send:@"right"];
    }
}

- (void)hideBottomView
{
	if (_bottomViewVisible == FALSE) return;
//	_tabBarController.tabBar.transform = CGAffineTransformIdentity;
	[UIView animateWithDuration:0.1
					 animations:^{
						 _tabBarController.tabBar.transform = CGAffineTransformIdentity;
						_bottomViewController.view.transform = CGAffineTransformIdentity;}
					 completion:^(BOOL finished){
						_bottomViewVisible = FALSE;
	}];
}

- (void)showBottomView
{
	if (_bottomViewVisible == TRUE) return;
	_tabBarController.tabBar.transform = CGAffineTransformIdentity;
	[UIView animateWithDuration:0.1
					 animations:^{_tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0.0,- kBottomViewHeight);
						 _bottomViewController.view.transform = CGAffineTransformMakeTranslation(0.0,
						 - kBottomViewHeight);}
					 completion:^(BOOL finished){
//						 _tabBarController.tabBar.transform = CGAffineTransformIdentity;
						 _bottomViewVisible = TRUE;
					 }];
}




@end
