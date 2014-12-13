//
//  BIAddInvoices.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//
#import "BIAddCustom.h"
#import "BIAddInvoices.h"
#import "BIAddProducts.h"
#import "UIViewController+MMDrawerController.h"
#import "BIDashBoard.h"
#import "ASIHTTPRequest.h"
#import "BIAppDelegate.h"
#import "BICustomerViewController.h"

#import "BICustomProductTableViewCell.h"
#import "BIInvoice.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

#define ACCEPTABLE_CHARECTERS @".0123456789"

@interface BIAddInvoices ()

@end

bool cashBool,otherBool,cardBool,chequeBool, isCurrentDay, isShowViewBusiness, isShowViewDateTimeForMain, isShowViewTablePayments;

BIAppDelegate* appdelegate;

@implementation BIAddInvoices

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)onShowViewTablePaymentsTerm:(id)sender
{
    isShowViewTablePayments = !isShowViewTablePayments;
    if (isShowViewTablePayments) {
         self.viewForTablePayments.hidden = NO;
    }
    else  self.viewForTablePayments.hidden = YES;
   
}

- (IBAction)onSaveAndSendEmail:(id)sender
{
    self.viewForPaymentTerms.hidden = YES;
    [self generatPdfForInvoice];
    self.viewPdfPreview.hidden = NO;
    [self.webViewPdf loadHTMLString:self.html baseURL:nil];
    
//    [self generatPdfForInvoice];
}
- (IBAction)onSend:(id)sender
{
    self.viewPdfPreview.hidden = YES;
    
     [self createPDFfromHTML:self.html withName:[NSString stringWithFormat:@"Invoice %@", self.txtInvoiceNumber.text]];
   
}
- (IBAction)onCancelSend:(id)sender
{
     self.viewPdfPreview.hidden = YES;
    [self saveInvoice];
}

- (IBAction)onCloseNumberOfUnit:(id)sender
{
    BIProduct* product = [appdelegate.productsFroAddInvoices objectAtIndex:self.indexPathSelected.row];
    [product setNumberOfUnit:[self.txtNumberOfUnit.text floatValue]];
    
    [self calculateAmout];
    
    [self.tableView reloadData];
    [self.txtNumberOfUnit resignFirstResponder];
    
    self.viewPopUpAddNumberUnit.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self.isEditInvoice)
    {
        NSLog(@"View DId load");
        [self loadInvoiceEdit];
    }
    
    if (appdelegate.isLoginSucesss)
    {
        //Request to get bussiness from server
    }
    else
    {
        //Get bussiness from local
        if (self.isEditInvoice)
        {
            self.txtBussiness.text = self.invoiceEdit.bussiness.bussinessName;
            
            self.bussinessSelected = self.invoiceEdit.bussiness;
            
        }
        else
        {
            self.txtBussiness.text = [[appdelegate.businessForUser objectAtIndex:appdelegate.businessForUser.count - 1] bussinessName];
            
            self.bussinessSelected = [appdelegate.businessForUser objectAtIndex:appdelegate.businessForUser.count - 1];
        }
    }

    
    self.paymentTerms = [[NSMutableArray alloc] initWithObjects:@"Due on reciept", @"Net 7 days", @"Net 10 days", @"Net 30 Days", nil];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    if (appdelegate.currentCustomerForAddInvoice.customerBussinessName.length > 0)
    {
        [self.btnAddCustom setTitle:appdelegate.currentCustomerForAddInvoice.customerBussinessName forState:UIControlStateNormal];
    }
    
    [self initScreen];
   
    
//    [self calculateAmout];
    
