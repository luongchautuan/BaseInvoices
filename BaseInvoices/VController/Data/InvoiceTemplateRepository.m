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
@end
