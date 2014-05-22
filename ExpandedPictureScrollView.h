//
//  ExpandedPictureScrollView.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/26/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class dataStore;
@interface ExpandedPictureScrollView : UIScrollView
@property (nonatomic)int indexOfPicture;
@property(nonatomic)dataStore *dataItem;
@property(nonatomic,strong)UIImageView *imageToDisplay;

- (id)initWithPageIndex:(NSInteger)index andDataItem:(dataStore *)passedDataItem;
@end
