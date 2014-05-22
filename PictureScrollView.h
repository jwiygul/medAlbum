//
//  PictureScrollView.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/13/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataStore.h"

@interface PictureScrollView : UIScrollView
@property (weak,nonatomic)dataStore *dataItem;
-(void)layoutScroll;
-(void)newLayoutScroll;
@end
