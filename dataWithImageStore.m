//
//  dataWithImageStore.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "dataWithImageStore.h"
#import "dataStore.h"
#import "imageStore.h"
#import "PasswordToggleStore.h"
@implementation dataWithImageStore
@synthesize passwordOn,passwordToggleStore;
+(dataWithImageStore *)sharedStore
{
    static dataWithImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

-(void)loadAllItems
{
    NSString *path = [self itemArchivePath];
    allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSString *passwordPath = [self passwordToggleArchivePath];
   
  passwordArray = [NSKeyedUnarchiver unarchiveObjectWithFile:passwordPath];
    passwordToggleStore = [passwordArray objectAtIndex:0];
    
    if (passwordArray == nil) {
        passwordArray = [[NSMutableArray alloc]init];
        
    }
    
    if (passwordToggleStore == nil) {
        passwordToggleStore = [[PasswordToggleStore alloc]init];
        [passwordArray addObject:passwordToggleStore];
        passwordToggleStore.passwordOn = YES;
        
    }
    
    passwordOn = passwordToggleStore.passwordOn;
    
    if (!allItems)
    {
        allItems = [[NSMutableArray alloc]init];
    }
}
-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}
-(BOOL)togglePassword
{
    NSString * path = [self passwordToggleArchivePath];
    if (passwordOn) {
        passwordOn = FALSE;
        passwordToggleStore.passwordOn = FALSE;
    }
    else{
        passwordOn = TRUE;
        passwordToggleStore.passwordOn = TRUE;
    }
   
    [passwordArray replaceObjectAtIndex:0 withObject:passwordToggleStore];
    
    if([NSKeyedArchiver archiveRootObject:passwordArray toFile:path]){
        NSLog(@"successful");
        return passwordOn;
    }
    
    else
        return FALSE;
}
-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //extract the path string, which is always at index 0 because of the above reason
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.archive"];//if using archiving, suffix is .archive
}
-(NSString *)passwordToggleArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //extract the path string, which is always at index 0 because of the above reason
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"password.archive"];
}
-(void)removeItem:(dataStore *)p
{
    NSString *key = [p imageKey];
    [[imageStore sharedStore]deleteImageForKey:key];
    [allItems removeObjectIdenticalTo:p];
    
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];//this is done because alloc actually calls this method, so you could theorectically override the alloc method by calling this method directly, so that sharedStore is only created once
}

-(id)init
{
    self = [super init];
    if (self) {
        [self loadAllItems];
    }
    return self;
}
-(NSArray*)allItems
{
    return allItems;
}
-(dataStore*)createItem
{
    dataStore *p = [[dataStore alloc]init];
    p.keyArray = [[NSMutableArray alloc]init];
    [allItems addObject:p];
    NSDate *d = [NSDate date];
    [p setDateCreated:d];
    return p;
}
-(void)removePictures:(int)numberOfPictures forDataItem:(dataStore *)dataItem
{
    int itemIndex = [allItems indexOfObjectIdenticalTo:dataItem];
   
        int count = [[[allItems objectAtIndex:itemIndex]keyArray]count];
    if (count >1)
    {
        
    
        for (int y = count-1; y>(count - numberOfPictures)-1; y--)
        {
            NSString *keyString = [[[allItems objectAtIndex:itemIndex]keyArray]objectAtIndex:y];
            [[[allItems objectAtIndex:itemIndex]keyArray]removeObjectAtIndex:y];
            [[[allItems objectAtIndex:itemIndex]thumbnailDataArray]removeObjectAtIndex:y];
            [[imageStore sharedStore]deleteImageForKey:keyString];
        }
    }
    else
    {
        NSString *keystring = [[[allItems objectAtIndex:itemIndex]keyArray]objectAtIndex:0];
        [[[allItems objectAtIndex:itemIndex]keyArray]removeObjectAtIndex:0];
        [[[allItems objectAtIndex:itemIndex]thumbnailDataArray]removeObjectAtIndex:0];
        [[imageStore sharedStore]deleteImageForKey:keystring];
    }
  
}
-(void)removePictureAtIndex:(NSNumber *)index forDataItem:(dataStore *)dataItem
{
    int itemIndex = [allItems indexOfObjectIdenticalTo:dataItem];
   
   NSString *keyString = [[[allItems objectAtIndex:itemIndex]keyArray]objectAtIndex:index.intValue];
   
    
    [[[allItems objectAtIndex:itemIndex]keyArray]removeObjectAtIndex:index.intValue];
    [[[allItems objectAtIndex:itemIndex]thumbnailDataArray]removeObjectAtIndex:index.intValue];
    [[imageStore sharedStore]deleteImageForKey:keyString];
    
    
}

@end
