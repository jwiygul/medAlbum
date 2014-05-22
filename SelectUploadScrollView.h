//
//  SelectUploadScrollView.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 10/30/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class dataStore;
@interface SelectUploadScrollView : UIScrollView
{
    NSMutableArray *buttonArray;
}
@property (weak,nonatomic)dataStore *dataItem;
@property (weak, nonatomic)id controller;
-(void)layoutScroll;
@end