//    [self.tableView setEditing:YES animated:YES];
    
    [self updateFrameTableView];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateAmout
{
    
    self.subTotal = 0;
    self.total = 0;
    self.taxes = 0;
    self.totalAmount = 0;
    
    //Calculate Subtotal, Taxes, Total and outstanding
    for (BIProduct* product in appdelegate.productsFroAddInvoices)
    {
        NSString* priceUnit = product.productUnitPrice;
        
        if ([priceUnit rangeOfString:@","].length != 0) {
            priceUnit = [priceUnit stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
//        if ([priceUnit containsString:@","])
//        {
//          priceUnit = [priceUnit stringByReplacingOccurrencesOfString:@"," withString:@""];
//        }
        
        self.subTotal = self.subTotal + [priceUnit floatValue] * product.numberOfUnit;
        
        NSLog(@"Unit: %f", [priceUnit floatValue]);
        self.taxes = self.taxes + [priceUnit floatValue] * product.numberOfUnit * [product.productTaxRate floatValue] / 100;
    }

    
    self.total = self.subTotal + self.taxes;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *localeCurrency = [[NSLocale alloc]
                                initWithLocaleIdentifier:@"en"];
    [formatter setLocale:localeCurrency];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    NSString* subTotal = [[formatter stringFromNumber:[NSNumber numberWithFloat:self.subTotal]] substringFromIndex:1];
    
    NSString* taxes = [[formatter stringFromNumber:[NSNumber numberWithFloat:self.taxes]] substringFromIndex:1];
    
    NSString* total = [[formatter stringFromNumber:[NSNumber numberWithFloat:self.total]] substringFromIndex:1];
    
    NSString* subTotalAfterFormat = [[NSString stringWithFormat:@"%@ ", self.bussinessSelected.currencySymbol] stringByAppendingString:subTotal];
    
    NSString* taxesAfterFormat = [[NSString stringWithFormat:@"%@ ", self.bussinessSelected.currencySymbol] stringByAppendingString:taxes];
    
    NSString* totalAfterFormat = [[NSString stringWithFormat:@"%@ ", self.bussinessSelected.currencySymbol] stringByAppendingString:total];
    
    self.lblSubTotal.text = subTotalAfterFormat;
    self.lblTaxes.text = taxesAfterFormat;
    self.lblTotal.text = totalAfterFormat;
    self.amountPaid = total;
    
    if (checkBoxSelected)
    {
        self.totalAmount = self.total - [self.amountPaid floatValue];
        
        NSString* totalOutStanding = [[formatter stringFromNumber:[NSNumber numberWithFloat:self.totalAmount]] substringFromIndex:1];
        
        NSString* subTotalAfterFormat = [[NSString stringWithFormat:@"%@ ", self.bussinessSelected.currencySymbol] stringByAppendingString:totalOutStanding];
        
        self.lblOutStanding.text = subTotalAfterFormat;
    }
    else
    {
        self.lblOutStanding.text = self.lblTotal.text;
        self.totalAmount = self.total;
    }
    
    if (appdelegate.productsFroAddInvoices.count > 0)
    {
        NSLog(@"Product Fỏ Add Invoice: %@", appdelegate.productsFroAddInvoices);
        self.tableView.hidden = NO;
    }
    else
    {
        self.tableView.hidden = YES;
        self.lblOutStanding.text = self.lblTotal.text;
        checkBoxSelected = false;
         [self.btnTotal setSelected:checkBoxSelected];
    }

}

#pragma mark init view add invoices

- (void)initScreen
{
    //set gesture for return to close soft keyboard
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGeusture];
    
    [tapGeusture setCancelsTouchesInView:NO];
    
    
    UITapGestureRecognizer *tapGeusturePopup = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusturePopup.numberOfTapsRequired = 1;
    [self.viewPopUpAddNumberUnit addGestureRecognizer:tapGeusturePopup];
    
    [tapGeusturePopup setCancelsTouchesInView:NO];

    UITapGestureRecognizer *tapGeusturePaymemt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusturePaymemt.numberOfTapsRequired = 1;
    [self.viewPopup addGestureRecognizer:tapGeusturePaymemt];
    
    [tapGeusturePaymemt setCancelsTouchesInView:NO];

    
    [self onVisibleOfViewListData:true];
    [self onVisibleofViewDateTime:true];
//    [self onVisibleOfDialogPopup:true];
    
    [self.txtNoteDesc setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    self.txtNoteDesc.leftView = paddingView;
    self.txtNoteDesc.leftViewMode = UITextFieldViewModeAlways;
    
   
    
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
    NSDate *myDate = [self.datePickerForMain date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *time = [dateFormat stringFromDate:myDate];
    
    self.txtDateForMain.text = time;
    
    self.scrollView.scrollEnabled = YES;
    
    
    if (self.isEditInvoice)
    {
        [self.txtTitle setText:@"Edit Invoice"];
//        [self loadInvoiceEdit];
    }
    else
    {
        self.txtInvoiceNumber.text = [NSString stringWithFormat:@"#%lu",appdelegate.invoicesForUser.count + 1];
        [self.txtTitle setText:@"Add Invoice"];
    }
    
   

}

- (void)updateFrameTableView
{
    self.tableView.frame = CGRectMake(1, 277, self.tableView.frame.size.width, appdelegate.productsFroAddInvoices.count * 28);
    
    self.viewTotal.frame = CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.viewTotal.frame.size.width, self.viewTotal.frame.size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;

        if(result.height == 480)
        {
            // iPhone Classic
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.viewTotal.frame.origin.y + self.viewTotal.frame.size.height + 160);
        }
        else
        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.viewTotal.frame.origin.y + self.viewTotal.frame.size.height + 160);
        }
    }

}

- (void)loadInvoiceEdit
{
    self.txtBussiness.text = self.invoiceEdit.bussiness.bussinessName;
    self.txtInvoiceNumber.text = self.invoiceEdit.invoiceName;
    [self.btnAddCustom setTitle:self.invoiceEdit.customer.customerBussinessName forState:UIControlStateNormal];
    self.txtDateForMain.text = self.invoiceEdit.dateInvoice;
    self.txtNoteDesc.text = self.invoiceEdit.noteInvoice;
    self.txtPaymentType.text = self.invoiceEdit.outStanding;
    self.totalAmount = self.invoiceEdit.totalOutSanding;
    
    appdelegate.bussinessForUser = self.invoiceEdit.bussiness;
    appdelegate.currentCustomerForAddInvoice = self.invoiceEdit.customer;
    checkBoxSelected = self.invoiceEdit.isPaided;
    
    [self.btnTotal setSelected:self.invoiceEdit.isPaided];
    
    appdelegate.productsFroAddInvoices = [[NSMutableArray alloc] init];
    appdelegate.productsFroAddInvoices = self.invoiceEdit.products;
    
    NSLog(@"Product Add: %lu", (unsigned long)appdelegate.productsFroAddInvoices.count);
    
    self.bussinessSelected = self.invoiceEdit.bussiness;
    
    if (appdelegate.currentCustomerForAddInvoice.customerBussinessName.length > 0) {
        [self.btnAddCustom setTitle:appdelegate.currentCustomerForAddInvoice.customerBussinessName forState:UIControlStateNormal];
    }
    
    self.lblSubTotal.text = self.invoiceEdit.subInvoice;
    self.lblTaxes.text = self.invoiceEdit.taxesInvoice;
    self.lblTotal.text = self.invoiceEdit.totalInvoices;
    
    if (checkBoxSelected)
    {
        self.lblOutStanding.text = self.invoiceEdit.outStanding;
    }
    else
    {
        self.lblOutStanding.text = self.lblTotal.text;
    }
    
    if (appdelegate.productsFroAddInvoices.count > 0)
    {
        
        self.tableView.hidden = NO;
    }
    else self.tableView.hidden = YES;
}

