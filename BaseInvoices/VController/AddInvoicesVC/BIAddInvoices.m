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
#import "SBJson.h"

#import "BICustomProductTableViewCell.h"
#import "BIInvoice.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

#define ACCEPTABLE_CHARECTERS @".0123456789"

@interface BIAddInvoices ()<CustomerViewControllerDelegate>

@end

bool cashBool,otherBool,cardBool,chequeBool, isCurrentDay, isShowViewBusiness, isShowViewDateTimeForMain, isShowViewTablePayments;

BIAppDelegate* appdelegate;

@implementation BIAddInvoices

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _isAutoCreateIncome = YES;
    [self.btnAutoCreateIncome setSelected:YES];
    
    if (self.isEditInvoice)
    {
        NSLog(@"View DId load");
        [self loadInvoiceEdit];
    }
    else
    {
        [[ServiceRequest getShareInstance] serviceRequestActionName:@"/invoice-template" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = [httpResponse statusCode];
            
            if (statusCode == 200)
            {
                NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                                encoding:NSUTF8StringEncoding];
                
                NSLog(@"RESPIONSE GET ALL Invoice Template: %@", responeString);
                NSDictionary* dataDict = [[NSDictionary alloc] init];
                SBJsonParser *json = [SBJsonParser new];
                dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
                
                if ([dataDict valueForKey:@"data"] != nil)
                {
                    appdelegate.invoicesTemplate = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary* invoiceTemplateDict in [dataDict valueForKey:@"data"])
                    {
                        InvoiceTemplateRepository* invoiceTemplateObject = [[InvoiceTemplateRepository alloc] initWithDict:invoiceTemplateDict];
                        BIBussiness* business = [[BIBussiness alloc] initWithDict:[invoiceTemplateDict valueForKey:@"business"]];
                        
                        [invoiceTemplateObject setBusiness:business];
                        [appdelegate.invoicesTemplate addObject:invoiceTemplateObject];
                        
                    }
                    
                    if ([BIAppDelegate shareAppdelegate].invoicesTemplate.count > 0)
                    {
                        InvoiceTemplateRepository* invoiceTemplateObject = [[BIAppDelegate shareAppdelegate].invoicesTemplate objectAtIndex:0];
                        _txtBussiness.text = invoiceTemplateObject.invoiceTemplateName;
                        _invoiceTemplateSelected = invoiceTemplateObject;
                    }
                    
                    [self.tableViewBusiness reloadData];
                    
                }
                
            }
        }];
        
        [self getCustomers];
    }
    
    self.paymentTerms = [[NSMutableArray alloc] initWithObjects:@"Due upon receipt", @"Due within 7 days", @"Due within 14 days",@"Due within 21 Days", @"Due within 30 Days", @"Paid", nil];
}

- (void)getCustomers
{
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/customer" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL CUSTOMER: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                appdelegate.customerForUser = [[NSMutableArray alloc] init];
                
                for (NSDictionary* customerDic in [dataDict valueForKey:@"data"])
                {
                    BICustomer* customerObject = [[BICustomer alloc] initWithDict:customerDic];
                    [appdelegate.customerForUser addObject:customerObject];
                }
                
                if ([BIAppDelegate shareAppdelegate].customerForUser.count > 0)
                {
                    BICustomer* customerObject = [[BIAppDelegate shareAppdelegate].customerForUser objectAtIndex:0];
                    _customerSelected = customerObject;
                    [self.btnAddCustom setTitle:customerObject.customerBussinessName forState:UIControlStateNormal];
                }
                
            }
        }
        
    }];
    
}

- (void)fecthDataWithInvoiceTemplate:(InvoiceTemplateRepository*)invoiceTemplate
{
    _txtBussiness.text = invoiceTemplate.invoiceTemplateName;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initScreen];
    
    
    //    [self calculateAmout];
    
    //    [self.tableView setEditing:YES animated:YES];
    
    [self updateFrameTableView];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIButton Sender

