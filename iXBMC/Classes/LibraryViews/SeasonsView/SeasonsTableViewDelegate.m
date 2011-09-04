#import "SeasonsTableViewDelegate.h"
#import "SeasonsViewController.h"
#import "SeasonsViewDataSource.h"
#import "SeasonTableItemCell.h"
#import "TableHeaderView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeasonsTableViewDelegate


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
//    if ([[((SeasonsViewDataSource*)((SeasonsViewController*)_controller).dataSource) currentSortName] isEqualToString:@"Title"])
//        return 30;
//    else 
        return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"seasonCell:height"] floatValue];

    if ([[(SeasonsViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
    {
        height += TTSTYLEVAR(tableViewCellMenuHeight);
    }
    
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
	TableHeaderView* view = [[TableHeaderView alloc] init];
	view.label = [((SeasonsViewDataSource*)((SeasonsViewController*)_controller).dataSource) tableView:tableView titleForHeaderInSection:section];
	return [view autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView 
{
    [super scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
    [(SeasonsViewController*)_controller didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[(SeasonsViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
	{
		[(SeasonTableItemCell *)cell setSelected:TRUE];
	}
}

@end
