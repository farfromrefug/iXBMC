@class SeasonsViewDataSource;
@interface SeasonTableItem : TTTableTextItem {
	
	UIImage* _poster;
    NSString* _label;
    NSString* _imageURL;
    NSNumber* _itemId;
    NSString* _showId;
    NSNumber* _nbEpisodes;
    NSNumber* _nbUnWatched;
    BOOL _watched;
	SeasonsViewDataSource* _dataSource;

}

@property (nonatomic, retain)   UIImage* poster;
@property (nonatomic, retain)   NSString* label;
@property (nonatomic, retain)   NSString* imageURL;
@property (nonatomic, retain)   NSNumber* itemId;
@property (nonatomic, retain)   NSString* showId;
@property (nonatomic, retain)   NSNumber* nbEpisodes;
@property (nonatomic, retain)   NSNumber* nbUnWatched;
@property (nonatomic, retain)   SeasonsViewDataSource* dataSource;
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
