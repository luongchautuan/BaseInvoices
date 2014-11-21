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
#import "BIProductsViewController.h"

@interface BIAddInvoices ()

@end

bool cashBool,otherBool,cardBool,chequeBool, isCurrentDay, isShowViewBusiness, isShowViewDateTimeForMain;

@implementation BIAddInvoices

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScreen];

    // Do any additional setup after loading the view from its nib.
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

#pragma mark init view add invoices

- (void)initScreen
{
    //set gesture for return to close soft keyboard
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
    [tapGeusture setCancelsTouchesInView:NO];
    
    checkBoxSelected = false;
    [self onVisibleOfViewListData:true];
    [self onVisibleofViewDateTime:true];
    [self onVisibleOfDialogPopup:true];
    
    [self.txtNoteDesc setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    self.txtNoteDesc.leftView = paddingView;
    self.txtNoteDesc.leftViewMode = UITextFieldViewModeAlways;
    
    if (self.isEditInvoice)
    {
        [self.txtTitle setText:@"Edit Invoice"];
    }
    else
    {
        [self.txtTitle setText:@"Add Invoice"];
    }
    
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
    NSDate *myDate = [self.datePickerForMain date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *time = [dateFormat stringFromDate:myDate];
    
    self.txtDateForMain.text = time;
    
    self.scrollView.scrollEnabled = YES;

   
    
    self.tableView.frame = CGRectMake(27, 277, 0, 0);
    
    self.viewTotal.frame = CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.viewTotal.frame.size.width, self.viewTotal.frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.viewTotal.frame.origin.y + self.viewTotal.frame.size.height + 80);
}


- (void)initData
{
    typeOfLstData = 0;
    [self initDataOfTableView];
}

- (IBAction)onShowViewLstBusiness:(id)sender
{
//    typeOfLstData = 0;
//    [self initDataOfTableView];
//    [self onVisibleOfViewListData:false];
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
}

- (IBAction)onSave:(id)sender
{
    NSLog(@"Save");
}

- (IBAction)onAddCustom:(id)sender
{
    BICustomerViewController *pushToVC = [[BICustomerViewController alloc] initWithNibName:@"BICustomerViewController" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onAddProduct:(id)sender
{
    BIProductsViewController *pushToVC = [[BIProductsViewController alloc] initWithNibName:@"BIProductsViewController" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onOpenMenu:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)onBack:(id)sender
{
    //    BIDashBoard *objectiveVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
    //    [self.navigationController pushViewController:objectiveVC animated:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)onCheckedButton:(id)sender
{
    if(checkBoxSelected)
    {
        checkBoxSelected = false;
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

#pragma mark - init tableview of dialog list data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 2, [[UIScreen mainScreen] bounds].size.height, 1)];/// change size as you need.
    
    separatorLineView.backgroundColor = [UIColor cyanColor];// you can also put image here
    
    [cell.contentView addSubview:separatorLineView];
    cell.textLabel.text = [arrData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currSelected = indexPath.row;
    NSLog(@"didSelectRowAtIndexPath");
    
    [self setTitleOfInvoices:[arrData objectAtIndex:indexPath.row]];
    [self.viewListData setHidden:true];
}

- (void)onReloadData
{
    [self.tbvViewListData reloadData];
}

#pragma mark init dialog popup

- (IBAction)onBackDialogPopup:(id)sender
{
    [self onVisibleOfDialogPopup:true];
}

- (void)onVisibleOfDialogPopup:(bool)isShow
{
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
    
    self.txtPaymentType.text = @"Cash";
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
    
    self.txtPaymentType.text = @"Cheque";

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
    
    self.txtPaymentType.text = @"Card";

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
    
    self.txtPaymentType.text = @"Other";

}

- (IBAction)onShowViewLstDataFromDialogPopup:(id)sender
{
    typeOfLstData = 2;
    [self initDataOfTableView];
    [self onVisibleOfViewListData:false];
}


- (void)checkAllStateUnSelectedOfButtonPopup
{
    
//    [self.btnOtherPopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_inactive.png"] forState:UIControlStateNormal];
//    
//    [self.btnCardPopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_inactive.png"] forState:UIControlStateNormal];
//    
//    [self.btnCashPopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_inactive.png"] forState:UIControlStateNormal];
//    
//    [self.btnChequePopup setBackgroundImage:[UIImage imageNamed:@"bg_btn_inactive.png"] forState:UIControlStateNormal];
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
