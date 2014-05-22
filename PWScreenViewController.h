//
//  PWScreenViewController.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 4/3/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeychainItemWrapper;

@interface PWScreenViewController : UIViewController
{
    KeychainItemWrapper *passwordWrapper;
    
}
@property (nonatomic)KeychainItemWrapper *passwordWrapper;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *matchPassWord;

@end
