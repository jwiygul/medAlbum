//
//  ExpandedPictureViewController.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/22/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "ExpandedPictureViewController.h"
#import "dataStore.h"
#import "imageStore.h"
#import "ExpandedPictureScrollView.h"
#import "dataWithImageStore.h"
#import "ThumbnailArrayViewController.h"
#import "ThumbnailArrayScrollView.h"
#import "SelectUploadScrollView.h"
#import <Dropbox/Dropbox.h>
static NSString *const kKeychainItemName = @"medAlbum";
static NSString *const kClientID = @"771260555485-ih8t01obb242j34903l80h2vj3e3pbqn.apps.googleusercontent.com";
static NSString *const kClientSecret = @"pDsdT-NKxxkO1SbevghS4VoP";
@interface ExpandedPictureViewController ()
- (id)initWithPageIndex:(NSInteger)index andDataItem:(dataStore *)passedDataItem;
@end

@implementation ExpandedPictureViewController
@synthesize dataItem,indexOfPicture,imageToDisplay,scrollView;
@synthesize calledByCamera;
@synthesize thumbControl;
- (id)initWithPageIndex:(NSInteger)index andDataItem:(dataStore *)passedDataItem
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        dataItem = passedDataItem;
        indexOfPicture = index;
        scrollView = [[ExpandedPictureScrollView alloc]initWithPageIndex:index andDataItem:passedDataItem];
    }
    return self;
}
+(ExpandedPictureViewController *)expandedPictureViewControllerForIndex:(NSInteger)index andDataItem:(dataStore *)passedDataItem
{
    if (index < [[passedDataItem keyArray]count]) {
        return [[self alloc]initWithPageIndex:index andDataItem:passedDataItem];
    }
    return nil;
}
-(void)loadView
{
    [super loadView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [imageToDisplay removeFromSuperview];
    imageToDisplay.image =nil;
    
}
-(void)done
{
    if (!calledByCamera) {
    
    [thumbControl layoutThumbScrollView];
    [thumbControl.thumbScrollView layoutScroll];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    driveService = [[GTLServiceDrive alloc] init];
    
    driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
  
    imageToDisplay = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[[dataItem thumbnailDataArray]objectAtIndex:indexOfPicture]]];

    [[self view]addSubview:imageToDisplay];
    [[self view]addSubview:scrollView];
    toolBar = [[UIToolbar alloc]init];
    [[self view]addSubview:toolBar];
    CGSize toolSize = [toolBar sizeThatFits:CGSizeZero];
    CGRect recter = [[UIScreen mainScreen]bounds];
    CGRect toolRect = CGRectMake(0.0, 0.0, toolSize.width, toolSize.height+20.0);
    CGRect other = CGRectMake(0.0, toolSize.height, recter.size.width, recter.size.height);
    imageToDisplay.frame = other;
    scrollView.frame = other;
    toolBar.frame = toolRect;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor blueColor];
    toolBar.tintColor = [UIColor whiteColor];
    backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    deleteButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete:)];
    uploadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(uploadToPort)];
    deleteButton.imageInsets = UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0);
    uploadButton.imageInsets = UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0);
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array;
    if (calledByCamera) {
        array = @[backButton];
    }
    else
        array = @[backButton, flexButton, uploadButton, flexButton, deleteButton];
    
    toolBar.items = array;
}