- (void)initData
{
    typeOfLstData = 0;
    [self initDataOfTableView];
}

- (IBAction)onShowViewLstBusiness:(id)sender
{
    isShowViewBusiness = !isShowViewBusiness;
    
    if (isShowViewBusiness) {
        [self.viewBusiness setHidden:NO];
        
        self.viewBusiness.frame=CGRectMake(20, 45, 292, 0);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewBusiness.frame=CGRectMake(20, 45, 292, 120);
        [UIView commitAnimations];
    }
    else
    {
        [self.viewBusiness setHidden:YES];
        
        self.viewBusiness.frame=CGRectMake(20, 45, 292, 120);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewBusiness.frame=CGRectMake(20, 45, 292, 0);
        [UIView commitAnimations];
    }
   
}

- (IBAction)onShowViewLstInvoicesNumber:(id)sender
{
    typeOfLstData = 1;
    [self initDataOfTableView];
    [self onVisibleOfViewListData:false];
}

- (IBAction)onShowViewDateTime:(id)sender
{
//    typeOfLstDatetime = 0;
//    [self onVisibleofViewDateTime:false];
    
    isShowViewDateTimeForMain = !isShowViewDateTimeForMain;
    
    if (isShowViewDateTimeForMain) {
        [self.viewDatePickerForMain setHidden:NO];
        
        self.viewBusiness.frame=CGRectMake(20, 168, 292, 0);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewDatePickerForMain.frame=CGRectMake(20, 168, 292, 170);
        [UIView commitAnimations];
    }
    else
    {
        [self.viewDatePickerForMain setHidden:YES];
        
        self.viewDatePickerForMain.frame=CGRectMake(20, 168, 292, 170);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewDatePickerForMain.frame=CGRectMake(20, 168, 292, 0);
        [UIView commitAnimations];
    }

    
}

- (IBAction)onSaveAndSend:(id)sender
{
    NSLog(@"Save And Send");
    if (appdelegate.productsFroAddInvoices.count > 0 && self.txtInvoiceNumber.text.length > 0 && self.btnAddCustom.titleLabel.text.length > 0)
    {
        self.viewForPaymentTerms.hidden = NO;
       
        self.viewForPaymentTermsChild.frame=CGRectMake(10, -190, 300, 192);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewForPaymentTermsChild.frame=CGRectMake(10, 190, 300, 192);
        [UIView commitAnimations];


    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}

- (IBAction)onSave:(id)sender
{
    NSLog(@"Save");
   [self saveInvoice];
}

- (void)saveInvoice
{
    if (appdelegate.productsFroAddInvoices.count > 0 && self.txtInvoiceNumber.text.length > 0 && self.txtDateForMain.text.length > 0  && self.btnAddCustom.titleLabel.text.length > 0)
    {
        if (!self.isEditInvoice)
        {
            BIInvoice* invoice = [[BIInvoice alloc] init];
            invoice.invoiceName = self.txtInvoiceNumber.text;
            invoice.bussiness = self.bussinessSelected;
            invoice.dateInvoice = self.txtDateForMain.text;
            invoice.customer = appdelegate.currentCustomerForAddInvoice;
            invoice.noteInvoice = self.txtNoteDesc.text;
            invoice.products = [[NSMutableArray alloc] init];
            invoice.products = appdelegate.productsFroAddInvoices;
            invoice.subInvoice = self.lblSubTotal.text;
            invoice.totalInvoices = self.lblTotal.text;
            invoice.taxesInvoice = self.lblTaxes.text;
            invoice.isPaided = checkBoxSelected;
            invoice.outStanding = self.lblOutStanding.text;
            invoice.totalOutSanding = self.totalAmount;
            
            [appdelegate.invoicesForUser addObject:invoice];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:appdelegate.invoicesForUser forKey:@"invoicesForUser"];
 
            if (appdelegate.isLaunchAppFirstTime)
            {
                NSLog(@"Is Launch App First Time");
                 appdelegate.isLaunchAppFirstTime = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                if (self.isEditInvoice) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                //        [self.navigationController popViewControllerAnimated:YES];
            }
            
//            appdelegate.currentCustomerForAddInvoice = nil;
//            appdelegate.productsFroAddInvoices = [[NSMutableArray alloc] init];

        }
        else
        {
            BIInvoice* invoiceEdit = [appdelegate.invoicesForUser objectAtIndex:self.indexPathSelected.section];
            invoiceEdit.invoiceName = self.txtInvoiceNumber.text;
            invoiceEdit.bussiness = self.bussinessSelected;
            invoiceEdit.dateInvoice = self.txtDateForMain.text;
            invoiceEdit.customer = appdelegate.currentCustomerForAddInvoice;
            invoiceEdit.noteInvoice = self.txtNoteDesc.text;
            invoiceEdit.products = [[NSMutableArray alloc] init];
            invoiceEdit.products = appdelegate.productsFroAddInvoices;
            invoiceEdit.subInvoice = self.lblSubTotal.text;
            invoiceEdit.totalInvoices = self.lblTotal.text;
            invoiceEdit.taxesInvoice = self.lblTaxes.text;
            invoiceEdit.isPaided = checkBoxSelected;
            invoiceEdit.outStanding = self.lblOutStanding.text;
            invoiceEdit.totalOutSanding = self.totalAmount;
            
            NSLog(@"Invoice business: %lu", (unsigned long)appdelegate.productsFroAddInvoices.count);

            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:appdelegate.invoicesForUser forKey:@"invoicesForUser"];
            
           
            
            if (appdelegate.isLaunchAppFirstTime)
            {
                NSLog(@"Is LaunApp First Time");
                appdelegate.isLaunchAppFirstTime = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                if (self.isEditInvoice)
                {
                    NSLog(@"isEditInvoice");
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    NSLog(@"No isEditInvoice");
                   [self.navigationController popToRootViewControllerAnimated:YES];
                }
                //        [self.navigationController popViewControllerAnimated:YES];
            }
           
            appdelegate.currentCustomerForAddInvoice = nil;
            appdelegate.productsFroAddInvoices = [[NSMutableArray alloc] init];
        }

        
    }
    else
    {
        if (appdelegate.productsFroAddInvoices.count <= 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Insert Products For Invoice" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
       
    }
    
}

