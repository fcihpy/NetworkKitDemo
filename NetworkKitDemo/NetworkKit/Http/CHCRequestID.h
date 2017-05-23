//
//  CHCRequestID.h
//  CHCMyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCNetworkConstants.h"

typedef void (^ResultBlock)(BOOL isSuccess, id object);
typedef void(^CHCProgressBlock)(NSProgress *uploadProgress);

@interface CHCRequestID : NSObject
//! 请求的结果集
@property (nonatomic, copy) ResultBlock resultBlock;
//! 请求消息体
@property (nonatomic, strong) id responeObject;
//! 唯一标识一条消息的ID
@property (nonatomic, strong, readonly) NSNumber *APIID;

//! 请求的原始信息，可以用来取消息一条请求
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSURLSessionUploadTask *uploadDataTask;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadDataTask;

//! 请求的进度结果集
@property (nonatomic, copy, readonly) CHCProgressBlock progressBlock;

//! 要解析的Model名
@property (nonatomic, strong, readonly) Class modelClass;

- (void)setResultBlock:(void (^) (BOOL isSuccess, id object))resultBlock;

- (void)setUploadResultBlock:(void (^) (BOOL isSuccess, id object))resultBlock
         uploadProgressBlock:(nullable void (^)(NSProgress *progress))uploadProgressBlock;

- (void)setDownloadResultBlock:(void (^ _Nonnull) (BOOL isSuccess, _Nonnull id object))resultBlock
         downloadProgressBlock:(nullable void (^)( NSProgress * _Nonnull progress))downloadProgressBlock;

+ (nullable instancetype)requestWithAPIID:(nonnull NSNumber *)APIID modelClass:(__unsafe_unretained _Nullable Class)modelClass;

@end

@interface CHCError : NSObject
@property (nonatomic, strong, readonly, nullable) NSString *message;
@property (nonatomic, assign, readonly) NSInteger code;
+ (nullable instancetype)errorWithCode:(NSInteger)code message:(nullable NSString *)message;
@end
