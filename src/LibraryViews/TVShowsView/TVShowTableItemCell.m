
#import "TVShowTableItemCell.h"
#import "TVShowTableItem.h"
#import "TVShowsViewDataSource.h"

#import "TVShowCellView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TVShowTableItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) 
    {		
		// Create a time zone view and add it as a subview of self's contentView.
//		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//		CGFloat height = [[defaults valueForKey:@"tvshowCell:height"] floatValue];
		CGRect tzvFrame = self.contentView.bounds;
		_infoView = [[TVShowCellView alloc] initWithFrame:tzvFrame];
//		_infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_infoView];
		
        _detailsButton = [[[TTButton alloc] initWithFrame:CGRectZero] autorelease];
        [_detailsButton setTitle:@"Info" forState:UIControlStateNormal];
        [_detailsButton setBackgroundColor:[UIColor clearColor]];
        [_detailsButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_detailsButton addTarget:self action:@selector(moreInfos:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailsButton];
        
        _tvdbButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_tvdbButton setTitle:@"TheTvdb" forState:UIControlStateNormal];
        [_tvdbButton setBackgroundColor:[UIColor clearColor]];
        [_tvdbButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_tvdbButton addTarget:self action:@selector(tvdb:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_tvdbButton];
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cellHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"tvshowCell:height"] floatValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object 
{
    [super setObject:object];
    if (_item != nil)
    {
        TVShowTableItem* item = (TVShowTableItem*)_item;
		        
        [_buttons addObject:_detailsButton];

        if (item.tvdb != nil && ![item.tvdb isEqual:@""])
        {
            _tvdbButton.hidden = FALSE;
            [_buttons addObject:_tvdbButton];
        }
        else
        {
            _tvdbButton.hidden = TRUE;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark actions

-(void) play:(id)sender
{
//    if (((TVShowTableItem*)_item).file)
//    {
////        [XBMCStateListener play:((TVShowsTableItem*)_item).file];
//    }
}
-(void) enqueue:(id)sender
{
//    if ([delegate respondsToSelector:@selector(TVShows:action:)])
//    {
////        [delegate TVShows:TVShows action:@"enqueue"];
//    }
}

-(void) moreInfos:(id)sender
{	
}

-(void) activate
{	
	NSString* url = [NSString stringWithFormat:@"tt://library/seasons/%@/%d"
					 ,((TVShowTableItem*)_item).itemId, !((TVShowTableItem*)_item).dataSource.hideWatched];
	TTOpenURL(url);
}

-(void) tvdb:(id)sender
{
    if (((TVShowTableItem*)_item).tvdb)
    {
		NSLog(@"tvdb %@", ((TVShowTableItem*)_item).tvdb);
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showTvdb:((TVShowTableItem*)_item).tvdb];
    }
}

@end
