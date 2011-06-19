#import "TTTableViewCoreDataController.h"

@protocol TVShowsViewControllerDelegate;

@class CustomTitleView;
@class RecentlyAddedEpisodesViewController;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface TVShowsViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {
    id<TVShowsViewControllerDelegate> _delegate;

    RecentlyAddedEpisodesViewController* _recentlyAddedEpisodes;
    TTView* _toolBar;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
    CustomTitleView* _titleBackground;
    BOOL _forSearch;
	BOOL _startWithWatched;

    NSIndexPath *_selectedCellIndexPath;
}

@property(nonatomic,assign) id<TVShowsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic) BOOL forSearch;

- (id)initWithWatched:(BOOL)watched;
-(void) updateRecentlyAddedEpisodes: (NSNotification *) notification;
- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void) updateLibrary;

@end

@protocol TVShowsViewControllerDelegate <NSObject>

- (void)TVShowsViewController:(TVShowsViewController*)controller didSelectObject:(id)object;

@end
