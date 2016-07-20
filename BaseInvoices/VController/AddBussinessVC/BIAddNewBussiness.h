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
#import "MyUITextField.h"
#import "BICurrency.h"
#import "CountryViewController.h"
#import "BICurrencyViewController.h"
#import "CountryRepository.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FlatDatePicker.h"

@interface BIAddNewBussiness : UIViewController<UITextFieldDelegate, BICurrencyViewControllerDelegate, FlatDatePickerDelegate, CountryViewControllerDelegate, UIGestureRecognizerDelegate>
{
    BOOL onCheckedButton;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtNameBussiness;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckVat;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressLine1;
@property (nonatomic)NSString* currencySymbol;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressLine2;
@property (weak, nonatomic) IBOutlet UIButton *btnCisRegistered;
@property (weak, nonatomic) IBOutlet MyUITextField *txtPostCode;

@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (nonatomic)BOOL isEditBusiness;
@property (nonatomic, retain)BIBussiness* bussinessEdit;
@property (nonatomic)int addFrom;

@property (weak, nonatomic) IBOutlet UITextField *txtDateStarted;
@property (nonatomic) NSIndexPath* indexPathSelected;

- (IBAction)onCheckedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL isCISRegistered;
@property (nonatomic, strong) NSString* cisRegisteredValue;

@property (nonatomic, strong) BICurrency* currencySelected;
@property (nonatomic, strong) CountryRepository* countrySelected;
@property (nonatomic, strong) NSString* dateStarted;
@property (nonatomic, strong) NSDate* selectedDate;

@property (nonatomic) FlatDatePicker* flatDatePicker;

@end
