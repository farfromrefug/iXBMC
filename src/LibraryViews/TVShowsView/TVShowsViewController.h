#import "BaseTableViewController.h"

@protocol TVShowsViewControllerDelegate;

@class RecentlyAddedEpisodesViewController;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface TVShowsViewController : BaseTableViewController {
    id<TVShowsViewControllerDelegate> _delegate;

    RecentlyAddedEpisodesViewController* _recentlyAddedEpisodes;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
	BOOL _startWithWatched;

}

@property(nonatomic,assign) id<TVShowsViewControllerDelegate> delegate;

- (id)initWithWatched:(BOOL)watched;
-(void) updateRecentlyAddedEpisodes: (NSNotification *) notification;
- (void) updateLibrary;

@end
