  #import "AppDelegate.h"
#import "HeaderTabBarController.h"
#import "NotConnectedController.h"
#import "XBMCGestureController.h"
#import "RemoteViewController.h"
#import "AddServerViewController.h"

#import "SettingsViewController.h"
#import "DetailViewController.h"

#import "XBMCHttpInterface.h"
#import "XBMCJSONCommunicator.h"
#import "XBMCStateListener.h"
#import "LibraryUpdater.h"

#import "MovieViewController.h"
#import "TVShowsViewController.h"
#import "SeasonsViewController.h"
#import "EpisodesViewController.h"

#import "CustomMoviePlayerViewController.h"
#import "FullscreenImageViewController.h"

#import "FileSearchFeedViewController.h"

#import "ActiveManager.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UINavigationBar (MyCustomNavBar)
//- (void) drawRect:(CGRect)rect {
//    UIImage *barImage = TTIMAGE(@"bundle://navBack.png");
//    [barImage drawInRect:rect];
//}
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[TTSTYLEVAR(navBarBackColor) set];	
	CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 2));
	[TTSTYLEVAR(navBarBorderColor) set];
	CGContextFillRect(context, CGRectMake(0, self.bounds.size.height - 2, self.bounds.size.width, 2));
}
@end

@interface AppDelegate()
- (NSString *)applicationDocumentsDirectory;

@end


