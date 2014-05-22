//
//  ThumbnailArrayViewController.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/20/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "ThumbnailArrayViewController.h"
#import "ThumbnailArrayScrollView.h"
#import "dataStore.h"
#import "ExpandedPictureViewController.h"
#import "PictureScrollView.h"
#import "imageStore.h"
#import "dataWithImageStore.h"
#import "InfoEntryViewController.h"
#import "SelectUploadScrollView.h"
#import <Dropbox/Dropbox.h>


@interface ThumbnailArrayViewController ()

@end

@implementation ThumbnailArrayViewController
@synthesize dataItem,evc,loadedImage,didPresentSelectUploadView;
@synthesize thumbScrollView;
@synthesize pvc;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        pictureButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(morePictures)];
        backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [[self navigationItem]setLeftItemsSupplementBackButton:YES];
        [[self navigationItem]setRightBarButtonItem:pictureButton];
        NSArray *buttonArray= [[NSArray alloc]initWithObjects:backButton, flexSpace, nil];
        [[self navigationItem]setLeftBarButtonItems:buttonArray];
        
        picturesTaken = 0;
        loadedImage = [[UIImageView alloc]init];
    }
    return self;
}

-(void)layoutThumbScrollView
{
    
    [thumbScrollView dumpImages];
    
}

-(void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ExpandedPictureViewController *)viewController
{
   
    viewController.imageToDisplay = nil;
    
    ExpandedPictureViewController *vc = [ExpandedPictureViewController expandedPictureViewControllerForIndex:viewController.indexOfPicture +1 andDataItem:dataItem];
    vc.thumbControl = self;
    if (viewController.calledByCamera) {
        vc.calledByCamera = YES;
    }
    return vc;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ExpandedPictureViewController *)viewController
{
   
    viewController.imageToDisplay = nil;
    ExpandedPictureViewController *vc = [ExpandedPictureViewController expandedPictureViewControllerForIndex:viewController.indexOfPicture -1 andDataItem:dataItem];
    vc.thumbControl = self;
    if (viewController.calledByCamera) {
        vc.calledByCamera = YES;
    }
    return vc;
}
-(void)loadView
{
    [super loadView];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    thumbScrollView = [[ThumbnailArrayScrollView alloc]initWithFrame:screenRect];
    thumbScrollView.dataItem = dataItem;
    thumbScrollView.directionalLockEnabled =YES;
    
    self.view =thumbScrollView;
    
    thumbScrollView.controller=self;
    [thumbScrollView layoutScroll];
    
    
   
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[UIImage alloc]init];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [dataItem setThumbnailDataFromImage:image];
    
    
    //following code creates a unique identifier to be used in key-value pairs
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault,newUniqueID);
    NSString *key= (__bridge NSString *)newUniqueIDString;
    [dataItem setImageKey:key];
    
    [[imageStore sharedStore]setImage:image forKey:key];
    [[dataItem keyArray]addObject:key];
    
    UIImage * newImage = [UIImage imageWithData:[[dataItem thumbnailDataArray]lastObject]];
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(0.0, 0.0, 60.0, 60.0);
    imageButton.customView = button;
    
    //tells objecs to lose owners since variables will be destroyed at end of function
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    picturesTaken++;
    
    [[dataWithImageStore sharedStore]saveChanges];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    picturesTaken = 0;
}
-(void)morePictures
{
    imagePickerController = [[UIImagePickerController alloc]init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    imagePickerController.delegate=self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.showsCameraControls = NO;
    CGRect screen = [[UIScreen mainScreen]applicationFrame];
    
    
    
    cameraToolBar = [[UIToolbar alloc]init];
    [imagePickerController.cameraOverlayView addSubview:cameraToolBar];
    CGSize toolSize = [cameraToolBar sizeThatFits:CGSizeZero];
    CGRect toolRect = CGRectMake(0.0, screen.origin.y + screen.size.height - toolSize.height-40.0, toolSize.width, toolSize.height+40.0);
    cameraToolBar.frame = toolRect;
   
    toolBar = [[UIToolbar alloc]init];
    [cameraToolBar setBackgroundImage:[[UIImage alloc]init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    cameraToolBar.tintColor = [UIColor darkTextColor];
    toolBar = [[UIToolbar alloc]init];
    [toolBar setBackgroundImage:[[UIImage alloc]init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    toolBar.tintColor = [UIColor darkTextColor];
    [imagePickerController.cameraOverlayView addSubview:toolBar];
    CGSize toptoolSize = [toolBar sizeThatFits:CGSizeZero];
    CGRect toptoolRect = CGRectMake(0.0, 0.0, toptoolSize.width, toptoolSize.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    toolBar.frame =toptoolRect;
    cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    takePictureButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    takePictureButton.imageInsets = UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0);
    addInfoButton = [[UIBarButtonItem alloc]initWithTitle:@"Patient Info" style:UIBarButtonItemStylePlain target:self action:@selector(addPatientInfo)];
    UIImage * image = [UIImage imageWithData:[[dataItem thumbnailDataArray]lastObject]];
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(0.0, 0.0, 60.0, 60.0);
    imageButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    imageButton.tintColor = [UIColor clearColor];
    NSArray *buttonArray = [[NSArray alloc]initWithObjects:imageButton,spaceButton, takePictureButton,spaceButton, doneButton,nil];
    [cameraToolBar setItems:buttonArray];
    NSArray *otherArray = [[NSArray alloc]initWithObjects:cancelButton,  spaceButton,addInfoButton, nil];
    [toolBar setItems:otherArray];
   
    [self presentViewController:imagePickerController animated:YES completion:nil];
    

}
-(void)showImage
{
    int count = [[dataItem keyArray]count];
    evc = [ExpandedPictureViewController expandedPictureViewControllerForIndex:count-1 andDataItem:dataItem];
    pvc = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pvc.dataSource = self;
    pvc.delegate = self;
    evc.thumbControl = self;
    evc.calledByCamera = YES;
    [pvc setViewControllers:@[evc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [imagePickerController presentViewController:pvc animated:YES completion:nil];
}
-(void)addPatientInfo
{
    InfoEntryViewController *favc = [[InfoEntryViewController alloc]init];
    favc.item = self.dataItem;
    UINavigationController *navCom = [[UINavigationController alloc]initWithRootViewController:favc];
    
    [navCom setModalPresentationStyle:UIModalPresentationPageSheet];
    [navCom setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [imagePickerController presentViewController:navCom animated:YES completion:nil];
    
}
-(void)showBigPicture:(id)sender forIndexedPicture:(NSNumber *)count
{
    NSInteger newNumber = count.integerValue;
    
    evc = [ExpandedPictureViewController expandedPictureViewControllerForIndex:newNumber andDataItem:dataItem];
    
    pvc = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pvc.dataSource = self;
    pvc.delegate = self;
    evc.thumbControl = self;
    evc.calledByCamera = NO;
    [pvc setViewControllers:@[evc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self presentViewController:pvc animated:YES completion:nil];
    
        
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
   
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (picturesTaken>0) {
        [[dataWithImageStore sharedStore]removePictures:picturesTaken forDataItem:dataItem];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancel
{
    [self imagePickerControllerDidCancel:imagePickerController];
}
-(void)takePhoto
{
    BOOL success = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (success) {
        [imagePickerController takePicture];
        
    }
    
}
-(void)finish
{
     [thumbScrollView layoutScroll];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
