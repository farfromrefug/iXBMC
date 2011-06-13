#import "MovieTableViewDelegate.h"
#import "MovieViewController.h"
#import "MovieViewDataSource.h"
#import "MovieTableItemCell.h"

#define MENU_HEIGHT 25;
#define FORSEARCH_HEIGHT 40;

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
        return 30;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"moviesView:cellHeight"] floatValue];
    
    if ([(MovieViewController*)_controller forSearch])
    {
        height = FORSEARCH_HEIGHT ;
    }
    
    if ([[(MovieViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
    {
        height += MENU_HEIGHT;
    }
    
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
	// create the parent view
	UIImageView * customSectionView = [[UIImageView alloc] initWithFrame:CGRectZero];
	customSectionView.backgroundColor = [UIColor clearColor];
	customSectionView.image = TTIMAGE(@"bundle://sectionback.png");
    customSectionView.image = [customSectionView.image stretchableImageWithLeftCapWidth:18 topCapHeight:3];
	
    UIImageView * labelBackImage = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
	labelBackImage.backgroundColor = [UIColor clearColor];
	labelBackImage.image = TTIMAGE(@"bundle://sectiontitleback.png");
    labelBackImage.image = [labelBackImage.image stretchableImageWithLeftCapWidth:15 topCapHeight:3];
	// create the label
    
    // create the label
	UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300
																	  , [self tableView:tableView 
															   heightForHeaderInSection:section])] autorelease];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = TTSTYLEVAR(themeColor);
	headerLabel.highlightedTextColor = TTSTYLEVAR(themeColor);
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.text = [((MovieViewDataSource*)((MovieViewController*)_controller).dataSource) tableView:tableView titleForHeaderInSection:section];
	[headerLabel sizeToFit];
    labelBackImage.frame = CGRectMake(0, 0, headerLabel.right + 15, [self tableView:tableView heightForHeaderInSection:section]);
    customSectionView.frame = CGRectMake(labelBackImage.right, 0,  tableView.frame.size.width - labelBackImage.right, [self tableView:tableView heightForHeaderInSection:section]);
    
	// package and return
	[customSectionView addSubview:labelBackImage];
	[customSectionView addSubview:headerLabel];
//	[headerLabel release];
	return [customSectionView autorelease];
	
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
