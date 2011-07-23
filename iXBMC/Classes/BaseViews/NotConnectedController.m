#import "NotConnectedController.h"


@implementation NotConnectedController

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  [super loadView];
//   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center
//     addObserver:self
//     selector:@selector(connectedToXBMC:)
//     name:@"ConnectedToXBMC"
//     object:nil ];

    TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:@"Not Connected"
                                                         subtitle:@"Tap here to go to the Settings Page"
                                                            image:TTIMAGE(@"bundle://error.png")] 
                               autorelease];
	errorView.frame = self.view.frame;
    errorView.backgroundColor = TTSTYLEVAR(tableViewBackColor);
    errorView.userInteractionEnabled= YES;
	errorView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    
//    //create new uiview with a background image
//    UIImage *backgroundImage = TTIMAGE(@"bundle://detailsback.png");
//    UIImageView *backgroundView = [[[UIImageView alloc] 
//                        initWithImage:backgroundImage] autorelease];
//    [errorView addSubview:backgroundView];
//    [errorView sendSubviewToBack:backgroundView];
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [errorView addGestureRecognizer:tapgr];
    [tapgr release]; 

    self.view = errorView;
    
}

- (void)viewWillAppear:(BOOL)animated 
{
}

//- (void)connectedToXBMC: (NSNotification *) notification
//{
//    [self dismissModalViewControllerAnimated:NO];
//}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    TTOpenURLFromView(@"tt://settings", [[TTNavigator navigator] topViewController].view);
}

@end
