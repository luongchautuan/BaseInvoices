//
//  BICurrency.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BICurrency : NSObject

@property (nonatomic, strong)NSString* currencyCode;
@property (nonatomic, strong)NSString* currencySymbol;
@property (nonatomic, strong)NSString* countryAndCurrency;
@property (nonatomic, strong) NSString* currencyID;
@property (nonatomic, strong) NSString* currencyDesc;
@property (nonatomic, strong) NSString* currencyName;

- (id)initWithDict:(NSDictionary*)dict;
- (NSDictionary*)getData;

@end
