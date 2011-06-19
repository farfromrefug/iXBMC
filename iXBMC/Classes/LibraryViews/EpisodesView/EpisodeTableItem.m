
#import "EpisodeTableItem.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EpisodeTableItem

@synthesize poster      = _poster;
@synthesize itemId = _itemId;
@synthesize file      = _file;
@synthesize label      = _label;
@synthesize imageURL      = _imageURL;
@synthesize episode = _episode;
@synthesize season = _season;
@synthesize tagline      = _tagline;
@synthesize genre      = _genre;
@synthesize runtime      = _runtime;
@synthesize firstaired = _firstaired;
@synthesize rating = _rating;
@synthesize watched = _watched;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init];
    if (self)
    {
		_poster = nil;
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_itemId);
    TT_RELEASE_SAFELY(_poster);
    TT_RELEASE_SAFELY(_file);
    TT_RELEASE_SAFELY(_label);
    TT_RELEASE_SAFELY(_imageURL);
    TT_RELEASE_SAFELY(_episode);
    TT_RELEASE_SAFELY(_season);
    TT_RELEASE_SAFELY(_genre);
    TT_RELEASE_SAFELY(_tagline);
    TT_RELEASE_SAFELY(_runtime);
    TT_RELEASE_SAFELY(_firstaired);
    TT_RELEASE_SAFELY(_rating);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


+ (id)item {
    EpisodeTableItem* item = [[[self alloc] init] autorelease];
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding

@end
