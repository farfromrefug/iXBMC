
#import "BaseTableViewController.h"

@protocol EpisodesViewControllerDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface EpisodesViewController : BaseTableViewController {
    id<EpisodesViewControllerDelegate> _delegate;

    TTButton* _hideWatchedButton;
    	
	BOOL _startWithWatched;
	NSString* _showId;
	NSString* _season;
	NSString* _showName;
}

@property(nonatomic,assign) id<EpisodesViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString* showId;
@property (nonatomic, retain) NSString* season;
@property (nonatomic, retain) NSString* showName;

- (id)initWithTVShow:(NSString *)tvshowid season:(NSString*)ss showWatched:(BOOL)watched;

@end

