//
//  SeasonsCellView.h
//  iXBMC
//
//  Created by Martin Guillon on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeasonTableItem;
@interface SeasonCellView : TTView {
    UIImage* _posterShadow;
    UIImage* _posterShadowSelected;
    UIImage* _newFlag;
	UIImage* _line;
	SeasonTableItem *_item;
	
	BOOL highlighted;
	BOOL editing;
}
@property (nonatomic, retain) SeasonTableItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;

- (void)loadImage;

@end
