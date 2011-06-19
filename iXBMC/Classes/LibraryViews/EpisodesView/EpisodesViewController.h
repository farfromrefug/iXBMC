#import "TTTableViewCoreDataController.h"

@protocol EpisodesViewControllerDelegate;

@class CustomTitleView;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface EpisodesViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {
    id<EpisodesViewControllerDelegate> _delegate;

//    RecentlyAddedViewController* _recentlyAddedEpisodess;
    TTView* _toolBar;
    TTButton* _hideWatchedButton;
    
    CustomTitleView* _titleBackground;

    NSIndexPath *_selectedCellIndexPath;
	
	BOOL _startWithWatched;
	NSString* _showId;
	NSString* _season;
	NSString* _showName;
//	NSNumber* _nbEpisodesToQueue;
}

@property(nonatomic,assign) id<EpisodesViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic, retain) NSString* showId;
@property (nonatomic, retain) NSString* season;
@property (nonatomic, retain) NSString* showName;
//@property (nonatomic, retain) NSNumber* nbEpisodesToQueue;

- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;
- (id)initWithTVShow:(NSString *)tvshowid season:(NSString*)ss showWatched:(BOOL)watched;

@end

@protocol EpisodesViewControllerDelegate <NSObject>

- (void)EpisodesViewController:(EpisodesViewController*)controller didSelectObject:(id)object;

@end
