//
//  BICurrencyViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BICurrencyViewControllerDelegate <NSObject>

- (void)checkCallback;

@end

@interface BICurrencyViewController : UIViewController

@property (nonatomic) id<BICurrencyViewControllerDelegate> delegate;

@property (nonatomic)NSMutableArray* allCurrency;

@end
