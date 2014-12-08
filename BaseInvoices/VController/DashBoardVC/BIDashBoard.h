//
//  BIDashBoard.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"

@interface BIDashBoard : UIViewController<BLLeftSideDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnAddinvoice;
@property (weak, nonatomic) IBOutlet UIView *viewAddMore;
@property (weak, nonatomic) IBOutlet UIButton *btnAddInvoiceMore;
@property (weak, nonatomic) IBOutlet UIButton *btnAddBusiness;

- (IBAction)onAddInvoice:(id)sender;
- (IBAction)showCat:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UIView *viewPopUp;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
