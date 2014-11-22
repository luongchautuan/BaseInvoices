//
//  BICustomProductTableViewCell.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/22/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BICustomProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblNameProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *quantity;
@end
