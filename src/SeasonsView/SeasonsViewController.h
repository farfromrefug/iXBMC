#import "TTTableViewCoreDataController.h"

@protocol SeasonsViewControllerDelegate;

@class CustomTitleView;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeasonsViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {
    id<SeasonsViewControllerDelegate> _delegate;

//    RecentlyAddedViewController* _recentlyAddedSeasonss;
    TTView* _toolBar;
    TTButton* _hideWatchedButton;
    TTButton* _sortButton;
    
    CustomTitleView* _titleBackground;

    NSIndexPath *_selectedCellIndexPath;
	
	BOOL _startWithWatched;
	NSString* _showId;
	NSString* _showName;
//	NSNumber* _nbEpisodesToQueue;
}

@property(nonatomic,assign) id<SeasonsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic, retain) NSString* showId;
@property (nonatomic, retain) NSString* showName;
//@property (nonatomic, retain) NSNumber* nbEpisodesToQueue;

- (void)loadContentForVisibleCells;
- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;
- (id)initWithTVShow:(NSString *)tvshowid showWatched:(BOOL)watched;

@end

@protocol SeasonsViewControllerDelegate <NSObject>

- (void)SeasonsViewController:(SeasonsViewController*)controller didSelectObject:(id)object;

@end
