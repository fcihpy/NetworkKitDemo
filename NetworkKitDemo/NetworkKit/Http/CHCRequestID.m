//
//  CHCRequestID.m
//  CHCMyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "CHCRequestID.h"

@interface CHCRequestID ()

@property (nonatomic, strong, readwrite) NSNumber *APIID;

@property (nonatomic, strong, readwrite) Class modelClass;

@end

@implementation CHCRequestID

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

- (void)setResultBlock:(void (^)(BOOL, id))resultBlock {
    _resultBlock = resultBlock;
}

- (void)setUploadResultBlock:(void (^)(BOOL, id))resultBlock
         uploadProgressBlock:(void (^)(NSProgress *progress))uploadProgressBlock {
    _resultBlock = resultBlock;
    _progressBlock = uploadProgressBlock;
}

- (void)setDownloadResultBlock:(void (^)(BOOL, id))resultBlock
         downloadProgressBlock:(void (^)(NSProgress *))downloadProgressBlock {
    _resultBlock = resultBlock;
    _progressBlock = downloadProgressBlock;
}

- (void)dealloc {
    if (_resultBlock) {
        _resultBlock = nil;
    }
    if (_progressBlock) {
        _progressBlock = nil;
    }
}

@end

@interface CHCError ()
@property (nonatomic, strong, readwrite, nullable) NSString *message;
@property (nonatomic, assign, readwrite) NSInteger code;
@end

@implementation CHCError
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message {
    if (self = [super init]) {
        _message = message;
        _code = code;
    }
    return self;
}

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [[self alloc] initWithCode:code message:message];
}

@end
