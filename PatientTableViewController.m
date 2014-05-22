//
//  PatientTableViewController.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "PatientTableViewController.h"
#import "dataWithImageStore.h"
#import "PatientViewCell.h"
#import "dataStore.h"
#import "InfoEntryViewController.h"
#import "dataWithImageStore.h"
#import "imageStore.h"
#import "PictureScrollView.h"
#import "ThumbnailArrayViewController.h"
#import "ThumbnailArrayScrollView.h"
#import "PWScreenViewController.h"
#import "InfoEntryViewController.h"
@interface PatientTableViewController ()

@end

@implementation PatientTableViewController
@synthesize patient;
- (id)init
{
    self = [super init];
    if (self) {
        [[self navigationController]navigationBar].translucent = TRUE;
        UIBarButtonItem *plusButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPatient)];
        togglePassword = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(togglePassword)];
        if ([[dataWithImageStore sharedStore]passwordOn]) {
            [togglePassword setTitle:@"Password On"];
        }
        else 
            [togglePassword setTitle:@"Password Off"];
        NSArray * array = [[NSArray alloc]initWithObjects:togglePassword, nil];
        [[self navigationItem]setRightBarButtonItems:array animated:NO];
        [[self navigationItem]setLeftBarButtonItem:plusButton];
    }
    return self;
}

-(void)togglePassword
{
    BOOL isOn = [[dataWithImageStore sharedStore]togglePassword];
    
    if (isOn) {
        [togglePassword setTitle:@"Password On"];
    }
    else
        [togglePassword setTitle:@"Password Off"];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbnailArrayViewController *thumbViewControl = [[ThumbnailArrayViewController alloc]init];
    dataStore *itemOfInterest = [[[dataWithImageStore sharedStore]allItems]objectAtIndex:[indexPath row]];
    thumbViewControl.dataItem = itemOfInterest;
    UINavigationController *navCom = [[UINavigationController alloc]initWithRootViewController:thumbViewControl];
    
    [navCom setModalPresentationStyle:UIModalPresentationFormSheet];
    [navCom setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navCom animated:YES completion:nil];
    
   
    

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[UIImage alloc]init];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [patient setThumbnailDataFromImage:image];
    
   
    //following code creates a unique identifier to be used in key-value pairs
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault,newUniqueID);
    NSString *key= (__bridge NSString *)newUniqueIDString;
    [patient setImageKey:key];

    [[imageStore sharedStore]setImage:image forKey:key];
    [[patient keyArray]addObject:key];
     
    
    UIImage * newImage = [UIImage imageWithData:[[patient thumbnailDataArray]lastObject]];
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0.0, 0.0, 60.0, 60.0);
    imageButton.customView = button;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[dataWithImageStore sharedStore]removeItem:patient];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadView
{
    [super loadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataWithImageStore sharedStore]allItems]count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        PatientViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientViewCell"];
        dataStore *p = [[[dataWithImageStore sharedStore]allItems]objectAtIndex:[indexPath row]];
  
        NSDateFormatter *formatter= [[NSDateFormatter alloc]init];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        NSString *date = [formatter stringFromDate:[p dateCreated]];
        [[cell dateTaken]setText:date];
        [[cell caseName]setText:[p caseName]];
    if ([[p thumbnailDataArray]count]>0) {
        NSData *data = [[p thumbnailDataArray]objectAtIndex:0];
        [[cell thumbNail]setImage:[UIImage imageWithData:data]];
    }
        return cell;
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PatientViewCell" bundle:nil];
    CGRect screen=[[UIScreen mainScreen]applicationFrame];
    
    CGRect newFrame = CGRectMake(0.0, screen.origin.y, screen.size.width, screen.size.height);
    imagePickerController = [[UIImagePickerController alloc]initWithNibName:nil bundle:nil];
    firstTableView = [[UITableView alloc]initWithFrame:newFrame style:UITableViewStyleGrouped];
    [firstTableView registerNib:nib forCellReuseIdentifier:@"PatientViewCell"];
    firstTableView.delegate = self;
    firstTableView.dataSource = self;
    
    [[self view]addSubview:firstTableView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPatient)];
    NSArray *array = [[NSArray alloc]initWithObjects:addButton, nil];
    [toolBar setItems:array];
    firstTableView.rowHeight = 125.0;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [firstTableView reloadData];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        dataStore *deletedItem = [[[dataWithImageStore sharedStore]allItems]objectAtIndex:[indexPath row]];
        [[dataWithImageStore sharedStore]removeItem:deletedItem];
        [firstTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)addNewPatient
{
  
    dataStore *item = [[dataWithImageStore sharedStore]createItem];
    
    self.patient = item;
    imagePickerController = [[UIImagePickerController alloc]init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    imagePickerController.delegate=self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.showsCameraControls = NO;
    CGRect screen = [[UIScreen mainScreen]applicationFrame];
    
    CGRect tableRect = CGRectMake(0.0, 360.0, screen.size.width, 70.0);
    
    
    
    pictureScrollView = [[PictureScrollView alloc]initWithFrame:tableRect];
    cameraToolBar = [[UIToolbar alloc]init];
   
    [cameraToolBar setBackgroundImage:[[UIImage alloc]init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    cameraToolBar.tintColor = [UIColor darkTextColor];
    toolBar = [[UIToolbar alloc]init];
    [toolBar setBackgroundImage:[[UIImage alloc]init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    toolBar.tintColor = [UIColor darkTextColor];
    CGSize toptoolSize = [toolBar sizeThatFits:CGSizeZero];
    CGRect toptoolRect = CGRectMake(0.0, 0.0, toptoolSize.width, toptoolSize.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    toolBar.frame =toptoolRect;
    [imagePickerController.cameraOverlayView addSubview:cameraToolBar];
    [imagePickerController.cameraOverlayView addSubview:toolBar];
    CGSize toolSize = [cameraToolBar sizeThatFits:CGSizeZero];
    CGRect toolRect = CGRectMake(0.0, screen.origin.y + screen.size.height - toolSize.height-40.0, toolSize.width, toolSize.height+40.0);
    cameraToolBar.frame = toolRect;
    cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(done)];
    doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    takePictureButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    addInfoButton = [[UIBarButtonItem alloc]initWithTitle:@"Patient Info" style:UIBarButtonItemStylePlain target:self action:@selector(addPatientInfo)];
    imageButton = [[UIBarButtonItem alloc]init];
    UIImage * newImage = [UIImage imageNamed:@"Default.png"];
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(0.0, 0.0, 60.0, 60.0);
    imageButton.customView = button;
    NSArray *buttonArray = [[NSArray alloc]initWithObjects:imageButton, spaceButton, takePictureButton,spaceButton, doneButton,nil];
    [cameraToolBar setItems:buttonArray];
    NSArray *otherArray = [[NSArray alloc]initWithObjects:cancelButton,spaceButton,addInfoButton, nil];
    [toolBar setItems:otherArray];
    pictureScrollView.delegate = self;
    pictureScrollView.dataItem = self.patient;
    pictureScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    
    
   // [[imagePickerController cameraOverlayView]addSubview:pictureScrollView];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)addPatientInfo
{
    InfoEntryViewController *favc = [[InfoEntryViewController alloc]init];
    favc.item = self.patient;
    UINavigationController *navCom = [[UINavigationController alloc]initWithRootViewController:favc];
    
    [navCom setModalPresentationStyle:UIModalPresentationFormSheet];
    //[navCom setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [imagePickerController presentViewController:navCom animated:YES completion:nil];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)done
{
    [self imagePickerControllerDidCancel:imagePickerController];
}





@end
