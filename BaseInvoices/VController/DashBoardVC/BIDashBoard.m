//
//  BIDashBoard.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIDashBoard.h"
#import "UIViewController+MMDrawerController.h"
#import "BIAddInvoices.h"
#import "BIAddNewBussiness.h"
#import "BIProductsViewController.h"
#import "BIProfileViewController.h"
#import "BICustomerViewController.h"
#import "BILogin.h"
#import "BIBussiness.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "BIInvoice.h"
#import "BIBusinessesViewController.h"
#import "BIInvoiceTableViewCell.h"
#import "SBJson.h"
#import "InvoiceTemplateViewController.h"

@interface BIDashBoard ()

@end

BIAppDelegate* appdelegate;

@implementation BIDashBoard

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
    // Do any additional setup after loading the view from its nib.
    [self.txtTitle setText:@"Dashboard"];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.viewPopUp addGestureRecognizer:tapGeusture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray* invoicesForUser = [[NSMutableArray alloc] init];
//    
//    invoicesForUser = [defaults rm_customObjectForKey:@"invoicesForUser"];
//    
//    if (invoicesForUser.count > 0)
//    {
//        self.tableView.hidden = NO;
//        appdelegate.invoicesForUser = invoicesForUser;
//    }
//    else
//    {
//        self.tableView.hidden = YES;
//    }
//
//    [self.tableView reloadData];
    
    [self getInvoices];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getInvoices
{
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/invoice" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE: %@", responeString);
            NSDictionary* data = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            data = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([data valueForKey:@"data"] != nil)
            {
                appdelegate.invoicesForUser = [[NSMutableArray alloc] init];
                
                for (NSDictionary* invoiceDict in [data valueForKey:@"data"])
                {
                    NSString* invoiceNumber = [invoiceDict valueForKey:@"invoice_no"];
                    NSString* invoiceID = [invoiceDict valueForKey:@"id"];
                    
                    NSDictionary* customerDict = [invoiceDict valueForKey:@"customer"];
                    NSDictionary* invoiceTemplateDict = [invoiceDict valueForKey:@"invoice_template"];
                    
                    NSString* customerName = [customerDict valueForKey:@"company_name"];
                    NSString* invoiceTotal = [invoiceDict valueForKey:@"total"];
                    
                    BIInvoice* invoiceObject = [[BIInvoice alloc] init];
                    [invoiceObject setTotalInvoices:invoiceTotal];
                    invoiceObject.customer = [[BICustomer alloc] init];
                    [invoiceObject.customer setCustomerBussinessName:customerName];
                    
                    if (invoiceNumber == nil || [invoiceNumber isEqual:[NSNull null]]) {
                        invoiceNumber = @"";
                    }
                    
                    [invoiceObject setInvoiceName:invoiceNumber];
                    
                    [appdelegate.invoicesForUser addObject:invoiceObject];
                }
                
                if (appdelegate.invoicesForUser.count > 0)
                {
                    self.tableView.hidden = NO;
                }
                else
                {
                    self.tableView.hidden = YES;
                }
                
                [self.tableView reloadData];

            }
        }
    }];
}

- (IBAction)onShowPopUp:(id)sender
{
    self.viewPopUp.hidden = NO;
    self.viewAddMore.hidden = NO;
    self.viewAddMore.frame=CGRectMake(24,-130, 288, 130);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewAddMore.frame=CGRectMake(24 ,65, 288, 130);
    [UIView commitAnimations];
}

- (void)selectCategory:(int)ID
{
    switch (ID)
    {
        case 0:
        {
            BIDashBoard *dashboardViewController = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
            [self.navigationController pushViewController:dashboardViewController animated:YES];
        }
            break;
        case 1:
        {
            InvoiceTemplateViewController *invoiceTemplateViewController = [[InvoiceTemplateViewController alloc] initWithNibName:@"InvoiceTemplateViewController" bundle:nil];
            [invoiceTemplateViewController setIsFromMenu:YES];
            [self.navigationController pushViewController:invoiceTemplateViewController animated:YES];
        }
            break;

        case 2:
        {
            BICustomerViewController *customerViewController = [[BICustomerViewController alloc] initWithNibName:@"BICustomerViewController" bundle:nil];
            [customerViewController setIsViewCustomerEdit:YES];
            [customerViewController setIsFromMenu:YES];
//            [self presentViewController:customerViewController animated:YES completion:nil];
            [self.navigationController pushViewController:customerViewController animated:YES];
        }
            break;
        case 3:
        {
            BIProductsViewController *educationVC = [[BIProductsViewController alloc] initWithNibName:@"BIProductsViewController" bundle:nil];
            [educationVC setIsFromMenu:YES];
            [educationVC setIsViewEditProduct:YES];
            
            [self.navigationController pushViewController:educationVC animated:YES];
        }
            break;
        case 5:
        {
            BIProfileViewController *skillVC = [[BIProfileViewController alloc] initWithNibName:@"BIProfileViewController" bundle:nil];
            [self.navigationController pushViewController:skillVC animated:YES];
        }
            break;
        case 4:
        {
            BIBusinessesViewController *referenceVC = [[BIBusinessesViewController alloc] initWithNibName:@"BIBusinessesViewController" bundle:nil];
            [referenceVC setIsFromMenu:YES];
            [self.navigationController pushViewController:referenceVC animated:YES];
        }
            
            break;
        case 6:
        {
            appdelegate.isLoginSucesss = NO;
            
            BILogin *referenceVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
            [self.navigationController pushViewController:referenceVC animated:YES];
        }
            break;
        default:
            break;
    }
}


