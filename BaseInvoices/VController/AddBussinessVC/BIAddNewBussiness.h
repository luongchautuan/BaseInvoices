//
//  BIAddNewBussiness.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIBussiness.h"
#import "BICurrencyViewController.h"

@interface BIAddNewBussiness : UIViewController<UITextFieldDelegate, BICurrencyViewControllerDelegate, UIGestureRecognizerDelegate>
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
@property (nonatomic)NSString* currencySymbol;
@property (strong, nonatomic) IBOutlet UIView *viewPopUpBanking;
@property (weak, nonatomic) IBOutlet UIView *viewPopUpMain;

@property (nonatomic)BOOL isEditBusiness;
@property (nonatomic, retain)BIBussiness* bussinessEdit;
@property (nonatomic)int addFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtBankAccountName;
@property (weak, nonatomic) IBOutlet UITextField *txtBankName;
@property (weak, nonatomic) IBOutlet UITextField *txtBankAccountNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtBankSortCode;

@property (nonatomic)NSIndexPath* indexPathSelected;
@property (weak, nonatomic) IBOutlet UITextField *txtBankDetails;

- (IBAction)onCheckedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
