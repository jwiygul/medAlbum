//
//  imageStore.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageStore : NSObject
{
    NSMutableDictionary *dictionary;
   
}
+(imageStore*)sharedStore;
@property (nonatomic,retain)NSMutableDictionary *dictionary;
-(void)setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;
-(NSString *)imagePathForKey:(NSString *)key;
-(void)clearCache;
-(NSString *)getImagePath:(NSString *)keyString;
@end
