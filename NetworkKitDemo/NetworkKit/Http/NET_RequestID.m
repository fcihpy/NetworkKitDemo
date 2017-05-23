//
//  NET_RequestID.m
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "NET_RequestID.h"

@interface NET_RequestID ()

@property (nonatomic, strong, readwrite) NSNumber *APIID;
@property (nonatomic, strong, readwrite) NSString *APIURLStr;
@property (nonatomic, strong, readwrite) Class modelClass;

@end

@implementation NET_RequestID

- (instancetype)initWithAPIID:(NSNumber *)APIID modelClass:(__unsafe_unretained Class)modelClass {
    if (self = [super init]) {
        _APIID = APIID;
        _modelClass = modelClass;
    }
    return self;
}

+ (instancetype)requestWithAPIID:(NSNumber *)APIID modelClass:(__unsafe_unretained Class)modelClass {
    return [[self alloc] initWithAPIID:APIID modelClass:modelClass];
}

- (void)setCompletionHandler:(NetRequestCompletionHandler)completionHandler {
    _completionHandler = completionHandler;
}


//- (void)setUploadResultBlock:(void (^)(BOOL, id))resultBlock
//         uploadProgressBlock:(void (^)(NSProgress *progress))uploadProgressBlock {
//    _completionHandler = completionHandler;
//    _progressBlock = uploadProgressBlock;
//}
//
//- (void)setDownloadResultBlock:(void (^)(BOOL, id))resultBlock
//         downloadProgressBlock:(void (^)(NSProgress *))downloadProgressBlock {
//    _completionHandler = completionHandler;
//    _progressBlock = downloadProgressBlock;
//}

- (void)dealloc {
    if (_completionHandler) {
        _completionHandler = nil;
    }
    if (_progressBlock) {
        _progressBlock = nil;
    }
}

@end

@interface NET_Error ()
@property (nonatomic, strong, readwrite, nullable) NSString *message;
@property (nonatomic, assign, readwrite) NSInteger code;
@end

@implementation NET_Error
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message {
    if (self = [super init]) {
        _message = message;
        _code = code;
    }
    return self;
}

- (instancetype)initWithErrorObject:(id)erroObject {
    if (self = [super init]) {
        if (erroObject && [erroObject isKindOfClass:[NSError class]]) {
            NSError *e = erroObject;
            _message = e.localizedDescription;
            _code = e.code;
        } else if (erroObject && [erroObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = erroObject;
            _message = dict[@"message"];
            _code = [dict[@"errorCode"] integerValue];
        }
       
    }
    return self;
}
+ (instancetype)errorWithErrorObject:(NSError *)erroObject {
    return [[self alloc] initWithErrorObject:erroObject];
}

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [[self alloc] initWithCode:code message:message];
}
@end
