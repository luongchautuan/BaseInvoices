//
//  CountryRepository.m
//  chumbarscratcherscard
//
//  Created by Luong Chau Tuan on 2/7/16.
//  Copyright © 2016 Mantis Solution. All rights reserved.
//

#import "CountryRepository.h"

@implementation CountryRepository

- (id)initWithCountryName:(NSString *)name countryCode:(NSString *)code dialCode:(NSString *)dialCode
{
    self = [super init];
    
    if (self) {
        self.countryName = name;
        self.countryCode = code;
        _dialCode = dialCode;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        self.countryName = [dict valueForKey:@"name"];
        self.countryCode = [dict valueForKey:@"code"];
        _dialCode = [dict valueForKey:@"id"];
    }
    
    return self;
}

- (NSDictionary*)getData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_countryCode forKey:@"code"];
    [dict setObject:_countryName forKey:@"name"];
    [dict setObject:_dialCode forKey:@"id"];
    
    return dict;
}

@end
