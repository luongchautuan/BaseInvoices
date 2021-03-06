//
//  AddInvoiceTemplateViewController.m
//  BaseInvoices
//
//  Created by Mac Mini on 7/14/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import "AddInvoiceTemplateViewController.h"
#import "BIAppDelegate.h"
#import "ServiceRequest.h"
#import "SBJson.h"
#import "BIDashBoard.h"
#import "UIViewController+MMDrawerController.h"
#import "UIImageView+WebCache.h"

@interface AddInvoiceTemplateViewController ()

@end

@implementation AddInvoiceTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_invoiceBeEdited != nil)
    {
        [self.lblTitle setText:@"Edit Invoice Template"];
        [self fetchData];
    }
    else
    {
        [self getBusiness];
    }
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1100)];
}

- (void)fetchData
{
    _businessSelected = _invoiceBeEdited.business;
    _txtBusinessName.text = _businessSelected.bussinessName;
    if (_businessSelected.bussinessAddress1 == nil || [_businessSelected.bussinessAddress1 isEqual:[NSNull null]])
    {
        _txtAddressLine1.text = @"";
    }
    else
        _txtAddressLine1.text = [NSString stringWithFormat:@"%@", _businessSelected.bussinessAddress1];
    
    if (_businessSelected.bussinessAddress2 == nil || [_businessSelected.bussinessAddress2 isEqual:[NSNull null]]) {
        _txtAddressLine2.text = @"";
    }
    else
        _txtAddressLine2.text = [NSString stringWithFormat:@"%@", _businessSelected.bussinessAddress2];

    if (_businessSelected.bussinessCity == nil|| [_businessSelected.bussinessCity isEqual:[NSNull null]]) {
        _txtCity.text = @"";
    }
    else
        _txtCity.text = [NSString stringWithFormat:@"%@", _businessSelected.bussinessCity];
    
    if (_businessSelected.bussinessPostCode == nil|| [_businessSelected.bussinessPostCode isEqual:[NSNull null]]) {
        _txtPostcode.text = @"";
    }
    else
        _txtPostcode.text = [NSString stringWithFormat:@"%@", _businessSelected.bussinessPostCode];
    
    if (_businessSelected.country == nil) {
        _txtCountry.text = @"";
    }
    else
    {
        _countrySelected = _businessSelected.country;
        _txtCountry.text = [NSString stringWithFormat:@"%@", _businessSelected.country.countryName];
    }
    
    if (_invoiceBeEdited.invoiceTemplateName == nil|| [_invoiceBeEdited.invoiceTemplateName isEqual:[NSNull null]]) {
        _txtContactName.text = @"";
    }
    else
        _txtContactName.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.invoiceTemplateName];
    
    if (_invoiceBeEdited.vat == nil|| [_invoiceBeEdited.vat isEqual:[NSNull null]]) {
        _txtVat.text = @"";
    }
    else
        _txtVat.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.vat];
    
    if (_invoiceBeEdited.email == nil|| [_invoiceBeEdited.email isEqual:[NSNull null]]) {
        _txtEmail.text = @"";
    }
    else
        _txtEmail.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.email];

    
    if (_invoiceBeEdited.telephone == nil|| [_businessSelected.bussinessAddress1 isEqual:[NSNull null]]) {
        _txtTelephone.text = @"";
    }
    else
        _txtTelephone.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.telephone];

    if (_invoiceBeEdited.bank_name == nil|| [_invoiceBeEdited.bank_name isEqual:[NSNull null]]) {
        _txtBankName.text = @"";
    }
    else
        _txtBankName.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.bank_name];
    
    if (_invoiceBeEdited.sort_code == nil|| [_invoiceBeEdited.sort_code isEqual:[NSNull null]]) {
        _txtSortCode.text = @"";
    }
    else
        _txtSortCode.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.sort_code];
    
    if (_invoiceBeEdited.account_number == nil|| [_invoiceBeEdited.account_number isEqual:[NSNull null]]) {
        _txtAccountNo.text = @"";
    }
    else
        _txtAccountNo.text = [NSString stringWithFormat:@"%@", _invoiceBeEdited.account_number];
    
    if (_invoiceBeEdited.image_url != nil)
    {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_invoiceBeEdited.image_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil || [image isEqual:[NSNull null]])
            {
                [_imageView setImage:[UIImage imageNamed:@"icon-attachment.png"]];
            }
            else
            {
                [_imageView setImage:image];
                _imageSelected = image;
            }

        }];
    }
}

