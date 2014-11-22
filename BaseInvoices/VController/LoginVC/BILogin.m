//
//  BILogin.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BILogin.h"
#import "BIRegister.h"
#import "BIDashBoard.h"
#import "UIViewController+MMDrawerController.h"
#import "BIAddInvoices.h"
#import "BIAddProducts.h"
#import "BIAddCustom.h"
#import "ASIHTTPRequest.h"
#import "BIAppDelegate.h"
#import "BIUser.h"
#import "BICustomerViewController.h"
#import "BIProductsViewController.h"
#import "BIProfileViewController.h"

@interface BILogin ()

@end

BIAppDelegate *appdelegate;

@implementation BILogin

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
    
//    self.edtUsername.text = @"test@test.com";
//    self.edtPassword.text = @"test";
    [self initScreen];
}

- (void)initScreen
{
    UIColor* color = [[UIColor alloc] initWithRed:198.0/255.0 green:224.0/255.0 blue:168.0/255.0 alpha:1.0];
    
    [self.edtUsername setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtPassword setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    
    self.edtUsername.leftView = paddingView;
    self.edtUsername.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtPassword.leftView = paddingView2;
    self.edtPassword.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self closeMenu];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    NSLog(@"viewDidAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender
{
    [self.viewActivity setHidden:NO];
    [self.activityIndicator startAnimating];
    
    if([self.edtPassword.text length] <1 ||[self.edtUsername.text length]<1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.viewActivity setHidden:YES];
        [self.activityIndicator stopAnimating];
        
    }
    else
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
        
        
        [request setTag:1];
        [request addBasicAuthenticationHeaderWithUsername:self.edtUsername.text andPassword:self.edtPassword.text];
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request setValidatesSecureCertificate:NO];
        [request setDelegate:self];
        [request startAsynchronous];
    }

}

- (IBAction)onRegister:(id)sender {
    BIRegister *pushToVC = [[BIRegister alloc] initWithNibName:@"BIRegister" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (void)closeMenu
{
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
            
            [self.navigationController pushViewController:customerViewController animated:YES];
        }
            break;
        case 2:
        {
            BIProductsViewController *educationVC = [[BIProductsViewController alloc] initWithNibName:@"BIProductsViewController" bundle:nil];
            [self.navigationController pushViewController:educationVC animated:YES];
        }
            break;
        case 3:
        {
            BIProfileViewController *skillVC = [[BIProfileViewController alloc] initWithNibName:@"BIProfileViewController" bundle:nil];
            [self.navigationController pushViewController:skillVC animated:YES];
        }
            break;
        case 4:
        {
            BILogin *referenceVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
            [self.navigationController pushViewController:referenceVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.edtPassword resignFirstResponder];
    [self.edtUsername resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        [self.scrollView setContentOffset:CGPointMake(0,50)];
    }
    
    if (textField.tag==1)
    {
        [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField== self.edtUsername)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if(textField == self.edtPassword)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }

    
    return YES;
}


#pragma mark - Request delegates...


- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1)
    {
        if([request responseStatusCode] == 200)
        {
            BIUser* user = [[BIUser alloc] init];
            user.userName = self.edtUsername.text;
            user.password = self.edtPassword.text;
            
            appdelegate.currentUser = user;
            
            appdelegate.isLoginSucesss = YES;
            
            BIDashBoard *pushToVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
            [self.navigationController pushViewController:pushToVC animated:YES];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.viewActivity setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Authentication failed" message:@"Username and password mismatched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

- (IBAction)onSkipLogin:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Authentication Information" message:@"Are you want to login later?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"SkipLogin: %ld", (long)buttonIndex);
    
    if (buttonIndex == 1)
    {
        BIDashBoard *pushToVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
        [self.navigationController pushViewController:pushToVC animated:YES];
    }
}

@end
