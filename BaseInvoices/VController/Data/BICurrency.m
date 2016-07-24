//
//  BICurrency.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICurrency.h"

@implementation BICurrency

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        _currencyID = [dict valueForKey:@"id"];
        _currencyCode = [dict valueForKey:@"iso"];
        _currencyDesc = [dict valueForKey:@"description"];
        _currencySymbol = [dict valueForKey:@"sign"];
    }
    
    return self;
}

- (NSDictionary*)getData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_currencyID forKey:@"id"];
    [dict setObject:_currencyCode forKey:@"iso"];
    [dict setObject:_currencyDesc forKey:@"description"];
    [dict setObject:_currencySymbol forKey:@"sign"];
    
    return dict;
}

@end
