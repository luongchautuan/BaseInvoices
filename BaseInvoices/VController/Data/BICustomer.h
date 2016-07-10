//
//  BICustomer.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/22/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BICustomer : NSObject

@property (nonatomic)NSString* customerBussinessName;
@property (nonatomic)NSString* customerEmail;
@property (nonatomic)NSString* customerAddress;
@property (nonatomic)NSString* customerCity;
@property (nonatomic)NSString* customerPostCode;
@property (nonatomic)NSString* customerTelephone;
@property (nonatomic)NSString* customerKeyContact;
@property (nonatomic)NSString* customerID;
@property (nonatomic, strong)NSString* countryID;

@end
