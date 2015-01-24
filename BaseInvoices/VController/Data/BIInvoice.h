//
//  BIInvoice.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/10/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIProduct.h"
#import "BICustomer.h"
#import "BIBussiness.h"

@interface BIInvoice : NSObject

@property (nonatomic, retain)BICustomer* customer;

@property (nonatomic)NSMutableArray* products;
@property (nonatomic, retain)BIBussiness* bussiness;

@property (nonatomic)NSString* invoiceName;
@property (nonatomic)NSString* dateInvoice;
@property (nonatomic)NSString* noteInvoice;
@property (nonatomic)NSString* subInvoice;
@property (nonatomic)NSString* taxesInvoice;
@property (nonatomic)NSString* totalInvoices;
@property (nonatomic)NSString* outStanding;

@property (nonatomic)float totalOutSanding;

@property (nonatomic)BOOL isPaided;

@end
