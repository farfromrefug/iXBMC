//
//  MovieCellView.h
//  iXBMC
//
//  Created by Martin Guillon on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MovieTableItem;
@interface MovieCellView : TTView {
    UIImage* _posterShadow;
    UIImage* _posterShadowSelected;
    UIImage* _newFlag;
    UIImage* _stars;
	UIImage* _line;
	MovieTableItem *_item;
	
	BOOL highlighted;
	BOOL editing;
}
@property (nonatomic, retain) MovieTableItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;

- (void)loadImage;

@end
