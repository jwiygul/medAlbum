//
//  InfoEntryViewController.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/11/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "InfoEntryViewController.h"
#import "dataWithImageStore.h"
@interface InfoEntryViewController ()

@end

@implementation InfoEntryViewController
@synthesize dateCreated,item;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"InfoEntryViewController" bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        [[self navigationItem]setLeftBarButtonItem:cancelButton];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
        [[self navigationItem]setRightBarButtonItem:doneButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view]endEditing:YES];
    }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDateFormatter *form=[[NSDateFormatter alloc]init];
    [form setDateStyle:NSDateFormatterShortStyle];
    [form setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateString = [[NSString alloc]init];
    
        dateString =  [form stringFromDate:[item dateCreated]];
       [[self dateCreated]setText:dateString];
   
    [caseName setText:[item caseName]];
}



- (void)save {
    
    [item setCaseName:[caseName text]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [[self view]endEditing:YES];
}
@end
