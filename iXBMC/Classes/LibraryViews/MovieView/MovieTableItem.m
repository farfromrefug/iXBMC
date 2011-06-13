
#import "MovieTableItem.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MovieTableItem

@synthesize poster      = _poster;
@synthesize file      = _file;
@synthesize label      = _label;
@synthesize tagline      = _tagline;
@synthesize genre      = _genre;
@synthesize runtime      = _runtime;
@synthesize imageURL      = _imageURL;
//@synthesize selected      = _selected;
@synthesize trailer       = _trailer;
@synthesize imdb       = _imdb;
@synthesize itemId = _itemId;
@synthesize year = _year;
@synthesize rating = _rating;
@synthesize watched = _watched;
@synthesize forSearch = _forSearch;

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
    TT_RELEASE_SAFELY(_file);
    TT_RELEASE_SAFELY(_year);
    TT_RELEASE_SAFELY(_rating);
    TT_RELEASE_SAFELY(_label);
    TT_RELEASE_SAFELY(_tagline);
    TT_RELEASE_SAFELY(_genre);
    TT_RELEASE_SAFELY(_runtime);
    TT_RELEASE_SAFELY(_imageURL);
    TT_RELEASE_SAFELY(_trailer);
    TT_RELEASE_SAFELY(_imdb);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


/////////////////////////////////////////////////////////////////////////////////////////////////////
//+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle {
//    MovieTableItem* item = [[[self alloc] init] autorelease];
//    item.text = text;
//    item.subtitle = subtitle;
//    return item;
//}


+ (id)item {
    MovieTableItem* item = [[[self alloc] init] autorelease];
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding

@end