- (IBAction)btnViewPdf_Clicked:(id)sender
{
    //Create New Icon
    
}

- (IBAction)btnSendToClient_Clicked:(id)sender
{
    
}

- (IBAction)onShowViewTablePaymentsTerm:(id)sender
{
    isShowViewTablePayments = !isShowViewTablePayments;
    
    if (isShowViewTablePayments)
    {
         self.viewForTablePayments.hidden = NO;
    }
    else
        self.viewForTablePayments.hidden = YES;
   
}

- (IBAction)onSaveAndSendEmail:(id)sender
{
    self.viewForPaymentTerms.hidden = YES;
    
    [self saveInvoice];
//    [self generatPdfForInvoice];
//    self.viewPdfPreview.hidden = NO;
//    [self.webViewPdf loadHTMLString:self.html baseURL:nil];

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
    BIProduct* product = [_productsAdded objectAtIndex:self.indexPathSelected.row];
    [product setQuantityValue:[self.txtNumberOfUnit.text intValue]];
    
    [self calculateAmout];
    
    [self.tableView reloadData];
    [self.txtNumberOfUnit resignFirstResponder];
    
    self.viewPopUpAddNumberUnit.hidden = YES;
}


- (void)calculateAmout
{
    self.subTotal = 0;
    self.total = 0;
    self.taxes = 0;
    self.totalAmount = 0;
    
    //Calculate Subtotal, Taxes, Total and outstanding
    for (BIProduct* product in _productsAdded)
    {
        NSString* priceUnit = [NSString stringWithFormat:@"%@", product.productUnitPrice];
        
        if ([priceUnit rangeOfString:@","].length != 0)
        {
            priceUnit = [priceUnit stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
        
        self.subTotal = self.subTotal + [priceUnit floatValue] * product.quantityValue;
        
        NSLog(@"Unit: %f", [priceUnit floatValue]);
     
        self.taxes = self.taxes + [priceUnit floatValue] * product.quantityValue * [product.productTaxRate floatValue] / 100;
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
    
    NSString* subTotalAfterFormat = [[NSString stringWithFormat:@"£"] stringByAppendingString:subTotal];
    
    NSString* taxesAfterFormat = [[NSString stringWithFormat:@"£"] stringByAppendingString:taxes];
    
    NSString* totalAfterFormat = [[NSString stringWithFormat:@"£"] stringByAppendingString:total];
    
    self.lblSubTotal.text = subTotalAfterFormat;
    self.lblTaxes.text = taxesAfterFormat;
    self.lblTotal.text = totalAfterFormat;
    self.amountPaid = total;
    
    if (checkBoxSelected)
    {
        self.totalAmount = self.total - [self.amountPaid floatValue];
        
        NSString* totalOutStanding = [[formatter stringFromNumber:[NSNumber numberWithFloat:self.totalAmount]] substringFromIndex:1];
        
        NSString* subTotalAfterFormat = [[NSString stringWithFormat:@"£"] stringByAppendingString:totalOutStanding];
        
        self.lblOutStanding.text = subTotalAfterFormat;
    }
    else
    {
        self.lblOutStanding.text = self.lblTotal.text;
        self.totalAmount = self.total;
    }
    
    if (_productsAdded.count > 0)
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
    
    [self.btnAutoCreateIncome setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnAutoCreateIncome setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnAutoCreateIncome setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
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
    self.tableView.frame = CGRectMake(8, self.lblProducts.frame.origin.y + 26, self.tableView.frame.size.width, _productsAdded.count * 44);
    
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
    self.txtBussiness.text = self.invoiceEdit.invoiceTemplate.invoiceTemplateName;
    self.txtInvoiceNumber.text = self.invoiceEdit.invoiceName;
    [self.btnAddCustom setTitle:self.invoiceEdit.customer.customerBussinessName forState:UIControlStateNormal];
    self.txtDateForMain.text = self.invoiceEdit.dateInvoice;
    self.txtNoteDesc.text = self.invoiceEdit.noteInvoice;

//    self.txtPaymentType.text = self.invoiceEdit.outStanding;
//    self.totalAmount = self.invoiceEdit.totalOutSanding;
    
    appdelegate.bussinessForUser = self.invoiceEdit.bussiness;
    _customerSelected = self.invoiceEdit.customer;
    checkBoxSelected = self.invoiceEdit.isPaided;
    
    [self.btnTotal setSelected:self.invoiceEdit.isPaided];
    
    _productsAdded= [[NSMutableArray alloc] init];
    _productsAdded = self.invoiceEdit.products;
    
    NSLog(@"Product Add: %lu", (unsigned long)_productsAdded.count);
    
    self.bussinessSelected = self.invoiceEdit.bussiness;
    
    if (_customerSelected.customerBussinessName.length > 0) {
        [self.btnAddCustom setTitle:_customerSelected.customerBussinessName forState:UIControlStateNormal];
    }
    
    if (checkBoxSelected)
    {
//        self.lblOutStanding.text = self.invoiceEdit.outStanding;
    }
    else
    {
//        self.lblOutStanding.text = self.lblTotal.text;
    }
    
    if (_invoiceEdit.products.count > 0)
    {
        self.tableView.hidden = NO;
    }
    else
        self.tableView.hidden = YES;
    
    
    [self calculateAmout];
}

- (IBAction)onShowViewLstBusiness:(id)sender
{
    isShowViewBusiness = !isShowViewBusiness;
    
    if (isShowViewBusiness)
    {
        [self.viewBusiness setHidden:NO];
        
        self.viewBusiness.frame= CGRectMake(20, 45, 292, 0);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewBusiness.frame= CGRectMake(20, 45, 292, 120);
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
    
    [self onVisibleOfViewListData:false];
}

- (IBAction)onShowViewDateTime:(id)sender
{
    isShowViewDateTimeForMain = !isShowViewDateTimeForMain;
    
    if (isShowViewDateTimeForMain)
    {
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
    if (_productsAdded.count > 0 && self.txtInvoiceNumber.text.length > 0 && self.btnAddCustom.titleLabel.text.length > 0)
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}

- (IBAction)onSave:(id)sender
{
    NSLog(@"Save");
    self.viewForPaymentTerms.hidden = NO;
    
    self.viewForPaymentTermsChild.frame=CGRectMake(10, -190, 300, 218);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewForPaymentTermsChild.frame=CGRectMake(10, 190, 300, 218);
    [UIView commitAnimations];

   
}


- (void)saveInvoice
{
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    if (_productsAdded.count > 0 && self.txtInvoiceNumber.text.length > 0 && self.txtDateForMain.text.length > 0  && self.btnAddCustom.titleLabel.text.length > 0)
    {
        //Save invoice into Server
        
        BIInvoice* invoice = [[BIInvoice alloc] init];
        invoice.invoiceName = self.txtInvoiceNumber.text;
        invoice.invoiceTemplate = _invoiceTemplateSelected;
        invoice.dateInvoice = self.txtDateForMain.text;
        invoice.customer = _customerSelected;
        invoice.noteInvoice = self.txtNoteDesc.text;
        invoice.products = [[NSMutableArray alloc] init];
        invoice.products = _productsAdded;
        invoice.subInvoice = [NSString stringWithFormat:@"%f",_subTotal];
        invoice.totalInvoices = [NSString stringWithFormat:@"%f",_total];
        invoice.taxesInvoice = [NSString stringWithFormat:@"%f",_taxes];
        invoice.isPaided = checkBoxSelected;
        invoice.totalOutSanding = self.totalAmount;
        invoice.due_selection = self.txtPaymentTerm.text;
        [invoice setIsAutoCreateIncome:_isAutoCreateIncome];
        
        NSDictionary* data = [invoice getDataToSync];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:data];
    }
    else
    {
        if (_productsAdded.count <= 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please Insert Products For Invoice" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
        
        [appdelegate.activityIndicatorView hide:YES];
       
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
    pushToVC.delegate = self;
    [self presentViewController:pushToVC animated:YES completion:nil];
}

- (IBAction)onAddProduct:(id)sender
{
    BIProductsViewController *pushToVC = [[BIProductsViewController alloc] initWithNibName:@"BIProductsViewController" bundle:nil];
    pushToVC.delegate = self;
    
    [self presentViewController:pushToVC animated:YES completion:nil];
}

- (IBAction)onOpenMenu:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    appdelegate.currentCustomerForAddInvoice = nil;
    _productsAdded = [[NSMutableArray alloc] init];
    
    if (_isFromWelcome)
    {
        BIDashBoard* dashboardView = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
        
        BLLeftSideVC *leftSideVC = [[BLLeftSideVC alloc] initWithNibName:@"BLLeftSideVC" bundle:nil];
        
        leftSideVC.delegate = dashboardView;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dashboardView];
        
        MMDrawerController* drawerController = [[MMDrawerController alloc] initWithCenterViewController:nav leftDrawerViewController:leftSideVC];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [self.navigationController pushViewController:drawerController animated:YES];
    }
    else
    {
        if (self.isEditInvoice)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else [self.navigationController popViewControllerAnimated:YES];
    }
    
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
  
    [self onVisibleOfViewListData:false];
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
    
//    [self.scrollView setContentOffset:CGPointMake(0, 0)];
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

#pragma mark - UITableView Delegate

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
        return appdelegate.invoicesTemplate.count;
    }
    return _productsAdded.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewPaymentTerms)
    {
        static NSString *CellIdentifier = @"newFriendCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }

        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        cell.textLabel.text = [self.paymentTerms objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    else if (tableView == self.tableViewBusiness)
    {
        static NSString *CellIdentifier = @"newFriendCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        cell.textLabel.text = [[appdelegate.invoicesTemplate objectAtIndex:indexPath.row] invoiceTemplateName];
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"BICustomProductTableViewCell";
    
    BICustomProductTableViewCell *customCell = (BICustomProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (customCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BICustomProductTableViewCell" owner:self options:nil];
        customCell = [nib objectAtIndex:0];
    }
    
    BIProduct* product = [_productsAdded objectAtIndex:indexPath.row];
    customCell.lblNameProduct.text = product.productName;
    
    NSLog(@"NUmber of unit:%@", product.productUnitPrice);
    
    [customCell.txtQuantity setText:[NSString stringWithFormat:@"%d", product.quantityValue]];
    
    CGFloat amount = [product.productUnitPrice floatValue]* product.quantityValue;
    NSString* amountAfterFormat = @"";
    if (fmodf(amount, 1.0) == 0.0)
    {
        amountAfterFormat = [[NSString stringWithFormat:@"£ "] stringByAppendingString:[NSString stringWithFormat:@"%d", (int)amount]];
    }
    else
    {
        amountAfterFormat = [[NSString stringWithFormat:@"£ "] stringByAppendingString:[NSString stringWithFormat:@"%.2f", amount]];
    }
    
    customCell.lblPrice.text = amountAfterFormat;
    
    [customCell.btnDeleteProduct addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [customCell.btnDeleteProduct setTag:indexPath.row];
    
    if(indexPath.row % 2 == 0)
    {
        [customCell setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:247.0/255.0f blue:231.0/255.0f alpha:1.0]];
    }
    else
    {
        [customCell setBackgroundColor:[UIColor whiteColor]];
    }

    
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
    
    [_productsAdded removeObjectAtIndex:indexPath.row];
    
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
    if (tableView == self.tableViewPaymentTerms)
    {
        self.txtPaymentTerm.text = [self.paymentTerms objectAtIndex:indexPath.row];
        isShowViewTablePayments = !isShowViewTablePayments;
        self.viewForTablePayments.hidden = YES;
    }
    else if (tableView== self.tableViewBusiness)
    {
        InvoiceTemplateRepository* invoiceTemplateObject = [[BIAppDelegate shareAppdelegate].invoicesTemplate objectAtIndex:indexPath.row];
        _invoiceTemplateSelected = invoiceTemplateObject;
        [self fecthDataWithInvoiceTemplate:invoiceTemplateObject];

        self.viewBusiness.hidden = YES;
    }
    else
    {
        self.indexPathSelected = indexPath;
        
        BIProduct* product = [_productsAdded objectAtIndex:indexPath.row];
        self.txtProductName.text = product.productName;
        self.txtNumberOfUnit.text = [NSString stringWithFormat:@"%d", product.quantityValue];
        
        [self.viewPopUpAddNumberUnit setHidden:NO];
        self.viewPopUpAddUnitMain.frame=CGRectMake(10, -110, 300, 130);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewPopUpAddUnitMain.frame=CGRectMake(10, 110, 300, 130);
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
        NSString* amountAfterFormat = [[NSString stringWithFormat:@"%@ ", @"£"] stringByAppendingString:amt];
        
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
    
    NSString* templateInvoice = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd\"><html><head><meta http-equiv='Content-Type'content='charset=utf-8' /><style type='text/css'>* {font-family: 'DejaVu Sans'; font-size: 16px; } table{ width: 810px; } table,th,td{ border: none; } table.tbheader td{ width: 400px; } table.tbheader span{ font-size: 20px; } table.tbcontent th{  text-align: left;  background-color:#000000 ; color:#FFFFFF;  margin-right: 0;  } table.tbfooter td{ width: 400px; } </style> <title></title> </head> <body> <div class='content'> <div class='header'> <table class='tbheader'> <tr> <td > <span style='font-family: Avqest;font-weight: bold;font-size: 54px; margin-top: 40px;font-style: italic;'>%@</span></td> <td> <span style='font-family: Avqest;font-weight: bold;'>%@</span><br/> <span>%@</span><br/> <span>%@</span><br/> <span>%@</span> </td> </tr> <tr > <td style='padding-top: 40px'> <span style='display:block;width:350px;border-bottom: 1px solid darkgrey;'></span></td> <td style='padding-top: 40px'><span style='display:block;width:250px;border-bottom: 1px solid darkgrey;'></span></td> </tr> <tr> <td><span>%@</span><br/><span>%@</span><br/><span>%@</span><br/><span>%@</span>  <br/><br/><span>VAT: %@</span> </td> <td><span style='font-size: 30px;font-family: Avqest;font-weight: bold;'>INVOICE %@</span><br/> <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>%@</span><br/> <span style='font-weight: bold;color: darkgrey'>Payment Terms: %@</span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span>  <br/>  <span style='font-weight: bold;color: darkgrey'></span> </td>   </tr>    </table>    </div>    <div class='content'>    <table class='tbcontent'>    <thead>    <tr style='background-color:#000000'>    <th>    Quantity    </th>    <th>    Details    </th>   <th>    Descriptions    </th>  <th>    Unit Price (%@)    </th>    <th>    Tax (%%)    </th>  </tr>    </thead>    <tbody>",  _invoiceTemplateSelected.business.bussinessName, _invoiceTemplateSelected.business.bussinessName, _invoiceTemplateSelected.business.bussinessAddress, _invoiceTemplateSelected.business.bussinessCity, _invoiceTemplateSelected.business.bussinessPostCode, _customerSelected.customerBussinessName, _customerSelected.customerAddress, _customerSelected.customerCity, _customerSelected.customerPostCode, _invoiceTemplateSelected.business.bussinessVat, self.txtInvoiceNumber.text, dateStr, self.txtPaymentTerm.text, @"£"];
    
    NSLog(@"Temp: %@", templateInvoice);
    
    NSString* tbody = [[NSString alloc] init];
    NSLog(@"Product: %lu", (unsigned long)appdelegate.productsFroAddInvoices.count);
    
    for (int  i = 0; i < _productsAdded.count; i++)
    {
        int quantityValue = [[_productsAdded objectAtIndex:i] quantityValue];
        NSString* productName = [[_productsAdded objectAtIndex:i] productName];
        NSString* price = [[_productsAdded objectAtIndex:i] productUnitPrice];
        NSString* subTotal = [NSString stringWithFormat:@"%.2f", [price floatValue] * quantityValue];
        NSString* tax = [[_productsAdded objectAtIndex:i] productTaxRate];
        
        NSString* stringForRow = [NSString stringWithFormat:@" <tr>    <td>    <span>%d</span>    </td>    <td>%@</td> <td>%@</td>       <td>%@</td>        <td>%@</td>       </tr>", quantityValue, productName,self.txtNoteDesc.text, price, tax];
        
        NSLog(@"String For ROw: %@", stringForRow);
        tbody = [tbody stringByAppendingString:stringForRow];
    }
    
    NSString* rowTotal = [NSString stringWithFormat:@"  <tr>        <td>        </td>        <td></td>        <td></td>        <td><span style='font-weight: bold'>SubTotal<span></span></td>    <td><span style='font-weight: bold'>%@<span></span> </td>    </tr>  <tr>        <td>        </td>        <td></td>        <td></td>        <td><span style='font-weight: bold'>Taxes<span></span></td>    <td><span style='font-weight: bold'>%@<span></span> </td>    </tr>  <tr>        <td>        </td>        <td></td>        <td></td>        <td><span style='font-weight: bold'>Total<span></span></td>    <td><span style='font-weight: bold'>%@<span></span> </td>    </tr>    <tr>        <td style='padding-top: 40px' colspan='2'><span style='display:block;width:350px;border-bottom: 1px solid darkgrey;'></td>        <td style='padding-top: 40px' colspan='2'><span style='display:block;width:350px;border-bottom: 1px solid darkgrey;'></td>        </tr>",self.lblSubTotal.text, self.lblTaxes.text, self.lblTotal.text];
    
    NSLog(@"Row TOtal: %@", rowTotal);
    
    tbody = [tbody stringByAppendingString:rowTotal];
    
    NSString* paymentDetails = [NSString stringWithFormat:@"   </tbody>        </table>        <table class='tbfooter'>        <tr>        <td><span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Bank Details:</span><br/><br/></td>        </tr>      <tr>                                <td><span></span><br>                                <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Bank/Sort Code: </span>%@<br>                                <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Account Number: </span>%@<br>                                <span style='font-size: 20px;font-family: Avqest;font-weight: bold;'>Bank Name: </span>%@<br>                                </td>                                <td><span style='font-size: 20px;font-family: Avqest;font-weight: bold;'></td>                                  </tr>        </table>        </div>        <div class='footer'>       </div>       </div>        </body>        </html>", _invoiceTemplateSelected.sort_code, _invoiceTemplateSelected.account_number, _invoiceTemplateSelected.bank_name];
     
    
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
                              initWithTitle:nil
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
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Your mail has been Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Mail saved: you saved the email message in the Drafts folder");
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Your Conversation has been saved to Draft" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"The export file has been successfully sent to the recipient." delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        case MFMailComposeResultFailed:
            
        {
            NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Your valuable FeedBack has been Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    NSLog(@"Disconnect EMAIL");
}

#pragma mark - ProductViewController Delegate

- (void)didSelectedProduct:(BIProduct *)product
{
    if (_productsAdded == nil) {
        _productsAdded = [[NSMutableArray alloc] init];
    }
    
    [_productsAdded addObject:product];
    
    [self calculateAmout];
    [_tableView setHidden:NO];
    [_tableView reloadData];
}


#pragma mark - CustomerViewController Delegate

- (void)didSelectedCustomer:(BICustomer *)customer
{
    _customerSelected = customer;
    [self.btnAddCustom setTitle:_customerSelected.customerBussinessName forState:UIControlStateNormal];
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
