
@interface EpisodeTableItem : TTTableTextItem {
	
	UIImage* _poster;
    NSNumber* _itemId;
    NSString* _file;
    NSString* _label;
    NSString* _imageURL;
    NSNumber* _episode;
    NSNumber* _season;
	
    NSString* _tagline;
	NSString* _genre;
    NSString* _runtime;
	NSString* _firstaired;
    NSString* _rating;
	
    BOOL _watched;

}

@property (nonatomic, retain)   UIImage* poster;
@property (nonatomic, retain)   NSNumber* itemId;
@property (nonatomic, retain)   NSString* file;
@property (nonatomic, retain)   NSString* label;
@property (nonatomic, retain)   NSString* imageURL;
@property (nonatomic, retain)   NSNumber* episode;
@property (nonatomic, retain)   NSNumber* season;

@property (nonatomic, retain)   NSString* tagline;
@property (nonatomic, retain)   NSString* genre;
@property (nonatomic, retain)   NSString* runtime;
@property (nonatomic, retain)   NSString* firstaired;
@property (nonatomic, retain)   NSString* rating;

@property (nonatomic)   BOOL watched;

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
