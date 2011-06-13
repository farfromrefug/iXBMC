#import <Three20/Three20.h>
#import "FixedTTTableViewController.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : FixedTTTableViewController<UIActionSheetDelegate>

@property(nonatomic,assign) id<SettingsViewControllerDelegate> delegate;

- (void) dismiss;
@end


//////////////


@protocol SettingsViewControllerDelegate <NSObject>

- (void)controller:(SettingsViewController*)controller didSelectObject:(id)object;

@end