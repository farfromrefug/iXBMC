
#import "TVShowsViewController.h"
#import "TVShowTableItemCell.h"
#import "TVShowsViewDataSource.h"
#import "TVShowsTableViewDelegate.h"
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
@implementation TVShowsViewController
@synthesize delegate = _delegate;
@synthesize selectedCellIndexPath = _selectedCellIndexPath;
@synthesize forSearch = _forSearch;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.title = @"TVShows";
      self.tabBarItem.image = [UIImage imageNamed:@"70-tv.png"];
    self.variableHeightRows = YES;
    self.showTableShadows = YES;
      _forSearch = FALSE;
        _selectedCellIndexPath = nil;
	}

  return self;
}


- (id)initForSearch {
    self = [super init];
    if (self) {
        self.title = @"TVShows";
        self.tabBarItem.image = [UIImage imageNamed:@"70-tv.png"];
        self.variableHeightRows = YES;
        self.showTableShadows = YES;
        _forSearch = YES;
    }
    
    return self;
}

- (void)dealloc
{    
//    TT_RELEASE_SAFELY(_recentlyAddedTVShowss);
    TT_RELEASE_SAFELY(_toolBar);
    TT_RELEASE_SAFELY(_selectedCellIndexPath);
    TT_RELEASE_SAFELY(_titleBackground);
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
    
    _sortButton = [TTButton buttonWithStyle:@"embossedButton:" title:@"Title"];
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
        _hideWatchedButton.selected = ((TVShowsViewDataSource*)self.dataSource).hideWatched;
        [_sortButton setTitle:[((TVShowsViewDataSource*)self.dataSource) currentSortName] forState:UIControlStateNormal] ;
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
     selector:@selector(updateRecentlyAddedTVShowss:)
     name:@"recentlyAddedTVShowss"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(reloadTableView)
     name:@"tvshowCellHeightChanged"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(reloadTableView)
     name:@"tvshowCellRatingStarsChanged"
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
    
    _titleBackground.title = @"TVShows";
    _titleBackground.subtitle = @"No Items Found";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
    
    if (!_forSearch)
    {
        ////toolbar
        _toolBar = [self createToolbar];
        [[self.tableView superview] addSubview:_toolBar];
        
        //Header VIew
        TVShowsViewController* searchController = [[[TVShowsViewController alloc] initForSearch] autorelease];

        self.searchViewController = searchController;
        
//        _recentlyAddedTVShows = [[RecentlyAddedViewController alloc] init];
//        _recentlyAddedTVShows.pageControl.hidden = TRUE;
//        [_recentlyAddedTVShows.view setFrame:CGRectMake(0, _searchController.searchBar.height
//                                                       , _searchController.searchBar.width
//                                                       , 100)];
        
        UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0
                                          , _searchController.searchBar.width
                                          , _searchController.searchBar.height
                                          /*+ _recentlyAddedTVShowss.view.height*/)] 
                          autorelease];
        [header setClipsToBounds:YES];
//        [header addSubview:_recentlyAddedTVShows.view];
        [header addSubview:_searchController.searchBar];
        self.tableView.tableHeaderView = header;
        
        _searchController.searchBar.tintColor = TTSTYLEVAR(navigationBarTintColor); 
        self.searchViewController.tableView.backgroundColor = [UIColor clearColor];
        [self.searchViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
        
        [self updateRecentlyAddedTVShows:nil];

        self.tableView.contentOffset = CGPointMake(0, _searchController.searchBar.height);

        [self.tableView setCanCancelContentTouches:NO];
//        TTButton* item = [TTButton buttonWithStyle:@"navigationButton:" title:@"Update"];
//        [item addTarget:self action:@selector(updateLibrary) forControlEvents:UIControlEventTouchUpInside];
//        [item sizeToFit];
////        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(updateLibrary)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];;
//        item = [TTButton buttonWithStyle:@"navigationButton:" title:@"Options"];
//        [item addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
//        [item sizeToFit];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];;
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
//	[self modelDidStartLoad:nil];
    [super viewWillAppear:animated];
    
//    [_recentlyAddedTVShowss viewWillAppear:animated];
    
    if (self.tableView.contentOffset.y <
        self.searchDisplayController.searchBar.frame.size.height)
    {
        self.tableView.contentOffset =
        CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    }
}

- (void)viewDidAppear:(BOOL)animated 
{    
	_isViewAppearing = FALSE;
    [super viewDidAppear:animated];
//    [self loadContentForVisibleCells];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_recentlyAddedTVShowss viewWillDisappear:animated];
    [self hideToolbar];
    //    [self showEmpty:NO];
}

- (void) reloadTableView
{
	[self setSelectedCellIndexPath:nil];
	[self.tableView reloadData];
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d items"
								 , [((TVShowsViewDataSource*)self.dataSource) 
									count]];
}

-(void) hideRecentlyAddedTVShowss
{
//    [_recentlyAddedTVShowss setTVShowss:nil];
    
    UIView* header = self.tableView.tableHeaderView; 
    [header setFrame:CGRectMake(0, 0
                                , _searchController.searchBar.width
                                , _searchController.searchBar.height)];
    self.tableView.tableHeaderView = header;
    
}

