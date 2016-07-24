//
//  BIBussiness.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BICurrency.h"
#import "CountryRepository.h"

@interface BIBussiness : NSObject

@property (nonatomic)NSString* bussinessName;
@property (nonatomic)NSString* bussinessDescription;
@property (nonatomic)NSString* bussinessAddress;
@property (nonatomic)NSString* bussinessAddress1;
@property (nonatomic)NSString* bussinessAddress2;

@property (nonatomic)NSString* bussinessCity;
@property (nonatomic)NSString* bussinessPostCode;
@property (nonatomic)NSString* bussinessVat;
@property (nonatomic)BOOL isVatRegistered;
@property (nonatomic)BOOL isCISRegistered;
@property (nonatomic)NSString* bussinessCurrency;
@property (nonatomic)NSString* currencySymbol;
@property (nonatomic)NSString* bankDetails;

@property (nonatomic, strong) NSString* currencyID;
@property (nonatomic, strong) NSString* countryID;

@property (nonatomic)NSString* bankAccountName;
@property (nonatomic)NSString* bankName;
@property (nonatomic)NSString* bankSortCode;
@property (nonatomic)NSString* bankAccountNumber;

@property (nonatomic, strong) NSString* businessID;
@property (nonatomic, strong) NSString* dateStarted;
@property (nonatomic, strong) NSString* userID;

@property (nonatomic, strong) BICurrency* currency;
@property (nonatomic, strong) CountryRepository* country;

- (id)initWithDict:(NSDictionary*)dict;
- (NSDictionary*)getDataForSync;

@end
