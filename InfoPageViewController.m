//
//  InfoPageViewController.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 2/14/14.
//  Copyright (c) 2014 Jeremy Wiygul. All rights reserved.
//

#import "InfoPageViewController.h"

@interface InfoPageViewController ()

@end

@implementation InfoPageViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor],NSForegroundColorAttributeName,
                                        [UIColor blueColor],NSBackgroundColorAttributeName,nil];
        self.navigationController.navigationBar.titleTextAttributes = textAttributes;
        self.title = @"medAlbum Info";
    }
    return self;
}
-(void)doneReading:(id)sender
{
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    UIView *view = [[UIView alloc]initWithFrame:rect];
    [self setView:view];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen]applicationFrame];
    UITextView *textView = [[UITextView alloc]init];
    [[self view]addSubview:textView];
   
    
        textView.frame = CGRectMake(0.0, screenRect.origin.y-[UIApplication sharedApplication].statusBarFrame.size.height, screenRect.size.width, screenRect.size.height);
        textView.font =[UIFont boldSystemFontOfSize:18.0];
    
    
    [textView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    textView.scrollEnabled = YES;
    textView.text =@"Hi!  Thanks for picking medAlbum.  Just a few things to know about our application.\n\nIt's password-protected, so the first time you open the application (or every time, if you don't set a password), you'll have the opportunity to set your password.  Once you've set it, make sure to write it down.\n\nThere is also an option to turn your password off, on the first page after you sign in.\n\nWe've integrated a couple of popular cloud storage services into medAlbum, so there are options to upload the photos you take in medAlbum to either Google Drive or Dropbox.  There's also the option to email the picture.  You need both an account and the associated application for the Dropbox option to work.  With Google Drive, you just need an account.  You CANNOT establish an account for either through medAlbum.\n\nYou should also make sure you are connected to WiFi when uploading the pictures-otherwise it will take forever to upload!\n\nAnd finally, you have the option of a short descriptor of the case, too.  Just press the button Patient Info.\n\nAnd that's it - simple and easy.  If there's something that bothers you about medAlbum, please don't just grumble to yourself-let us know!";
	
	textView.delegate = self;
    
    [textView setEditable:NO];
    
    
}@end
