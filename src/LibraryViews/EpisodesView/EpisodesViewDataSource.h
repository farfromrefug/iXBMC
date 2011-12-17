#import "XBMCFetchedResultDataSource.h"

@class AppDelegate;
@class EpisodesViewModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface EpisodesViewDataSource : XBMCFetchedResultDataSource 
{
    AppDelegate* appDelegate;
    BOOL _hideWatched;    
	NSString* _showId;
	NSString* _season;
//	NSNumber* _nbEpisodesToQueue;
}


@property (nonatomic) BOOL hideWatched;

- (id) initWithTVShow:(NSString *)tvshowid season:(NSString *)seasonid showWatched:(BOOL)watched controllerTableView:(UITableView *)controllerTableView;
- (void) toggleWatched;

-(NSUInteger) count;
@property (nonatomic, retain) NSString* showId;
@property (nonatomic, retain) NSString* season;

@end
