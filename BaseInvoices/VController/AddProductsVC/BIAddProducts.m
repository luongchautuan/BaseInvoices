//
//  BIAddProducts.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddProducts.h"
#import "BIAddInvoices.h"
#import "ASIHTTPRequest.h"
#import "BIAppDelegate.h"

@interface BIAddProducts ()

@end

@implementation BIAddProducts

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
    [self.txtTitle setText:@"Add Products"];
    [self initScreen];
    // Do any additional setup after loading the view from its nib.
}

- (void)initScreen
{
//    [self.edtName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.edtUnitPrice setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.edtTaxRate setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.description setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    
    self.edtName.leftView = paddingView;
    self.edtName.leftViewMode = UITextFieldViewModeAlways;
    
//    self.description.leftView = paddingView2;
//    self.description.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtTaxRate.leftView = paddingView3;
    self.edtTaxRate.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtUnitPrice.leftView = paddingView4;
    self.edtUnitPrice.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.edtName resignFirstResponder];
    [self.edtTaxRate resignFirstResponder];
    [self.edtUnitPrice resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

#pragma mark - Request delegates...

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1)
    {
        if([request responseStatusCode] == 200)
        {

        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.viewActivity setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add Product failed" message:@"Something Wrong, Please Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)onSaveProduct:(id)sender
{
    [self.viewActivity setHidden:NO];
    [self.activityIndicator startAnimating];
    
    if([self.edtName.text length] < 1 ||[self.edtTaxRate.text length] < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.viewActivity setHidden:YES];
        [self.activityIndicator stopAnimating];
        
    }
    else
    {
        
    }
}

@end
