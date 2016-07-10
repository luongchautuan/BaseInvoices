//
//  BIProductsViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BIProductsViewControllerDelegate <NSObject>

- (void)checkCallback;

@end

@interface BIProductsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) id<BIProductsViewControllerDelegate> delegate;
@property (nonatomic)BOOL isViewEditProduct;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end