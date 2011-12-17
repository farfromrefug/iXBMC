
#import "SeasonsViewController.h"
#import "SeasonTableItemCell.h"
#import "SeasonsViewDataSource.h"
#import "SeasonsTableViewDelegate.h"
#import "TVShow.h"
#import "Season.h"
#import "Episode.h"

#import "ActiveManager.h"

//#import "RecentlyAddedViewController.h"
#import "CustomTitleView.h"

#import "LibraryUpdater.h"
#import "XBMCStateListener.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeasonsViewController
@synthesize delegate = _delegate;
@synthesize selectedCellIndexPath = _selectedCellIndexPath;
@synthesize showId = _showId;
@synthesize showName = _showName;
//@synthesize nbEpisodesToQueue = _nbEpisodesToQueue;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTVShow:(NSString *)tvshowid showWatched:(BOOL)watched
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.title = @"TVShows";
		self.tabBarItem.image = [UIImage imageNamed:@"70-tv.png"];
		self.variableHeightRows = YES;
		self.showTableShadows = YES;
        _selectedCellIndexPath = nil;
		self.showId = tvshowid;
//		self.showName = showName;
		_startWithWatched = watched;
		
		NSArray *array = [[[ActiveManager shared] managedObjectContext] fetchObjectsForEntityName:@"TVShow" withPredicate:
						  [NSPredicate predicateWithFormat:@"tvshowid == %@", tvshowid]];
        
        if (array == nil || [array count] ==0) {
			self.showName = @"Seasons";
//			self.nbEpisodesToQueue = [NSNumber numberWithInt:0];
		}
		else
		{
			self.showName = ((TVShow*)[array objectAtIndex:0]).label;
//			self.nbEpisodesToQueue = [NSNumber numberWithInt:[((TVShow*)[array objectAtIndex:0]).episodes count]];
		}
	}

  return self;
}

- (void)dealloc
{    
//    TT_RELEASE_SAFELY(_recentlyAddedSeasonss);
    TT_RELEASE_SAFELY(_toolBar);
    TT_RELEASE_SAFELY(_selectedCellIndexPath);
    TT_RELEASE_SAFELY(_titleBackground);
    TT_RELEASE_SAFELY(_showName);
    TT_RELEASE_SAFELY(_showId);
//    TT_RELEASE_SAFELY(_nbEpisodesToQueue);
    [super dealloc];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (TTView*) createToolbar
{
    TTView* toolbar = [[[TTView alloc] initWithFrame:CGRectMake(0, -41, self.tableView.width, 41)] autorelease];
    toolbar.backgroundColor = [UIColor clearColor];
    toolbar.style = TTSTYLEVAR(tableToolbar);
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
    
    UILabel* sortLabel = [[[UILabel alloc] init] autorelease];
    sortLabel.text = @"Sort:";
    sortLabel.backgroundColor = [UIColor clearColor];
    sortLabel.font = [UIFont systemFontOfSize:12];
    sortLabel.textColor = [UIColor grayColor];
    sortLabel.highlightedTextColor = [UIColor whiteColor];
    sortLabel.textAlignment = UITextAlignmentLeft;
    sortLabel.frame = CGRectMake(_hideWatchedButton.right + 10, 12, toolbar.width, 41);
    sortLabel.size = [sortLabel sizeThatFits:sortLabel.size];
    [sortLabel sizeToFit];
    [toolbar addSubview:sortLabel];
    
    _sortButton = [TTButton buttonWithStyle:@"embossedButton:" title:@"Season"];
    _sortButton.frame = CGRectMake(sortLabel.right + 5, 10, 71, 25);
    [_sortButton addTarget:self action:@selector(switchSort:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:_sortButton];
    
    TTButton *button = [TTButton buttonWithStyle:@"embossedButton:" title:@"Update"];
    button.frame = CGRectMake(_sortButton.right + 5, 10, 71, 25);
    [button addTarget:self action:@selector(updateLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:button];
    return toolbar;
}

- (void) hideToolbar
{
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:0.5];
    _toolBar.bottom =  0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void) toggleToolbar
{
    if (_toolBar.bottom == 0)
    {
        _hideWatchedButton.selected = ((SeasonsViewDataSource*)self.dataSource).hideWatched;
        [_sortButton setTitle:[((SeasonsViewDataSource*)self.dataSource) currentSortName] forState:UIControlStateNormal] ;
    }
    
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:0.5];
    if (_toolBar.top == 0)
        _toolBar.bottom = 0;
    else _toolBar.top = 0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
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
     selector:@selector(persistentStoreChanged:)
     name:@"persistentStoreChanged"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(updateLibrary)
     name:@"DragRefreshTableReload"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(connectedToXBMC:)
     name:@"ConnectedToXBMC"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(disconnectedFromXBMC:)
     name:@"DisconnectedFromXBMC"
     object:nil ];
	
	[center
     addObserver:self
     selector:@selector(reloadTableView)
     name:@"highQualityChanged"
     object:nil ];
	
	[center
     addObserver:self
     selector:@selector(reloadTableView)
     name:@"cacheCleared"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(reloadTableView)
     name:@"seasonCellHeightChanged"
     object:nil ];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:gesture];
    [gesture release];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
    
    //clear background color of uitableview
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //create new uiview with a background image
    UIImage *backgroundImage = TTIMAGE(@"bundle://tableViewback.png");
    UIImageView *backgroundView = [[[UIImageView alloc] 
                                   initWithImage:backgroundImage] autorelease];
    
    //adjust the frame for the case of navigation or tabbars
    backgroundView.frame = self.tableView.frame;
    
    //add background view and send it to the back
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    _titleBackground = [[[CustomTitleView alloc] init] retain];
    
    _titleBackground.title = self.showName;
    _titleBackground.subtitle = @"No Season Found";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
    
	////toolbar
	_toolBar = [self createToolbar];
	[[self.tableView superview] addSubview:_toolBar];

	[self.tableView setCanCancelContentTouches:NO];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{    
	_isViewAppearing = FALSE;
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideToolbar];
}