@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void) initDefaultValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([defaults valueForKey:@"images:highQuality"] == nil)
    {
        [defaults setValue:[NSNumber numberWithBool:TTSTYLEVAR(highQualityImages)] 
                    forKey:@"images:highQuality"];
    }
	if ([defaults valueForKey:@"cell:height"] == nil)
    {
        [defaults setValue:[NSNumber numberWithFloat:TTSTYLEVAR(cellHeight)] 
                    forKey:@"cell:height"];
    }
    if ([defaults valueForKey:@"movieCell:height"] == nil)
    {
        [defaults setValue:[NSNumber numberWithFloat:TTSTYLEVAR(movieCellHeight)] 
                    forKey:@"movieCell:height"];
    }
    if ([defaults valueForKey:@"movieCell:ratingStars"] == nil)
    {
        [defaults setValue:[NSNumber numberWithBool:TTSTYLEVAR(movieCellRatingStars)] 
                    forKey:@"movieCell:ratingStars"];
    }
	
	if ([defaults valueForKey:@"tvshowCell:height"] == nil)
    {
        [defaults setValue:[NSNumber numberWithFloat:TTSTYLEVAR(tvshowCellHeight)] 
                    forKey:@"tvshowCell:height"];
    }
    if ([defaults valueForKey:@"tvshowCell:ratingStars"] == nil)
    {
        [defaults setValue:[NSNumber numberWithBool:TTSTYLEVAR(tvshowCellRatingStars)] 
                    forKey:@"tvshowCell:ratingStars"];
    }
	
	if ([defaults valueForKey:@"seasonCell:height"] == nil)
    {
        [defaults setValue:[NSNumber numberWithFloat:TTSTYLEVAR(seasonCellHeight)] 
                    forKey:@"seasonCell:height"];
    }
	
	if ([defaults valueForKey:@"episodeCell:height"] == nil)
    {
        [defaults setValue:[NSNumber numberWithFloat:TTSTYLEVAR(episodeCellHeight)] 
                    forKey:@"episodeCell:height"];
    }
    if ([defaults valueForKey:@"episodeCell:ratingStars"] == nil)
    {
        [defaults setValue:[NSNumber numberWithBool:TTSTYLEVAR(episodeCellRatingStars)] 
                    forKey:@"episodeCell:ratingStars"];
    }
	
	if ([defaults valueForKey:@"tvshows:playAndEnqueue"] == nil)
    {
        [defaults setValue:[NSNumber numberWithBool:TRUE] 
                    forKey:@"tvshows:playAndEnqueue"];
    }
    
    if ([defaults valueForKey:@"currenthost"] == nil) 
    {
        [defaults setValue:@"" forKey:@"currenthost"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication*)application 
{  
    [TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
    [self initDefaultValues];
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];

//    HUD = nil;
    [[TTURLRequestQueue mainQueue] setMaxContentLength:20];
    [[TTURLCache sharedCache] setDisableDiskCache:FALSE];
    TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
  
    TTURLMap* map = navigator.URLMap;
  
    // Any URL that doesn't match will fall back on this one, and open in the web browser
    [map from:@"*" toViewController:[TTWebController class]];

    // The settings controller will appear as a modal view controller, animated from bottom to top.
    [map from:@"tt://settings" toSharedViewController:[SettingsViewController class]];
    
    [map from: @"tt://addserver" toViewController: [AddServerViewController class]];
    [map from: @"tt://addserver/(initWithHost:)" toViewController: [AddServerViewController class]];
    
    // The Not Connected is shared, meaning there will only ever be one created.  Loading
    // This URL will make the existing tab bar controller appear if it was not visible.
    ////    [map from:@"tt://notConnected" toModalViewController:[NotConnectedController class]];
    
    // The Not Connected is shared, meaning there will only ever be one created.  Loading
    // This URL will make the existing tab bar controller appear if it was not visible.
    [map from:@"tt://gesture" toSharedViewController:[XBMCGestureController class]];
    [map from:@"tt://remote" toSharedViewController:[RemoteViewController class]];
  
  // The tab bar controller is shared, meaning there will only ever be one created.  Loading
  // This URL will make the existing tab bar controller appear if it was not visible.
  [map from:@"tt://tabBar" toSharedViewController:[HeaderTabBarController class]];
  
  // Menu controllers are also shared - we only create one to show in each tab, so opening
  // these URLs will switch to the tab containing the menu
    [map from:@"tt://library/movies/(initWithWatched:)" toSharedViewController:[MovieViewController class]];
    [map from:@"tt://library/tvshows/(initWithWatched:)" toSharedViewController:[TVShowsViewController class]];
	[map from:@"tt://library/seasons/(initWithTVShow:)/(showWatched:)" toSharedViewController:[SeasonsViewController class]];
	
	[map from:@"tt://library/episodes/(initWithTVShow:)/(season:)/(showWatched:)" toSharedViewController:[EpisodesViewController class]];
	
	[map from:@"tt://details" toViewController:[DetailViewController class]];
	
	[map from:@"tt://videos" toSharedViewController:[FileSearchFeedViewController class]];
	[map from:@"tt://videosWithPath" toViewController:[FileSearchFeedViewController class]];
  
//  // By specifying the parent URL, we are saying that the tab containing menu #5 will be
//  // selected before opening this URL, ensuring that about controllers are only pushed
//  // inside the tab containing the about menu
//  [map from:@"tt://about/(initWithAbout:)" parent:@"tt://menu/5"
//       toViewController:[ContentController class] selector:nil transition:0];
//  
//  // This is an example of how to use a transition.  Opening the nutrition page will do a flip
//  [map from:@"tt://food/(initWithNutrition:)/nutrition" toViewController:[ContentController class]
//       transition:UIViewAnimationTransitionFlipFromLeft];
//       
//  // The ordering controller will appear as a modal view controller, animated from bottom to top
//  [map from:@"tt://order?waitress=(initWithWaitress:)"
//       toModalViewController:[ContentController class]];
  
  // This is a hash URL - it will simply invoke the method orderAction: on the order controller,
  // and it will open the order controller first if it was not already visible
//  [map from:@"tt://order?waitress=()#(orderAction:)" toViewController:[ContentController class]];
  
  // This will show the post controller to prompt to type in their order
//  [map from:@"tt://order/food" toViewController:[TTPostController class]];
  
  // This will call the confirmOrder method on this app delegate and ask it to return a
  // view controller to be opened.  In this case, it will return an alert view controller. 
  // This kind of URL mapping gives you the chance to configure your controller before
  // it is opened.
//  [map from:@"tt://order/confirm" toViewController:self selector:@selector(confirmOrder)];
//  
//  // This will simply call the sendOrder method on this app delegate
//  [map from:@"tt://order/send" toObject:self selector:@selector(sendOrder)];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(hostChanged:)
     name:@"hostChanged"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(deleteHost:)
     name:@"askToDeleteHost"
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
    


  // Before opening the tab bar, we see if the controller history was persisted the last time
  if (![navigator restoreViewControllers]) 
      {
          [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://tabBar"]];      
      }
    // This is the first launch, so we just start with the tab bar
    //[self hostChanged:nil]; 
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"hostChanged" 
     object:nil];
}

//
//- (void)showHUD
//{
//    if (!HUD)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // No need to hod onto (retain)
//            
//            // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
//            HUD = [MBProgressHUD showHUDAddedTo:[TTNavigator navigator].window animated:YES];
//            HUD.labelText = @"Connecting";
//            
//            // Add HUD to screen
//            //    [[TTNavigator navigator].window addSubview:HUD];
//            
//        });
//    }
//}
//
//- (void)hideHUD
//{
//    if (HUD)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//			[MBProgressHUD hideHUDForView:[TTNavigator navigator].window animated:YES];
//		});
//        HUD = nil;
//    }
//}
//
//- (void)startConnectingAnimation 
//{
//    [self showHUD];
//
//    [self performSelector:@selector(showConnectionFailure) withObject:nil afterDelay:10.0];
//}
//
//- (void)showConnectionFailure
//{
//    [self showHUD];
//    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-cross.png"]] autorelease];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.labelText = @"Failure";
//    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1.0];
//}



- (void)disconnectedFromXBMC: (NSNotification *) notification
{
//    if(![[[TTNavigator navigator] visibleViewController] isKindOfClass:[NotConnectedController class]])
//    {
//        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://notConnected"]];        
//    }
    [[LibraryUpdater sharedInstance] stop];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
//    [[LibraryUpdater sharedInstance] updateRecentlyAdded];

//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showConnectionFailure) object:nil];
//    [self showHUD];

//    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.labelText = @"Connected";
//    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.5];

//    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://gesture"]];        
    [[LibraryUpdater sharedInstance] start];
}


- (void)deleteHost: (NSNotification *) notification
{
    NSString* deletingHost = [[notification userInfo] objectForKey:@"name"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* hosts;
    if ([defaults objectForKey:@"hosts"] == nil)
    {
        return;
        hosts = [[[NSMutableDictionary alloc] init] autorelease];
    }
    else
    {
        hosts =  [[[NSMutableDictionary alloc] 
                   initWithDictionary:[defaults objectForKey:@"hosts"]] autorelease];
    }
    if ([hosts valueForKey:deletingHost] != nil)
    {
        [[TTURLCache cacheWithName:deletingHost] removeAll:YES];
        [hosts removeObjectForKey:deletingHost];
        
        if ([(NSString*)[defaults objectForKey:@"currenthost"] compare:deletingHost]== NSOrderedSame)
        {
            [defaults setObject:@"" forKey:@"currenthost"];
            [self hostChanged:nil];
        }
        [[ActiveManager shared] deleteStore:deletingHost];

        [defaults setObject:hosts forKey:@"hosts"];
        [defaults synchronize];
    }
}

- (void)hostChanged: (NSNotification *) notification
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[XBMCStateListener sharedInstance] stop];
    NSString* hostname = TTSTYLEVAR(emptyDBName);
    bool canConnect = false;
    if (![[defaults valueForKey:@"currenthost"] isEqualToString:@""]) 
    {
        hostname = [defaults valueForKey:@"currenthost"];
        canConnect = true;
    }
    
    [[ActiveManager shared] newPersistentStoreCoordinator:hostname];

    if (!canConnect)
    {
        return;
    }
    
    [TTURLCache setSharedCache:[TTURLCache cacheWithName:hostname]];
    
    if (![[defaults objectForKey:@"hosts"] valueForKey:hostname]) return;
    NSDictionary* hostinfos = [[defaults objectForKey:@"hosts"] objectForKey:hostname];
    
    [[XBMCJSONCommunicator sharedInstance] setAddress:[hostinfos objectForKey:@"address"] 
                                                 port:[hostinfos objectForKey:@"port"] 
                                                login:[hostinfos objectForKey:@"login"]
                                             password:[hostinfos objectForKey:@"pwd"]];
    [[XBMCHttpInterface sharedInstance] setAddress:[hostinfos objectForKey:@"address"] 
                                                 port:[hostinfos objectForKey:@"port"]
                                                login:[hostinfos objectForKey:@"login"]
                                             password:[hostinfos objectForKey:@"pwd"]];
    [[XBMCStateListener sharedInstance] start];
}



- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}

- (UIViewController*)openURL:(NSString*)url {
    return TTOpenURL(url);
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {

	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(UIApplication *)application {
    if (![[ActiveManager shared] save]) 
    {
        abort();
    }
}

- (void)showTrailer:(NSString *)url name:(NSString*)name
{
    if (!url || [url isEqual:@""]) return; 
    CustomMoviePlayerViewController *moviePlayer = [[CustomMoviePlayerViewController alloc] 
                                                    initWithUrl:url name:name];
    [moviePlayer readyPlayer];
    
	// Show the movie player as modal
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:moviePlayer];
    [[[TTNavigator navigator] viewControllerForURL:@"tt://tabBar"] presentModalViewController:navController animated:YES];
    [moviePlayer release];
    [navController release];
}

- (void)showImdb:(NSString *)imdbid 
{
    if ([imdbid length] > 0)
    {
        NSString* url = [NSString stringWithFormat:@"http://www.imdb.com/title/%@",imdbid];
        TTOpenURL(url);
    }
}

- (void)showTvdb:(NSString *)tvdbid
{
    if ([tvdbid length] > 0)
    {
        NSString* url = [NSString stringWithFormat:@"http://thetvdb.com/?tab=series&id=%@",tvdbid];
        TTOpenURL(url);
    }
}

- (void)showMovieDetails:(NSNumber *)movieid 
{
	
//	TTOpenURL([NSString stringWithFormat:@"tt://details/Movie/%@",movieid]);
//    DetailViewController *controller = [[DetailViewController alloc] 
//                                        initWithEntity:@"Movie" 
//                                        id:movieid];
//    [[[TTNavigator navigator] topViewController].navigationController pushViewController:controller animated:YES];
//    [controller release];
	[[TTNavigator navigator] openURLAction:
	 [[[TTURLAction actionWithURLPath:@"tt://details"]
	   applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:
				   @"movie", @"type"
				   ,movieid, @"id", nil]]
	  applyAnimated:YES]];
}

- (void)showFullscreenImage:(NSString *)imageurl 
{
    if ([imageurl isEqual:@""]) return; 
    FullscreenImageViewController *controller = [[FullscreenImageViewController alloc] 
                                                    initWithImageUrl:imageurl];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	// Show the fullscreen controller
    [[[TTNavigator navigator] viewControllerForURL:@"tt://tabBar"] presentModalViewController:controller animated:YES];
    [controller release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Application's documents directory


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
            lastObject];
}

@end
