//
//  BIBusinessesViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/27/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"

@interface InvoiceTemplateViewController : UIViewController<BLLeftSideDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnCloseViewController;
@property (weak, nonatomic) IBOutlet UIButton *btnAddInvoiceTemplate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (nonatomic) BOOL isFromMenu;

@end
