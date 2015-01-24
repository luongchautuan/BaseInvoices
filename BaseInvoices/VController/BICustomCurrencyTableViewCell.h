//
//  BICustomCurrencyTableViewCell.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BICustomCurrencyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCurrencyCode;
@property (weak, nonatomic) IBOutlet UILabel *lblSymbolCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@end
