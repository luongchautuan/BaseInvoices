//
//  BIAddNewBussiness.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIAddNewBussiness : UIViewController<UITextFieldDelegate>
{
    BOOL onCheckedButton;
}

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtNameBussiness;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtPostCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckVat;
@property (weak, nonatomic) IBOutlet UITextField *txtVat;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
- (IBAction)onCheckedButton:(id)sender;

@end
