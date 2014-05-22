//
//  dataWithImageStore.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class dataStore;
@class PasswordToggleStore;
@interface dataWithImageStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    BOOL passwordOn;
    NSMutableArray *passwordArray;
    //PasswordToggleStore *passwordToggleStore;
}
@property (nonatomic)PasswordToggleStore *passwordToggleStore;
+(dataWithImageStore *)sharedStore;
@property (nonatomic)BOOL passwordOn;
-(NSArray*)allItems;
-(dataStore*)createItem;
-(void)removeItem:(dataStore *)p;
-(NSString *)itemArchivePath;
-(NSString *)passwordToggleArchivePath;
-(BOOL)saveChanges;
-(void)loadAllItems;
-(void)removePictures:(int)numberOfPictures forDataItem:(dataStore *)dataItem;
-(void)removePictureAtIndex:(NSNumber *)index forDataItem:(dataStore *)dataItem;
-(BOOL)togglePassword;
@end
