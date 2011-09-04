
#import "BaseTableViewController.h"

@protocol SeasonsViewControllerDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeasonsViewController : BaseTableViewController {
    id<SeasonsViewControllerDelegate> _delegate;

    TTButton* _hideWatchedButton;
    	
	BOOL _startWithWatched;
	NSString* _showId;
	NSString* _showName;
}

@property(nonatomic,assign) id<SeasonsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString* showId;
@property (nonatomic, retain) NSString* showName;

- (id)initWithTVShow:(NSString *)tvshowid showWatched:(BOOL)watched;

@end
