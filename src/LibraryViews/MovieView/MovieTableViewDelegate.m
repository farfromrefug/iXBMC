#import "MovieTableViewDelegate.h"
#import "MovieViewController.h"
#import "MovieViewDataSource.h"
#import "MovieTableItemCell.h"
#import "TableHeaderView.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MovieTableViewDelegate


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
//    if ([[((MovieViewDataSource*)((MovieViewController*)_controller).dataSource) currentSortName] isEqualToString:@"Title"])
//        return 30;
//    else 
        return 20;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"movieCell:height"] floatValue];
    
    if ([(MovieViewController*)_controller forSearch])
    {
        height = TTSTYLEVAR(tableViewCellSearchHeight) ;
    }
    
    if ([[(MovieViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
    {
        height += TTSTYLEVAR(tableViewCellMenuHeight);
    }
    
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	TableHeaderView* view = [[TableHeaderView alloc] init];
	view.label = [((MovieViewDataSource*)((MovieViewController*)_controller).dataSource) tableView:tableView titleForHeaderInSection:section];
	return [view autorelease];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView 
{
    [super scrollViewDidEndDecelerating:scrollView];

//    [(MovieViewController*)_controller loadContentForVisibleCells]; 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ///.....
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

    if (!decelerate) 
    {
//        [(MovieViewController*)_controller loadContentForVisibleCells]; 
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(MovieViewController*)_controller didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[(MovieViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
	{
		[(MovieTableItemCell *)cell setSelected:TRUE];
	}
    //[(MovieTableItemCell*)cell loadImage];
}

@end
