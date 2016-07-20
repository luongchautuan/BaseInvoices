//
//  WelcomeViewController.m
//  Taxmapp
//
//  Created by Luong Chau Tuan on 4/28/16.
//  Copyright © 2016 parameswaran a. All rights reserved.
//

#import "WelcomeViewController.h"
#import "BIAddInvoices.h"
//#import "AddExpence.h"
#import "BIDashBoard.h"
#import "BLLeftSideVC.h"
#import "MMDrawerController.h"
#import "ServiceRequest.h"
#import "SBJson.h"
#import "BIAppDelegate.h"
#import "AddInvoiceTemplateViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    //Auto relogin
    NSString* strData = [NSString stringWithFormat:@"{\"email\": \"%@\",\"password\": \"%@\"}", [[NSUserDefaults standardUserDefaults]valueForKey:@"Username"], [[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
    
    [[ServiceRequest getShareInstance] serviceRequestWithData:strData actionName:@"/login" result:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
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
                NSDictionary* userData = [[data valueForKey:@"data"] valueForKey:@"user"];
                
                NSString* name = [userData valueForKey:@"name"];
                NSString* userID = [userData valueForKey:@"id"];
                NSString* token = [[data valueForKey:@"data"] valueForKey:@"token"];
                int cis_registered = 0;
                int vat_registered = 0;
                if ([[userData valueForKey:@"cis_registered"] isEqual:[NSNull null]] || [userData valueForKey:@"cis_registered"] == nil) {
                    
                }
                else
                {
                    cis_registered = [[userData valueForKey:@"cis_registered"] intValue];
                }
                
                if ([[userData valueForKey:@"vat_registered"] isEqual:[NSNull null]] || [userData valueForKey:@"vat_registered"] == nil) {
                    
                }
                else
                {
                    vat_registered = [[userData valueForKey:@"vat_registered"] intValue];
                }
                
                
                NSUserDefaults *userDefault= [[NSUserDefaults alloc] init];
                [userDefault setBool:YES forKey:@"LOGIN"];
                
                [userDefault setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"] forKey:@"Username"];
                
                [userDefault setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"] forKey:@"Pass"];
                
                [userDefault setValue:name forKey:@"nameUser"];
                
                [userDefault setValue:userID forKey:@"User ID"];
                [userDefault setValue:token forKey:@"token"];
                
                [userDefault setValue:[NSNumber numberWithInt:cis_registered] forKey:@"cis_registered"];
                [userDefault setValue:[NSNumber numberWithInt:vat_registered] forKey:@"vat_registered"];
                
                NSString *dataStr;
                dataStr = [[[data valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"id"];
                
                BIUser* user = [[BIUser alloc] init];
                user.userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"Username"];
                user.password = [[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"];
                user.token = [[data valueForKey:@"data"] valueForKey:@"token"];
                user.displayName = name;
                user.isLoginSuccessFully = YES;
                
                [BIAppDelegate shareAppdelegate].currentUser = user;
                [BIAppDelegate shareAppdelegate].currentUser.userID = dataStr;

                [BIAppDelegate shareAppdelegate].isLoginSucesss = YES;
            }
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Sender

- (IBAction)btnCreateInvoice_Clicked:(id)sender
{
    BIAddInvoices *addIncome = [[BIAddInvoices alloc]initWithNibName:@"BIAddInvoices" bundle:nil];
    [addIncome setIsFromWelcome:YES];
    [self.navigationController pushViewController:addIncome animated:YES];

}

- (IBAction)btnAddExpense_Clicked:(id)sender
{
    AddInvoiceTemplateViewController *pushToVC = [[AddInvoiceTemplateViewController alloc] initWithNibName:@"AddInvoiceTemplateViewController" bundle:nil];
    [pushToVC setIsFromWelcome:YES];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)btnGoToDashboard_Clicked:(id)sender
{
    [self navigateToDashboard];
}

- (IBAction)btnClose_Clicked:(id)sender
{
    [self navigateToDashboard];
}

- (void)navigateToDashboard
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
