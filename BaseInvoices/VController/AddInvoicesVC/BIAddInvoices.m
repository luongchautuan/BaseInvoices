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

@interface BIAddInvoices ()

@end

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
//    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
//    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
//    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];
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
    
    checkBoxSelected = false;
    [self onVisibleOfViewListData:true];
    [self onVisibleofViewDateTime:true];
    [self onVisibleOfDialogPopup:true];
    
    [self.txtTitle setText:@"Add Invoices"];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnTotal setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
}

- (void)initData
{
    typeOfLstData = 0;
    [self initDataOfTableView];
}

- (IBAction)onShowViewLstBusiness:(id)sender {
    typeOfLstData = 0;
    [self initDataOfTableView];
    [self onVisibleOfViewListData:false];
}

- (IBAction)onShowViewLstInvoicesNumber:(id)sender {
    typeOfLstData = 1;
    [self initDataOfTableView];
    [self onVisibleOfViewListData:false];
}

- (IBAction)onShowViewDateTime:(id)sender {
    [self onVisibleofViewDateTime:false];
}

- (IBAction)onSaveAndSend:(id)sender {
}

- (IBAction)onSave:(id)sender {
}

- (IBAction)onAddCustom:(id)sender {
    
    BIAddCustom *pushToVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}
- (IBAction)onAddProduct:(id)sender {
    
    BIAddProducts *pushToVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onOpenMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)onBack:(id)sender {
    //    BIDashBoard *objectiveVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
    //    [self.navigationController pushViewController:objectiveVC animated:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)onCheckedButton:(id)sender {
    if(checkBoxSelected)
    {
        checkBoxSelected = false;
    }
    else
    {
        [self onVisibleOfDialogPopup:false];
        checkBoxSelected = true;
    }
    
    [self.btnTotal setSelected:checkBoxSelected];
}

#pragma mark init dialog list data
- (IBAction)onBackViewListData:(id)sender {
    [self onVisibleOfViewListData:true];
}

- (void)onVisibleOfViewListData:(bool)isShow
{
    [self.viewListData setHidden:isShow];

}

- (void)initDataOfTableView
{
    arrData = [[NSMutableArray alloc] init];
    if(typeOfLstData==0){
        
        [self testData];
    }else{
        
        [self testData2];
    }
    
    totalItem = arrData.count;
    [self onReloadData];
}

- (void)setTitleOfInvoices:(NSString*)data
{
    if(typeOfLstData==0){
        [self.btnBusiness setTitle:data forState:UIControlStateNormal];
    }else{
        [self.btnInvoicesNumber setTitle:data forState:UIControlStateNormal];
    }
}

- (void)testData
{
    for(int i = 0 ; i < 10; i ++)
    {
        [arrData addObject:[NSString stringWithFormat:@"Business : %d",i]];
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
- (IBAction)onBackViewDateTime:(id)sender {
     [self onVisibleofViewDateTime:true];
}

- (IBAction)onSaveDateTime:(id)sender {
    NSDate *myDate = [self.dpViewDateTime date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSString *time = [dateFormat stringFromDate:myDate];
    
    [self.btnDateTime setTitle:time forState:UIControlStateNormal];
    [self.viewDateTime setHidden:true];
}

- (void)onVisibleofViewDateTime:(bool)isShow
{
    [self.viewDateTime setHidden:isShow];

}

#pragma mark - init tableview of dialog list data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currSelected = indexPath.row;
    [self setTitleOfInvoices:[arrData objectAtIndex:indexPath.row]];
    [self.viewListData setHidden:true];
}

- (void)onReloadData
{
    [self.tbvViewListData reloadData];
}

#pragma mark init dialog popup
- (IBAction)onBackDialogPopup:(id)sender {
    [self onVisibleOfDialogPopup:true];
}

- (void)onVisibleOfDialogPopup:(bool)isShow{
    [self.viewPopup setHidden:isShow];
}
@end
