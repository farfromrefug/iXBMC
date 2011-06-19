#import "SettingsViewController.h"
#import "SettingsViewControllerDelegate.h"
#import "SettingsViewDataSource.h"
#import "HostTableItem.h"
#import "HostTableItemCell.h"

#import "BCTab.h"
#import "CustomSwitch.h"

@implementation SettingsViewController
@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (NSString *)iconImageName {
	return @"106-sliders.png";
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
}

- (NSString *)iconTitle {
	return @"Settings";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.variableHeightRows = YES;
//        self.tableViewStyle = UITableViewStylePlain;      
        self.showTableShadows = YES;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
//        //create new uiview with a background image
//        UIImage *backgroundImage = TTIMAGE(@"bundle://tableViewback.png");
//        UIImageView *backgroundView = [[[UIImageView alloc] 
//                                        initWithImage:backgroundImage] autorelease];
//        self.tableView.backgroundView = backgroundView;
//        //adjust the frame for the case of navigation or tabbars
//        backgroundView.frame = self.view.frame;
//        
//        //add background view and send it to the back
//        [self.view addSubview:backgroundView];
//        [self.view sendSubviewToBack:backgroundView];

    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; 
	self.tableView.backgroundColor = [UIColor clearColor];
	self.view.backgroundColor = [UIColor clearColor];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(addHost:)
     name:@"hostAdded"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(updateHost:)
     name:@"hostUpdated"
     object:nil ];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

}
- (void) createModel {
    NSMutableArray* hostsData = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* hosts = [defaults objectForKey:@"hosts"];

    for(NSString *aKey in [defaults objectForKey:@"hosts"])
    {
        [hostsData addObject:[HostTableItem 
                         itemWithText:aKey
                         subtitle:[[hosts objectForKey:aKey] valueForKey:@"address"]]];            
    }

    TTTableLink* addHost = [TTTableLink itemWithText:@"Add Host" URL:@"tt://addserver"];
    [hostsData addObject:addHost];
	
	CustomSwitch* button;
	TTTableControlItem* switchControlItem;
	
	NSMutableArray* generalSettingsData = [[NSMutableArray alloc] init];

	button =  [CustomSwitch switchWithTitle:@""];
	button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
	| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
	| UIViewAutoresizingFlexibleTopMargin ;      
	[button addTarget:self action:@selector(highQualityChanged:) 
	 forControlEvents:UIControlEventTouchUpInside];
	
	[button setSelected:[[defaults valueForKey:@"images:highQuality"] boolValue]];
	
	switchControlItem = [TTTableControlItem itemWithCaption:@"HD images (Slower)" control:button];
	[generalSettingsData addObject:switchControlItem];
    
    NSMutableArray* moviesViewData = [[NSMutableArray alloc] init];
    
    UISlider* slider = [[[UISlider alloc] init] autorelease];
    
    UIImage *minImage = TTIMAGE(@"bundle://sliderMin.png");
    UIImage *maxImage = TTIMAGE(@"bundle://sliderMax.png");
    UIImage *tumbImage= TTIMAGE(@"bundle://osd_slidernubf2.png");
    UIImage *tumbImageOn= TTIMAGE(@"bundle://osd_slidernubf.png");
    minImage=[minImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:4.0];
    maxImage=[maxImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:4.0];
    [slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [slider setThumbImage:tumbImage forState:UIControlStateNormal];
    [slider setThumbImage:tumbImageOn forState:UIControlStateHighlighted];

    [slider addTarget:self action:@selector(movieCellHeightChanged:) 
     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    slider.minimumValue = TTSTYLEVAR(movieCellMinHeight);
    slider.maximumValue = TTSTYLEVAR(movieCellMaxHeight);
    slider.continuous = YES;
    [slider setValue:[[defaults valueForKey:@"movieCell:height"] floatValue]];
    
    TTTableControlItem* sliderItem = [TTTableControlItem itemWithCaption:@"Cells Height" control:slider];
    [moviesViewData addObject:sliderItem];
    
    button =  [CustomSwitch switchWithTitle:@""];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
                        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
                        | UIViewAutoresizingFlexibleTopMargin ;      
    [button addTarget:self action:@selector(movieCellRatingStarsChanged:) 
     forControlEvents:UIControlEventTouchUpInside];

    [button setSelected:[[defaults valueForKey:@"movieCell:ratingStars"] boolValue]];
    
    switchControlItem = [TTTableControlItem itemWithCaption:@"rating Stars" control:button];
    [moviesViewData addObject:switchControlItem];
	
	NSMutableArray* tvshowsViewData = [[NSMutableArray alloc] init];
    
    slider = [[[UISlider alloc] init] autorelease];
    minImage=[minImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:4.0];
    maxImage=[maxImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:4.0];
    [slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [slider setThumbImage:tumbImage forState:UIControlStateNormal];
    [slider setThumbImage:tumbImageOn forState:UIControlStateHighlighted];
	
    [slider addTarget:self action:@selector(tvshowCellHeightChanged:) 
     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    slider.minimumValue = TTSTYLEVAR(tvshowCellMinHeight);
    slider.maximumValue = TTSTYLEVAR(tvshowCellMaxHeight);
    slider.continuous = YES;
    [slider setValue:[[defaults valueForKey:@"tvshowCell:height"] floatValue]];
    
    sliderItem = [TTTableControlItem itemWithCaption:@"Cells Height" control:slider];
    [tvshowsViewData addObject:sliderItem];
    
    button =  [CustomSwitch switchWithTitle:@""];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
	| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
	| UIViewAutoresizingFlexibleTopMargin ;      
    [button addTarget:self action:@selector(tvshowCellRatingStarsChanged:) 
     forControlEvents:UIControlEventTouchUpInside];
	
    [button setSelected:[[defaults valueForKey:@"tvshowCell:ratingStars"] boolValue]];
    
    switchControlItem = [TTTableControlItem itemWithCaption:@"rating Stars" control:button];
    [tvshowsViewData addObject:switchControlItem];
    
    
    // This demonstrates how to create a table with standard table "fields".  Many of these
    // fields with URLs that will be visited when the row is selected
    self.dataSource = [SettingsViewDataSource dataSourceWithArrays:@"Hosts",hostsData
                       ,@"General", generalSettingsData
					   ,@"Movies View", moviesViewData
					   ,@"TVShows View", tvshowsViewData, nil];
    [hostsData release];
    [generalSettingsData release];
    [moviesViewData release];
    [tvshowsViewData release];
}

-(void)addHost: (NSNotification *) notification
{
    NSUInteger index = [self.tableView numberOfRowsInSection:0] - 1;
    NSDictionary* userInfo = [notification userInfo];
    HostTableItem* object = [HostTableItem 
                                   itemWithText:[userInfo valueForKey:@"name"]
                                   subtitle:[userInfo valueForKey:@"address"]];

    NSArray *hosts = [((TTSectionedDataSource*)self.dataSource).items objectAtIndex:0];
    [[((TTSectionedDataSource*)self.dataSource).items objectAtIndex:0] insertObject:object atIndex:[hosts count]-1];
    //    [hosts release];
    
    [(TTModel*)self.model beginUpdates];
    [(TTModel*)self.model didInsertObject: object
                    atIndexPath:[NSIndexPath 
                                 indexPathForRow:index inSection:0]];
    [(TTModel*)self.model endUpdates];
}

-(void)updateHost: (NSNotification *) notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSArray *hosts = [((TTSectionedDataSource*)self.dataSource).items objectAtIndex:0];
    int index = 0;
    for (id item in hosts)
     {
         if ([item isKindOfClass:[HostTableItem class]]
             && [((HostTableItem*)item).text isEqualToString:[userInfo valueForKey:@"name"]])
         {
//             NSLog(@"test update %@", userInfo);
             ((HostTableItem*)item).subtitle = [userInfo valueForKey:@"address"];
//             [(TTModel*)self.model beginUpdates];
//             [(TTModel*)self.model didUpdateObject:item atIndexPath:[NSIndexPath 
//                                                                     indexPathForRow:index inSection:0]];
//             [(TTModel*)self.model endUpdates];
             [self.tableView reloadData];
             break;
         }
         index++;
     }
}

- (void)dealloc {
    [super dealloc];
}

-(void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

//- (void)connectedToXBMC: (NSNotification *) notification
//{
//    [self dismissModalViewControllerAnimated:NO];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0
        && indexPath.row < [self.tableView numberOfRowsInSection:0] - 1)
    {
//        if (self.editing)
//        {
//            NSString* url = [NSString stringWithFormat:@"tt://addserver/%@",[(TTTableSubtitleItem*)object text]];
//            // [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:url]];
//            
//            [((AppDelegate*)[UIApplication sharedApplication].delegate) openURL:url];
//        }
//        else
//        {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////            NSLog(@"selected %@",[(TTTableSubtitleItem*)object text]);
//            [defaults setObject:[(TTTableSubtitleItem*)object text] forKey:@"currenthost"];
//            [defaults synchronize];
//            [[NSNotificationCenter defaultCenter] 
//             postNotificationName:@"hostChanged" 
//             object:nil];	
//        }
    }
    else
    {
        [_delegate controller:self didSelectObject:object];
    }
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[SettingsViewControllerDelegate alloc] initWithController:self] autorelease];
}

- (void)highQualityChanged:(id)sender {
    
    TTButton *control = (TTButton *)sender;
    
    BOOL value = !control.selected;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:value] forKey:@"images:highQuality"];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"highQualityChanged" 
     object:nil];
    control.selected = value;
}

- (void)movieCellHeightChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    CGFloat value = slider.value;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithFloat:value] forKey:@"movieCell:height"];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"movieCellHeightChanged" 
     object:nil];
}

- (void)tvshowCellHeightChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    CGFloat value = slider.value;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithFloat:value] forKey:@"tvshowCell:height"];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"tvshowCellHeightChanged" 
     object:nil];
}

- (void)movieCellRatingStarsChanged:(id)sender {
    
    TTButton *control = (TTButton *)sender;
    
    BOOL value = !control.selected;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:value] forKey:@"movieCell:ratingStars"];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"movieCellRatingStarsChanged" 
     object:nil];
    control.selected = value;
}

- (void)tvshowCellRatingStarsChanged:(id)sender {
    
    TTButton *control = (TTButton *)sender;
    
    BOOL value = !control.selected;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:value] forKey:@"tvshowCell:ratingStars"];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"tvshowCellRatingStarsChanged" 
     object:nil];
    control.selected = value;
}

@end
