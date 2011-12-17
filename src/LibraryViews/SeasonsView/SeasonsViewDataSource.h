#import "XBMCFetchedResultDataSource.h"

@class AppDelegate;
@class SeasonsViewModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeasonsViewDataSource : XBMCFetchedResultDataSource 
{
    AppDelegate* appDelegate;
    BOOL _hideWatched;    
	NSString* _showId;
//	NSNumber* _nbEpisodesToQueue;
}


@property (nonatomic) BOOL hideWatched;

- (id) initWithTVShow:(NSString *)tvshowid showWatched:(BOOL)watched controllerTableView:(UITableView *)controllerTableView;
- (void) toggleWatched;

-(NSUInteger) count;
@property (nonatomic, retain) NSString* showId;

@end
