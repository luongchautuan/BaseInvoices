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

// User enter number is move to password text field

- (IBAction)userButton:(id)sender
{
//    passwordTxtFld.text=[NSString stringWithFormat:@"%@%i",passwordTxtFld.text,((UIButton *)sender).tag];
    
    
//    NSLog(@"in password %@",passwordTxtFld.text );
    
}


// Delete a character in the string(user name , password).
- (IBAction)Cleartxt:(id)sender
{
//    if ( [passwordTxtFld.text length]  > 0)
//        passwordTxtFld.text = [passwordTxtFld.text substringToIndex:[passwordTxtFld.text length] - 1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)txtEmail:(id)sender
{
    
}

- (IBAction)txtPassword:(id)sender
{
    
}
@end
