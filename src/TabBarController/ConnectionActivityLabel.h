#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTView;
@class TTButton;

@interface ConnectionActivityLabel : UIView {

  TTView*                   _bezelView;
  UIActivityIndicatorView*  _activityIndicator;
  UILabel*                  _label;
}

@property (nonatomic, copy)     NSString* text;
@property (nonatomic, retain)   UIFont*   font;

@property (nonatomic)           BOOL      isAnimating;

- (id)init;
- (void)setIsAnimating:(BOOL)isAnimating;

@end
