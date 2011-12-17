#import <Three20/Three20.h>
#import "FixedTTTableViewController.h"

@interface AddServerViewController : FixedTTTableViewController <UITextFieldDelegate>
{
    NSMutableDictionary* _serverInfo;
    NSString* hostName;
}
@property (nonatomic, retain) NSMutableDictionary* serverInfo;
@property (nonatomic, retain) NSString* hostName;

- (BOOL)findAndResignFirstResonder: (UIView*) stView;
- (id)initWithHost:(NSString *)host;

@end
