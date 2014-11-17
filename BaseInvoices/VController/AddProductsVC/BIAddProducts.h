//
//  BIAddProducts.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIAddProducts : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)onBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *edtName;
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *edtUnitPrice;
@property (weak, nonatomic) IBOutlet UITextField *edtTaxRate;


@end
