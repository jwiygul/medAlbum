//
//  ExpandedPictureScrollView.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/26/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "ExpandedPictureScrollView.h"
#import "dataWithImageStore.h"
#import "imageStore.h"
#import "dataStore.h"
@implementation ExpandedPictureScrollView
@synthesize dataItem,indexOfPicture,imageToDisplay;
- (id)initWithPageIndex:(NSInteger)index andDataItem:(dataStore *)passedDataItem
{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    
    if (self) {
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 4;
        indexOfPicture = index;
        dataItem = passedDataItem;
        tiledLayer.tileSize = CGSizeMake(1000.0, 1000.0);
        
       
    }
    return self;
}
+(Class)layerClass
{
    return [CATiledLayer class];
}
-(void)removeFromSuperview
{
    [super removeFromSuperview];
}
- (void)drawRect:(CGRect)rect
{
    NSString *keyString = [[dataItem keyArray]objectAtIndex:indexOfPicture];
    UIImage *image = [[imageStore sharedStore]imageForKey:keyString];
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    //CGFloat imageScale = self.frame.size.width/imageRect.size.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    // Scale the context so that the image is rendered
    // at the correct size for the zoom level.
   
   CGContextRotateCTM (context, M_PI*0.5);
    CGContextTranslateCTM (context, 0.0,0.0);
   
    CGContextScaleCTM(context, 0.17,-0.17);
    CGContextDrawImage(context, imageRect, image.CGImage);
    
    
    


//CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
//CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//UIImage* newImage = [UIImage imageWithCGImage:ref];

//CGContextRelease(bitmap);
//CGImageRelease(ref);

    
    
    
  
    CGContextRestoreGState(context);
    
   
}

@end
