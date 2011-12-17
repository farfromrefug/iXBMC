
@interface BCTab : UIButton {
}

- (id)initWithIconImageName:(NSString *)image 
	selectedImageNameSuffix:(NSString *)selectedSuffix 
   landscapeImageNameSuffix:(NSString *)landscapeSuffix;

- (id)initWithIconImageName:(NSString *)image 
	selectedImageNameSuffix:(NSString *)selectedSuffix 
   landscapeImageNameSuffix:(NSString *)landscapeSuffi 
					  title:(NSString*) tt;
- (void)adjustImageForOrientation;

-(void)setButtonTitle:(NSString*)tt;

@end
