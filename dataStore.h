//
//  dataStore.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface dataStore : NSObject <NSCoding>


@property (nonatomic) NSDate *dateCreated;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSString * patientName;
@property (nonatomic, retain) NSString * medRecNum;
@property (nonatomic, retain) NSString *caseName;
@property (nonatomic,strong) UIImage *thumbnail;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain)NSMutableArray *thumbnailDataArray;
@property (nonatomic,retain)NSMutableArray *keyArray;
-(void)setThumbnailDataFromImage:(UIImage *)image;

@end
