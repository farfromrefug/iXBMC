
#import "TVShowsViewController.h"
#import "TVShowTableItemCell.h"
#import "TVShowsViewDataSource.h"
#import "TVShowsTableViewDelegate.h"
#import "TVShow.h"
#import "Season.h"
#import "Episode.h"

#import "ActiveManager.h"

#import "BCTab.h"

#import "RecentlyAddedEpisodesViewController.h"
#import "CustomTitleView.h"

#import "LibraryUpdater.h"
#import "XBMCStateListener.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TVShowsViewController
@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)iconImageName {
	return @"iconTVShows.png";
}

- (NSString *)selectedIconImageNameSuffix
{
	return @"On";
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
}

- (NSString *)iconTitle {
	return @"TVShows";
}

- (id)initWithWatched:(BOOL)watched
{
    self = [super init];
    if (self) {
		self.variableHeightRows = YES;
		//self.showTableShadows = YES;
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
    TT_RELEASE_SAFELY(_recentlyAddedEpisodes);
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
        _hideWatchedButton.selected = ((TVShowsViewDataSource*)self.dataSource).hideWatched;
        [_sortButton setTitle:[((TVShowsViewDataSource*)self.dataSource) currentSortName] forState:UIControlStateNormal] ;
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
		 selector:@selector(updateRecentlyAddedEpisodes:)
		 name:@"recentlyAddedEpisodes"
		 object:nil ];
		
		[center
		 addObserver:self
		 selector:@selector(reloadTableView)
		 name:@"tvshowCellHeightChanged"
		 object:nil ];
	}
	
	[center
	 addObserver:self
	 selector:@selector(reloadTableView)
	 name:@"tvshowCellRatingStarsChanged"
	 object:nil ];
        
    _titleBackground.title = @"TVShows";
    _titleBackground.subtitle = @"No Items Found";
        
    if (!_forSearch)
    {
        //Header VIew
        TVShowsViewController* searchController = [[[TVShowsViewController alloc] initForSearch] autorelease];

        self.searchViewController = searchController;
        
        _recentlyAddedEpisodes = [[RecentlyAddedEpisodesViewController alloc] init];
        _recentlyAddedEpisodes.pageControl.hidden = TRUE;
        [_recentlyAddedEpisodes.view setFrame:CGRectMake(0, _searchController.searchBar.height
                                                       , _searchController.searchBar.width
                                                       , 75)];
        
        UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0
                                          , _searchController.searchBar.width
                                          , _searchController.searchBar.height)] 
                          autorelease];
        [header setClipsToBounds:YES];
        header.backgroundColor = [UIColor clearColor]; 
        [header addSubview:_recentlyAddedEpisodes.view];
        [header addSubview:_searchController.searchBar];
        self.tableView.tableHeaderView = header;
        
        _searchController.searchBar.barStyle = UIBarStyleBlack; 
        _searchController.searchBar.tintColor = TTSTYLEVAR(tableViewBackColor); 
//        self.searchViewController.tableView.backgroundColor = [UIColor clearColor];
//        [self.searchViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
//        
//        [self updateRecentlyAddedEpisodes:nil];

        self.tableView.contentOffset = CGPointMake(0, _searchController.searchBar.height);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
//	[self modelDidStartLoad:nil];
    [super viewWillAppear:animated];
    
    [_recentlyAddedEpisodes viewWillAppear:animated];
    
    if (self.tableView.contentOffset.y <
        self.searchDisplayController.searchBar.frame.size.height)
    {
        self.tableView.contentOffset =
        CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    }
	if (_recentlyAddedEpisodes.episodes == nil)
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
    [_recentlyAddedEpisodes viewWillDisappear:animated];
}

- (void) updateSubtitle
{
	_titleBackground.subtitle = [NSString stringWithFormat:@"%d shows"
								 , [((TVShowsViewDataSource*)self.dataSource) 
									count]];
}

-(void) hideRecentlyAddedEpisodes
{
    [_recentlyAddedEpisodes setEpisodes:nil];
    
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
    [self hideRecentlyAddedEpisodes];
}

- (void) updateStarted: (NSNotification *) notification 
{
	if ([((TVShowsViewDataSource*)self.dataSource) count] == 0 )
	{
		[self showLoading:TRUE];
	}
}

- (void) updateFinished: (NSNotification *) notification 
{
}


- (void) updateLibrary {
    [[LibraryUpdater sharedInstance] updateRecentlyAddedEpisodes:TRUE];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[TVShowsViewDataSource alloc]
                        initWithWatched:_startWithWatched 
                        controllerTableView:self.tableView] autorelease];
    [((TVShowsViewDataSource*)self.dataSource).delegates addObject:self];
    ((TVShowsViewDataSource*)self.dataSource).forSearch = _forSearch;
}
-(void) updateRecentlyAddedEpisodes: (NSNotification *) notification
{
    [_recentlyAddedEpisodes setEpisodes:[[LibraryUpdater sharedInstance] recentlyAddedEpisodes]];
    
    UIView* header = self.tableView.tableHeaderView; 
	
	[UIView beginAnimations:nil context:self.tableView];
	[UIView setAnimationDuration:0.5];
	CGFloat height = _searchController.searchBar.height;
	
    if ([_recentlyAddedEpisodes nbEpisodes] > 0)
    {
        height = _searchController.searchBar.height
		+ _recentlyAddedEpisodes.view.height;
    }

	[header setFrame:CGRectMake(header.frame.origin.x, header.frame.origin.y
								, header.frame.size.width
								, height)];
    self.tableView.tableHeaderView = header;
    [UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TVShowsTableViewDelegate alloc] initWithController:self] autorelease];
}


- (void)connectedToXBMC: (NSNotification *) notification
{
    [super connectedToXBMC:notification];
	[self updateLibrary];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [super disconnectedFromXBMC:notification];
    [self hideRecentlyAddedEpisodes];
}

- (void) toggleWatched:(id)sender
{
    [self deselectCurrentObject];
    [((TVShowsViewDataSource*)self.dataSource) toggleWatched];
    _hideWatchedButton.selected = ((TVShowsViewDataSource*)self.dataSource).hideWatched;
	[self reloadTableView];
}

- (void) switchSort:(id)sender
{
    [self deselectCurrentObject];
    [_sortButton setTitle:[((TVShowsViewDataSource*)self.dataSource) switchSort] forState:UIControlStateNormal] ;
	[self reloadTableView];
}

@end