- (void)checkCallback
{
    NSLog(@"Check Call Back");
    [self calculateAmout];
}

- (IBAction)onAddCustom:(id)sender
{
    BICustomerViewController *pushToVC = [[BICustomerViewController alloc] initWithNibName:@"BICustomerViewController" bundle:nil];
    [self presentViewController:pushToVC animated:YES completion:nil];
}

- (IBAction)onAddProduct:(id)sender
{
    if (self.bussinessSelected.bussinessName.length > 0 || appdelegate.bussinessForUser.bussinessName.length > 0   ) {
        BIProductsViewController *pushToVC = [[BIProductsViewController alloc] initWithNibName:@"BIProductsViewController" bundle:nil];
        pushToVC.delegate = self;
        
        [self presentViewController:pushToVC animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please select your business first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
  
}

- (IBAction)onOpenMenu:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    appdelegate.currentCustomerForAddInvoice = nil;
    appdelegate.productsFroAddInvoices = [[NSMutableArray alloc] init];
    if (self.isEditInvoice) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCheckedButton:(id)sender
{
    if(checkBoxSelected)
    {
        checkBoxSelected = false;
        if (self.isEditInvoice) {
            self.lblOutStanding.text = self.invoiceEdit.outStanding;
        }
        else
        {
            self.lblOutStanding.text = self.lblTotal.text;
        }
        
    }
    else
    {
        [self onVisibleOfDialogPopup:false];
        checkBoxSelected = true;
        
        NSDate *myDate = [self.datePickerForPopUp date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        NSString *time = [dateFormat stringFromDate:myDate];
        
        self.txtDateMarkPaid.text = time;
    }
    
    [self.btnTotal setSelected:checkBoxSelected];
}

#pragma mark init dialog list data

- (IBAction)onBackViewListData:(id)sender
{
    [self onVisibleOfViewListData:true];
}

- (void)onVisibleOfViewListData:(bool)isShow
{
    NSLog(@"onVisibleOfViewListData: %d",typeOfLstData);
    [self setNewPositionOfViewListData:typeOfLstData];
    [self.viewListData setHidden:isShow];
}

- (void)setNewPositionOfViewListData:(int)type
{
    if(type==0)
    {
        [self shiftHorizontallyView:115.0f];
    }else if(type==1){
        [self shiftHorizontallyView:155.0f];
    }else if(type==2){
        [self shiftHorizontallyView:275.0f];
    }
}

- (void)shiftHorizontallyView:(float)rangeY
{
    CGRect frame = self.viewChilds.bounds;
    frame.origin.y = frame.origin.y + rangeY;
    frame.origin.x = 10.0f;
    //        self.viewChilds.bounds = frame;
    [self.viewChilds setFrame:frame];
}

- (void)initDataOfTableView
{
    arrData = [[NSMutableArray alloc] init];
    if(typeOfLstData==0)
    {
        [self testData];
    }
    else if(typeOfLstData==1)
    {
        [self testData2];
    }
    else if(typeOfLstData==2)
    {
         [self testData3];
    }
    
    totalItem = arrData.count;
    
    [self onReloadData];
}

- (void)setTitleOfInvoices:(NSString*)data
{
    if(typeOfLstData==0)
    {
        [self.btnBusiness setTitle:data forState:UIControlStateNormal];
    }
    else if(typeOfLstData==1)
    {
        [self.btnInvoicesNumber setTitle:data forState:UIControlStateNormal];
    }
    else if(typeOfLstData==2)
    {
        [self.btnPayTypeDialogPopup setTitle:data forState:UIControlStateNormal];
    }
}

- (void)testData
{
    for(int i = 0 ; i < 10; i ++)
    {
        [arrData addObject:[NSString stringWithFormat:@"Business : %d",i]];
    }
}

- (void)testData3
{
    for(int i = 0 ; i < 10; i ++)
    {
        [arrData addObject:[NSString stringWithFormat:@"Payment Type : %d",i]];
    }
}

- (void)testData2
{
    for(int i = 0 ; i < 10; i ++)
    {
        [arrData addObject:[NSString stringWithFormat:@"Invoices Number : %d",i]];
    }
}

#pragma mark init dialog date time

- (IBAction)onBackViewDateTime:(id)sender
{
     [self onVisibleofViewDateTime:true];
}

- (IBAction)onSaveDateTime:(id)sender
{
    NSDate *myDate = [self.dpViewDateTime date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *time = [dateFormat stringFromDate:myDate];
    
//    self.txtDatePaid.text = time;
    if(typeOfLstDatetime == 0)
    {
        [self.btnDateTime setTitle:time forState:UIControlStateNormal];
    }
    else
    {
        [self.btnDateTimeDialogPopup setTitle:time forState:UIControlStateNormal];
    }
    
    [self.viewDateTime setHidden:true];
}

- (void)onVisibleofViewDateTime:(bool)isShow
{
    [self.viewDateTime setHidden:isShow];
}

//#pragma mark - init tableview of dialog list data
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return arrData.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.textColor = [UIColor blackColor];
////        cell.detailTextLabel.textColor = [UIColor whiteColor];
//    }
//    
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 2, [[UIScreen mainScreen] bounds].size.height, 1)];/// change size as you need.
//    
//    separatorLineView.backgroundColor = [UIColor cyanColor];// you can also put image here
//    
//    [cell.contentView addSubview:separatorLineView];
//    cell.textLabel.text = [arrData objectAtIndex:indexPath.row];
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    currSelected = indexPath.row;
//    NSLog(@"didSelectRowAtIndexPath");
//    
//    [self setTitleOfInvoices:[arrData objectAtIndex:indexPath.row]];
//    [self.viewListData setHidden:true];
//}

- (void)onReloadData
{
    [self.tbvViewListData reloadData];
}

#pragma mark init dialog popup

- (IBAction)onBackDialogPopup:(id)sender
{
    [self.txtPaymentType resignFirstResponder];
    [self.txtNoteDescriptionPayment resignFirstResponder];
    
    if (self.isEditInvoice) {
        
        self.totalAmount = self.invoiceEdit.totalOutSanding - [self.amountPaid floatValue];
        NSLog(@"TotalOutStanding: %f", self.totalAmount);
    }
    else
    {
        self.totalAmount = self.total - [self.amountPaid floatValue];
    }
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *localeCurrency = [[NSLocale alloc]
                                initWithLocaleIdentifier:@"en"];
    [formatter setLocale:localeCurrency];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];

    
    NSString* totalOutStanding = [[formatter stringFromNumber:[NSNumber numberWithFloat:self.totalAmount]] substringFromIndex:1];
    
    NSString* subTotalAfterFormat = [[NSString stringWithFormat:@"%@ ", self.bussinessSelected.currencySymbol] stringByAppendingString:totalOutStanding];
    
    self.lblOutStanding.text = subTotalAfterFormat;
    
    [self onVisibleOfDialogPopup:true];
}

- (void)onVisibleOfDialogPopup:(bool)isShow
{
    if (self.isEditInvoice)
    {
        self.txtPaymentType.text = self.invoiceEdit.outStanding;
        NSLog(@"AMount paid: %f", self.invoiceEdit.totalOutSanding);
        self.amountPaid = [NSString stringWithFormat:@"%f",self.invoiceEdit.totalOutSanding];
    }
    else
    {
        self.txtPaymentType.text = self.lblTotal.text;
        self.amountPaid = [NSString stringWithFormat:@"%f",self.total];
    }
    
    
    
    [self.viewPopup setHidden:isShow];
    self.viewMarkPaid.frame=CGRectMake(10, -104, 300, 250);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewMarkPaid.frame=CGRectMake(10, 104, 300, 255);
    [UIView commitAnimations];
}

- (void)checkStateOfButtonPopup:(int)type
{
    [self checkAllStateUnSelectedOfButtonPopup];
    
    switch (type)
    {
        case 1:
            [self.btnCashPopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_active.png"] forState:UIControlStateNormal];
            break;
            
        case 3:
            [self.btnCardPopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_active.png"] forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.btnChequePopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_active.png"] forState:UIControlStateNormal];
            break;
            
        case 4:
            [self.btnOtherPopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_active.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (IBAction)onShowViewDateTimeFromDialogPopup:(id)sender
{
    typeOfLstDatetime = 1;
    [self onVisibleofViewDateTime:false];
    [self.viewDateForPopUp setHidden:NO];
    

}

- (IBAction)onCheckCashPopup:(id)sender
{
    isCheckTypeInPopup = 1;
    
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"cash button (select).png"] forState:UIControlStateNormal];
    
    cardBool=FALSE;
    chequeBool=FALSE;
    otherBool=FALSE;
    
    
    [self.btnCardPopup setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnChequePopup setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOtherPopup setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    
//    self.txtPaymentType.text = @"Cash";
//    [self checkStateOfButtonPopup:isCheckTypeInPopup];
}

- (IBAction)onCheckChequePopup:(id)sender
{
    isCheckTypeInPopup = 2;
//    [self checkStateOfButtonPopup:isCheckTypeInPopup];
    
    UIButton *btn1 = sender;
    
    chequeBool =TRUE ;
    [btn1 setImage:[UIImage imageNamed:@"cheque button ( select).png"] forState:UIControlStateNormal];
    
    
    [self.btnCardPopup setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCashPopup setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnOtherPopup setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    cardBool=FALSE;
    cashBool=FALSE;
    otherBool=FALSE;
    
//    self.txtPaymentType.text = @"Cheque";

}

- (IBAction)onCheckCardPopup:(id)sender
{
    isCheckTypeInPopup = 3;
//    [self checkStateOfButtonPopup:isCheckTypeInPopup];
    
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"card button (select).png"] forState:UIControlStateNormal];
    cardBool = TRUE;
    
    [self.btnCashPopup setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnChequePopup setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOtherPopup setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    cashBool=FALSE;
    chequeBool=FALSE;
    otherBool=FALSE;
    
//    self.txtPaymentType.text = @"Card";

}

- (IBAction)onCheckOtherPopup:(id)sender
{
    isCheckTypeInPopup = 4;
//    [self checkStateOfButtonPopup:isCheckTypeInPopup];
    
    UIButton *btn1 = sender;
    
    otherBool =TRUE ;
    
    [btn1 setImage:[UIImage imageNamed:@"other button (select).png"] forState:UIControlStateNormal];
    
    [self.btnCardPopup setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnChequePopup setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnCashPopup setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    cardBool=FALSE;
    chequeBool=FALSE;
    cashBool=FALSE;
    
//    self.txtPaymentType.text = @"Other";

}

- (IBAction)onShowViewLstDataFromDialogPopup:(id)sender
{
    typeOfLstData = 2;
    [self initDataOfTableView];
    [self onVisibleOfViewListData:false];
}


- (void)checkAllStateUnSelectedOfButtonPopup
{
}

#pragma mark animation popup

- (void)onAnimationOfPopup:(UIView*)view withX:(int)x withY:(int)y withW:(int)w withH:(int)h toH:(int)mH
{
    view.frame=CGRectMake(x, y, w, h);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    view.frame=CGRectMake(x, y, w, mH);
    [UIView commitAnimations];
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtNoteDesc resignFirstResponder];
    [self.tbvViewListData resignFirstResponder];
    [self.txtInvoiceNumber resignFirstResponder];
    [self.txtNoteDesc resignFirstResponder];   
    [self.txtNumberOfUnit resignFirstResponder];
    [self.txtProductName resignFirstResponder];
    [self.txtInvoiceNumber resignFirstResponder];
    [self.txtPaymentType resignFirstResponder];
    [self.txtNoteDescriptionPayment resignFirstResponder];
    
     [self.scrollView setContentOffset:CGPointMake(0, -20)];
}

- (IBAction)selectDateFromPopUp:(id)sender
{
    if ([sender tag] == 1)
    {
        NSDate *myDate = [self.datePickerForMain date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        NSString *time = [dateFormat stringFromDate:myDate];
        
        self.txtDateForMain.text = time;
    }
    else
    {
        NSDate *myDate = [self.datePickerForPopUp date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        NSString *time = [dateFormat stringFromDate:myDate];
        
        self.txtDateMarkPaid.text = time;
    }

}

- (IBAction)closeDateForPopUp:(id)sender
{
    self.viewDateForPopUp.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableViewPaymentTerms)
    {
        return  self.paymentTerms.count;
    }
    else if (tableView == self.tableViewBusiness)
    {
        return appdelegate.businessForUser.count;
    }
    return appdelegate.productsFroAddInvoices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewPaymentTerms) {
        static NSString *CellIdentifier = @"newFriendCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = [self.paymentTerms objectAtIndex:indexPath.row];
        
        return cell;

    }
    else if (tableView == self.tableViewBusiness)
    {
        static NSString *CellIdentifier = @"newFriendCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [[appdelegate.businessForUser objectAtIndex:indexPath.row] bussinessName];
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"BICustomProductTableViewCell";
    
    BICustomProductTableViewCell *customCell = (BICustomProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (customCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BICustomProductTableViewCell" owner:self options:nil];
        customCell = [nib objectAtIndex:0];
    }
    
    BIProduct* product = [appdelegate.productsFroAddInvoices objectAtIndex:indexPath.row];
    customCell.lblNameProduct.text = product.productName;
    
    NSLog(@"NUmber of unit:%@", product.productUnitPrice);
    
    [customCell.quantity setTitle:[NSString stringWithFormat:@"%.1f",product.numberOfUnit] forState:UIControlStateNormal] ;
    
    NSString* amountAfterFormat = [[NSString stringWithFormat:@"%@ ", self.bussinessSelected.currencySymbol] stringByAppendingString:product.productUnitPrice];
    
    customCell.lblPrice.text = amountAfterFormat;
    
    [customCell.btnDeleteProduct addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [customCell.btnDeleteProduct setTag:indexPath.row];
    
    return customCell;
}

-(IBAction)delete:(id)sender
{
    
    NSLog(@"Cell Checked");
    //    [self.itemTableView beginUpdates];
    UIButton* button = (UIButton*)sender;
    [button setBackgroundImage:[UIImage imageNamed:@"btn_check_ON.png"] forState:UIControlStateNormal];
    
    CGPoint center = button.center;
    CGPoint rootViewPoint = [button.superview convertPoint:center toView:self.tableView];
    
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    
    [appdelegate.productsFroAddInvoices removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self calculateAmout];
    
    [self updateFrameTableView];

    
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return YES if you want the specified item to be editable.
//    if (tableView == self.tableViewPaymentTerms) {
//        return NO;
//    }
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//        [appdelegate.productsFroAddInvoices removeObjectAtIndex:indexPath.row];
//        
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
//                                  withRowAnimation:UITableViewRowAnimationFade];
//        [self calculateAmout];
//        
//        [self updateFrameTableView];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewPaymentTerms) {
        self.txtPaymentTerm.text = [self.paymentTerms objectAtIndex:indexPath.row];
        isShowViewTablePayments = !isShowViewTablePayments;
        self.viewForTablePayments.hidden = YES;
    }
    else if (tableView== self.tableViewBusiness)
    {
        self.txtBussiness.text = [[appdelegate.businessForUser objectAtIndex:indexPath.row] bussinessName];
        self.bussinessSelected = [appdelegate.businessForUser objectAtIndex:indexPath.row];
        appdelegate.bussinessForUser = [appdelegate.businessForUser objectAtIndex:indexPath.row];
        self.viewBusiness.hidden = YES;
    }
    else
    {
        self.indexPathSelected = indexPath;
        
        BIProduct* product = [appdelegate.productsFroAddInvoices objectAtIndex:indexPath.row];
        self.txtProductName.text = product.productName;
        self.txtNumberOfUnit.text = [NSString stringWithFormat:@"%.1f", product.numberOfUnit];
        
        [self.viewPopUpAddNumberUnit setHidden:NO];
        self.viewPopUpAddUnitMain.frame=CGRectMake(10, -110, 300, 107);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewPopUpAddUnitMain.frame=CGRectMake(10, 110, 300, 107);
        [UIView commitAnimations];
    }
  
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 23)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 30)];
    }
    
    if (textField.tag == 20)
    {
        if ([self.amountPaid rangeOfString:@","].length != 0) {
            self.amountPaid = [self.amountPaid stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
//        if ([self.amountPaid containsString:@","] )
//        {
//            self.amountPaid = [self.amountPaid stringByReplacingOccurrencesOfString:@"," withString:@""];
//        }
        
        if (textField.text.length > 0)
        {
            self.txtPaymentType.text = [NSString stringWithFormat:@"%.2f", [self.amountPaid floatValue]];
        }
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 20)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSLocale *localeCurrency = [[NSLocale alloc]
                                    initWithLocaleIdentifier:@"en"];
        [formatter setLocale:localeCurrency];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [formatter setGroupingSeparator:groupingSeparator];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:YES];
        
        if ([textField.text rangeOfString:@","].length != 0) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
//        if ([textField.text containsString:@","] ) {
//            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
//        }
        
        self.amountPaid = textField.text;
        
        NSString* amt = [[formatter stringFromNumber:[NSNumber numberWithFloat:[textField.text floatValue]]] substringFromIndex:1];
        
        NSLog(@"Currency symbol: %@", appdelegate.bussinessForUser.currencySymbol);
        NSString* amountAfterFormat = [[NSString stringWithFormat:@"%@ ", appdelegate.bussinessForUser.currencySymbol] stringByAppendingString:amt];
        
        if (textField.text.length) {
            self.txtPaymentType.text = amountAfterFormat;
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField == self.txtNoteDesc)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 12)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }

    return YES;
}

