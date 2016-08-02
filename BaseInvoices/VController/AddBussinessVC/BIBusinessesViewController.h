//
//  BIBusinessesViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/27/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"
#import "BIBussiness.h"

@protocol BIBusinessViewControllerDelegate <NSObject>

- (void)didSelectedBusiness:(BIBussiness*)business;

@end

@interface BIBusinessesViewController : UIViewController<BLLeftSideDelegate>

@property (nonatomic) id<BIBusinessViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnCloseViewController;
@property (weak, nonatomic) IBOutlet UIButton *btnAddBusiness;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (nonatomic) BOOL isFromMenu;
@property (nonatomic, strong) NSMutableArray* searchResults;

@end
