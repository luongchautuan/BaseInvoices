//
//  InvoiceTemplateTableViewCell.h
//  BaseInvoices
//
//  Created by Mac Mini on 7/14/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceTemplateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblContactName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVat;
@end
