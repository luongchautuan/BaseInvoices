//
//  BIDashBoard.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"
#import "MyUITextField.h"

@interface BIDashBoard : UIViewController<BLLeftSideDelegate, UITableViewDelegate, UITableViewDataSource>
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

@property (weak, nonatomic) IBOutlet UIView *viewDatePaid;
@property (weak, nonatomic) IBOutlet MyUITextField *txtDatePaid;
@property (weak, nonatomic) IBOutlet UIView *viewTableDate;
@property (weak, nonatomic) IBOutlet MyUITextField *txtAmountPaid;
@property (weak, nonatomic) IBOutlet UIView *viewMarkPaid;

@property (nonatomic, strong) NSIndexPath* indexPathSelected;
@property (nonatomic) BOOL isShowingDatePaid;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
