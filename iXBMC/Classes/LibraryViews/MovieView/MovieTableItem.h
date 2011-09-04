#import "BaseTableItem.h"

@interface MovieTableItem : BaseTableItem {
	
    NSString* _file;
    NSString* _tagline;
    NSString* _genre;
    NSString* _runtime;
	NSString* _year;
    NSString* _rating;
    NSString* _trailer;
    NSString* _imdb;

    NSNumber* _itemId;
    BOOL _watched;
    BOOL _forSearch;
}

@property (nonatomic, retain)   NSString* file;
@property (nonatomic, retain)   NSString* tagline;
@property (nonatomic, retain)   NSString* genre;
@property (nonatomic, retain)   NSString* runtime;
@property (nonatomic, retain)   NSString* year;
@property (nonatomic, retain)   NSString* rating;
@property (nonatomic, retain)   NSString* trailer;
@property (nonatomic, retain)   NSString* imdb;
@property (nonatomic, retain)   NSNumber* itemId;
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
