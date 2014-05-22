//
//  ThumbnailArrayScrollView.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/20/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "ThumbnailArrayScrollView.h"
#import "dataStore.h"

@implementation ThumbnailArrayScrollView
@synthesize dataItem, controller;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setScrollEnabled:YES];
        self.opaque = YES;
        self.alpha = 1.0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutScroll
{
    NSLog(@"layout scroll");
    int count = [[dataItem thumbnailDataArray]count];
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    
        buttonArray = [[NSMutableArray alloc]init];
    
    
    CGFloat curXLoc = 10.0;
    CGFloat curYLoc = 10.0;
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
        [revealButton addTarget:self action:@selector(showBigPicture:) forControlEvents:UIControlEventTouchUpInside];
        [revealButton setImage:newImage.image forState:UIControlStateNormal];
        [self addSubview:revealButton];
        [buttonArray addObject:revealButton];
        curXLoc += 70.0;
        imageIndex++;
    }
    
    
   
    [self setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    
}
-(void)dumpImages
{
    NSLog(@"dump Images");
    int count = [buttonArray count];
    if (count >0) {
    for (int y = 0; y<count; y++) {
        UIImageView *i = [buttonArray objectAtIndex:y];
        [i removeFromSuperview];
        i=nil;
    }
                      }
}
-(void)showBigPicture:(id)sender
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
