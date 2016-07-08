//
//  CountryViewController.h
//  BaseInvoices
//
//  Created by Mac Mini on 7/8/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryRepository.h"

@protocol CountryViewControllerDelegate <NSObject>

- (void)CountrySelected:(CountryRepository*)countrySelected;

@end

@interface CountryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) id <CountryViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
