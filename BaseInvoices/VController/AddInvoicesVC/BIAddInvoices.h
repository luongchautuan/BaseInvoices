//
//  BIAddInvoices.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIAddInvoices : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL checkBoxSelected;
    NSMutableArray *arrData;
    NSInteger totalItem;
    NSInteger currSelected;
    int typeOfLstData;
    
    //0: lst business, 1:lst invoice number, 2: lst payment type
    int typeOfLstDatetime;
    
    //0: datetime in add invoices, 1: datetime in popup
    int isCheckTypeInPopup;
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
@property (weak, nonatomic) IBOutlet UIView *viewBusiness;
@property (weak, nonatomic) IBOutlet UITableView *tableViewBusiness;
@property (weak, nonatomic) IBOutlet UIView *viewInvoices;
@property (weak, nonatomic) IBOutlet UITableView *tableViewInvoice;
@property (weak, nonatomic) IBOutlet UIView *viewDatePickerForMain;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerForMain;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerForPopUp;
@property (weak, nonatomic) IBOutlet UIView *viewDateForPopUp;

@property  (nonatomic)BOOL isEditInvoice;

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
@property (weak, nonatomic) IBOutlet UIView *viewChilds;
@property (weak, nonatomic) IBOutlet UIView *viewTotal;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

#pragma mark init dialog popup
@property (weak, nonatomic) IBOutlet UIView *viewPopup;
@property (weak, nonatomic) IBOutlet UITextField *txtDateMarkPaid;
@property (weak, nonatomic) IBOutlet UIButton *btnBackDialogPopup;

@property (weak, nonatomic) IBOutlet UITextField *txtPaymentType;

@property (weak, nonatomic) IBOutlet UITextField *txtDateForMain;

- (IBAction)onBackDialogPopup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtNoteDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnCashPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnChequePopup;
@property (weak, nonatomic) IBOutlet UIButton *btnCardPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnDateTimeDialogPopup;
@property (weak, nonatomic) IBOutlet UIButton *btnPayTypeDialogPopup;
- (IBAction)onShowViewDateTimeFromDialogPopup:(id)sender;
- (IBAction)onCheckCashPopup:(id)sender;
- (IBAction)onCheckChequePopup:(id)sender;
- (IBAction)onCheckCardPopup:(id)sender;
- (IBAction)onCheckOtherPopup:(id)sender;
- (IBAction)onShowViewLstDataFromDialogPopup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtBussiness;

@property (weak, nonatomic) IBOutlet UIView *viewMarkPaid;

- (void)setNewPositionOfViewListData:(int)type;
@end
