//
//  BIInvoiceTableViewCell.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/26/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIInvoiceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblInvoiceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblInvoiceTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (weak, nonatomic) IBOutlet UIButton *btnPaid;
@property (weak, nonatomic) IBOutlet UIImageView *imgPaid;
@end
