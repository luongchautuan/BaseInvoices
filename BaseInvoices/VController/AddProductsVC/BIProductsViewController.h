//
//  BIProductsViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"
#import "BIProduct.h"

@protocol BIProductsViewControllerDelegate <NSObject>

- (void)checkCallback;
- (void)didSelectedProduct:(BIProduct*)product;

@end

@interface BIProductsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BLLeftSideDelegate>

@property (nonatomic) id<BIProductsViewControllerDelegate> delegate;
@property (nonatomic)BOOL isViewEditProduct;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (nonatomic) BOOL isFromMenu;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end
