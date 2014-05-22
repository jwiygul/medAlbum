//
//  InfoEntryViewController.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/11/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataStore.h"
@interface InfoEntryViewController : UIViewController 
{
    __weak IBOutlet UITextField *patientName;
    
    __weak IBOutlet UITextField *medRecNum;
    
    __weak IBOutlet UITextField *caseName;
}
@property (weak, nonatomic) IBOutlet UILabel *dateCreated;
@property (weak,nonatomic)dataStore *item;



- (IBAction)hideKeyboard:(id)sender;



@end
