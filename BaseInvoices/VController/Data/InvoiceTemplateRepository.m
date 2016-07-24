//
//  InvoiceTemplateRepository.m
//  BaseInvoices
//
//  Created by Mac Mini on 7/14/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import "InvoiceTemplateRepository.h"

@implementation InvoiceTemplateRepository

- (id)initWithTemplateID:(NSString *)invoiceTemplateID invoiceTemplateNumber:(NSString *)invoiceTemplateNumber businessID:(NSString *)businessID invoiceTemplateName:(NSString *)invoiceTemplateName invoiceTemplateAddress:(NSString *)invoiceTemplateAddress vat:(NSString *)vat telephone:(NSString *)telephone email:(NSString *)email scan:(NSString *)scan bank_name:(NSString *)bank_name sort_code:(NSString *)sort_code account_number:(NSString *)account_number with_vat:(NSString *)with_vat without_vat:(NSString *)without_vat vat_number:(NSString *)vat_number image_url:(NSString *)image_url created:(NSString *)created modified:(NSString *)modified
{
    self = [super init];
    
    if (self)
    {
        _invoiceTemplateID = invoiceTemplateID;
        _invoiceTemplateNumber = invoiceTemplateNumber;
        _businessID = businessID;
        _invoiceTemplateName = invoiceTemplateName;
        _invoiceTemplateAddress = invoiceTemplateAddress;
        _vat = vat;
        _telephone = telephone;
        _email = email;
        _scan = scan;
        _bank_name = bank_name;
        _sort_code = sort_code;
        _account_number = account_number;
        _with_vat = with_vat;
        _without_vat = without_vat;
        _vat_number = vat_number;
        _image_url = image_url;
        _created = created;
        _modified = modified;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        _invoiceTemplateID = [dict valueForKey:@"id"];
        _invoiceTemplateNumber = [dict valueForKey:@"invoice_id"];
        _businessID = [dict valueForKey:@"business_id"];
        _invoiceTemplateName = [dict valueForKey:@"name"];
        _invoiceTemplateAddress = [dict valueForKey:@"address"];
        _vat = [dict valueForKey:@"vat"];
        _telephone = [dict valueForKey:@"telephone"];
        _email = [dict valueForKey:@"email"];
        _scan = [dict valueForKey:@"scan"];
        _bank_name = [dict valueForKey:@"bank_name"];
        _sort_code = [dict valueForKey:@"sort_code"];
        _account_number = [dict valueForKey:@"account_number"];
        _with_vat = [dict valueForKey:@"with_vat"];
        _without_vat = [dict valueForKey:@"without_vat"];
        _vat_number = [dict valueForKey:@"vat_number"];
        _image_url = [dict valueForKey:@"image_url"];
        _created = [dict valueForKey:@"created"];
        _modified = [dict valueForKey:@"modified"];

    }
    
    return self;
}

- (NSDictionary*)getInvoiceTemplate
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_invoiceTemplateID forKey:@"id"];
    [dict setObject:_userID forKey:@"user_id"];
    [dict setObject:_invoiceTemplateID forKey:@"invoice_id"];
    [dict setObject:_business.businessID forKey:@"business_id"];
    [dict setObject:_invoiceTemplateName forKey:@"name"];
    [dict setObject:_invoiceTemplateID forKey:@"address"];
    [dict setObject:_invoiceTemplateID forKey:@"vat"];
    [dict setObject:_invoiceTemplateID forKey:@"telephone"];
    [dict setObject:_invoiceTemplateID forKey:@"address_line2"];
    [dict setObject:_invoiceTemplateID forKey:@"city"];
    [dict setObject:_invoiceTemplateID forKey:@"postcode"];
    [dict setObject:_invoiceTemplateID forKey:@"date_started"];
    [dict setObject:_invoiceTemplateID forKey:@"cis_registered"];
    [dict setObject:_invoiceTemplateID forKey:@"vat_registered"];
    [dict setObject:_invoiceTemplateID forKey:@"vat_number"];
    [dict setObject:_invoiceTemplateID forKey:@"bank_account_name"];
    [dict setObject:_invoiceTemplateID forKey:@"bank_name"];
    [dict setObject:_invoiceTemplateID forKey:@"sort_code"];
    [dict setObject:_invoiceTemplateID forKey:@"bank_account_number"];
    [dict setObject:_invoiceTemplateID forKey:@"created"];
    [dict setObject:_invoiceTemplateID forKey:@"modified"];
    [dict setObject:_invoiceTemplateID forKey:@"bank_name"];
    
    return dict;
    
}

- (NSDictionary*)getInvoiteTemplateData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];

    [dict setObject:_business.getDataForSync forKey:@"business"];
    [dict setObject:_business.businessID forKey:@"business_id"];
    [dict setObject:_invoiceTemplateName forKey:@"name"];
    if (_business.bussinessAddress == nil || [_business.bussinessAddress isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address"];
    }
    else
    {
        [dict setObject:_business.bussinessAddress forKey:@"address"];
    }
    
    if (_vat_number == nil || [_vat_number isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"vat"];
    }
    else
    {
        [dict setObject:_vat_number forKey:@"vat"];
    }
    
    if (_telephone == nil || [_telephone isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"telephone"];
    }
    else
    {
        [dict setObject:_telephone forKey:@"telephone"];
    }
    
    if (_email == nil || [_email isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"email"];
    }
    else
    {
        [dict setObject:_email forKey:@"email"];
    }
    
    if (_bank_name == nil || [_bank_name isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"bank_name"];
    }
    else
    {
        [dict setObject:_bank_name forKey:@"bank_name"];
    }
    
    if (_sort_code == nil || [_sort_code isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"sort_code"];
    }
    else
    {
        [dict setObject:_sort_code forKey:@"sort_code"];
    }
    
    if (_account_number == nil || [_account_number isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"account_number"];
    }
    else
    {
        [dict setObject:_account_number forKey:@"account_number"];
    }
    
    if (_countryID == nil || [_countryID isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"country_id"];
    }
    else
    {
        [dict setObject:_countryID forKey:@"country_id"];
    }

    return dict;

}

@end
