//
//  imageStore.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "imageStore.h"
@implementation imageStore
@synthesize dictionary;
-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}
-(NSString *)getImagePath:(NSString *)keyString
{
   
    return [self imagePathForKey:keyString];
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(imageStore *)sharedStore
{
    static imageStore * sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:NULL]init];
    }
    return sharedStore;
}
-(void)clearCache
{
    //causes all images in dictionary to be destroyed if there is a memory warning posted, while the one that is currently in imageView is not affected
    [dictionary removeAllObjects];
    NSLog(@"cache cleared");
}
-(id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc]init];
        //makes imageStore an observer for memory warning notifications
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
-(void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    //creates path ffor image
    NSString *imagePath = [self imagePathForKey:s];
    //turns image into JPEG
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    //write image to full path
    [d writeToFile:imagePath atomically:YES];
    
}

-(UIImage *)imageForKey:(NSString *)s
{
    UIImage *result = [dictionary objectForKey:s];
    //assigns image from filesystem to item, if it exists
    if (!result)
    {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        if (result)
        {
            [dictionary setObject:result forKey:s];
        }
        else
            NSLog(@"Error:unable to find %@", [self imagePathForKey:s]);
    }
    return result;
}

-(void)deleteImageForKey:(NSString *)s
{
    if(!s)
    {
        return;
    }
    [dictionary removeObjectForKey:s];
    //removes image binary data from filesystem
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
}

@end
