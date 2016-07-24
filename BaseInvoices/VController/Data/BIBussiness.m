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
    
    if (self)
    {
        _businessID = [dict valueForKey:@"id"];
        _bussinessName = [dict valueForKey:@"name"];
        _bussinessCity = [dict valueForKey:@"city"];
        _bussinessAddress = [dict valueForKey:@"address"];
        _bussinessAddress1 = [dict valueForKey:@"address_line1"];
        _bussinessAddress2 = [dict valueForKey:@"address_line2"];
        _bussinessPostCode = [dict valueForKey:@"postcode"];
        _bussinessVat = [dict valueForKey:@"vat_number"];
        _userID = [dict valueForKey:@"user_id"];
        _currencyID = [dict valueForKey:@"currency_id"];
        _countryID = [dict valueForKey:@"country_id"];
        _bankSortCode = [dict valueForKey:@"sort_code"];
        _bankName = [dict valueForKey:@"bank_name"];
        _bankAccountName = [dict valueForKey:@"bank_account_name"];
        _bankAccountNumber = [dict valueForKey:@"bank_account_number"];
        _bussinessDescription = [dict valueForKey:@"description"];
        _dateStarted = [dict valueForKey:@"date_started"];
        
        if ([dict valueForKey:@"cis_registered"] == nil || [[dict valueForKey:@"cis_registered"] isEqual:[NSNull null]]) {
            _isCISRegistered = NO;
        }
        else
            _isCISRegistered = [[dict valueForKey:@"cis_registered"] boolValue];
        
        if ([dict valueForKey:@"vat_registered"] == nil || [[dict valueForKey:@"vat_registered"] isEqual:[NSNull null]]) {
            _isVatRegistered = NO;
        }
        else
            _isVatRegistered = [[dict valueForKey:@"vat_registered"] boolValue];
        
        _currency = [[BICurrency alloc] initWithDict:[dict valueForKey:@"currency"]];
        _country = [[CountryRepository alloc] initWithDict:[dict valueForKey:@"country"]];
    }
    
    return self;
}

- (NSDictionary*)getDataForSync
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_businessID forKey:@"id"];
    [dict setObject:_userID forKey:@"user_id"];
    
    if (_currencyID == nil || [_currencyID isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"currency_id"];
    }
    else
    {
        [dict setObject:_currencyID forKey:@"currency_id"];
    }
    
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
    
    [dict setObject:_bussinessName forKey:@"name"];

    if (_bussinessDescription == nil || [_bussinessDescription isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"description"];
    }
    else
    {
        [dict setObject:_bussinessDescription forKey:@"description"];
    }

    if (_bussinessAddress == nil || [_bussinessAddress isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address"];
    }
    else
    {
        [dict setObject:_bussinessAddress forKey:@"address"];
    }

    if (_bussinessAddress1 == nil || [_bussinessAddress1 isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address_line1"];
    }
    else
    {
        [dict setObject:_bussinessAddress1 forKey:@"address_line1"];
    }
    
    if (_bussinessAddress2 == nil || [_bussinessAddress2 isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"address_line2"];
    }
    else
    {
        [dict setObject:_bussinessAddress2 forKey:@"address_line2"];
    }
    
    if (_bussinessCity == nil || [_bussinessCity isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"city"];
    }
    else
    {
        [dict setObject:_bussinessCity forKey:@"city"];
    }

    if (_bussinessPostCode == nil || [_bussinessPostCode isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"postcode"];
    }
    else
    {
        [dict setObject:_bussinessPostCode forKey:@"postcode"];
    }
    
    if (_dateStarted == nil || [_dateStarted isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"date_started"];
    }
    else
    {
        [dict setObject:_dateStarted forKey:@"date_started"];
    }

    if (_isCISRegistered) {
        [dict setObject:@"1" forKey:@"cis_registered"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"cis_registered"];
    }
    
    if (_isVatRegistered) {
        [dict setObject:@"1" forKey:@"vat_registered"];
    }
    else
        [dict setObject:@"0" forKey:@"vat_registered"];
    
    if (_bussinessVat == nil || [_bussinessVat isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"vat_number"];
    }
    else
    {
        [dict setObject:_bussinessVat forKey:@"vat_number"];
    }
    
    if (_bankAccountName == nil || [_bankAccountName isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"bank_account_name"];
    }
    else
    {
        [dict setObject:_bankAccountName forKey:@"bank_account_name"];
    }
    
    if (_bankName == nil || [_bankName isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"bank_name"];
    }
    else
    {
        [dict setObject:_bankName forKey:@"bank_name"];
    }
    
    if (_bankSortCode == nil || [_bankSortCode isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"sort_code"];
    }
    else
    {
        [dict setObject:_bankSortCode forKey:@"sort_code"];
    }
    
    if (_bankAccountNumber == nil || [_bankAccountNumber isEqual:[NSNull null]])
    {
        [dict setObject:@"" forKey:@"bank_account_number"];
    }
    else
    {
        [dict setObject:_bankAccountNumber forKey:@"bank_account_number"];
    }
   
    return dict;
}
@end
