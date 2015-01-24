//
//  BIAddProducts.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIProduct.h"

@interface BIAddProducts : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)onBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *edtName;


@property (weak, nonatomic) IBOutlet UITextField *edtUnitPrice;
@property (weak, nonatomic) IBOutlet UITextField *edtTaxRate;
@property (weak, nonatomic) IBOutlet UITextField *edtDesc;

@property (nonatomic)BOOL isEditProduct;

@property (nonatomic, retain)BIProduct* product;

@property (nonatomic)NSString* unitPrice;
@property (nonatomic)NSString* price;
@property (nonatomic)NSString* tax;

@end
