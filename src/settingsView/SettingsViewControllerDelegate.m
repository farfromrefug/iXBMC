//
//  SettingsViewControllerDelegate.m
//  iXBMC
//
//  Created by Martin Guillon on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewControllerDelegate.h"
#import "SettingsViewController.h"
#import "SettingsViewDataSource.h"
#import "HostTableItemCell.h"

@implementation SettingsViewControllerDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
//    NSIndexPath *rowToSelect = indexPath;
//    NSInteger section = indexPath.section;
//    BOOL isEditing = self.editing;
//    
//    // If editing, don't allow instructions to be selected
//    // Not editing: Only allow instructions to be selected
//    if ((isEditing && section == INSTRUCTIONS_SECTION) || (!isEditing && section != INSTRUCTIONS_SECTION)) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        rowToSelect = nil;    
//    }
//    
//	return rowToSelect;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([cell isKindOfClass:[HostTableItemCell class]])
    {
        [(HostTableItemCell*)cell setDelegate:self.controller];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
	headerLabel.text = [((SettingsViewDataSource*)((SettingsViewController*)_controller).dataSource) tableView:tableView titleForHeaderInSection:section];
	[headerLabel sizeToFit];
    labelBackImage.frame = CGRectMake(0, 0, headerLabel.right + 15, [self tableView:tableView heightForHeaderInSection:section]);
    customSectionView.frame = CGRectMake(labelBackImage.right, 0,  tableView.frame.size.width - labelBackImage.right, [self tableView:tableView heightForHeaderInSection:section]);
    
	// package and return
	[customSectionView addSubview:labelBackImage];
	[customSectionView addSubview:headerLabel];
//	[headerLabel release];
	return [customSectionView autorelease];
	
}

@end
