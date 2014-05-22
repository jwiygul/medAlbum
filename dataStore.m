//
//  dataStore.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "dataStore.h"

@implementation dataStore
@synthesize imageKey, dateCreated,patientName,medRecNum,thumbnail,thumbnailData,thumbnailDataArray,keyArray,caseName;


-(void)setThumbnailDataFromImage:(UIImage *)image//called by imagepickercontroller
{
    
    CGSize origImageSize = [image size];
    CGRect newRect = CGRectMake(0, 0, 60, 60);
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];

    //[path addClip];
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x =(newRect.size.width - projectRect.size.width)/2.0;
    projectRect.origin.y =(newRect.size.height-projectRect.size.height)/2.0;
    [image drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    if (thumbnailDataArray==nil) {
        thumbnailDataArray = [[NSMutableArray alloc]init];
    }
    // NSData *data = UIImagePNGRepresentation(smallImage);
    //if (thumbnail == nil) {
       
      //  [self setThumbnail:smallImage];
        //[self setThumbnailData:data];
    //}
    NSData *otherObject = UIImagePNGRepresentation(smallImage);
    
    [thumbnailDataArray addObject:otherObject];
    
    UIGraphicsEndImageContext();
}

-(UIImage *)thumbnail
{
    if (!thumbnailData) {
        return nil;
    }
    if (!thumbnail) {
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    [aCoder encodeObject:thumbnailDataArray forKey:@"thumbnailDataArray"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:keyArray forKey:@"keyArray"];
    [aCoder encodeObject:caseName forKey:@"caseName"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
         
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setDateCreated:[aDecoder decodeObjectForKey:@"dateCreated"]];
        [self setThumbnailData:[aDecoder decodeObjectForKey:@"thumbnailData"]];
        [self setThumbnailDataArray:[aDecoder decodeObjectForKey:@"thumbnailDataArray"]];
        [self setKeyArray:[aDecoder decodeObjectForKey:@"keyArray"]];
        [self setCaseName:[aDecoder decodeObjectForKey:@"caseName"]];
        
        
    }
    return self;
}


@end
