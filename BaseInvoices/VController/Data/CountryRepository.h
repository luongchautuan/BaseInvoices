//
//  CountryRepository.h
//  chumbarscratcherscard
//
//  Created by Luong Chau Tuan on 2/7/16.
//  Copyright © 2016 Mantis Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryRepository : NSObject

@property (nonatomic, strong) NSString* countryName;
@property (nonatomic, strong) NSString* countryCode;
@property (nonatomic, strong) NSString* dialCode;
@property (nonatomic, strong) NSString* imageUrl;

- (id)initWithCountryName:(NSString*)name countryCode:(NSString*)code dialCode:(NSString*)dialCode;

@end
