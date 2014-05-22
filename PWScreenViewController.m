//
//  PWScreenViewController.m
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 4/3/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import "PWScreenViewController.h"
#import "PatientTableViewController.h"
#import "KeychainItemWrapper.h"
#import "InfoPageViewController.h"
@interface PWScreenViewController ()

@end

@implementation PWScreenViewController
{
    BOOL initScreen;
    NSString *passWordCheck;
}
@synthesize passwordWrapper,password, matchPassWord;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(infoPage)];
        [[self navigationItem]setRightBarButtonItem:rightButton];
        [[self navigationItem]setLeftBarButtonItem:leftButton];
        
    }
    return self;
}
-(void)done
{
    
    
    //[passwordWrapper setObject:[password text] forKey:(__bridge id)(kSecValueData)];
    //passWordCheck = [passwordWrapper objectForKey:secAttr];
    
    //citation for camera icon art license and author
    //http://creativecommons.org/licenses/by-nd/3.0/
    //Author: Svengraph http://svengraph.deviantart.com/
    //citation for folder icon art
    //Wil Nichols - http://wilnichols.com/
    //citation for folder+camera icon
    // http://delacro.deviantart.com/
    
    
    if (initScreen) {
        NSComparisonResult result = [[password text] compare:[matchPassWord text]];
        if (result == NSOrderedSame) {
            [passwordWrapper setObject:[password text] forKey:(__bridge id)(kSecValueData)];
            PatientTableViewController *pvc = [[PatientTableViewController alloc]init];
            [[self navigationController]pushViewController:pvc animated:YES];
        }
        else{
            password.text = nil;
            matchPassWord.text = nil;
            return;
        }
        
    }
    else{
    NSComparisonResult result = [passWordCheck compare:[password text]];
    if(result == NSOrderedSame){
        PatientTableViewController *pvc = [[PatientTableViewController alloc]init];
        //[passwordWrapper resetKeychainItem];
        [[self navigationController]pushViewController:pvc animated:YES];
    }
    else
    {
        password.text = nil;
        return;
    }
    }
    
    
}
-(void)infoPage
{
    InfoPageViewController * vc = [[InfoPageViewController alloc]init];
    [[self navigationController]pushViewController:vc animated:YES];
}
-(void)loadView
{
    [super loadView];
    id secAttr = (__bridge id)kSecValueData;
    passWordCheck = [passwordWrapper objectForKey:secAttr];
    NSComparisonResult result = [passWordCheck compare:@""];
    if (result == NSOrderedSame) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PWInitScreenViewController" owner:self options:nil];
        [self setView:[nib objectAtIndex:0]];
        initScreen = TRUE;
    }
    else{
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PWScreenViewController" owner:self options:nil];
        [self setView:[nib objectAtIndex:0]];
        initScreen = FALSE;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
