
#import "MovieViewController.h"
#import "MovieTableItemCell.h"
#import "MovieViewDataSource.h"
#import "MovieTableViewDelegate.h"
#import "Movie.h"

#import "ActiveManager.h"

#import "RecentlyAddedMoviesViewController.h"
#import "CustomTitleView.h"

#import "BCTab.h"

#import "LibraryUpdater.h"
#import "XBMCStateListener.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MovieViewController
@synthesize delegate = _delegate;
@synthesize selectedCellIndexPath = _selectedCellIndexPath;
@synthesize forSearch = _forSearch;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)iconImageName {
	return @"46-movie-2.png";
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
}

- (NSString *)iconTitle {
	return @"Movies";
}

- (id)initWithWatched:(BOOL)watched
{
	self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.variableHeightRows = YES;
		self.showTableShadows = YES;
		_forSearch = FALSE;
        _selectedCellIndexPath = nil;
		_startWithWatched = watched;
	}

  return self;
}


- (id)initForSearch {
    self = [self initWithWatched:YES];
    if (self) {
        _forSearch = YES;
    }
    
    return self;
}

- (void)dealloc
{    
    TT_RELEASE_SAFELY(_recentlyAddedMovies);
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
    [UIView setAnimationDuration:TTSTYLEVAR(toolbarAnimationDuration)];
    _toolBar.bottom =  0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void) toggleToolbar
{
    if (_toolBar.bottom == 0)
    {
        _hideWatchedButton.selected = ((MovieViewDataSource*)self.dataSource).hideWatched;
        [_sortButton setTitle:[((MovieViewDataSource*)self.dataSource) currentSortName] forState:UIControlStateNormal] ;
    }
    
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:TTSTYLEVAR(toolbarAnimationDuration)];
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
    
	if (!_forSearch)
	{
		[center
		 addObserver:self
		 selector:@selector(updateRecentlyAddedMovies:)
		 name:@"recentlyAddedMovies"
		 object:nil ];
		
		[center
		 addObserver:self
		 selector:@selector(reloadTableView)
		 name:@"movieCellHeightChanged"
		 object:nil ];
	}
	
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
	 name:@"movieCellRatingStarsChanged"
	 object:nil ];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:gesture];
    [gesture release];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
    
    //clear background color of uitableview
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    
//    //create new uiview with a background image
//    UIImage *backgroundImage = TTIMAGE(@"bundle://tableViewback.png");
//    UIImageView *backgroundView = [[[UIImageView alloc] 
//                                   initWithImage:backgroundImage] autorelease];
//    
//    //adjust the frame for the case of navigation or tabbars
//    backgroundView.frame = self.tableView.frame;
//    
//    //add background view and send it to the back
//    [self.view addSubview:backgroundView];
//    [self.view sendSubviewToBack:backgroundView];
    
    _titleBackground = [[[CustomTitleView alloc] init] retain];
    
    _titleBackground.title = @"Movies";
    _titleBackground.subtitle = @"No Items Found";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
    
    if (!_forSearch)
    {
        ////toolbar
        _toolBar = [self createToolbar];
        [[self.tableView superview] addSubview:_toolBar];
        
        //Header VIew
        MovieViewController* searchController = [[[MovieViewController alloc] initForSearch] autorelease];

        self.searchViewController = searchController;
        
        _recentlyAddedMovies = [[RecentlyAddedMoviesViewController alloc] init];
        _recentlyAddedMovies.pageControl.hidden = TRUE;
        [_recentlyAddedMovies.view setFrame:CGRectMake(0, _searchController.searchBar.height
                                                       , _searchController.searchBar.width
                                                       , 100)];
        
        UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0
                                          , _searchController.searchBar.width
                                          , _searchController.searchBar.height
                                          + _recentlyAddedMovies.view.height)] 
                          autorelease];
        [header setClipsToBounds:YES];
        [header addSubview:_recentlyAddedMovies.view];
        [header addSubview:_searchController.searchBar];
        self.tableView.tableHeaderView = header;
        
        _searchController.searchBar.tintColor = TTSTYLEVAR(navigationBarTintColor); 
        self.searchViewController.tableView.backgroundColor = [UIColor clearColor];
        [self.searchViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
        
        [self updateRecentlyAddedMovies:nil];

        self.tableView.contentOffset = CGPointMake(0, _searchController.searchBar.height);

        [self.tableView setCanCancelContentTouches:NO];
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
    
    [_recentlyAddedMovies viewWillAppear:animated];
    
    if (self.tableView.contentOffset.y <
        self.searchDisplayController.searchBar.frame.size.height)
    {
        self.tableView.contentOffset =
        CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    }
	[self updateLibrary];
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
    [_recentlyAddedMovies viewWillDisappear:animated];
    [self hideToolbar];
    //    [self showEmpty:NO];
}

