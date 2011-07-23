
#import "FileSearchFeedViewController.h"

#import "XBMCStateListener.h"

#import "ShareItem.h"
#import "FileSearchFeedDataSource.h"

#import "BCTab.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FileSearchFeedViewController
@synthesize path = _path;

- (NSString *)iconImageName {
	return @"iconVideos.png";
}

- (NSString *)selectedIconImageNameSuffix
{
	return @"On";
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
}

- (NSString *)iconTitle {
	return @"Videos";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) 
	{
		_errorTap = 0;
		if ([query objectForKey:@"title"])
		{
			self.title = [query objectForKey:@"title"];
		}
		else
		{
			self.title = @"Videos";
		}
		self.variableHeightRows = YES;
		self.path = [query objectForKey:@"path"];
		
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
		
		self.view.backgroundColor = TTSTYLEVAR(tableViewBackColor);
		self.tableView.backgroundColor = TTSTYLEVAR(tableViewBackColor);
	}

	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	return [self initWithNavigatorURL:[NSURL URLWithString:@"tt://videosWithPath"]
					query:[NSDictionary dictionaryWithObject:@"" forKey:@"path"]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	TT_RELEASE_SAFELY(_path);
	TT_RELEASE_SAFELY(_errorTap);
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(disconnectedFromXBMC:)
     name:@"DisconnectedFromXBMC"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(connectedToXBMC:)
     name:@"ConnectedToXBMC"
     object:nil ];
    
    if (![[XBMCStateListener sharedInstance] connected])
    {
        [self disconnectedFromXBMC:nil];
    }
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[FileSearchFeedDataSource alloc]
                      initWithPath:self.path] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canShowModel {
	if (![[XBMCStateListener sharedInstance] connected]) 
	{
		return NO;
		
	} else {
		return [super canShowModel];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoad {
	if ([[XBMCStateListener sharedInstance] connected])
	{
		return [super shouldLoad];
	}
	else
	{
		return NO;
	}
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
	[self refresh];
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	if (!_errorTap)
	{
		_errorTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTap:)] retain];
	}
    [self.view addGestureRecognizer:_errorTap];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
	[self refresh];
	[self.view removeGestureRecognizer:_errorTap];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

-(void)errorTap:(UITapGestureRecognizer *)gesture
{
    TTOpenURL(@"tt://settings");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    if ([[XBMCStateListener sharedInstance] connected])
	{
		[[self navigationController] setNavigationBarHidden:NO animated:NO];
	}
	else
	{
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
	if ([object isKindOfClass:[TTTableMoreButton class]])
	{
		[super didSelectObject:object atIndexPath:indexPath];
	}
	else if ([object isKindOfClass:[ShareItem class]])
	{
		ShareItem *item = (ShareItem *)object;
		NSString *path = item.source;
		[[TTNavigator navigator] openURLAction:
		 [[[TTURLAction actionWithURLPath:@"tt://videosWithPath"]
		   applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:
					   path, @"path"
					   ,item.text, @"title", nil]]
		  applyAnimated:YES]];
	}
}

@end