- (void) reloadTableView
{
	[self setSelectedCellIndexPath:nil];
	[self.tableView reloadData];
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d Seasons"
								 , [((SeasonsViewDataSource*)self.dataSource) 
									count]];	
}

- (void) persistentStoreChanged: (NSNotification *) notification 
{
    [[self navigationController] popToViewController:self animated:YES];
    [self invalidateModel];
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
- (void)didRefreshModel {
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d Seasons"
									 , [((SeasonsViewDataSource*)self.dataSource) 
										count]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (BOOL)shouldLoad {
//	return NO;
//}
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////
//- (BOOL)shouldLoadMore {
//	return YES;
//}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)showLoading:(BOOL)show {
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)showEmpty:(BOOL)show {
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)showError:(BOOL)show {
//}



- (void)loadContentForVisibleCells
{
    if ([XBMCStateListener connected])
    {
        NSArray *cells = [self.tableView visibleCells];
        [cells retain];
        for (int i = 0; i < [cells count]; i++) 
        { 
            // Go through each cell in the array and call its loadContent method if it responds to it.
            SeasonTableItemCell *SeasonCell = (SeasonTableItemCell *)[[cells objectAtIndex: i] retain];
            [SeasonCell loadImage];
            [SeasonCell release];
            SeasonCell = nil;
        }
        [cells release];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[SeasonsTableViewDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void) deselectCurrentObject
{
    NSIndexPath* oldIndex = [_selectedCellIndexPath retain];
    [self setSelectedCellIndexPath:nil];
	[[self.tableView cellForRowAtIndexPath:oldIndex] setSelected:FALSE];
    [self didDeselectRowAtIndexPath:oldIndex];
    [oldIndex release];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    
    NSIndexPath* oldIndex = [_selectedCellIndexPath retain];
    if ([indexPath isEqual:oldIndex]) 
    {
        [self deselectCurrentObject];
        return;
    }
    else
    {
        [self setSelectedCellIndexPath:indexPath];
		[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:TRUE];        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
    [self reloadTableView];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [self reloadTableView];
}


-(void)didSwipeLeft:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        [(SeasonTableItemCell*)swipedCell moreInfos:nil];
    }
}

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((SeasonsViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((SeasonsViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
}

- (void) switchSort:(id)sender
{
    [self deselectCurrentObject];
    [_sortButton setTitle:[((SeasonsViewDataSource*)self.dataSource) switchSort] forState:UIControlStateNormal] ;
	[self reloadTableView];
}

@end

