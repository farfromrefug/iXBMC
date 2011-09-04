#import "FixedTTTableViewController.h"


@implementation FixedTTTableViewController


#pragma mark overlay resizing

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addToOverlayView:(UIView*)view {
	[super addToOverlayView:view];
	_tableOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
}


#pragma mark keyboard resizing

static int keyboardAdjustCount = 0;

/*
 If we were to shrink the table view by the whole size of the
 keyboard,
 that would be too much, since the keyboard extends down below the
 bottom
 of the table. So we adjust the bounds of the keyboard so that its
 height only
 covers the amount of they keyboard that covers the table.
 */
-(CGRect)adjustKeyboardBounds:(CGRect)bounds
{
    //DMV: TODO: it would be good to contribute this back to three20
    
    //the three20 code assumes that the table goes all the way to the bottom
    //of the screen when resizing it for the keyboard. This change allows us
    //to only resize the part of the screen that overlaps the keyboard.
    
    if (bounds.size.height > mDeltaBottom)
        bounds.size.height -= mDeltaBottom;
    else
        bounds.size.height = 0;
    return bounds;
}

/**
 * Sent to the controller before the keyboard slides in.
 */
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds
{
    mDeltaBottom = TTScreenBounds().size.height - self.view.height - self.view.ttScreenY;
    [super keyboardWillAppear:animated withBounds:bounds];
    
}

/**
 * Sent to the controller before the keyboard slides out.
 */
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds
{
    keyboardAdjustCount--;
    if (keyboardAdjustCount != 0)
    {
        TTDASSERT(NO);
        keyboardAdjustCount = 0;
        return; //for some reason, we are being called too much
    }
    bounds = [self adjustKeyboardBounds:bounds];
    [super keyboardWillDisappear:animated withBounds:bounds];
    
}

/**
 * Sent to the controller after the keyboard has slid in.
 */
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds
{
    if (keyboardAdjustCount != 0)
    {
        TTDASSERT(NO);
        keyboardAdjustCount = 0;
        return; //for some reason, we are being called too much
    }
    keyboardAdjustCount++;
    bounds = [self adjustKeyboardBounds:bounds];
    [super keyboardDidAppear:animated withBounds:bounds];
    
    //scroll to the new folder row
    [self.tableView scrollFirstResponderIntoView];
    
}

/**
 * Sent to the controller after the keyboard has slid out.
 */
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds
{
    [super keyboardDidDisappear:animated withBounds:bounds];
    
} 

@end