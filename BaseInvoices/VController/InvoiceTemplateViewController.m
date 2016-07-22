//
//  BIBusinessesViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/27/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "InvoiceTemplateViewController.h"
#import "BIAppDelegate.h"
#import "InvoiceTemplateRepository.h"
#import "BIAddNewBussiness.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "SBJson.h"
#import "InvoiceTemplateTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "AddInvoiceTemplateViewController.h"

@interface InvoiceTemplateViewController ()

@end

BIAppDelegate* appdelegate;

@implementation InvoiceTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_isFromMenu)
    {
        [self.btnMenu setHidden:NO];
        [self.btnBack setHidden:YES];
    }
    else
    {
        [self.btnMenu setHidden:YES];
        [self.btnBack setHidden:NO];
    }
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
                
                [self.tableView  reloadData];
            }
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCat:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)btnAddInvoiceTemplate_Clicked:(id)sender
{
    AddInvoiceTemplateViewController *pushToVC = [[AddInvoiceTemplateViewController alloc] initWithNibName:@"AddInvoiceTemplateViewController" bundle:nil];
    
    [self.navigationController pushViewController:pushToVC animated:YES];
}


- (IBAction)onCloseViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.invoicesTemplate.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InvoiceTemplateTableViewCell";
    
    InvoiceTemplateTableViewCell *customCell = (InvoiceTemplateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (customCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvoiceTemplateTableViewCell" owner:self options:nil];
        customCell = [nib objectAtIndex:0];
    }
    
    InvoiceTemplateRepository* invoiceTemplateObject = [appdelegate.invoicesTemplate objectAtIndex:indexPath.row];
    customCell.lblContactName.text = invoiceTemplateObject.invoiceTemplateName;
    customCell.lblEmail.text = invoiceTemplateObject.email;
    
    BOOL isVat = [invoiceTemplateObject.with_vat boolValue];
    if (isVat)
    {
        [customCell.imgVat setImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"]];
    }
    else
    {
        [customCell.imgVat setImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"]];
    }
    
    return customCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceTemplateRepository* invoiceTemplateObject = [appdelegate.invoicesTemplate objectAtIndex:indexPath.row];
    
    AddInvoiceTemplateViewController *pushToVC = [[AddInvoiceTemplateViewController alloc] initWithNibName:@"AddInvoiceTemplateViewController" bundle:nil];
    [pushToVC setIsFromWelcome:NO];
    [pushToVC setInvoiceBeEdited:invoiceTemplateObject];
//    [pushToVC setIndexPathSelected:indexPath];

    [self.navigationController pushViewController:pushToVC animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
