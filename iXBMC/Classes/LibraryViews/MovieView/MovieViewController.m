
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)iconImageName {
	return @"iconMovies.png";
}

- (NSString *)selectedIconImageNameSuffix
{
	return @"On";
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
}

- (NSString *)iconTitle {
	return @"Movies";
}

- (id)initWithWatched:(BOOL)watched
{
	self = [super init];
    if (self) {
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

- (void) toggleToolbar
{
    if (_toolBar.bottom == 0)
    {
        _hideWatchedButton.selected = ((MovieViewDataSource*)self.dataSource).hideWatched;
        [_sortButton setTitle:[((MovieViewDataSource*)self.dataSource) currentSortName] forState:UIControlStateNormal] ;
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
	 name:@"movieCellRatingStarsChanged"
	 object:nil ];
    
    _titleBackground.title = @"Movies";
    _titleBackground.subtitle = @"No Items Found";
    
    if (!_forSearch)
    {
        
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
        
        _searchController.searchBar.tintColor = TTSTYLEVAR(tableViewBackColor); 
        self.searchViewController.tableView.backgroundColor = [UIColor clearColor];
        [self.searchViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
        
        [self updateRecentlyAddedMovies:nil];

        self.tableView.contentOffset = CGPointMake(0, _searchController.searchBar.height);

    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [_recentlyAddedMovies viewWillAppear:animated];
    
    if (self.tableView.contentOffset.y <
        self.searchDisplayController.searchBar.frame.size.height)
    {
        self.tableView.contentOffset =
        CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    }
	if (_recentlyAddedMovies.movies == nil)
	{
		[self updateLibrary];
	}
}

- (void)viewDidAppear:(BOOL)animated 
{    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_recentlyAddedMovies viewWillDisappear:animated];
}

- (void) updateSubtitle
{
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d movies"
								 , [((MovieViewDataSource*)self.dataSource) 
									count]];
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
    [super persistentStoreChanged:notification];
    [self hideRecentlyAddedMovies];
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

- (void)connectedToXBMC: (NSNotification *) notification
{
    [super connectedToXBMC:notification];
	[self updateLibrary];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [super disconnectedFromXBMC:notification];
    [self hideRecentlyAddedMovies];
}

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((MovieViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((MovieViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
}

- (void) switchSort:(id)sender
{
    [self deselectCurrentObject];
    [_sortButton setTitle:[((MovieViewDataSource*)self.dataSource) switchSort] forState:UIControlStateNormal] ;
	[self reloadTableView];
}

@end

