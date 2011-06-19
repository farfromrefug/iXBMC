
#import "ToolbarController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ToolbarController
@synthesize delegate = _delegate;

- (void) hideToolbar
{
    [UIView beginAnimations:nil context:self.view];
    [UIView setAnimationDuration:TTSTYLEVAR(toolbarAnimationDuration)];
    self.view.bottom =  0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void) toggleToolbar
{
    [UIView beginAnimations:nil context:self.view];
    [UIView setAnimationDuration:TTSTYLEVAR(toolbarAnimationDuration)];
    if (self.view.top == 0)
        self.view.bottom = 0;
    else self.view.top = 0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


@end

