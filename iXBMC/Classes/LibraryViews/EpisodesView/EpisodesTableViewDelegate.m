#import "EpisodesTableViewDelegate.h"
#import "EpisodesViewController.h"
#import "EpisodesViewDataSource.h"
#import "EpisodeTableItemCell.h"

#define MENU_HEIGHT 25;
#define FORSEARCH_HEIGHT 40;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EpisodesTableViewDelegate


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
//    if ([[((EpisodesViewDataSource*)((EpisodesViewController*)_controller).dataSource) currentSortName] isEqualToString:@"Title"])
//        return 30;
//    else 
        return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"episodeCell:height"] floatValue];

    if ([[(EpisodesViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
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
	headerLabel.text = [((EpisodesViewDataSource*)((EpisodesViewController*)_controller).dataSource) tableView:tableView titleForHeaderInSection:section];
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
    [(EpisodesViewController*)_controller didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[(EpisodesViewController*)_controller selectedCellIndexPath] isEqual:indexPath])
	{
		[(EpisodeTableItemCell *)cell setSelected:TRUE];
	}
}

@end
