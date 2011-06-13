#import "XBMCFetchedResultDataSource.h"

@class AppDelegate;
@class MovieViewModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MovieViewDataSource : XBMCFetchedResultDataSource 
{
    AppDelegate* appDelegate;
    
    NSDictionary* sortTypes;
    NSString* currentSort;
    
    NSString* _query;
    BOOL _forSearch;
    BOOL _hideWatched;
    
    NSArray * _filteredListContent;
}


@property (nonatomic) BOOL forSearch;
@property (nonatomic) BOOL hideWatched;
@property (nonatomic, retain) NSArray *filteredListContent;
@property (nonatomic, retain, readonly) NSDictionary* sortTypes;
@property (nonatomic, retain) NSString* query;

- (void) toggleWatched;

-(NSUInteger) count;

@end