- (void)getBusiness
{
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/business" accessToken:[BIAppDelegate shareAppdelegate].currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL BUSSINESS: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                [BIAppDelegate shareAppdelegate].businessForUser = [[NSMutableArray alloc] init];
                
                for (NSDictionary* businessDict in [dataDict valueForKey:@"data"])
                {
                    BIBussiness* businessObject = [[BIBussiness alloc] initWithDict:businessDict];
                    [[BIAppDelegate shareAppdelegate].businessForUser addObject:businessObject];
                    
                }
                
                if ([BIAppDelegate shareAppdelegate].businessForUser.count > 0)
                {
                    //Select First Object
                    BIBussiness* businessObject = [[BIAppDelegate shareAppdelegate].businessForUser objectAtIndex:0];
                    _businessSelected = businessObject;
                
                    [self fetchDataWithBusiness:businessObject];
                    
                }
            }
            
        }
    }];

}

- (void)fetchDataWithBusiness:(BIBussiness*)business
{
    _txtBusinessName.text = business.bussinessName;
    if (business.bussinessAddress2 != nil && ![business.bussinessAddress2 isEqual:[NSNull null]])
    {
        _txtAddressLine2.text = business.bussinessAddress2;
    }
    if (business.bussinessAddress1 != nil && ![business.bussinessAddress1 isEqual:[NSNull null]])
    {
        _txtAddressLine1.text = business.bussinessAddress1;
    }
    
    if (business.bussinessCity != nil && ![business.bussinessCity isEqual:[NSNull null]])
    {
        _txtCity.text = business.bussinessCity;
    }
    
    if (business.bussinessPostCode != nil && ![business.bussinessPostCode isEqual:[NSNull null]])
    {
        _txtPostcode.text = business.bussinessPostCode;
    }

    if (business.bankSortCode != nil && ![business.bankSortCode isEqual:[NSNull null]])
    {
        _txtSortCode.text = business.bankSortCode;
    }
    
    if (business.bankName != nil && ![business.bankName isEqual:[NSNull null]])
    {
        _txtBankName.text = business.bankName;
    }
    
    if (business.bankAccountNumber != nil && ![business.bankAccountNumber isEqual:[NSNull null]])
    {
        _txtAccountNo.text = business.bankAccountNumber;
    }
    
    if (business.country != nil && ![business.country isEqual:[NSNull null]])
    {
        _countrySelected = business.country;
    
        if (business.country.countryName != nil && ![business.country.countryName isEqual:[NSNull null]])
        {
            _txtCountry.text = business.country.countryName;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Sender

- (IBAction)btnTakeAPhoto_Clicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                   message: @"Select Action."
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"otherButtonTitles:@"Select Photo",@"Take Photo", nil];
    [alert show];
    alert.tag = 0;
}

- (IBAction)btnSaveInvoiceTemplate_Clicked:(id)sender
{
    if (self.txtBusinessName.text.length == 0 || self.txtContactName.text.length == 0 )
    {
        [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
        
        UIAlertView* message = [[UIAlertView alloc] initWithTitle:nil message:@"All required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [message show];
    }
    else
    {
        InvoiceTemplateRepository* invoiceTemplate = [[InvoiceTemplateRepository alloc] init];
        invoiceTemplate.business = [[BIBussiness alloc] init];
        [invoiceTemplate setBusiness:_businessSelected];
        [invoiceTemplate setBusinessID:_businessSelected.businessID];
        [invoiceTemplate setInvoiceTemplateName:_txtContactName.text];
        [invoiceTemplate setVat_number:_txtVat.text];
        [invoiceTemplate setTelephone:_txtTelephone.text];
        [invoiceTemplate setEmail:_txtEmail.text];
        [invoiceTemplate setBank_name:_txtBankName.text];
        [invoiceTemplate setSort_code:_txtSortCode.text];
        [invoiceTemplate setAccount_number:_txtAccountNo.text];
        [invoiceTemplate setCountryID:_countrySelected.dialCode];
        
        if (_imageSelected != nil) {
            [invoiceTemplate setScan:@"image.png"];
        }
        
        NSDictionary* data = [invoiceTemplate getInvoiteTemplateData];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:data];
        
        NSString* actionName = [NSString stringWithFormat:@"/invoice-template"];
        NSString* method = @"POST";
        if (_invoiceBeEdited != nil)
        {
            actionName = [NSString stringWithFormat:@"/invoice-template/%@",_invoiceBeEdited.invoiceTemplateID];
            method = @"PUT";
        }
        
        NSLog(@"JSON POST: %@", jsonString );
        
        [[ServiceRequest getShareInstance]  serviceRequestWithDataStr:jsonString actionName:actionName accessToken:[BIAppDelegate shareAppdelegate].currentUser.token method:method result:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = [httpResponse statusCode];
            
            NSLog(@"ERROR : %@", [connectionError localizedDescription]);
            
            if (statusCode == 200)
            {
                NSString *responeString = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
                NSLog(@"RESPIONSE: %@", responeString);
                NSDictionary* data = [[NSDictionary alloc] init];
                SBJsonParser *json = [SBJsonParser new];
                data = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
                
                if ([data valueForKey:@"data"] != nil)
                {
                    NSString* invoiceTemplateID = [[data valueForKey:@"data"] valueForKey:@"id"];
                    
                    InvoiceTemplateRepository* invoiceTemplateRespon = [[InvoiceTemplateRepository alloc] initWithDict:[data valueForKey:@"data"]];
                    
                    NSData *imageData = UIImagePNGRepresentation(_imageSelected);
                    
                    [[ServiceRequest getShareInstance] uploadImageWithData:imageData actionName:[NSString stringWithFormat:@"/file/invoice_template/%@/upload", invoiceTemplateID] accessToken:[BIAppDelegate shareAppdelegate].currentUser.token result:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        
                        [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
                        
                        NSLog(@"UPLOAD IMAGE ERROR: %@", [connectionError localizedDescription]);
                        if (_isFromAddInvoice)
                        {
                            [self.delegate addSuccessFullyWithInvoiceTemplate:invoiceTemplateRespon];
                        }
                        
                        [self back];
                    }];
                    
                }
            }
            else
            {
                [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
                
                NSString *responeString = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
                
                NSLog(@"RESPIONSE: %@", responeString);
                NSDictionary* data = [[NSDictionary alloc] init];
                SBJsonParser *json = [SBJsonParser new];
                data = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
                
                NSString* error = [[data valueForKey:@"error"] objectAtIndex:0];
                
                UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [message show];
            }

        }];
        
//        [[ServiceRequest getShareInstance] serviceRequestActionName:actionName accessToken:[BIAppDelegate shareAppdelegate].currentUser.token method:method result:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//        }];
        
    }

}

- (IBAction)btnSelectBusinessName_Clicked:(id)sender
{
    BIBusinessesViewController *referenceVC = [[BIBusinessesViewController alloc] initWithNibName:@"BIBusinessesViewController" bundle:nil];
    [referenceVC setIsFromMenu:NO];
    referenceVC.delegate = self;
    [self.navigationController pushViewController:referenceVC animated:YES];
}

- (IBAction)btnSelectCountry_Clicked:(id)sender
{
    CountryViewController *pushToVC = [[CountryViewController alloc] initWithNibName:@"CountryViewController" bundle:nil];
    pushToVC.delegate = self;
    [self.navigationController pushViewController:pushToVC animated:YES];

}

- (IBAction)btnBack_Clicked:(id)sender
{
    [self back];
}

- (void)back
{
    if (_isFromWelcome)
    {
        BIDashBoard* dashboardView = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
        
        BLLeftSideVC *leftSideVC = [[BLLeftSideVC alloc] initWithNibName:@"BLLeftSideVC" bundle:nil];
        
        leftSideVC.delegate = dashboardView;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dashboardView];
        
        MMDrawerController* drawerController = [[MMDrawerController alloc] initWithCenterViewController:nav leftDrawerViewController:leftSideVC];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [self.navigationController pushViewController:drawerController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 0)
    {
        if (buttonIndex == 2)
        {
            NSLog(@"Take Photo");
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"Select Photo");
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
            
        }
        else if (buttonIndex == 0)
        {
            NSLog(@"Cancel");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary)
    {
        chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    }
    
    if(chosenImage == nil)
    {
        chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(chosenImage == nil)
    {
        chosenImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    self.imageView.image = chosenImage;
    
    _imageSelected = chosenImage;
    
    if(picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - CountryViewController Delegate

- (void)CountrySelected:(CountryRepository *)countrySelected
{
    _countrySelected = countrySelected;
    _txtCountry.text = countrySelected.countryName;
}

#pragma mark - BusinessViewController Delegate

- (void)didSelectedBusiness:(BIBussiness *)business
{
    _businessSelected = business;
    [self fetchDataWithBusiness:business];
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
