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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* invoicesForUser = [[NSMutableArray alloc] init];
    
    invoicesForUser = [defaults rm_customObjectForKey:@"invoicesForUser"];
    
    if (invoicesForUser.count > 0)
    {
        self.tableView.hidden = NO;
        appdelegate.invoicesForUser = invoicesForUser;
    }
    else
    {
        self.tableView.hidden = YES;
    }

    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            BICustomerViewController *customerViewController = [[BICustomerViewController alloc] initWithNibName:@"BICustomerViewController" bundle:nil];
            [customerViewController setIsViewCustomerEdit:YES];
//            [self presentViewController:customerViewController animated:YES completion:nil];
            [self.navigationController pushViewController:customerViewController animated:YES];
        }
            break;
        case 2:
        {
            BIProductsViewController *educationVC = [[BIProductsViewController alloc] initWithNibName:@"BIProductsViewController" bundle:nil];
            
            [educationVC setIsViewEditProduct:YES];
            
            [self.navigationController pushViewController:educationVC animated:YES];
        }
            break;
        case 4:
        {
            BIProfileViewController *skillVC = [[BIProfileViewController alloc] initWithNibName:@"BIProfileViewController" bundle:nil];
            [self.navigationController pushViewController:skillVC animated:YES];
        }
            break;
        case 3:
        {
            BIBusinessesViewController *referenceVC = [[BIBusinessesViewController alloc] initWithNibName:@"BIBusinessesViewController" bundle:nil];
            [self.navigationController pushViewController:referenceVC animated:YES];
        }
            
            break;
        case 5:
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

- (IBAction)onAddBusiness:(id)sender
{
    self.viewAddMore.hidden = YES;
    self.viewPopUp.hidden = YES;
    BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
    [pushToVC setAddFrom:0];
    
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)showCat:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
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
    NSLog(@"Cutstomer: %@", invoice.bussiness.bussinessName);
    customCell.lblInvoiceNumber.text = invoice.invoiceName;
    customCell.lblCustomerName.text = invoice.customer.customerBussinessName;
    customCell.lblInvoiceTotal.text = invoice.totalInvoices;
    
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

@end
