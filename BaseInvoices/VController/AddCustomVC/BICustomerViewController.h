//
//  BICustomerViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"
#import "BICustomer.h"

@protocol CustomerViewControllerDelegate <NSObject>

- (void)didSelectedCustomer:(BICustomer*)customer;

@end

@interface BICustomerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BLLeftSideDelegate>

@property (nonatomic) id <CustomerViewControllerDelegate> delegate;

@property (nonatomic)BOOL isViewCustomerEdit;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (nonatomic) BOOL isFromMenu;
@property (nonatomic, strong) NSMutableArray* searchResults;

@end
