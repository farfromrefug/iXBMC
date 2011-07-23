
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface FileSearchFeedModel : TTModel {
  NSString* _path;

  NSMutableArray*  _items;

	BOOL _finished;
	BOOL _loading;
}

@property (nonatomic, copy)     NSString*       path;
@property (nonatomic, readonly) NSMutableArray* items;
@property (nonatomic, readonly) BOOL            finished;

- (id)initWithPath:(NSString*)path;

@end
