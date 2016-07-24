//
//  InvoiceTemplateRepository.h
//  BaseInvoices
//
//  Created by Mac Mini on 7/14/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIBussiness.h"

@interface InvoiceTemplateRepository : NSObject

@property (nonatomic, strong) NSString* invoiceTemplateID;
@property (nonatomic, strong) NSString* invoiceTemplateNumber;
@property (nonatomic, strong) NSString* businessID;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* invoiceTemplateName;
@property (nonatomic, strong) NSString* invoiceTemplateAddress;
@property (nonatomic, strong) NSString* vat;
@property (nonatomic, strong) NSString* telephone;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* scan;
@property (nonatomic, strong) NSString* bank_name;
@property (nonatomic, strong) NSString* sort_code;
@property (nonatomic, strong) NSString* account_number;
@property (nonatomic, strong) NSString* with_vat;
@property (nonatomic, strong) NSString* without_vat;
@property (nonatomic, strong) NSString* vat_number;
@property (nonatomic, strong) NSString* image_url;
@property (nonatomic, strong) NSString* created;
@property (nonatomic, strong) NSString* modified;

@property (nonatomic) NSString* countryID;

@property (nonatomic, strong) BIBussiness* business;

- (id)initWithTemplateID:(NSString*)invoiceTemplateID invoiceTemplateNumber:(NSString*)invoiceTemplateNumber businessID:(NSString*)businessID invoiceTemplateName:(NSString*)invoiceTemplateName invoiceTemplateAddress:(NSString*)invoiceTemplateAddress vat:(NSString*)vat telephone:(NSString*)telephone email:(NSString*)email scan:(NSString*)scan bank_name:(NSString*)bank_name sort_code:(NSString*)sort_code account_number:(NSString*)account_number with_vat:(NSString*)with_vat without_vat:(NSString*)without_vat vat_number:(NSString*)vat_number image_url:(NSString*)image_url created:(NSString*)created modified:(NSString*)modified;

- (id)initWithDict:(NSDictionary*)dict;

- (NSDictionary*)getInvoiceTemplate;
- (NSDictionary*)getInvoiteTemplateData;

@end
