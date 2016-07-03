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
#import "NSUserDefaults+RMSaveCustomObject.h"
#define ACCEPTABLE_CHARECTERS @"+0123456789."

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
    
    self.unitPrice = self.product.productUnitPrice;
    
    NSLog(@"Currency symbol: %@", self.product.productUnitPrice );
    NSString* amountAfterFormat = [[NSString stringWithFormat:@"%@ ", appdelegate.bussinessForUser.currencySymbol] stringByAppendingString:self.unitPrice];

    NSString* taxAfterFormat = [NSString stringWithFormat:@"%@ %%", self.product.productTaxRate];
    
    self.edtName.text = self.product.productName;
    self.edtDesc.text = self.product.productDescription;
    self.edtTaxRate.text = taxAfterFormat;
    self.edtUnitPrice.text = amountAfterFormat;
}

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
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
    if (self.edtName.text.length > 0 && self.edtUnitPrice.text.length > 0)
    {
        if (self.edtTaxRate.text.length <= 0) {
            self.tax = @"0";
            self.edtTaxRate.text = @" 0 %";
        }
        
       
        if (!self.isEditProduct)
        {
            NSLog(@"Number: %@", self.edtUnitPrice.text);
            
            if ([self.edtUnitPrice.text rangeOfString:[NSString stringWithFormat:@"%@", appdelegate.bussinessForUser.currencySymbol]].length == 0)
            {
                NSLog(@"Number 1: %@", self.edtUnitPrice.text);
                if ([self.edtUnitPrice.text rangeOfString:@","].length != 0) {
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSLocale *localeCurrency = [[NSLocale alloc]
                                                initWithLocaleIdentifier:@"en"];
                    [formatter setLocale:localeCurrency];
                    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    
                    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
                    [formatter setGroupingSeparator:groupingSeparator];
                    [formatter setGroupingSize:3];
                    [formatter setAlwaysShowsDecimalSeparator:NO];
                    [formatter setUsesGroupingSeparator:YES];

                    
                    self.edtUnitPrice.text = [self.edtUnitPrice.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                    
                    self.unitPrice = self.edtUnitPrice.text;
                    
                    NSString* amt = [[formatter stringFromNumber:[NSNumber numberWithFloat:[self.edtUnitPrice.text floatValue]]] substringFromIndex:1];
                    
                    self.price = amt;
                }
                else{
                    self.price = self.edtUnitPrice.text;
                }
               
            }
           
            
            BIProduct* product = [[BIProduct alloc] init];
            product.productName = self.edtName.text;
            product.productDescription = self.edtDesc.text;
            product.productTaxRate = self.tax;
            product.productUnitPrice = self.price;
            product.numberOfUnit = 1;
            
            [appdelegate.productsForUser addObject:product];
        }
        else
        {
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"productName contains[c] %@", self.edtName.text];
            
            for (BIProduct* product in [appdelegate.productsForUser filteredArrayUsingPredicate:resultPredicate])
            {
                product.productName = self.edtName.text;
                product.productDescription = self.edtDesc.text;
                product.productTaxRate = self.edtTaxRate.text;
                product.productUnitPrice = self.unitPrice;
//                product.numberOfUnit = 1;
            }
        }
        
        NSLog(@"ProductForuser: %@", appdelegate.productsForUser);
//
//        NSMutableArray* arrayTosave = [[NSMutableArray alloc] init];
//        arrayTosave = appdelegate.productsForUser;
//        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults rm_setCustomObject:appdelegate.productsForUser forKey:@"productsForUser"];
//        [defaults synchronize];
        
        if (self.isEditProduct)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 2 || textField.tag == 3)
    {
        NSLog(@"String: %@", string);
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }

    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 2)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSLocale *localeCurrency = [[NSLocale alloc]
                                    initWithLocaleIdentifier:@"en"];
        [formatter setLocale:localeCurrency];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [formatter setGroupingSeparator:groupingSeparator];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:YES];
        
        if ([textField.text rangeOfString:@","].length != 0) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
//        if ([textField.text containsString:@","] ) {
//            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
//        }
       
        self.unitPrice = textField.text;
        
        NSString* amt = [[formatter stringFromNumber:[NSNumber numberWithFloat:[textField.text floatValue]]] substringFromIndex:1];
        
        self.price = amt;
        
        NSLog(@"Currency symbol: %@", amt);
        NSString* amountAfterFormat = [[NSString stringWithFormat:@"%@ ", appdelegate.bussinessForUser.currencySymbol] stringByAppendingString:amt];
        
        if (textField.text.length) {
            self.edtUnitPrice.text = amountAfterFormat;
        }     
    }
    
    if (textField.tag == 3)
    {
        if ([textField.text rangeOfString:@"%%"].length != 0) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"%%" withString:@""];
        }
        
//        if ([textField.text containsString:@"%%"]) {
//            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"%%" withString:@""];
//        }
        self.tax = textField.text;
        
        if (textField.text.length > 0)
        {
            self.edtTaxRate.text = [NSString stringWithFormat:@"%@ %%",self.tax];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2)
    {
        if ([self.unitPrice rangeOfString:@","].length != 0) {
            self.unitPrice = [self.unitPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
        }
        
//        if ([self.unitPrice containsString:@","] )
//        {
//            self.unitPrice = [self.unitPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
//        }
        
        if (textField.text.length > 0)
        {
                self.edtUnitPrice.text = [NSString stringWithFormat:@"%.2f", [self.unitPrice floatValue]];
        }
    }
    
    if (textField.tag == 3)
    {
        if ([textField.text rangeOfString:@"%%"].length != 0) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"%%" withString:@""];
            NSLog(@"Tax: %@", textField.text );
            self.tax = textField.text;
            
            self.edtTaxRate.text = self.tax;
        }
//        if ([textField.text containsString:@"%%"])
//        {
//            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"%%" withString:@""];
//            NSLog(@"Tax: %@", textField.text );
//            self.tax = textField.text;
//            
//            self.edtTaxRate.text = self.tax;
//        }
    }
}

@end
