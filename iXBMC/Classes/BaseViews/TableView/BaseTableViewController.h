#import "TTTableViewCoreDataController.h"

@class CustomTitleView;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface BaseTableViewController : TTTableViewCoreDataController<TTSearchTextFieldDelegate> {

    BOOL _forSearch;

    TTView* _toolBar;
    
    CustomTitleView* _titleBackground;

    NSIndexPath *_selectedCellIndexPath;
}

@property (nonatomic, retain) NSIndexPath* selectedCellIndexPath;
@property (nonatomic) BOOL forSearch;

- (void)didDeselectRowAtIndexPath:(NSIndexPath*)indexPath;
- (TTView*) createToolbar;
- (void) hideToolbar;
- (void) toggleToolbar;
- (void) reloadTableView;
- (void) deselectCurrentObject;

- (void) persistentStoreChanged: (NSNotification *) notification;
- (void)connectedToXBMC: (NSNotification *) notification;
- (void)disconnectedFromXBMC: (NSNotification *) notification;

@end
