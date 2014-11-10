//
//  BIDashBoard.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"

@interface BIDashBoard : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnAddinvoice;

- (IBAction)onAddInvoice:(id)sender;
- (IBAction)showCat:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;

@end
