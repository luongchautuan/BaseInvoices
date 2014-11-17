//
//  BIAddCustom.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIAddCustom : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)onBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *edtBussinessName;
@property (weak, nonatomic) IBOutlet UITextField *edtEmail;
@property (weak, nonatomic) IBOutlet UITextField *edtAddress;
@property (weak, nonatomic) IBOutlet UITextField *edtCity;
@property (weak, nonatomic) IBOutlet UITextField *edtPostCode;
@property (weak, nonatomic) IBOutlet UITextField *edtPhone;
@property (weak, nonatomic) IBOutlet UITextField *edtKeyContact;

@end
