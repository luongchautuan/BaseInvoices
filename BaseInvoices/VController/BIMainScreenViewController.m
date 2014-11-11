//
//  BIMainScreenViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/10/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIMainScreenViewController.h"

@interface BIMainScreenViewController ()

@end

@implementation BIMainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registation:(id)sender
{
    //Go To Register View

}

- (IBAction)login:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"LOGIN"]==YES)
    {
        //Go to Login View
    }
    else
    {
        //Go to Main Login
    }
}

#pragma mark - Text filed delegates...

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
