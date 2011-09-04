
#import "BaseTableViewController.h"
#import "BaseTableItemCell.h"

#import "CustomTitleView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BaseTableViewController
@synthesize selectedCellIndexPath = _selectedCellIndexPath;
@synthesize forSearch = _forSearch;

///////////////////////////////////////////////////////////////////////////////////////////////////


- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.variableHeightRows = YES;
        _selectedCellIndexPath = nil;
		_forSearch = FALSE;
	}

  return self;
}

- (void)dealloc
{    
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
     selector:@selector(persistentStoreChanged:)
     name:@"persistentStoreChanged"
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
	 name:@"cacheCleared"
	 object:nil ];
	
	[center
	 addObserver:self
	 selector:@selector(reloadTableView)
	 name:@"highQualityChanged"
	 object:nil ];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:gesture];
    [gesture release];
	
	gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:gesture];
    [gesture release];
	
	gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
//    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:gesture];
    [gesture release];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
    
    self.view.backgroundColor = TTSTYLEVAR(tableViewBackColor);
    self.tableView.backgroundColor = TTSTYLEVAR(tableViewBackColor);
    
    _titleBackground = [[[CustomTitleView alloc] init] retain];
    
    _titleBackground.title = @"Items";
    _titleBackground.subtitle = @"No Items Found";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
    
    if (!_forSearch)
    {
        ////toolbar
        _toolBar = [self createToolbar];
        [[self.tableView superview] addSubview:_toolBar];
        
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
	[self deselectCurrentObject];
//	[self modelDidStartLoad:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideToolbar];
}

- (void) updateSubtitle
{
	_titleBackground.subtitle = @"no items";
}

- (void) reloadTableView
{
	[self setSelectedCellIndexPath:nil];
	[self.tableView reloadData];
	[self updateSubtitle];
}

- (void) persistentStoreChanged: (NSNotification *) notification 
{
    [[self navigationController] popToViewController:self animated:YES];
    [self invalidateModel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRefreshModel {
	[self updateSubtitle];
}

- (void) modelDidFinishLoad:(id<TTModel>)model{
    
    [super modelDidFinishLoad:model];
    
    [self reloadTableView];
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

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath 
{
	[self setSelectedCellIndexPath:indexPath];
    [self deselectCurrentObject];
	UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:indexPath];
	[(BaseTableItemCell*)swipedCell activate];

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
		[self deselectCurrentObject];
        [(BaseTableItemCell*)swipedCell activate];
    }
}

-(void)didSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
		[self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)didLongPress:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
		//        UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        
		NSIndexPath* oldIndex = [_selectedCellIndexPath retain];
		[self deselectCurrentObject];
		if (![swipedIndexPath isEqual:oldIndex]) 
		{
			[self setSelectedCellIndexPath:swipedIndexPath];
			[[self.tableView cellForRowAtIndexPath:swipedIndexPath] setSelected:TRUE];        
			[self.tableView beginUpdates];
			[self.tableView endUpdates];
			[self.tableView scrollToRowAtIndexPath:swipedIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
		}
		
    }
}

@end

