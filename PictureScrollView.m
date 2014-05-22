//
//  PictureScrollView.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/13/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "PictureScrollView.h"
#import "dataStore.h"
#import "dataWithImageStore.h"

@implementation PictureScrollView
@synthesize dataItem;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setScrollEnabled:YES];
        [self setPagingEnabled:NO];
        
    }
    return self;
}

-(void)layoutScroll
{
   /*int count = [[dataItem thumbnailDataArray]count];
    UIImageView *image = [[UIImageView alloc]init];
    CGFloat curXLoc = 0.0;
    for (int i = 0; i<count; i++) {
        CGRect imageFrame = CGRectMake(curXLoc, 0.0, 60.0, 60.0);
        image.image = [UIImage imageWithData:[[dataItem thumbnailDataArray]objectAtIndex:i]];
        image.frame = imageFrame;
        [self addSubview:image];
        curXLoc += 70.0;
        
    }*/
    //CGFloat imageSize = 70.0 * count;
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[[dataItem thumbnailDataArray]lastObject]]];
    CGRect frame = CGRectMake(0.0, 0.0, 60.0, 60.0);
    image.frame = frame;
    [self addSubview:image];
    [self setContentSize:CGSizeMake(70.0, self.bounds.size.height)];
}
-(void)newLayoutScroll
{
    int count = [[dataItem thumbnailDataArray]count];
    
    CGFloat curXLoc = 0.0;
    for (int i = 0; i<count; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        CGRect imageFrame = CGRectMake(curXLoc, 0.0, 60.0, 60.0);
        image.image = [UIImage imageWithData:[[dataItem thumbnailDataArray]objectAtIndex:i]];
        image.frame = imageFrame;
        [self addSubview:image];
        curXLoc += 70.0;
        
    }
    CGFloat imageSize = 80.0 * count;
    
    [self setContentSize:CGSizeMake(imageSize, self.bounds.size.height)];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
  
}



@end
