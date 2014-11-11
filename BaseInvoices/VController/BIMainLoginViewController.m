//
//  BIMainLoginViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/11/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIMainLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "BIAppDelegate.h"

@interface BIMainLoginViewController ()

@end

@implementation BIMainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request delegates...


- (void)requestFinished:(ASIHTTPRequest *)request
{
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

#pragma mark - Text filed delegates...

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Button

- (IBAction)forgotPassword:(id)sender
{
    
}

- (IBAction)Cancel:(id)sender
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)txtEmail:(id)sender {
}

- (IBAction)txtPassword:(id)sender {
}
@end
