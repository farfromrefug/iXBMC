@interface BaseTableItem : TTTableItem {
	
	UIImage* _poster;
    NSString* _label;
    NSString* _imageURL;
}

@property (nonatomic, retain)   UIImage* poster;
@property (nonatomic, retain)   NSString* label;
@property (nonatomic, retain)   NSString* imageURL;

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
