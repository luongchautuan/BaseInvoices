//
//  ServiceRequest.h
//  chumbarscratcherscard
//
//  Created by Luong Chau Tuan on 2/24/16.
//  Copyright © 2016 Mantis Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequest : NSObject

+ (ServiceRequest *) getShareInstance;

- (void)serviceRequestWithData:(NSString*)data actionName:(NSString*)actionName result:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completion;

- (void)serviceRequestActionName:(NSString*)actionName result:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completion;

- (void)serviceRequestActionName:(NSString*)actionName accessToken:(NSString *)accessToken result:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completion;

- (void)serviceRequestWithData:(NSString*)data actionName:(NSString*)actionName accessToken:(NSString*)accessToken result:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completion;
- (void)uploadImageWithData:(NSData *)data actionName:(NSString *)actionName accessToken:(NSString *)accessToken result:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completion;

- (void)serviceRequestActionName:(NSString *)actionName accessToken:(NSString *)accessToken method:(NSString*)method result:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completion;

- (void)serviceRequestWithDataStr:(NSString *)data actionName:(NSString *)actionName accessToken:(NSString *)accessToken result:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completion;

@end
