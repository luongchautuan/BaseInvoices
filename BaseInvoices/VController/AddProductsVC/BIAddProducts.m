//
//  BIAddProducts.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddProducts.h"
#import "BIAddInvoices.h"
#import "BIProduct.h"
#import "BIAppDelegate.h"

@interface BIAddProducts ()

@end

BIAppDelegate* appdelegate;

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
    
//    [self.txtTitle setText:@"Add Products"];
    
    [self initScreen];
    
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isEditProduct)
    {
        [self.txtTitle setText:@"Edit Products"];
        [self loadProductDetail];
    }
    else
    {
        [self.txtTitle setText:@"Add Products"];
    }
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
    
    self.edtDesc.leftView = paddingView2;
    self.edtDesc.leftViewMode = UITextFieldViewModeAlways;
    
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

- (void)loadProductDetail
{
    self.edtName.text = self.product.productName;
    self.edtDesc.text = self.product.productDescription;
    self.edtTaxRate.text = self.product.productTaxRate;
    self.edtUnitPrice.text = self.product.productUnitPrice;
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.edtName resignFirstResponder];
    [self.edtTaxRate resignFirstResponder];
    [self.edtUnitPrice resignFirstResponder];
    [self.edtDesc resignFirstResponder];
}

- (IBAction)onSaveProduct:(id)sender
{
    if (self.edtName.text.length > 0 && self.edtTaxRate.text.length > 0 && self.edtUnitPrice.text.length > 0)
    {
        BIProduct* product = [[BIProduct alloc] init];
        product.productName = self.edtName.text;
        product.productDescription = self.edtDesc.text;
        product.productTaxRate = self.edtTaxRate.text;
        product.productUnitPrice = self.edtUnitPrice.text;
        
        [appdelegate.productsForUser addObject:product];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
