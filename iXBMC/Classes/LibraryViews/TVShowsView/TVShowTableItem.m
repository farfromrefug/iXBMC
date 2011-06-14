
#import "TVShowTableItem.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TVShowTableItem

@synthesize poster      = _poster;
@synthesize label      = _label;
@synthesize tagline      = _tagline;
@synthesize genre      = _genre;
@synthesize imageURL      = _imageURL;
//@synthesize selected      = _selected;
@synthesize imdb       = _imdb;
@synthesize itemId = _itemId;
@synthesize rating = _rating;
@synthesize watched = _watched;
@synthesize forSearch = _forSearch;
@synthesize nbEpisodes = _nbEpisodes;
@synthesize nbUnWatched = _nbUnWatched;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init];
    if (self)
    {
		_poster = nil;
//        _selected = false;
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_poster);
    TT_RELEASE_SAFELY(_rating);
    TT_RELEASE_SAFELY(_label);
    TT_RELEASE_SAFELY(_tagline);
    TT_RELEASE_SAFELY(_genre);
    TT_RELEASE_SAFELY(_imageURL);
    TT_RELEASE_SAFELY(_itemId);
    TT_RELEASE_SAFELY(_imdb);
    TT_RELEASE_SAFELY(_nbEpisodes);
    TT_RELEASE_SAFELY(_nbUnWatched);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


+ (id)item {
    TVShowTableItem* item = [[[self alloc] init] autorelease];
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding

@end
