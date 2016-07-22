//
//  BIBussiness.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIBussiness.h"

@implementation BIBussiness

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _businessID = [dict valueForKey:@"id"];
        _bussinessName = [dict valueForKey:@"name"];
        _bussinessCity = [dict valueForKey:@"city"];
        _bussinessAddress = [dict valueForKey:@"address"];
        _bussinessAddress1 = [dict valueForKey:@"address_line1"];
        _bussinessAddress2 = [dict valueForKey:@"address_line2"];
        _bussinessPostCode = [dict valueForKey:@"postcode"];
        _bussinessVat = [dict valueForKey:@"vat_number"];
        
        _country = [[CountryRepository alloc] initWithDict:[dict valueForKey:@"country"]];
    }
    
    return self;
    
}
@end
