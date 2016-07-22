//
//  BIProductsViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIProductsViewController.h"
#import "BIAddProducts.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "SBJson.h"
#import "UIViewController+MMDrawerController.h"

@interface BIProductsViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BIProductsViewController

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
        [self.btnBack setHidden:NO];
        [self.btnMenu setHidden:YES];
    }
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/product" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL PRODUCT: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                appdelegate.productsForUser = [[NSMutableArray alloc] init];
                
                for (NSDictionary* productDict in [dataDict valueForKey:@"data"])
                {
                    NSString* productID = [productDict valueForKey:@"id"];
                    NSString* productName = [productDict valueForKey:@"name"];
                    NSString* unitPrict = [NSString stringWithFormat:@"%@", [productDict valueForKey:@"unit_price"]];
                    NSString* productDesc = [productDict valueForKey:@"description"];
                    NSString* tax_rate = [productDict valueForKey:@"tax_rate"];
                    NSString* userID = [productDict valueForKey:@"user_id"];
                    NSString* created = [productDict valueForKey:@"created"];
                    NSString* modified = [productDict valueForKey:@"modified"];
                    
                    BIProduct* productObject = [[BIProduct alloc] init];
                    [productObject setProductName:productName];
                    [productObject setProductTaxRate:tax_rate];
                    [productObject setNumberOfUnit:[unitPrict floatValue]];
                    [productObject setProductUnitPrice:unitPrict];
                    [productObject setProductDescription:productDesc];
                    [productObject setProductID:productID];
                    [productObject setCreated:created];
                    [productObject setModified:modified];
                    [productObject setQuantityValue:1];
                    
                    [appdelegate.productsForUser addObject:productObject];
                }
                
                [self.tableView reloadData];
                
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

- (IBAction)onAddProduct:(id)sender
{
    BIAddProducts *pushToVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
    [self presentViewController:pushToVC animated:YES completion:nil];
//    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onCloseViewController:(id)sender
{
    if (self.isViewEditProduct) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       [self dismissViewControllerAnimated:YES completion:nil]; 
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.productsForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    
    BIProduct* product = [appdelegate.productsForUser objectAtIndex:indexPath.row];
    cell.textLabel.text = product.productName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIProduct* product = [appdelegate.productsForUser objectAtIndex:indexPath.row];
    
    if (self.isViewEditProduct)
    {
        BIAddProducts *pushToVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
        [pushToVC setIsEditProduct:YES];
        [pushToVC setProduct:product];

        [self.navigationController pushViewController:pushToVC animated:YES];
    }
    else
    {
        [self.delegate didSelectedProduct:product];
//        [appdelegate.productsFroAddInvoices addObject:product];
        
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.delegate checkCallback];
//        [self.navigationController popViewControllerAnimated:YES];
    }
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
