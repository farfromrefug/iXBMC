#import "BaseTableViewController.h"

@protocol MovieViewControllerDelegate;

@class Movie;
@class CustomTitleView;
@class RecentlyAddedMoviesViewController;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MovieViewController : BaseTableViewController {
    id<MovieViewControllerDelegate> _delegate;

    RecentlyAddedMoviesViewController* _recentlyAddedMovies;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
	BOOL _startWithWatched;
}

@property(nonatomic,assign) id<MovieViewControllerDelegate> delegate;

- (id)initWithWatched:(BOOL)watched;
-(void) updateRecentlyAddedMovies: (NSNotification *) notification;
- (void) updateLibrary;


@end
