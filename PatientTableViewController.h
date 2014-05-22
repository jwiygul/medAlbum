//
//  PatientTableViewController.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataStore.h"
#import "PictureScrollView.h"
#import "KeychainItemWrapper.h"
@interface PatientTableViewController : UIViewController <UIImagePickerControllerDelegate, UITableViewDelegate, UIScrollViewDelegate>
{
    UIImagePickerController *imagePickerController;
    UIToolbar *toolBar;
    UIToolbar *cameraToolBar;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *takePictureButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *addInfoButton;
    UIBarButtonItem *imageButton;
    UITableView *cameraTableView;
    UITableView *firstTableView;
    PictureScrollView *pictureScrollView;
    KeychainItemWrapper *keyChainItem;
    UIBarButtonItem *togglePassword;
}
@property (weak,nonatomic)dataStore *patient;
@end
