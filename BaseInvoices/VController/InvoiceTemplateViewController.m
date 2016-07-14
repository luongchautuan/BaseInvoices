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
                    NSString* invoiceTemplateID = [invoiceTemplateDict valueForKey:@"id"];
                    NSString* invoiceTemplateNumber = [invoiceTemplateDict valueForKey:@"invoice_id"];
                    NSString* businessID = [invoiceTemplateDict valueForKey:@"business_id"];
                    NSString* invoiceTemplateName = [invoiceTemplateDict valueForKey:@"name"];
                    NSString* invoiceTemplateAddress = [invoiceTemplateDict valueForKey:@"address"];
                    NSString* vat = [invoiceTemplateDict valueForKey:@"vat"];
                    NSString* telephone = [invoiceTemplateDict valueForKey:@"telephone"];
                    NSString* email = [invoiceTemplateDict valueForKey:@"email"];
                    NSString* scan = [invoiceTemplateDict valueForKey:@"scan"];
                    NSString* bank_name = [invoiceTemplateDict valueForKey:@"bank_name"];
                    NSString* sort_code = [invoiceTemplateDict valueForKey:@"sort_code"];
                    NSString* account_number = [invoiceTemplateDict valueForKey:@"account_number"];
                    NSString* with_vat = [invoiceTemplateDict valueForKey:@"with_vat"];
                    NSString* without_vat = [invoiceTemplateDict valueForKey:@"without_vat"];
                    NSString* vat_number = [invoiceTemplateDict valueForKey:@"vat_number"];
                    NSString* image_url = [invoiceTemplateDict valueForKey:@"image_url"];
                    NSString* created = [invoiceTemplateDict valueForKey:@"created"];
                    NSString* modified = [invoiceTemplateDict valueForKey:@"modified"];
                    
                    InvoiceTemplateRepository* invoiceTemplateObject = [[InvoiceTemplateRepository alloc] initWithTemplateID:invoiceTemplateID invoiceTemplateNumber:invoiceTemplateNumber businessID:businessID invoiceTemplateName:invoiceTemplateName invoiceTemplateAddress:invoiceTemplateAddress vat:vat telephone:telephone email:email scan:scan bank_name:bank_name sort_code:sort_code account_number:account_number with_vat:with_vat without_vat:without_vat vat_number:vat_number image_url:image_url created:created modified:modified];
                    
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

- (IBAction)onAddBussiness:(id)sender
{
    BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
    [pushToVC setIsEditBusiness:NO];
    [pushToVC setAddFrom:2];
    
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
    return appdelegate.businessForUser.count;
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
    
    return customCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIBussiness* bussiness = [appdelegate.businessForUser objectAtIndex:indexPath.row];
    
    //    if (self.isViewCustomerEdit)
    //    {
    BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
    [pushToVC setIsEditBusiness:YES];
    [pushToVC setBussinessEdit:bussiness];
    [pushToVC setIndexPathSelected:indexPath];
    //
    [self.navigationController pushViewController:pushToVC animated:YES];
    //    }
    //    else
    //    {
    //        appdelegate.currentCustomerForAddInvoice = customer;
    //
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    
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
