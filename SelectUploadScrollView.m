//
//  SelectUploadScrollView.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 10/30/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "SelectUploadScrollView.h"
#import "dataStore.h"
@implementation SelectUploadScrollView

@synthesize dataItem, controller;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setScrollEnabled:YES];
    }
    return self;
}

-(void)layoutScroll
{
    int count = [[dataItem thumbnailDataArray]count];
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    buttonArray = [[NSMutableArray alloc]init];
    CGFloat curXLoc = 10.0;
    CGFloat curYLoc = 100.0;
    int imageIndex = 0;
    for (int i = 0; i < count; i++)
    {
        if (curXLoc > (screenRect.size.width - 60.0)) {
            curYLoc += 80.0;
            curXLoc = 10.0;
        }
        UIImageView *newImage = [[UIImageView alloc]init];
        UIButton *revealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSData *data = [[dataItem thumbnailDataArray]objectAtIndex:i];
        newImage.image = [UIImage imageWithData:data];
        CGRect imageFrame = CGRectMake(curXLoc, curYLoc, 60.0, 60.0);
        
        revealButton.frame = imageFrame;
        revealButton.tag = imageIndex;
        
        [revealButton addTarget:self action:@selector(showIsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [revealButton setImage:newImage.image forState:UIControlStateNormal];
        [self addSubview:revealButton];
        [buttonArray addObject:revealButton];
        curXLoc += 70.0;
        imageIndex++;
    }
    
    
    
    [self setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    
}

-(void)showIsSelected:(id)sender
{
    
    int count = [buttonArray indexOfObject:sender];
   
    NSNumber *number = [[NSNumber alloc]initWithInt:count];
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"forIndexedPicture:"];
    SEL newSelector = NSSelectorFromString(selector);
    
    if ([[self controller]respondsToSelector:newSelector])
    {
        [[self controller]performSelector:newSelector withObject:sender withObject:number];
    }
    
    
    
}

@end