- (void) updateSubtitle
{
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d movies"
								 , [((MovieViewDataSource*)self.dataSource) 
									count]];
}

- (void) reloadTableView
{
	[self setSelectedCellIndexPath:nil];
	[self.tableView reloadData];
	[self updateSubtitle];
}

-(void) hideRecentlyAddedMovies
{
    [_recentlyAddedMovies setMovies:nil];
    
	[UIView beginAnimations:nil context:self.tableView];
	[UIView setAnimationDuration:0.5];
	
    UIView* header = self.tableView.tableHeaderView; 
    [header setFrame:CGRectMake(0, 0
                                , _searchController.searchBar.width
                                , _searchController.searchBar.height)];
    self.tableView.tableHeaderView = header;
	
    [UIView commitAnimations];
}

- (void) persistentStoreChanged: (NSNotification *) notification 
{
    [[self navigationController] popToViewController:self animated:YES];
    [self hideRecentlyAddedMovies];
    [self invalidateModel];
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((MovieViewDataSource*)self.dataSource) count]];
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
    [[LibraryUpdater sharedInstance] updateRecentlyAddedMovies:TRUE];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	NSDate *start = [[NSDate date] retain];
    self.dataSource = [[[MovieViewDataSource alloc]
						initWithWatched:_startWithWatched 
						controllerTableView:self.tableView] autorelease];
    [((MovieViewDataSource*)self.dataSource).delegates addObject:self];
    ((MovieViewDataSource*)self.dataSource).forSearch = _forSearch;
	[start release];
//    if ([LibraryUpdater updating])
//    {
//        [self modelDidBeginUpdates:self.model];
//    }
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((MovieViewDataSource*)self.dataSource) count]];
}

//- (void)modelDidFinishLoad:(id)sender
//{
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((MovieViewDataSource*)self.dataSource) count]];
//    
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRefreshModel {
	[self updateSubtitle];
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
            MovieTableItemCell *movieCell = (MovieTableItemCell *)[[cells objectAtIndex: i] retain];
            [movieCell loadImage];
            [movieCell release];
            movieCell = nil;
        }
        [cells release];
    }
}

-(void) updateRecentlyAddedMovies: (NSNotification *) notification
{
    [_recentlyAddedMovies setMovies:[[LibraryUpdater sharedInstance] recentlyAddedMovies]];
    
    UIView* header = self.tableView.tableHeaderView; 
	
	[UIView beginAnimations:nil context:self.tableView];
	[UIView setAnimationDuration:0.5];
    if ([_recentlyAddedMovies nbMovies] > 0)
    {
        [header setFrame:CGRectMake(0, 0
                   , _searchController.searchBar.width
                   , _searchController.searchBar.height
                    + _recentlyAddedMovies.view.height)];
    }
    else
    {
        [header setFrame:CGRectMake(0, 0
                                , _searchController.searchBar.width
                                , _searchController.searchBar.height)];
    }
    self.tableView.tableHeaderView = header;
    [UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[MovieTableViewDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void) deselectCurrentObject
{
    NSIndexPath* oldIndex = [_selectedCellIndexPath retain];
    [self setSelectedCellIndexPath:nil];
	MovieTableItemCell *cell = (MovieTableItemCell *)[self.tableView cellForRowAtIndexPath:oldIndex];
//    [self.tableView deselectRowAtIndexPath:oldIndex animated:NO];
	[cell setSelected:FALSE];
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
        MovieTableItemCell *cell = (MovieTableItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        [cell setDelegate:self];
		[cell setSelected:TRUE];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MovieTableItemCell *cell = (MovieTableItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setDelegate:self];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTSearchTextFieldDelegate

- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {
    //    [_delegate movieViewController:self didSelectObject:object];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
    [self reloadTableView];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [self hideRecentlyAddedMovies];
    [self reloadTableView];
}


-(void)didSwipeLeft:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        [(MovieTableItemCell*)swipedCell moreInfos:nil];
        // ...
    }
}

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((MovieViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((MovieViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
//    _titleBackground.subtitle = [NSString stringWithFormat:@"%d items", [((MovieViewDataSource*)self.dataSource) count]];
}

- (void) switchSort:(id)sender
{
    [self deselectCurrentObject];
    [_sortButton setTitle:[((MovieViewDataSource*)self.dataSource) switchSort] forState:UIControlStateNormal] ;
	[self reloadTableView];
}

@end