- (void) persistentStoreChanged: (NSNotification *) notification 
{
    [[self navigationController] popToViewController:self animated:YES];
    [self hideRecentlyAddedTVShowss];
    [self invalidateModel];
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((TVShowsViewDataSource*)self.dataSource) count]];
}

- (void) updateStarted: (NSNotification *) notification 
{
    //    [self.model.delegates perform:@selector(modelDidStartLoad:) withObject:self.model];

//    if(!self.tableBannerView) {
//        //bannerview is adjusted by the TTTableView. it takes the full width
//        //and gets its height from TTStyleSheet
//        
//        TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBanner] autorelease];
//        UIView* lastView = [self.view.subviews lastObject];
//        label.text = @"Updating Library...";
//        [label sizeToFit];
//        label.frame = CGRectMake(0, lastView.bottom+10, self.view.width, label.height);
//        
//        [self setTableBannerView:label animated:YES];
//        //[label release];
//    }
}

- (void) updateFinished: (NSNotification *) notification 
{
//    if(self.tableBannerView) {
//        [self setTableBannerView:nil animated:YES];
//    }
}


- (void) updateLibrary {
//    [[LibraryUpdater sharedInstance] updateRecentlyAddedTVShowss];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
//	if (_isViewAppearing) return;
	NSDate *start = [[NSDate date] retain];
    self.dataSource = [[[TVShowsViewDataSource alloc]
                        initWithEntity:[[[[ActiveManager shared] managedObjectModel] 
										 entitiesByName] objectForKey:@"TVShow"] 
                        controllerTableView:self.tableView] autorelease];
    [((TVShowsViewDataSource*)self.dataSource).delegates addObject:self];
    ((TVShowsViewDataSource*)self.dataSource).forSearch = _forSearch;
	NSLog(@"createModel: %f", -[start timeIntervalSinceNow]);
//    if ([LibraryUpdater updating])
//    {
//        [self modelDidBeginUpdates:self.model];
//    }
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((TVShowsViewDataSource*)self.dataSource) count]];
}

//- (void)modelDidFinishLoad:(id)sender
//{
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((TVShowsViewDataSource*)self.dataSource) count]];
//    
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRefreshModel {
// 	[super didRefreshModel];
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d items"
									 , [((TVShowsViewDataSource*)self.dataSource) 
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
            TVShowTableItemCell *TVShowCell = (TVShowTableItemCell *)[[cells objectAtIndex: i] retain];
            [TVShowCell loadImage];
            [TVShowCell release];
            TVShowCell = nil;
        }
        [cells release];
    }
}

-(void) updateRecentlyAddedTVShows: (NSNotification *) notification
{
//    [_recentlyAddedTVShows setTVShowss:[[LibraryUpdater sharedInstance] recentlyAddedTVShowss]];
    
    UIView* header = self.tableView.tableHeaderView; 
//    if ([_recentlyAddedTVShows.TVShows count] > 0)
//    {
//        [header setFrame:CGRectMake(0, 0
//                   , _searchController.searchBar.width
//                   , _searchController.searchBar.height
//                    + _recentlyAddedTVShowss.view.height)];
//    }
//    else
    {
        [header setFrame:CGRectMake(0, 0
                                , _searchController.searchBar.width
                                , _searchController.searchBar.height)];
    }
    self.tableView.tableHeaderView = header;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TVShowsTableViewDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void) deselectCurrentObject
{
    NSIndexPath* oldIndex = [_selectedCellIndexPath retain];
    [self setSelectedCellIndexPath:nil];
//	TVShowTableItemCell *cell = (TVShowTableItemCell *)[self.tableView cellForRowAtIndexPath:oldIndex];
//    [self.tableView deselectRowAtIndexPath:oldIndex animated:NO];
	[[self.tableView cellForRowAtIndexPath:oldIndex] setSelected:FALSE];
    [self didDeselectRowAtIndexPath:oldIndex];
    [oldIndex release];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    
    NSIndexPath* oldIndex = [_selectedCellIndexPath retain];
    
//    NSIndexPath* newIndex = indexPath;
//    NSLog(@"selected %d %d", indexPath.row, indexPath.section);
    if ([indexPath isEqual:oldIndex]) 
    {
        [self deselectCurrentObject];
//        [oldIndex release];
        return;
    }
    else
    {
//    [oldIndex release];

        [self setSelectedCellIndexPath:indexPath];
//        TVShowTableItemCell *cell = (TVShowTableItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        [cell setDelegate:self];
		[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:TRUE];
//        [cell toggleImage:TRUE];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
//    TVShowTableItemCell *cell = (TVShowTableItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setDelegate:self];
//    [cell toggleImage:FALSE];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTSearchTextFieldDelegate

- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {
    //    [_delegate TVShowsViewController:self didSelectObject:object];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
    [self reloadTableView];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
//    [self hideRecentlyAddedTVShows];
    [self reloadTableView];
}


-(void)didSwipeLeft:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        [(TVShowTableItemCell*)swipedCell moreInfos:nil];
        // ...
    }
}

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((TVShowsViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((TVShowsViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((TVShowsViewDataSource*)self.dataSource) count]];
}

- (void) switchSort:(id)sender
{
    [self deselectCurrentObject];
    [_sortButton setTitle:[((TVShowsViewDataSource*)self.dataSource) switchSort] forState:UIControlStateNormal] ;
	[self reloadTableView];
}

@end

