//
//  BICustomer.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/22/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryRepository.h"

@interface BICustomer : NSObject

@property (nonatomic, strong) NSString* customerBussinessName;
@property (nonatomic, strong) NSString* customerEmail;
@property (nonatomic, strong) NSString* customerAddress;
@property (nonatomic, strong) NSString* customerAddress1;
@property (nonatomic, strong) NSString* customerAddress2;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* customerCity;
@property (nonatomic, strong) NSString* customerPostCode;
@property (nonatomic, strong) NSString* customerTelephone;
@property (nonatomic, strong) NSString* customerKeyContact;
@property (nonatomic, strong) NSString* customerID;
@property (nonatomic, strong) NSString* customerDescription;

@property (nonatomic, strong)NSString* countryID;
@property (nonatomic, strong) CountryRepository* country;

- (id)initWithDict:(NSDictionary*)dict;
- (NSDictionary*)getData;

@end
