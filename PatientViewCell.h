//
//  PatientViewCell.h
//  surgeryPhotoApp
//
//  Created by Jeremy Wiygul on 3/10/13.
//  Copyright (c) 2013 Jeremy Wiygul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *medRecNum;
@property (weak, nonatomic) IBOutlet UILabel *dateTaken;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNail;
@property (weak, nonatomic) IBOutlet UILabel *caseName;

@end
