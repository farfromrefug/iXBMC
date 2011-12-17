
#import "SeasonsViewController.h"
#import "SeasonTableItemCell.h"
#import "SeasonsViewDataSource.h"
#import "SeasonsTableViewDelegate.h"
#import "TVShow.h"
#import "Season.h"
#import "Episode.h"

#import "ActiveManager.h"

#import "CustomTitleView.h"

#import "LibraryUpdater.h"
#import "XBMCStateListener.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeasonsViewController
@synthesize delegate = _delegate;
@synthesize showId = _showId;
@synthesize showName = _showName;
//@synthesize nbEpisodesToQueue = _nbEpisodesToQueue;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTVShow:(NSString *)tvshowid showWatched:(BOOL)watched
{
    self = [super init];
    if (self) {
		self.showId = tvshowid;
		self.dataSource = nil;

		_startWithWatched = watched;
		
		NSArray *array = [[[ActiveManager shared] managedObjectContext] fetchObjectsForEntityName:@"TVShow" withPredicate:
						  [NSPredicate predicateWithFormat:@"tvshowid == %@", tvshowid]];
        
        if (array == nil || [array count] ==0) {
			self.showName = @"Seasons";
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
        _hideWatchedButton.selected = ((SeasonsViewDataSource*)self.dataSource).hideWatched;
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
     name:@"seasonCellHeightChanged"
     object:nil ];
    
    _titleBackground.title = self.showName;
    _titleBackground.subtitle = @"No Season Found";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
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
}

- (void) updateSubtitle
{
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d Seasons"
								 , [((SeasonsViewDataSource*)self.dataSource) 
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
    self.dataSource = [[[SeasonsViewDataSource alloc]
                        initWithTVShow:self.showId showWatched:_startWithWatched
                        controllerTableView:self.tableView] autorelease];
    [((SeasonsViewDataSource*)self.dataSource).delegates addObject:self];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[SeasonsTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((SeasonsViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((SeasonsViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
}

@end

