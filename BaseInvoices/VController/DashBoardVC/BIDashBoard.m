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
            
            NSLog(@"RESPIONSE INVOICE: %@", responeString);
            NSDictionary* data = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            data = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([data valueForKey:@"data"] != nil)
            {
                appdelegate.invoicesForUser = [[NSMutableArray alloc] init];
                
                for (NSDictionary* invoiceDict in [data valueForKey:@"data"])
                {
                    BIInvoice* invoiceObject = [[BIInvoice alloc] initWithDict:invoiceDict];
                    
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
            NSUserDefaults *def= [[NSUserDefaults alloc]init];
            [def setBool:NO forKey:@"LOGIN"];
            
            [def synchronize];

            BILogin *referenceVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
            [self.navigationController pushViewController:referenceVC animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIButton Sender

- (IBAction)btnSelectedDate_Clicked:(id)sender
{
    NSDate *myDate = [self.datePicker date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *time = [dateFormat stringFromDate:myDate];
    
    self.txtDatePaid.text = time;
    
    [_viewTableDate setHidden:YES];
}

- (IBAction)btnDatePaid_Clicked:(id)sender
{
    [_viewDatePaid setHidden:YES];
    
    BIInvoice* invoice = [appdelegate.invoicesForUser objectAtIndex:_indexPathSelected.section];
    [invoice setIsPaided:YES];
    
    NSDictionary* data = [invoice getDataToSync];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:data];
    
    NSLog(@"JSON STRING: %@", jsonString);
    
    NSString* actionName = [NSString stringWithFormat:@"/invoice/%@",invoice.invoiceID];
    NSString* method = @"PUT";
    
    NSLog(@"JSON POST: %@", jsonString );
    
    [[ServiceRequest getShareInstance]  serviceRequestWithDataStr:jsonString actionName:actionName accessToken:[BIAppDelegate shareAppdelegate].currentUser.token method:method result:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        NSLog(@"ERROR : %@", [connectionError localizedDescription]);
        
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
                NSString* invoiceTemplateID = [[data valueForKey:@"data"] valueForKey:@"id"];
                
                NSLog(@"INVOICE ID: %@", invoiceTemplateID);
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[_indexPathSelected] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
        else
        {
            [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
            
            NSString *responeString = [[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE: %@", responeString);
            NSDictionary* data = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            data = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            NSString* error = [[data valueForKey:@"error"] objectAtIndex:0];
            
            UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [message show];
        }
        
        _indexPathSelected = nil;
        
    }];

}

- (IBAction)btnShowDatePaid_Clicked:(id)sender
{
    if (_isShowingDatePaid)
    {
        [self.viewTableDate setHidden:YES];
    }
    else
    {
        [self.viewTableDate setHidden:NO];
    }
    
    _isShowingDatePaid = !_isShowingDatePaid;
}

- (IBAction)onAddInvoice:(id)sender
{
    self.viewAddMore.hidden = YES;
    self.viewPopUp.hidden = YES;
    
    BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
    [pushToVC setIsFromWelcome:NO];
    [self.navigationController pushViewController:pushToVC animated:YES];
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

#pragma mark - UITableView Delegate

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
    
    if (invoice.isPaided)
    {
        [customCell.imgPaid setImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"]];
    }
    else
    {
        [customCell.imgPaid setImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"]];
         [customCell.btnPaid addTarget:self action:@selector(btnPaidInvoice_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    
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

- (IBAction)btnPaidInvoice_Clicked:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];

    _indexPathSelected = indexPath;
    
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *time = [dateFormat stringFromDate:myDate];

    _txtDatePaid.text = time;
    
    [self.viewDatePaid setHidden:NO];
    self.viewMarkPaid.frame = CGRectMake(10, -104, 300, 250);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewMarkPaid.frame = CGRectMake(10, 104, 300, 255);
    [UIView commitAnimations];
    
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
