
#import "MovieTableItem.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MovieTableItem

@synthesize file      = _file;

@synthesize trailer       = _trailer;
@synthesize imdb       = _imdb;
@synthesize itemId = _itemId;
@synthesize tagline      = _tagline;
@synthesize genre      = _genre;
@synthesize runtime      = _runtime;
@synthesize year = _year;
@synthesize rating = _rating;
@synthesize watched = _watched;
@synthesize forSearch = _forSearch;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_file);
    TT_RELEASE_SAFELY(_year);
    TT_RELEASE_SAFELY(_rating);
    TT_RELEASE_SAFELY(_tagline);
    TT_RELEASE_SAFELY(_genre);
    TT_RELEASE_SAFELY(_runtime);
    TT_RELEASE_SAFELY(_trailer);
    TT_RELEASE_SAFELY(_imdb);
	TT_RELEASE_SAFELY(_itemId);
   
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public



+ (id)item {
    MovieTableItem* item = [[[self alloc] init] autorelease];
    return item;
}

@end
