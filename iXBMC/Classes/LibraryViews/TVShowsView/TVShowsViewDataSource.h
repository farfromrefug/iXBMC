#import "XBMCFetchedResultDataSource.h"

@class AppDelegate;
@class TVShowsViewModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface TVShowsViewDataSource : XBMCFetchedResultDataSource 
{
    AppDelegate* appDelegate;
    
    NSString* _query;
    BOOL _forSearch;
    BOOL _hideWatched;
    
    NSArray * _filteredListContent;
}


@property (nonatomic) BOOL forSearch;
@property (nonatomic) BOOL hideWatched;
@property (nonatomic, retain) NSArray *filteredListContent;
@property (nonatomic, retain) NSString* query;

- (void) toggleWatched;

-(NSUInteger) count;

@end
