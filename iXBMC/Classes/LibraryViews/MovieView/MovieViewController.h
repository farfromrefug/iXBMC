#import "TTTableViewCoreDataController.h"

@protocol MovieViewControllerDelegate;

@class Movie;
@class CustomTitleView;
@class RecentlyAddedMoviesViewController;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MovieViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {
    id<MovieViewControllerDelegate> _delegate;

    RecentlyAddedMoviesViewController* _recentlyAddedMovies;
    TTView* _toolBar;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
    CustomTitleView* _titleBackground;
    BOOL _forSearch;
	BOOL _startWithWatched;

    NSIndexPath *_selectedCellIndexPath;
}

@property(nonatomic,assign) id<MovieViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic) BOOL forSearch;

- (id)initWithWatched:(BOOL)watched;
- (void)loadContentForVisibleCells;
-(void) updateRecentlyAddedMovies: (NSNotification *) notification;
- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void) updateLibrary;


@end

@protocol MovieViewControllerDelegate <NSObject>

- (void)movieViewController:(MovieViewController*)controller didSelectObject:(id)object;

@end
