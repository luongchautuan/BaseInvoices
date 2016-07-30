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
#import "SBJson.h"

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
    NSString* amountAfterFormat = [NSString stringWithFormat:@"£ %@", self.unitPrice];

    self.tax = self.product.productTaxRate;
    NSString* taxAfterFormat = [NSString stringWithFormat:@"%@ %%", self.product.productTaxRate];
    
    self.edtName.text = self.product.productName;
    self.edtDesc.text = self.product.productDescription;
    self.edtTaxRate.text = taxAfterFormat;
    self.edtUnitPrice.text = amountAfterFormat;
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
    [BIAppDelegate shareAppdelegate].activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BIAppDelegate shareAppdelegate].activityIndicatorView.mode = MBProgressHUDAnimationFade;
    
    if (self.edtName.text.length > 0)
    {
        if (self.edtTaxRate.text.length <= 0) {
            self.tax = @"0";
            self.edtTaxRate.text = @" 0 %";
        }        
       
        if (!self.isEditProduct)
        {
            NSLog(@"Number: %@", self.edtUnitPrice.text);
            
            if ([self.edtUnitPrice.text rangeOfString:[NSString stringWithFormat:@"%@", @"£"]].length == 0)
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
                else
                {
                    self.price = self.edtUnitPrice.text;
                     self.unitPrice = self.edtUnitPrice.text;
                }
               
            }
        }
        
        //Save Customer into Server
        NSString* urlString = @"";
        NSString* method = @"";
        urlString = @"/product?";
        
        NSString *dataContent =[NSString stringWithFormat:@"name=%@&description=%@&unit_price=%@&tax_rate=%@", self.edtName.text, self.edtDesc.text, self.unitPrice, self.tax];
        
        NSLog(@"dataContent: %@", dataContent);
        
        if (self.isEditProduct) {
            method = @"PUT";
            
            urlString = @"/product";
            
            dataContent =[NSString stringWithFormat:@"/%@?name=%@&description=%@&unit_price=%@&tax_rate=%@", self.product.productID , self.edtName.text, self.edtDesc.text, self.unitPrice, self.tax];
        }
        else
        {
            method = @"POST";
        }
        
        dataContent = [dataContent stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        
        if ([dataContent containsString:@"@"]) {
            dataContent = [dataContent stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
        }
        
        [[ServiceRequest getShareInstance] serviceRequestActionName:[NSString stringWithFormat:@"%@%@",urlString, dataContent] accessToken:appdelegate.currentUser.token method:method result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = [httpResponse statusCode];
            
            [appdelegate.activityIndicatorView hide:YES];
            
            if (statusCode == 200)
            {
                NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                                encoding:NSUTF8StringEncoding];
                
                NSLog(@"RESPIONSE CREATE NEW CUSTOMER / SUPPLIER: %@", responeString);
                NSDictionary* dataDict = [[NSDictionary alloc] init];
                SBJsonParser *json = [SBJsonParser new];
                dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
                
                if ([dataDict valueForKey:@"data"] != nil)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                NSString* message = @"";
                message = @"Cannot save customer";
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }];
        
    }
    else
    {
        [appdelegate.activityIndicatorView hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Product name required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
       
        self.unitPrice = textField.text;
        
        NSString* amt = [[formatter stringFromNumber:[NSNumber numberWithFloat:[textField.text floatValue]]] substringFromIndex:1];
        
        self.price = amt;
        
        NSLog(@"Currency symbol: %@", amt);
        NSString* amountAfterFormat = [[NSString stringWithFormat:@"%@ ", @"£"] stringByAppendingString:amt];
        
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
            if (fmodf([self.unitPrice floatValue], 1.0) == 0.0) {
                self.edtUnitPrice.text = [NSString stringWithFormat:@"%d", (int)[self.unitPrice floatValue]];
            }
            else
                self.edtUnitPrice.text = [NSString stringWithFormat:@"%.2f", [self.unitPrice floatValue]];
        }
    }
    
    if (textField.tag == 3)
    {
        NSLog(@"TEXT: %@", self.edtTaxRate.text);
        
        if ([self.edtTaxRate.text containsString:@"%"]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSLog(@"Tax: %@", textField.text );
            self.tax = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            self.edtTaxRate.text = self.tax;
        }

    }
}

@end
