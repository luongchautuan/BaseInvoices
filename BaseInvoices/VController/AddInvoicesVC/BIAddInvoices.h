//
//  BIAddInvoices.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIInvoice.h"
#import <MessageUI/MessageUI.h>
#import "NDHTMLtoPDF.h"
#import "BIProductsViewController.h"
#import "InvoiceTemplateRepository.h"

@interface BIAddInvoices : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, NDHTMLtoPDFDelegate,MFMailComposeViewControllerDelegate, UIAlertViewDelegate, BIProductsViewControllerDelegate>
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
    
    MFMailComposeViewController *mailComposer;
    NSString *currFile;
}

#pragma mark init view add invoices

@property (nonatomic)float subTotal;
@property (nonatomic)float taxes;
@property (nonatomic)float total;
@property (nonatomic)float totalAmount;
@property (nonatomic)NSString* amountPaid;
@property (nonatomic)NSString* html;

@property (strong, nonatomic) IBOutlet UIView *viewPdfPreview;
@property (weak, nonatomic) IBOutlet UIWebView *webViewPdf;
@property (weak, nonatomic) IBOutlet UIView *viewPdfPreviewMain;

@property (weak, nonatomic) IBOutlet UITextField *txtNoteDescriptionPayment;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPaymentTerms;
@property (weak, nonatomic) IBOutlet UIView *viewForPaymentTermsChild;
@property (weak, nonatomic) IBOutlet UIView *viewForTablePayments;
@property (weak, nonatomic) IBOutlet UITextField *txtPaymentTerm;

@property (weak, nonatomic) IBOutlet UIView *viewForPaymentTerms;
@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
@property (nonatomic)NSMutableArray* paymentTerms;

@property (nonatomic)NSIndexPath* indexPathSelected;

@property (nonatomic, retain)BIInvoice* invoiceEdit;
@property (nonatomic, retain)BIBussiness* bussinessSelected;

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
@property (weak, nonatomic) IBOutlet UITextField *txtInvoiceNumber;

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

@property (weak, nonatomic) IBOutlet UILabel *lblProducts;
@property (nonatomic) BOOL isFromWelcome;

- (IBAction)onShowViewDateTimeFromDialogPopup:(id)sender;
- (IBAction)onCheckCashPopup:(id)sender;
- (IBAction)onCheckChequePopup:(id)sender;
- (IBAction)onCheckCardPopup:(id)sender;
- (IBAction)onCheckOtherPopup:(id)sender;
- (IBAction)onShowViewLstDataFromDialogPopup:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtBussiness;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxes;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblOutStanding;

@property (weak, nonatomic) IBOutlet UIView *viewMarkPaid;
@property (weak, nonatomic) IBOutlet UIView *viewPopUpAddUnitMain;
@property (weak, nonatomic) IBOutlet UITextField *txtProductName;
@property (weak, nonatomic) IBOutlet UITextField *txtNumberOfUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnClosePopUpUnit;

@property (weak, nonatomic) IBOutlet UIView *viewPopUpAddNumberUnit;

@property (nonatomic) InvoiceTemplateRepository* invoiceTemplateSelected;
@property (nonatomic) BICustomer* customerSelected;

@property (weak, nonatomic) IBOutlet UIButton *btnAutoCreateIncome;
@property (nonatomic, strong) NSMutableArray* productsAdded;

@property (nonatomic) BOOL isAutoCreateIncome;

- (void)setNewPositionOfViewListData:(int)type;


@end
