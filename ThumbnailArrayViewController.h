//
//  ThumbnailArrayViewController.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/20/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class dataStore;
@class PictureScrollView;
@class ThumbnailArrayScrollView;
@class ExpandedPictureViewController;

@interface ThumbnailArrayViewController : UIViewController<UIImagePickerControllerDelegate,UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    UIView *pickerGroupView;
    UIToolbar *toolBar;
    UIToolbar *cameraToolBar;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *takePictureButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *addInfoButton;
    UIBarButtonItem *imageButton;
    UIBarButtonItem *pictureButton;
    //UIBarButtonItem *GDButton;
    UIBarButtonItem *backButton;
    UITableView *cameraTableView;
    UITableView *firstTableView;
    PictureScrollView *pictureScrollView;
    ThumbnailArrayScrollView *thumbScrollView;
    int picturesTaken;
    UIImageView *loadedImage;
    ExpandedPictureViewController *evc;
    NSUInteger *indexOfPicture;
    UIPageViewController *pvc;
    
}
@property (nonatomic,strong)UIImageView *loadedImage;
@property(nonatomic)ThumbnailArrayScrollView *thumbScrollView;
@property (weak, nonatomic)dataStore *dataItem;
@property (nonatomic)ExpandedPictureViewController *evc;
@property (nonatomic)UIPageViewController *pvc;
@property(nonatomic)BOOL didPresentSelectUploadView;
-(void)layoutThumbScrollView;
-(void)showBigPicture:(id)sender forIndexedPicture:(NSNumber *)count;
@end
