//
//  ExpandedPictureViewController.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/22/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
@class dataStore,ExpandedPictureScrollView;
@class ThumbnailArrayViewController;
@interface ExpandedPictureViewController : UIViewController<UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIImageView *_imageToDisplay;
    dataStore *dataItem;
    NSString *string;
    UIPageViewController *controller;
    UIToolbar *toolBar;
     UIView *pickerGroupView;
    UIBarButtonItem *backButton, *deleteButton, *uploadButton;
    DBFile *myDBFile;
    GTLServiceDrive *driveService;
}

@property(nonatomic)BOOL calledByCamera;
@property(nonatomic)ThumbnailArrayViewController *thumbControl;
@property(nonatomic,strong)UIImageView *imageToDisplay;
@property (nonatomic)ExpandedPictureScrollView *scrollView;
@property (nonatomic,retain)dataStore *dataItem;
@property (nonatomic)NSInteger indexOfPicture;
+(ExpandedPictureViewController *)expandedPictureViewControllerForIndex:(NSInteger)index andDataItem:(dataStore *)passedDataItem;

@end
