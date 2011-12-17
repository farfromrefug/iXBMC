
@interface ShareItem : NSObject {
	NSString* _text;
	NSString* _type;
	NSString* _source;
}

@property (nonatomic, copy)   NSString* text;
@property (nonatomic, copy)   NSString* type;
@property (nonatomic, copy)   NSString* source;

@end
