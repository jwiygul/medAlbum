//
//  PasswordToggleStore.m
//  medAlbum
//
//  Created by Jeremy Wiygul on 2/27/14.
//  Copyright (c) 2014 Jeremy Wiygul. All rights reserved.
//

#import "PasswordToggleStore.h"

@implementation PasswordToggleStore
@synthesize passwordOn;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:passwordOn forKey:@"passwordOn"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        [self setPasswordOn:[aDecoder decodeBoolForKey:@"passwordOn"]];
        
    }
    return self;
}
@end
