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
    NSMutableArray *arrData;
    NSInteger totalItem;
    NSInteger currSelected;
    int typeOfLstData;
}

#pragma mark init view add invoices
@property (weak, nonatomic) IBOutlet UIButton *btnAddCustom;
@property (weak, nonatomic) IBOutlet UIButton *btnAddProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveSend;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnTotal;
@property (weak, nonatomic) IBOutlet UIView *viewAddInvoices;
@property (weak, nonatomic) IBOutlet UIButton *btnBusiness;
@property (weak, nonatomic) IBOutlet UIButton *btnInvoicesNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnDateTime;

- (IBAction)onAddCustom:(id)sender;
- (IBAction)onOpenMenu:(id)sender;
- (IBAction)onCheckedButton:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onAddProduct:(id)sender;
- (IBAction)onShowViewLstBusiness:(id)sender;
- (IBAction)onShowViewLstInvoicesNumber:(id)sender;
- (IBAction)onShowViewDateTime:(id)sender;
- (IBAction)onSaveAndSend:(id)sender;
- (IBAction)onSave:(id)sender;

#pragma mark init dialog datetime
@property (weak, nonatomic) IBOutlet UIView *viewDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnBackViewDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveViewDateTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpViewDateTime;
- (IBAction)onBackViewDateTime:(id)sender;
- (IBAction)onSaveDateTime:(id)sender;

#pragma mark init dialog list data
@property (weak, nonatomic) IBOutlet UIView *viewListData;
@property (weak, nonatomic) IBOutlet UIButton *btnBackViewListData;
@property (weak, nonatomic) IBOutlet UITableView *tbvViewListData;
- (IBAction)onBackViewListData:(id)sender;

#pragma mark init dialog popup
@property (weak, nonatomic) IBOutlet UIView *viewPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnBackDialogPopup;
- (IBAction)onBackDialogPopup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtNoteDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnCashPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnChequePopup;
@property (weak, nonatomic) IBOutlet UIButton *btnCardPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherPopup;

@property (weak, nonatomic) IBOutlet UIView *viewMarkPaid;
@property (weak, nonatomic) IBOutlet UITextField *txtDatePaid;

@end
