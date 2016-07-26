//
//  BIInvoice.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/10/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIInvoice.h"

@implementation BIInvoice

- (NSDictionary*)getDataToSync
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_invoiceName forKey:@"invoice_no"];
    [dict setObject:_customer.getData forKey:@"customer"];
    [dict setObject:_customer.customerID forKey:@"customer_id"];
    [dict setObject:_invoiceTemplate.business.getDataForSync forKey:@"business"];
    
    [dict setObject:_invoiceTemplate.business.businessID forKey:@"business_id"];
    NSMutableArray *invoiceDetails = [NSMutableArray new];
    
    for (BIProduct* product in _products)
    {
        NSMutableDictionary* productDict = [NSMutableDictionary new];
        [productDict setObject:_invoiceTemplate.userID forKey:@"user_id"];
        [productDict setObject:product.productID forKey:@"product_id"];
        [productDict setObject:product.getData forKey:@"product"];
        [productDict setObject:[NSString stringWithFormat:@"%d", product.quantityValue] forKey:@"quantity"];
        [productDict setObject:[NSString stringWithFormat:@"%f", product.quantityValue * [product.productUnitPrice floatValue]] forKey:@"amount"];
        
        
        [invoiceDetails addObject:productDict];
    }
    
    [dict setObject:invoiceDetails forKey:@"invoice_details"];
    
    
    [dict setObject:@"1" forKey:@"payment_type_id"];
    [dict setObject:_invoiceTemplate.getInvoiteTemplateData forKey:@"invoice_template"];
    [dict setObject:_invoiceTemplate.invoiceTemplateID forKey:@"invoice_template_id"];
    [dict setObject:_dateInvoice forKey:@"date"];
    
    [dict setObject:_dateInvoice forKey:@"due_on"];
    [dict setObject:_due_selection forKey:@"due_selection"];
    [dict setObject:_noteInvoice forKey:@"notes"];
    [dict setObject:_totalInvoices forKey:@"amount"];
    [dict setObject:_totalInvoices forKey:@"total"];
    [dict setObject:@"0" forKey:@"paid"];
    [dict setObject:@"Queried" forKey:@"status"];
    
    if (_isAutoCreateIncome)
    {
        [dict setObject:@"1" forKey:@"auto_create_income"];
    }
    else
        [dict setObject:@"0" forKey:@"auto_create_income"];
    
    return dict;
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        _invoiceID = [dict valueForKey:@"id"];
        _invoiceName = [dict valueForKey:@"invoice_no"];
        
        if (_invoiceName == nil || [_invoiceName isEqual:[NSNull null]]) {
            _invoiceName = @"";
        }
        
        _isPaided = [[dict valueForKey:@"paid"] boolValue];
        _totalInvoices = [dict valueForKey:@"total"];
        _due_selection = [dict valueForKey:@"due_selection"];
        _taxesInvoice = [dict valueForKey:@"vat"];
        _noteInvoice = [dict valueForKey:@"notes"];
        _subInvoice = [dict valueForKey:@"amount"];
        
        _invoiceTemplate = [[InvoiceTemplateRepository alloc] initWithDict:[dict valueForKey:@"invoice_template"]];
        _customer = [[BICustomer alloc] initWithDict:[dict valueForKey:@"customer"]];

        _products = [[NSMutableArray alloc] init];
        for (NSDictionary* productDict in [dict valueForKey:@"invoice_details"])
        {
            BIProduct* product = [[BIProduct alloc] initWithDict:productDict];
            [_products addObject:product];
        }
    }
    
    return self;
}

//
//{
//    "invoice_no": 0,
//    "customer_id": 0,
//    "business_id": 0,
//    "payment_type_id": 0,
//    "invoice_template_id": 0,
//    "invoice_template": "",
//    "invoice_details": [
//                        {
//                            "product_id": 0,
//                            "quantity": 0,
//                            "product": {
//                                "name": "",
//                                "description": "",
//                                "unit_price": 0,
//                                "tax_rate": 0
//                            }
//                        }
//                        ],
//    "auto_create_income": 0,
//    "date": "",
//    "due_selection": "",
//    "due_on": "",
//    "amount": 0,
//    "vat": 0,
//    "total": 0,
//    "notes": "",
//    "paid": "",
//    "paid_on": ""
//}

@end
