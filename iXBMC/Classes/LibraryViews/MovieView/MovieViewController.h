#import "TTTableViewCoreDataController.h"

@protocol MovieViewControllerDelegate;

@class Movie;
@class CustomTitleView;
@class RecentlyAddedViewController;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MovieViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {
    id<MovieViewControllerDelegate> _delegate;

    RecentlyAddedViewController* _recentlyAddedMovies;
    TTView* _toolBar;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
    CustomTitleView* _titleBackground;
    BOOL _forSearch;

    NSIndexPath *_selectedCellIndexPath;
}

@property(nonatomic,assign) id<MovieViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic) BOOL forSearch;

- (void)loadContentForVisibleCells;
-(void) updateRecentlyAddedMovies: (NSNotification *) notification;
- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@protocol MovieViewControllerDelegate <NSObject>

- (void)movieViewController:(MovieViewController*)controller didSelectObject:(id)object;

@end
