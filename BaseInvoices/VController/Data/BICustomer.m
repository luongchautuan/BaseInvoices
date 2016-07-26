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

- (NSDictionary*)getData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_customerID forKey:@"id"];
    [dict setObject:_userID forKey:@"user_id"];
    if (_countryID == nil || [_countryID isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"country_id"];
        [dict setObject:@"" forKey:@"country"];
    }
    else
    {
        [dict setObject:_countryID forKey:@"country_id"];
        [dict setObject:_country.getData forKey:@"country"];
    }

    if (_customerBussinessName == nil || [_customerBussinessName isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"company_name"];
    }
    else
    {
        [dict setObject:_customerBussinessName forKey:@"company_name"];
    }

    if (_customerDescription == nil || [_customerDescription isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"description"];
    }
    else
    {
        [dict setObject:_customerDescription forKey:@"description"];
    }

    if (_customerAddress == nil || [_customerAddress isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address"];
    }
    else
    {
        [dict setObject:_customerAddress forKey:@"address"];
    }

    if (_customerAddress1 == nil || [_customerAddress1 isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address_line1"];
    }
    else
    {
        [dict setObject:_customerAddress1 forKey:@"address_line1"];
    }

    if (_customerAddress2 == nil || [_customerAddress2 isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address_line2"];
    }
    else
    {
        [dict setObject:_customerAddress2 forKey:@"address_line2"];
    }
    
    if (_customerCity == nil || [_customerCity isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"city"];
    }
    else
    {
        [dict setObject:_customerCity forKey:@"city"];
    }
    
    if (_customerPostCode == nil || [_customerPostCode isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"postcode"];
    }
    else
    {
        [dict setObject:_customerPostCode forKey:@"postcode"];
    }

    if (_customerTelephone == nil || [_customerTelephone isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"telephone"];
    }
    else
    {
        [dict setObject:_customerTelephone forKey:@"telephone"];
    }
    
    if (_customerEmail == nil || [_customerEmail isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"email"];
    }
    else
    {
        [dict setObject:_customerEmail forKey:@"email"];
    }
    
    if (_customerKeyContact == nil || [_customerKeyContact isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"contact"];
    }
    else
    {
        [dict setObject:_customerKeyContact forKey:@"contact"];
    }
    
    return dict;
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