- (IBAction)onAddInvoice:(id)sender
{
    if (appdelegate.invoicesForUser.count == 0)
    {
        self.viewPopUp.hidden = YES;
        self.viewAddMore.hidden = YES;
        
        //Check user config or check created bussiness
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isExistBussiness = [defaults boolForKey:@"bussiness"];
        
        if (isExistBussiness)
        {
            //        BIBussiness* bussinessForUser = [defaults rm_customObjectForKey:@"bussinessForUser"];
            //        appdelegate.bussinessForUser = bussinessForUser;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray* bussinessForUser = [[NSMutableArray alloc] init];
            
            bussinessForUser = [defaults rm_customObjectForKey:@"bussinessesForUser"];
            
            if (bussinessForUser.count > 0)
            {
                appdelegate.businessForUser = bussinessForUser;
            }
            
            appdelegate.productsFroAddInvoices = [[NSMutableArray alloc] init];
            
            BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
            [self.navigationController pushViewController:pushToVC animated:YES];
        }
        else
        {
            appdelegate.isLaunchAppFirstTime = YES;
            BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
            [pushToVC setAddFrom:1];
            
            [self.navigationController pushViewController:pushToVC animated:YES];
        }

    }
    else if (!appdelegate.isLoginSucesss)
    {
        self.viewAddMore.hidden = YES;
        self.viewPopUp.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please log in or register to add more invoice" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        
        [alert setTag:1];
        [alert show];
        
        return;
    }
    else
    {
        self.viewAddMore.hidden = YES;
        self.viewPopUp.hidden = YES;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray* bussinessForUser = [[NSMutableArray alloc] init];
        
        bussinessForUser = [defaults rm_customObjectForKey:@"bussinessesForUser"];
        
        if (bussinessForUser.count > 0)
        {
            appdelegate.businessForUser = bussinessForUser;
        }
        
        appdelegate.productsFroAddInvoices = [[NSMutableArray alloc] init];
        
        BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
        [self.navigationController pushViewController:pushToVC animated:YES];

    }

}

- (IBAction)onAddBusiness:(id)sender
{
    if (appdelegate.businessForUser.count == 0)
    {
        self.viewAddMore.hidden = YES;
        self.viewPopUp.hidden = YES;
        BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
        [pushToVC setAddFrom:0];
        
        [self.navigationController pushViewController:pushToVC animated:YES];
    }
    else if (!appdelegate.isLoginSucesss)
    {
        self.viewAddMore.hidden = YES;
        self.viewPopUp.hidden = YES;

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please log in or register to add more invoice" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
        
        return;
    }
    
    if (appdelegate.isLoginSucesss)
    {
        self.viewAddMore.hidden = YES;
        self.viewPopUp.hidden = YES;
        BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
        [pushToVC setAddFrom:0];
        
        [self.navigationController pushViewController:pushToVC animated:YES];

    }
    else
    {
        
    }
}

- (IBAction)showCat:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    NSLog(@"TAP");
    self.viewPopUp.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return appdelegate.invoicesForUser.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BIInvoiceTableViewCell";
    
    BIInvoiceTableViewCell *customCell = (BIInvoiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (customCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BIInvoiceTableViewCell" owner:self options:nil];
        customCell = [nib objectAtIndex:0];
    }
   
    BIInvoice* invoice = [appdelegate.invoicesForUser objectAtIndex:indexPath.section];
    NSLog(@"Cutstomer: %@", invoice.invoiceName);
    customCell.lblInvoiceNumber.text = [NSString stringWithFormat:@"#%@", invoice.invoiceName];
    customCell.lblCustomerName.text = [NSString stringWithFormat:@"%@", invoice.customer.customerBussinessName];
    customCell.lblInvoiceTotal.text = [NSString stringWithFormat:@"£%@", invoice.totalInvoices];
    
    return customCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIInvoice* invoice = [appdelegate.invoicesForUser objectAtIndex:indexPath.section];
    
    BIAddInvoices* editInvoiceViewController = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
    [editInvoiceViewController setIsEditInvoice:YES];
    [editInvoiceViewController setInvoiceEdit:invoice];
    [editInvoiceViewController setIndexPathSelected:indexPath];
    
    [self presentViewController:editInvoiceViewController animated:YES completion:nil];
    
}

//Get invoices info from server
-(void)getAllInvoice
{
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"SkipLogin: %ld", (long)buttonIndex);
    
    if (buttonIndex != 0)
    {
        NSLog(@"Cancel");
    }
    else
    {
        NSLog(@"LOgin");
        BILogin *referenceVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
        [self.navigationController pushViewController:referenceVC animated:YES];
    }
}

@end
