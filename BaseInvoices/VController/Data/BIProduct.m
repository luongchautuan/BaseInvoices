//
//  BIProduct.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIProduct.h"

@implementation BIProduct

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        _productID = [dict valueForKey:@"product_id"];
        _productName = [[dict valueForKey:@"product"] valueForKey:@"name"];
        _productTaxRate = [[dict valueForKey:@"product"] valueForKey:@"tax_rate"];
        _productUnitPrice = [[dict valueForKey:@"product"] valueForKey:@"unit_price"];
        _productDescription = [[dict valueForKey:@"product"] valueForKey:@"description"];
        _quantityValue = [[dict valueForKey:@"quantity"] intValue];
    }
    
    return self;
}

- (NSDictionary*)getData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_userID forKey:@"user_id"];
    [dict setObject:_productName forKey:@"name"];
    [dict setObject:_productUnitPrice forKey:@"unit_price"];
    [dict setObject:_productDescription forKey:@"description"];
    [dict setObject:_productTaxRate forKey:@"tax_rate"];
    [dict setObject:_productID forKey:@"id"];
    
    return dict;
}
@end
