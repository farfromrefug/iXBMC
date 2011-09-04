#import "BaseTableItem.h"

@class TVShowsViewDataSource;
@interface TVShowTableItem : BaseTableItem {
	
    NSString* _tagline;
    NSString* _genre;
    NSString* _tvdb;
    NSString* _rating;
    NSString* _premiered;
    NSNumber* _itemId;
    NSNumber* _nbEpisodes;
    NSNumber* _nbUnWatched;
    BOOL _watched;
    BOOL _forSearch;
	TVShowsViewDataSource* _dataSource;
}

@property (nonatomic, retain)   NSString* tagline;
@property (nonatomic, retain)   NSString* genre;
@property (nonatomic, retain)   NSString* tvdb;
@property (nonatomic, retain)   NSString* rating;
@property (nonatomic, retain)   NSString* premiered;
@property (nonatomic, retain)   NSNumber* itemId;
@property (nonatomic, retain)   NSNumber* nbEpisodes;
@property (nonatomic, retain)   NSNumber* nbUnWatched;
@property (nonatomic, retain)   TVShowsViewDataSource* dataSource;
@property (nonatomic)   BOOL watched;
@property (nonatomic)   BOOL forSearch;

+ (id)item;
//+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle;
//+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle URL:(NSString*)URL;
//+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle URL:(NSString*)URL
//      accessoryURL:(NSString*)accessoryURL;
//+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
//               URL:(NSString*)URL;
//+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
//      URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL;

@end
