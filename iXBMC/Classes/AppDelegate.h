#import <Three20/Three20.h>

//@class MBProgressHUD;
@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
//	MBProgressHUD *HUD;
    NSString* connectedStoreName;
}

@property (nonatomic, readonly)         NSString* applicationDocumentsDirectory;

+ (AppDelegate *)sharedAppDelegate;
- (UIViewController*)openURL:(NSString*)url;

- (void)hostChanged: (NSNotification *) notification;
- (void)connectedToXBMC: (NSNotification *) notification;
- (void)disconnectedFromXBMC: (NSNotification *) notification;

- (void)showTrailer:(NSString *)url name:(NSString*)name;
- (void)showImdb:(NSString *)imdbid;
- (void)showTvdb:(NSString *)tvdbid;
- (void)showMovieDetails:(NSNumber *)movieid;
- (void)showFullscreenImage:(NSString *)imageurl;


@end