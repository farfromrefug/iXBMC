
@interface TVShowTableItem : TTTableTextItem {
	
	UIImage* _poster;
    NSString* _label;
    NSString* _tagline;
    NSString* _genre;
    NSString* _imageURL;
    NSString* _imdb;
    NSString* _rating;
    NSNumber* _itemId;
    BOOL _watched;
//    BOOL _selected;
    BOOL _forSearch;
}

@property (nonatomic, retain)   UIImage* poster;
@property (nonatomic, retain)   NSString* label;
@property (nonatomic, retain)   NSString* tagline;
@property (nonatomic, retain)   NSString* genre;
@property (nonatomic, retain)   NSString* imageURL;
@property (nonatomic, retain)   NSString* imdb;
@property (nonatomic, retain)   NSString* rating;
@property (nonatomic, retain)   NSNumber* itemId;
@property (nonatomic)   BOOL watched;
//@property (nonatomic)   BOOL selected;
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