- (void)generatPdfForInvoice
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"en"];
    [dateFormatter setLocale:locale];
    
    
    NSDate *date  = [dateFormatter dateFromString:self.txtDateForMain.text];
    
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString* dateStr = [dateFormatter stringFromDate:date];

    NSLog(@"Date: %@", dateStr);
    
    NSString* templateInvoice = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd\"><html><head><meta http-equiv='Content-Type'content='charset=utf-8' /><style type='text/css'>* {font-family: 'DejaVu Sans'; font-size: 16px; } table{ width: 810px; } table,th,td{ border: none; } table.tbheader td{ width: 400px; } table.tbheader span{ font-size: 20px; } table.tbcontent th{  text-align: left;  background-color:#000000 ; color:#FFFFFF;  margin-right: 0;  } table.tbfooter td{ width: 400px; } </style> <title></title> </head> <body> <div class='content'> <div class='header'> <table class='tbheader'> <tr> <td > <span style='font-family: Avqest;font-weight: bold;font-size: 54px; margin-top: 40px;font-style: italic;'>%@</span></td> <td> <span style='font-family: Avqest;font-weight: bold;'>%@</span><br/> <span>%@</span><br/> <span>%@</span><br/> <span>%@</span> </td> </tr> <tr > <td style='padding-top: 40px'> <span style='display:block;width:350px;border-bottom: 1px solid darkgrey;'></span></td> <td style='padding-top: 40px'><span style='display:block;width:250px;border-bottom: 1px solid darkgrey;'></span></td> </tr> <tr> <td><span>%@</span><br/><span>%@</span><br/><span>%@</span><br/><span>%@</span>  <br/><br/><span>VAT: %@</span> </td> <td><span style='font-size: 30px;font-family: Avqest;font-weight: bold;'>INVOICE %@</span><br/> <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>%@</span><br/> <span style='font-weight: bold;color: darkgrey'>Payment Terms: %@</span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span> </td>   </tr>    </table>    </div>    <div class='content'>    <table class='tbcontent'>    <thead>    <tr style='background-color:#000000'>    <th>    Quantity    </th>    <th>    Details    </th>   <th>    Descriptions    </th>  <th>    Unit Price (%@)    </th>    <th>    Tax (%%)    </th>  </tr>    </thead>    <tbody>",  self.txtBussiness.text, self.txtBussiness.text,self.bussinessSelected.bussinessAddress,appdelegate.bussinessForUser.bussinessCity, appdelegate.bussinessForUser.bussinessPostCode, appdelegate.currentCustomerForAddInvoice.customerBussinessName, appdelegate.currentCustomerForAddInvoice.customerAddress, appdelegate.currentCustomerForAddInvoice.customerCity, appdelegate.currentCustomerForAddInvoice.customerPostCode,appdelegate.bussinessForUser.bussinessVat, self.txtInvoiceNumber.text, dateStr, self.txtPaymentTerm.text, self.bussinessSelected.currencySymbol];
    
    NSLog(@"Temp: %@", templateInvoice);
    
    NSString* tbody = [[NSString alloc] init];
    NSLog(@"Product: %lu", (unsigned long)appdelegate.productsFroAddInvoices.count);
    
    for (int  i = 0; i < appdelegate.productsFroAddInvoices.count; i++)
    {
        float quantity = [[appdelegate.productsFroAddInvoices objectAtIndex:i] numberOfUnit];
        NSString* productName = [[appdelegate.productsFroAddInvoices objectAtIndex:i] productName];
        NSString* price = [[appdelegate.productsFroAddInvoices objectAtIndex:i] productUnitPrice];
        NSString* subTotal = [NSString stringWithFormat:@"%.2f", [price floatValue] * quantity];
        NSString* tax = [[appdelegate.productsFroAddInvoices objectAtIndex:i] productTaxRate];
        
        NSString* stringForRow = [NSString stringWithFormat:@" <tr>    <td>    <span>%.1f</span>    </td>    <td>%@</td> <td>%@</td>       <td>%@</td>        <td>%@</td>       </tr>", quantity, productName,self.txtNoteDesc.text, price, tax];
        
        NSLog(@"String For ROw: %@", stringForRow);
        tbody = [tbody stringByAppendingString:stringForRow];
    }
    
    NSString* rowTotal = [NSString stringWithFormat:@"  <tr>        <td>        </td>        <td></td>        <td></td>        <td><span style='font-weight: bold'>SubTotal<span></span></td>    <td><span style='font-weight: bold'>%@<span></span> </td>    </tr>  <tr>        <td>        </td>        <td></td>        <td></td>        <td><span style='font-weight: bold'>Taxes<span></span></td>    <td><span style='font-weight: bold'>%@<span></span> </td>    </tr>  <tr>        <td>        </td>        <td></td>        <td></td>        <td><span style='font-weight: bold'>Total<span></span></td>    <td><span style='font-weight: bold'>%@<span></span> </td>    </tr>    <tr>        <td style='padding-top: 40px' colspan='2'><span style='display:block;width:350px;border-bottom: 1px solid darkgrey;'></td>        <td style='padding-top: 40px' colspan='2'><span style='display:block;width:350px;border-bottom: 1px solid darkgrey;'></td>        </tr>",self.lblSubTotal.text, self.lblTaxes.text, self.lblTotal.text];
    
    NSLog(@"Row TOtal: %@", rowTotal);
    
    tbody = [tbody stringByAppendingString:rowTotal];
    
    NSString* paymentDetails = [NSString stringWithFormat:@"   </tbody>        </table>        <table class='tbfooter'>        <tr>        <td><span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Bank Details:</span><br/><br/></td>        </tr>      <tr>                                <td><span></span><br>                                <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Bank/Sort Code: </span>%@<br>                                <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Account Number: </span>%@<br>                                <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Bank Name: </span>%@<br>                                </td>                                <td><span style='font-size: 20px;font-family: Avqest;font-weight: bold;'></td>                                  </tr>        </table>        </div>        <div class='footer'>       </div>       </div>        </body>        </html>", appdelegate.bussinessForUser.bankSortCode, appdelegate.bussinessForUser.bankAccountNumber, appdelegate.bussinessForUser.bankName];
     
    
    tbody = [tbody stringByAppendingString:paymentDetails];
    
    templateInvoice = [templateInvoice stringByAppendingString:tbody];
    
    self.html = templateInvoice;
    
