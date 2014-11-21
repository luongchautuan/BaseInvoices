//
//  BICustomerViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICustomerViewController.h"
#import "BIAddCustom.h"
#import "BIAddInvoices.h"

@interface BICustomerViewController ()

@end

@implementation BICustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddCustomer:(id)sender
{
    BIAddCustom *pushToVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onCloseViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
