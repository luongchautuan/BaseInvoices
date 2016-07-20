//
//  AddInvoiceTemplateViewController.h
//  BaseInvoices
//
//  Created by Mac Mini on 7/14/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceTemplateRepository.h"
#import "MyUITextField.h"
#import "BIBussiness.h"
#import "CountryRepository.h"
#import "BIBusinessesViewController.h"
#import "CountryViewController.h"

@protocol AddInvoiceTemplateViewControllerDelegate <NSObject>

- (void)addSuccessFully;

@end

@interface AddInvoiceTemplateViewController : UIViewController<UIImagePickerControllerDelegate, BIBusinessViewControllerDelegate, CountryViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>

@property (nonatomic)id <AddInvoiceTemplateViewControllerDelegate> delegate;

@property (nonatomic, strong) InvoiceTemplateRepository* invoiceBeEdited;

@property (nonatomic) BOOL isFromWelcome;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MyUITextField *txtAddressLine1;
@property (weak, nonatomic) IBOutlet MyUITextField *txtAddressLine2;
@property (weak, nonatomic) IBOutlet MyUITextField *txtCity;
@property (weak, nonatomic) IBOutlet MyUITextField *txtPostcode;
@property (weak, nonatomic) IBOutlet MyUITextField *txtCountry;
@property (weak, nonatomic) IBOutlet MyUITextField *txtContactName;
@property (weak, nonatomic) IBOutlet MyUITextField *txtVat;
@property (weak, nonatomic) IBOutlet MyUITextField *txtBusinessName;
@property (weak, nonatomic) IBOutlet MyUITextField *txtTelephone;
@property (weak, nonatomic) IBOutlet MyUITextField *txtEmail;
@property (weak, nonatomic) IBOutlet MyUITextField *txtBankName;
@property (weak, nonatomic) IBOutlet MyUITextField *txtSortCode;
@property (weak, nonatomic) IBOutlet MyUITextField *txtAccountNo;

@property (weak, nonatomic) IBOutlet UIButton *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) BIBussiness* businessSelected;
@property (nonatomic, strong) CountryRepository* countrySelected;
@property (nonatomic, strong) UIImage* imageSelected;

@end
