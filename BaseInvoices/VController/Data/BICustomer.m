//
//  BICustomer.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/22/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICustomer.h"

@implementation BICustomer

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        _customerID = [dict valueForKey:@"id"];
        _countryID = [dict valueForKey:@"country_id"];
        _customerBussinessName = [dict valueForKey:@"company_name"];
        _customerAddress = [dict valueForKey:@"address"];
        _customerAddress1 = [dict valueForKey:@"address_line1"];
        _customerAddress2 = [dict valueForKey:@"address_line2"];
        _userID = [dict valueForKey:@"user_id"];
        
        _customerCity = [dict valueForKey:@"city"];
        _customerPostCode = [dict valueForKey:@"postcode"];
        _customerTelephone = [dict valueForKey:@"telephone"];
        _customerEmail = [dict valueForKey:@"email"];
        _customerKeyContact = [dict valueForKey:@"contact"];
        
        _country = [[CountryRepository alloc] initWithDict:[dict valueForKey:@"country"]];
        
    }
    
    return self;
}


//"id":5990,
//"user_id":4,
//"country_id":77,
//"company_name":"Test",
//"description":"",
//"address":"",
//"address_line1":"",
//"address_line2":"",
//"city":"",
//"postcode":"",
//"telephone":"",
//"email":"",
//"contact":"",
//"created":"2016-07-09 17:03:48",
//"modified":"2016-07-09 17:03:48"


@end
