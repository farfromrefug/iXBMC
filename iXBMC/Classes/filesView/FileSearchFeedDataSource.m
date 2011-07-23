
#import "FileSearchFeedDataSource.h"

#import "FileSearchFeedModel.h"
#import "ShareItem.h"
#import "ShareItemCell.h"

#import "XBMCStateListener.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FileSearchFeedDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPath:(NSString*)path {
  if (self = [super init]) {
    _searchFeedModel = [[FileSearchFeedModel alloc] initWithPath:path];
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_searchFeedModel);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
  return _searchFeedModel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray* items = [[NSMutableArray alloc] init];

//	for (ShareItem* item in _searchFeedModel.items) {
////		TTTableTextItem* item = [TTTableTextItem itemWithText:view.text];
////		item.userInfo = item.source;
//		[items addObject:item];
////		[item release];
//	}
	[items addObjectsFromArray:_searchFeedModel.items];

	[items addObject:[TTTableMoreButton itemWithText:@"reload…"]];

	self.items = items;
	TT_RELEASE_SAFELY(items);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
  if (reloading) {
    return NSLocalizedString(@"Updating Twitter feed...", @"Twitter feed updating text");
  } else {
    return NSLocalizedString(@"Loading Twitter feed...", @"Twitter feed loading text");
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
	if (![[XBMCStateListener sharedInstance] connected]) 
	{
		return NSLocalizedString(@"Not Connected", @"");
		
	} else {
		return NSLocalizedString(@"No item found.", @"");
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForEmpty {
	if (![[XBMCStateListener sharedInstance] connected]) 
	{
		return TTIMAGE(@"bundle://error.png");
		
	} else {
		return nil;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForEmpty {
	if (![[XBMCStateListener sharedInstance] connected]) 
	{
		return NSLocalizedString(@"Tap here to go to the Settings Page", @"");
		
	} else {
		return nil;
	}
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Twitter stream.", @"");
}

#pragma mark -
#pragma mark TTTable view data source methods

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object 
{
	if ([object isKindOfClass:[ShareItem class]])
	{
		return [ShareItemCell class];
	}
	else
	{
		return [TTTableMoreButtonCell class];
	}
}

@end

