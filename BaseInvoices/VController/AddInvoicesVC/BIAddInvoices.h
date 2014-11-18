//
//  BIAddInvoices.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIAddInvoices : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL checkBoxSelected;
}

@property (weak, nonatomic) IBOutlet UIButton *btnAddCustom;
- (IBAction)onAddCustom:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnAddProduct;
- (IBAction)onAddProduct:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
- (IBAction)onOpenMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)onBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnSaveSend;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *txtBussinessName;
@property (weak, nonatomic) IBOutlet UILabel *txtInvoiceNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOn;
@property (weak, nonatomic) IBOutlet UITextField *txtDueOn;
@property (weak, nonatomic) IBOutlet UITextField *txtSubTotal;
@property (weak, nonatomic) IBOutlet UITextField *txtTax;
@property (weak, nonatomic) IBOutlet UITextField *txtTotal;
@property (weak, nonatomic) IBOutlet UIButton *btnTotal;

@property (weak, nonatomic) IBOutlet UIButton *btnMarkPaid;

- (IBAction)onCheckedButton:(id)sender;


@end
