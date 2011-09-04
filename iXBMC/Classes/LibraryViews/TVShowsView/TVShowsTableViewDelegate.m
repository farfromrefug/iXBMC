#import "TVShowsTableViewDelegate.h"
#import "TVShowsViewController.h"
#import "TVShowsViewDataSource.h"
#import "TVShowTableItemCell.h"
#import "TableHeaderView.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TVShowsTableViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithController:(TTTableViewController*)controller {
    self = [super initWithController:controller];
    if (self) {
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
#pragma mark UIScrollViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([(TVShowsViewController*)_controller forSearch])
    {
        return 0;
    }
	return 20;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"tvshowCell:height"] floatValue];
    
    if ([(TVShowsViewController*)_controller forSearch])
    {
        height = TTSTYLEVAR(tableViewCellSearchHeight) ;
    }
    
    if ([[(TVShowsViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
    {
        height += TTSTYLEVAR(tableViewCellMenuHeight);
    }
    
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{    
	TableHeaderView* view = [[TableHeaderView alloc] init];
	view.label = [((TVShowsViewDataSource*)((TVShowsViewController*)_controller).dataSource) tableView:tableView titleForHeaderInSection:section];
	return [view autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView 
{
    [super scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ///.....
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(TVShowsViewController*)_controller didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[(TVShowsViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
	{
		[(TVShowTableItemCell *)cell setSelected:TRUE];
	}
}

@end