-(void)uploadToPort
{
    SelectUploadScrollView *selectScrollView = [[SelectUploadScrollView alloc]init];
    pickerGroupView = [[UIView alloc]initWithFrame:[[self view]frame]];
    UIToolbar *anotherToolBar = [[UIToolbar alloc]init];
    [pickerGroupView addSubview:selectScrollView];
    [pickerGroupView addSubview:anotherToolBar];
    [[[self view]window]addSubview:pickerGroupView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropboxIcon.png"]];
    UIButton *selectUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectUploadButton addTarget:self action:@selector(selectUploadPort:) forControlEvents:UIControlEventTouchUpInside];
    selectUploadButton.frame = CGRectMake(0.0, 0.0, 70.0, 70.0);
    selectUploadButton.tag = 0;
    selectUploadButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [selectUploadButton setTitle:@"Dropbox" forState:UIControlStateNormal];
    [selectUploadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectUploadButton setBackgroundImage:imageView.image forState:UIControlStateNormal];
    selectUploadButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -90.0, 0.0);
    
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"googleDriveIcon.png"]];
    UIButton *selectUploadButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectUploadButton2 addTarget:self action:@selector(selectUploadPort:) forControlEvents:UIControlEventTouchUpInside];
    selectUploadButton2.frame = CGRectMake(120.0, 0.0, 70.0, 70.0);
    selectUploadButton2.tag =1;
    selectUploadButton2.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [selectUploadButton2 setTitle:@"Google Drive" forState:UIControlStateNormal];
    [selectUploadButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectUploadButton2 setBackgroundImage:imageView2.image forState:UIControlStateNormal];
    selectUploadButton2.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -90.0, 0.0);
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mail_icon.png"]];
    UIButton *selectUploadButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectUploadButton3 addTarget:self action:@selector(selectUploadPort:) forControlEvents:UIControlEventTouchUpInside];
    selectUploadButton3.frame = CGRectMake(240.0, 0.0, 70.0, 70.0);
    selectUploadButton3.tag =2;
    selectUploadButton3.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [selectUploadButton3 setTitle:@"Mail" forState:UIControlStateNormal];
    [selectUploadButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectUploadButton3 setBackgroundImage:imageView3.image forState:UIControlStateNormal];
    selectUploadButton3.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -90.0, 0.0);
    
    
   
    
    [selectScrollView addSubview:selectUploadButton];
    [selectScrollView addSubview:selectUploadButton2];
    [selectScrollView addSubview:selectUploadButton3];
    
    CGPoint recr = CGPointMake(0.0, 0.0);
    recr.y =selectScrollView.frame.origin.y;
    recr.x = selectScrollView.frame.origin.x;
    CGRect screenRect = [[UIScreen mainScreen]applicationFrame];
    CGSize viewerGroupSize = [pickerGroupView sizeThatFits:CGSizeZero];
    CGSize rect = [anotherToolBar sizeThatFits:CGSizeZero];
    anotherToolBar.frame = CGRectMake(recr.x, recr.y, rect.width, rect.height);
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(slideDownPicker)];
    NSArray *array= [[NSArray alloc]initWithObjects:cancel, nil];
    anotherToolBar.items = array;
    selectScrollView.frame = CGRectMake(0.0, recr.y + anotherToolBar.frame.size.height, pickerGroupView.frame.size.width, pickerGroupView.frame.size.height);
    CGRect startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, viewerGroupSize.width, viewerGroupSize.height);
    anotherToolBar.translucent = NO;
    anotherToolBar.barTintColor = [UIColor blackColor];
    
    pickerGroupView.frame = startRect;
    CGRect pickRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - viewerGroupSize.height/3, viewerGroupSize.width, viewerGroupSize.height);
    selectScrollView.backgroundColor = [UIColor whiteColor];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    
    [UIView setAnimationDelegate:self];
    pickerGroupView.frame = pickRect;
    
    [[self view]setAlpha:0.5];
    [[self view]setBackgroundColor:[UIColor blackColor]];
    backButton.enabled = NO;
    deleteButton.enabled = NO;
    uploadButton.enabled = NO;
    
    
    [UIView commitAnimations];
}
-(void)selectUploadPort:(UIButton *)button
{
    switch (button.tag) {
        case 0:{
            DBAccount *account = [[DBAccountManager sharedManager]linkedAccount];
            if (!account) {
                [[DBAccountManager sharedManager]linkFromController:self];
            }
            else{
                UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to DropBox"];
                DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
                if (account) {
                    DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
                    [DBFilesystem setSharedFilesystem:filesystem];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MMMM d, YYYY h:mm:ss a"];
                    NSString *date = [dateFormat stringFromDate:[NSDate date]];
                    
                    NSString *png = [NSString stringWithFormat:@"%@.png",date];
                    
                    
                    DBPath *newPath = [[DBPath root] childPath:png];
                    myDBFile = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
                }
                NSString *keyString = [[dataItem keyArray]objectAtIndex:indexOfPicture];
                
                UIImage *image = [[imageStore sharedStore]imageForKey:keyString];
                BOOL success=   [myDBFile writeData:UIImagePNGRepresentation(image) error:nil];
                if (success) {
                    [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                    [self showAlert:@"DropBox" message:@"file saved!"];
                }
                else{
                    [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                    [self showAlert:@"DropBox" message:@"File could not be saved"];
                }
        
                [self slideDownPicker];
                
            }
            
        }
            break;
        case 1 :{
            [self slideDownPicker];
            if (![self isAuthorized]) {
                [self presentViewController:[self createAuthController] animated:YES completion:nil];
            }
            else{
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"EEEE MMMM d, YYYY h:mm a, zzz"];
                
                GTLDriveFile *file = [GTLDriveFile object];
                file.title = [dateFormat stringFromDate:[NSDate date]];
                file.descriptionProperty = @"Uploaded from medAlbum";
                file.mimeType = @"image/png";
                NSString *keyString = [[dataItem keyArray]objectAtIndex:indexOfPicture];
                
                UIImage *image = [[imageStore sharedStore]imageForKey:keyString];
                NSData *data = UIImagePNGRepresentation((UIImage *)image);
                GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
                GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                                   uploadParameters:uploadParameters];
                
                UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
                
                [driveService executeQuery:query
                              completionHandler:^(GTLServiceTicket *ticket,
                                                  GTLDriveFile *insertedFile, NSError *error) {
                                  [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                                  if (error == nil)
                                  {
                                      NSLog(@"File ID: %@", insertedFile.identifier);
                                      [self showAlert:@"Google Drive" message:@"File saved!"];
                                  }
                                  else
                                  {
                                      NSLog(@"An error occurred: %@", error);
                                      [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                                  }
                              }];
                

            }
            break;
        }
        case 2 :{
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                    picker.mailComposeDelegate = self;
                    
                    [picker setSubject:@"MedAlbum Photo"];
                    NSString *keyString = [[dataItem keyArray]objectAtIndex:indexOfPicture];
                    NSString *filePath = [[imageStore sharedStore]getImagePath:keyString];
                    
                    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                    NSData *evenMoreData = UIImagePNGRepresentation(image);
                    NSString *mimeString = @"image/png";
                    [picker addAttachmentData:evenMoreData mimeType:mimeString fileName:@"MedAlbum Photo"];
                    
                    [self presentViewController:picker animated:YES completion:nil];
                    [self slideDownPicker];
                }
            }
           
            break;
        }
                default:
            break;
    }
    
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    
    return progressAlert;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}
