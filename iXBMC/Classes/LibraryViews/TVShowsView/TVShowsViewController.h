#import "TTTableViewCoreDataController.h"

@protocol TVShowsViewControllerDelegate;

@class CustomTitleView;
//@class RecentlyAddedViewController;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface TVShowsViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {
    id<TVShowsViewControllerDelegate> _delegate;

//    RecentlyAddedViewController* _recentlyAddedTVShowss;
    TTView* _toolBar;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
    CustomTitleView* _titleBackground;
    BOOL _forSearch;

    NSIndexPath *_selectedCellIndexPath;
}

@property(nonatomic,assign) id<TVShowsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic) BOOL forSearch;

- (void)loadContentForVisibleCells;
-(void) updateRecentlyAddedTVShows: (NSNotification *) notification;
- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@protocol TVShowsViewControllerDelegate <NSObject>

- (void)TVShowsViewController:(TVShowsViewController*)controller didSelectObject:(id)object;

@end
