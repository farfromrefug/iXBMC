//
//  HostTableItemCell.m
//  iXBMC
//
//  Created by Martin Guillon on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HostTableItemCell.h"
#import "HostTableItem.h"
#import "SettingsViewController.h"

@implementation HostTableItemCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier 
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) 
    {
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(100, 100, 100, 0.2);
        self.selectionStyle = TTSTYLEVAR(tableSelectionStyle);     
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        self.subtitleLabel.textColor = [UIColor grayColor];
        self.subtitleLabel.highlightedTextColor = [UIColor grayColor];
        
        _line = [[[UIImageView alloc] init] autorelease];
        _line.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleTopMargin;
        _line.image = TTIMAGE(@"bundle://cellline.png");
        [self.contentView addSubview:_line];
                
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shortPress:)];
        [[self contentView] addGestureRecognizer:tapGesture];

        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longGesture.minimumPressDuration = 0.5;
        [tapGesture requireGestureRecognizerToFail:longGesture];
        [[self contentView] addGestureRecognizer:longGesture];

        [tapGesture release];
        [longGesture release];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    CGFloat height = [[defaults valueForKey:@"moviesView:cellHeight"] floatValue];
//    
//    if (((MovieTableItem*)_item).forSearch)
//    {
//        height = FORSEARCH_HEIGHT ;
//    }
//    //    CGFloat width = self.contentView.width - (height + kTableCellSmallMargin);
//    CGFloat left = 0;
    
    _line.frame = CGRectMake(0, self.contentView.height -1
                             , self.contentView.width, 1);
}

-(void)longPress:(id)_sender
{
    if (((UILongPressGestureRecognizer *)_sender).state == UIGestureRecognizerStateBegan)
    {
//        [self becomeFirstResponder];
//        UIMenuItem *first = [[[UIMenuItem alloc] initWithTitle:@"ClearCache" action:@selector(clearCache:)] autorelease];
//        UIMenuItem *second = [[[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteHost:)] autorelease];
//        
//        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        menuController.menuItems = [NSArray arrayWithObjects:first,second,nil];
//        
//        [menuController setTargetRect:self.frame inView:self.superview];
//        [menuController setMenuVisible:YES animated:YES];
		
		NSMutableArray* titles = [NSMutableArray array];
		[titles addObject:@"ClearCache"];
		[titles addObject:@"Delete"];
		
		UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Option for %@",[(HostTableItem*)_item text]]
														   delegate:self cancelButtonTitle:@"Cancel" 
											 destructiveButtonTitle:nil otherButtonTitles:nil];
		alert.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		for (NSString * tt in titles) { [alert addButtonWithTitle:tt]; }
		[alert showInView:self];
		[alert release];
    }
}

-(void)shortPress:(id)_sender
{
    
    if (((UILongPressGestureRecognizer *)_sender).state == UIGestureRecognizerStateEnded)
    {            
        if (self.editing)
        {
            NSString* url = [NSString stringWithFormat:@"tt://addserver/%@"
                             ,[(HostTableItem*)_item text]];
            // [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:url]];
            
            [((AppDelegate*)[UIApplication sharedApplication].delegate) openURL:url];
        }
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //                NSLog(@"selected %@",[(HostTableItem*)item text]);
            [defaults setObject:[(HostTableItem*)_item text] forKey:@"currenthost"];
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:@"hostChanged" 
             object:nil];	
        }
    }
}

//
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]) {
		[self deleteHost:nil];
	} else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"ClearCache"]) {
		[self clearCache:nil];
	}
}

-(BOOL)canBecomeFirstResponder {
    
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    BOOL canPerform = NO;
    
    if (action == @selector(clearCache:)) {
        canPerform = YES;
    }
    else if (action == @selector(deleteHost:)) {
        canPerform = YES;
    }
    
    return canPerform;
}

- (void)clearCache:(id)sender 
{
    [[TTURLCache cacheWithName:[(TTTableSubtitleItem*)_item text]] removeAll:YES];
    [self resignFirstResponder];
	[[NSNotificationCenter defaultCenter] 
     postNotificationName:@"cacheCleared" 
     object:nil];
}

- (void)deleteHost:(id)sender 
{
    [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"askToDeleteHost" 
         object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[(HostTableItem*)_item text], @"name", nil]];
        
    UITableView * tableView = (UITableView*) self.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell: self];
    id object = [[((TTSectionedDataSource*)delegate.dataSource).items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [(TTModel*)delegate.model didDeleteObject:object atIndexPath:indexPath];
//    [tableView beginUpdates];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView endUpdates];
    [self resignFirstResponder];
}
@end