//    [self createPDFfromHTML:templateInvoice withName:[NSString stringWithFormat:@"Invoice %@", self.txtInvoiceNumber.text]];

}


- (void)createPDFfromHTML:(NSString *)data withName:(NSString *)name
{
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",name];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"FIle Path: %@", filePath);
    self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:data pathForPDF:filePath delegate:self pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5)];
    
}

#pragma mark NDHTMLtoPDFDelegate

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
    NSLog(@"%@",result);
    currFile = htmlToPDF.PDFpath;
    
    if([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        NSString *subject;
        
        subject = [NSString stringWithFormat:@"You have a new Invoice %@ from %@!", self.txtInvoiceNumber.text, appdelegate.bussinessForUser.bussinessName] ;
        
        [mailer setSubject:subject];
        [mailer setTitle:@"Invite"];
        
        NSData *myData = [NSData dataWithContentsOfFile:currFile];
        
        NSString* invoiceNumber = self.txtInvoiceNumber.text;
        NSString* total = self.lblTotal.text;
        
        NSString* emailBody = [[NSString alloc] init];
        
        emailBody = [emailBody stringByAppendingString:[NSString stringWithFormat:@"Hi %@,\nPlease find attached your latest invoice for (%@) for %@ ", self.btnAddCustom.titleLabel.text, invoiceNumber, total]];
        
        NSString* emailToRecipents = appdelegate.currentCustomerForAddInvoice.customerEmail;
        NSLog(@"Email To recipents: %@", emailToRecipents);
        NSArray *toRecipents = [NSArray arrayWithObject:emailToRecipents];
        
        
        [mailer setMessageBody:emailBody isHTML:NO];
        [mailer setToRecipients:toRecipents];
        
        NSArray *listItems = [currFile componentsSeparatedByString:@"Documents/"];
        [mailer addAttachmentData:myData mimeType:@"text/pdf" fileName:[listItems objectAtIndex:1]];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
//        if (self.isEditInvoice) {
//            [self presentViewController:mailer animated:YES completion:nil];
//        }
//        else
//        {
//            [self presentViewController:mailer animated:YES completion:nil];
//        }
        

        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Failure"
                              message:@"Your device doesn't support the composer sheet"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

    
//    mailComposer = [[MFMailComposeViewController alloc]init];
//    mailComposer.mailComposeDelegate = self;
//    [mailComposer setSubject:@"Export data"];
//    [mailComposer setMessageBody:@"" isHTML:NO];
//    
//    [self presentModalViewController:mailComposer animated:YES];
//    
//    NSData *myData = [NSData dataWithContentsOfFile:currFile];
//    
//    NSArray *listItems = [currFile componentsSeparatedByString:@"Documents/"];
//    [mailComposer addAttachmentData:myData mimeType:@"text/pdf" fileName:[listItems objectAtIndex:1]];
}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
    NSLog(@"%@",result);
    
    NSString *title = [NSString stringWithFormat:@"Data exported error"];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        NSLog(@"DIALOG PDF COMPLETE");
        
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"The cancel button was clicked from alertView");
            
        }
    }
    else
    {
        NSLog(@"cancel");
      
        if (self.isEditInvoice)
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else [self dismissViewControllerAnimated:YES completion:nil];
        
        [self saveInvoice];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            /*	NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");*/
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deleted" message:@"Your mail has been Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Mail saved: you saved the email message in the Drafts folder");
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Saved" message:@"Your Conversation has been saved to Draft" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"The export file has been successfully sent to the recipient." delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        case MFMailComposeResultFailed:
            
        {
            NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Your valuable FeedBack has been Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    NSLog(@"Disconnect EMAIL");
}



//#pragma mark UIGestureRecognizerDelegate methods
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isDescendantOfView:self.tbvViewListData]) {
//        
//        // Don't let selections of auto-complete entries fire the
//        // gesture recognizer
//        return NO;
//    }
//    
//    return YES;
//}
@end
