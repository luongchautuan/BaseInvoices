//
//  BICurrencyViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BICurrency.h"

@protocol BICurrencyViewControllerDelegate <NSObject>

- (void)checkCallback;
- (void)didSelectedCurrency:(BICurrency*)currency;

@end

@interface BICurrencyViewController : UIViewController

@property (nonatomic) id<BICurrencyViewControllerDelegate> delegate;

@property (nonatomic)NSMutableArray* allCurrency;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
