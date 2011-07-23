
#import "FileSearchFeedModel.h"

#import "ShareItem.h"

#import "XBMCJSONCommunicator.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FileSearchFeedModel

@synthesize path     = _path;
@synthesize items          = _items;
@synthesize finished        = _finished;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPath:(NSString*)path {
  if (self = [super init]) {
    self.path = path;
    _items = [[NSMutableArray array] retain];
	  _loading = false;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc 
{
	TT_RELEASE_SAFELY(_path);
	TT_RELEASE_SAFELY(_items);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
	return [_items count] > 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
	return _loading;
}

- (void)gotSources:(id)result
{
	NSLog(@"printResult: %@", result);
	
	if (![[result objectForKey:@"failure"] boolValue])
    {
		NSMutableArray* items;
		if ([[result objectForKey:@"result"] objectForKey:@"shares"])
		{
			NSArray* shares = [[result objectForKey:@"result"] objectForKey:@"shares"];
			items = [NSMutableArray arrayWithCapacity:[shares count]];
			for (NSDictionary* entry in shares) {
				ShareItem* item = [[ShareItem alloc] init];
				
				item.text = [entry objectForKey:@"label"];
				item.source = [entry objectForKey:@"file"];
				item.type = @"directory";
				
				[items addObject:item];
				TT_RELEASE_SAFELY(item);
			}
		}
		else if ([[result objectForKey:@"result"] objectForKey:@"files"])
        {
			NSArray* files = [[result objectForKey:@"result"] objectForKey:@"files"];
			items = [NSMutableArray arrayWithCapacity:[files count]];
			for (NSDictionary* entry in files) {
				ShareItem* item = [[ShareItem alloc] init];
					
				item.text = [entry objectForKey:@"label"];
				item.source = [entry objectForKey:@"file"];
				item.type = [entry objectForKey:@"filetype"];
				
				[items addObject:item];
				TT_RELEASE_SAFELY(item);
			}
		}
		_finished = true;
		[_items addObjectsFromArray: items];
		_loading = false;
		[self didFinishLoad];		
	}
	else
	{
		[self didCancelLoad];		
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more 
{
  if (!self.isLoading) 
  {
	  [_items removeAllObjects];
	  _loading = true;
	  [self didStartLoad];
	  if ([_path length] == 0)
	  {
		  NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"Files.GetSources", @"cmd"
							 , [NSDictionary dictionaryWithObjectsAndKeys:
															   @"video"
															 , @"media", nil], @"params"
							 ,nil];
		  [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotSources:)]; 
	  }
	  else
	  {
		  NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
								   @"Files.GetDirectory", @"cmd"
								   , [NSDictionary dictionaryWithObjectsAndKeys:
									  _path, @"directory"
									  , @"files", @"media"
									  ,[NSArray arrayWithObjects:@"title", @"originaltitle"
									   , @"plot", @"cast", @"episode", @"premiered", @"file"
									   , @"studio", @"genre", @"rating", @"imdbnumber", @"fanart", @"thumbnail", nil]
									  , @"fields", nil], @"params"
								   ,nil];
		  [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotSources:)]; 
	  }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)requestDidFinishLoad:(TTURLRequest*)request {
//  TTURLJSONResponse* response = request.response;
//  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
//
//  NSDictionary* feed = response.rootObject;
//  TTDASSERT([[feed objectForKey:@"results"] isKindOfClass:[NSArray class]]);
//
//  NSArray* entries = [feed objectForKey:@"results"];
//
//  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
//  [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZ"];
//
//  NSMutableArray* views = [NSMutableArray arrayWithCapacity:[entries count]];
//
//  for (NSDictionary* entry in entries) {
//    FileView* view = [[FileView alloc] init];
//
//    NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"created_at"]];
//    view.created = date;
//    view.viewId = [NSNumber numberWithLongLong:
//                     [[entry objectForKey:@"id"] longLongValue]];
//    view.text = [entry objectForKey:@"text"];
//    view.source = [entry objectForKey:@"source"];
//
//    [views addObject:view];
//    TT_RELEASE_SAFELY(view);
//  }
//  _finished = views.count < _resultsPerPage;
//  [_views addObjectsFromArray: views];
//
//  TT_RELEASE_SAFELY(dateFormatter);
//
//  [super requestDidFinishLoad:request];
//}


@end