-(void)slideDownPicker
{
    CGRect screenRect = [[UIScreen mainScreen]applicationFrame];
    CGRect endFrame = pickerGroupView.frame;
    
    endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop:)];
    [[self view]setAlpha:1.0];
    [[self view]setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    pickerGroupView.frame = endFrame;
    
    
    
    [UIView commitAnimations];
    backButton.Enabled = YES;
    deleteButton.Enabled=YES;
    uploadButton.enabled = YES;
    
}
-(void)setFrameValues
{
    [toolBar removeFromSuperview];
    [scrollView removeFromSuperview];
    [imageToDisplay removeFromSuperview];
    
    scrollView = nil;
    if (indexOfPicture >0) {
        scrollView = [[ExpandedPictureScrollView alloc]initWithPageIndex:indexOfPicture-1  andDataItem:dataItem];
    }
    else
        scrollView = [[ExpandedPictureScrollView alloc]initWithPageIndex:indexOfPicture andDataItem:dataItem];
    
    [[self view]addSubview:scrollView];
    [[self view]addSubview:toolBar];
    CGSize toolSize = [toolBar sizeThatFits:CGSizeZero];
    CGRect recter = [[UIScreen mainScreen]bounds];
    
    
    CGRect toolRect = CGRectMake(0.0, recter.origin.y, toolSize.width, toolSize.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    CGRect other = CGRectMake(0.0, recter.origin.y+toolSize.height+[UIApplication sharedApplication].statusBarFrame.size.height, recter.size.width, recter.size.height);
    toolBar.frame = toolRect;
    scrollView.frame =other;
    [[self view]layoutSubviews];
    if (indexOfPicture >0) {
        ExpandedPictureViewController *evc = [self initWithPageIndex:indexOfPicture-1 andDataItem:dataItem];
        [thumbControl.pvc setViewControllers:@[evc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        thumbControl.pvc.dataSource = thumbControl;
        thumbControl.pvc.delegate = thumbControl;
    }
    else{
        ExpandedPictureViewController *evc = [self initWithPageIndex:indexOfPicture andDataItem:dataItem];
        [thumbControl.pvc setViewControllers:@[evc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        thumbControl.pvc.dataSource = thumbControl;
        thumbControl.pvc.delegate = thumbControl;
    }
    
}
-(void)delete:(id)sender
{
    NSError *error;
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
    [alertView show];

  
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        return;
    }
    else if (buttonIndex ==1){
        NSNumber *index = [[NSNumber alloc]initWithInteger:indexOfPicture];
        [[dataWithImageStore sharedStore]removePictureAtIndex:index forDataItem:dataItem];
        [thumbControl layoutThumbScrollView];
        [self setFrameValues];
        
    }
        
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[imageStore sharedStore]clearCache];
}
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)driveService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        driveService.authorizer = nil;
    }
    else
    {
        driveService.authorizer = authResult;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
