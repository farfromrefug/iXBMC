
#import "EpisodesViewController.h"
#import "EpisodeTableItemCell.h"
#import "EpisodesViewDataSource.h"
#import "EpisodesTableViewDelegate.h"
#import "TVShow.h"
#import "Episode.h"
#import "Episode.h"

#import "ActiveManager.h"

#import "CustomTitleView.h"

#import "LibraryUpdater.h"
#import "XBMCStateListener.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EpisodesViewController
@synthesize delegate = _delegate;
@synthesize showId = _showId;
@synthesize season = _season;
@synthesize showName = _showName;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTVShow:(NSString *)tvshowid season:(NSString*)ss showWatched:(BOOL)watched
{
    self = [super init];
    if (self) {
		self.dataSource = nil;
		self.showId = tvshowid;
		self.season = ss;
		_startWithWatched = watched;
		
		NSArray *array = [[[ActiveManager shared] managedObjectContext] fetchObjectsForEntityName:@"TVShow" withPredicate:
						  [NSPredicate predicateWithFormat:@"tvshowid == %@", tvshowid]];
        
        if (array == nil || [array count] ==0) {
			self.showName = @"Episodes";
		}
		else
		{
			self.showName = ((TVShow*)[array objectAtIndex:0]).label;
		}
	}

  return self;
}

- (void)dealloc
{    
    TT_RELEASE_SAFELY(_showName);
    TT_RELEASE_SAFELY(_showId);
    TT_RELEASE_SAFELY(_season);
    [super dealloc];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (TTView*) createToolbar
{
    TTView* toolbar = [super createToolbar];

    UILabel* watchedLabel = [[[UILabel alloc] init] autorelease];
    watchedLabel.text = @"NoWatched:";
    watchedLabel.backgroundColor = [UIColor clearColor];
    watchedLabel.font = [UIFont systemFontOfSize:12];
    watchedLabel.textColor = [UIColor grayColor];
    watchedLabel.highlightedTextColor = [UIColor whiteColor];
    watchedLabel.textAlignment = UITextAlignmentLeft;
    watchedLabel.frame = CGRectMake(10, 12, toolbar.width, 41);
    watchedLabel.size = [watchedLabel sizeThatFits:watchedLabel.size];
    [watchedLabel sizeToFit];
    [toolbar addSubview:watchedLabel];
    
    _hideWatchedButton = [TTButton buttonWithStyle:@"switchButton:" title:@""];
    _hideWatchedButton.frame = CGRectMake(watchedLabel.right + 5, 10, 41, 21);
    [_hideWatchedButton addTarget:self action:@selector(toggleWatched:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:_hideWatchedButton];
    
    TTButton *button = [TTButton buttonWithStyle:@"embossedButton:" title:@"Update"];
    button.frame = CGRectMake(_hideWatchedButton.right + 5, 10, 71, 25);
    [button addTarget:self action:@selector(updateLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:button];
    return toolbar;
}

- (void) toggleToolbar
{
    if (_toolBar.bottom == 0)
    {
        _hideWatchedButton.selected = ((EpisodesViewDataSource*)self.dataSource).hideWatched;
    }
    [super toggleToolbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(updateStarted:)
     name:@"updatingLibrary"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(updateFinished:)
     name:@"updatedLibrary"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(reloadTableView)
     name:@"episodeCellHeightChanged"
     object:nil ];
    
    _titleBackground.title = self.showName;
    _titleBackground.subtitle = @"No Episode Found";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) updateSubtitle
{
	NSString* strTitle;
	if ([self.season isEqualToString:@"-1"])
	{
		strTitle = @"All Seasons ● ";
	}
	else
	{
		strTitle = [NSString stringWithFormat:@"Season %@ ● "
					,_season];
	}
	_titleBackground.subtitle = [strTitle stringByAppendingFormat:@"%d Episodes"
								 ,[((EpisodesViewDataSource*)self.dataSource) 
											  count]];	
}

- (void) updateStarted: (NSNotification *) notification 
{
}

- (void) updateFinished: (NSNotification *) notification 
{
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[EpisodesViewDataSource alloc]
                        initWithTVShow:self.showId season:self.season showWatched:_startWithWatched
                        controllerTableView:self.tableView] autorelease];
    [((EpisodesViewDataSource*)self.dataSource).delegates addObject:self];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[EpisodesTableViewDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((EpisodesViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((EpisodesViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
}

@end

