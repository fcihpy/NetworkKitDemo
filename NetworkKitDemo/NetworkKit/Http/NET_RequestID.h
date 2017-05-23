//
//  NET_RequestID.h
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NET_NetworkConstants.h"
@class NET_Error;

typedef void (^ResultBlock)(BOOL isSuccess, id object);
typedef void(^NETProgressBlock)(NSProgress *uploadProgress);
typedef void(^NetRequestCompletionHandler)(NET_Error *error, id object);

@interface NET_RequestID : NSObject
//! 请求的结果集
@property (nonatomic, copy) NetRequestCompletionHandler completionHandler;
//! 请求消息体
@property (nonatomic, strong) id responeObject;
//! 唯一标识一条消息的ID
@property (nonatomic, strong, readonly) NSNumber *APIID;
//! API url
@property (nonatomic, strong, readonly) NSString *APIURLStr;
//! 请求的原始信息，可以用来取消息一条请求
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSURLSessionUploadTask *uploadDataTask;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadDataTask;

//! 请求的进度结果集
@property (nonatomic, copy, readonly) NETProgressBlock progressBlock;

//! 要解析的Model名
@property (nonatomic, strong, readonly) Class modelClass;

- (void)setCompletionHandler:(NetRequestCompletionHandler)completionHandler;

- (void)setUploadResultBlock:(void (^) (BOOL isSuccess, id object))resultBlock
         uploadProgressBlock:(nullable void (^)(NSProgress *progress))uploadProgressBlock;

- (void)setDownloadResultBlock:(void (^ _Nonnull) (BOOL isSuccess, _Nonnull id object))resultBlock
         downloadProgressBlock:(nullable void (^)( NSProgress * _Nonnull progress))downloadProgressBlock;

+ (nullable instancetype)requestWithAPIID:(nonnull NSNumber *)APIID modelClass:(__unsafe_unretained _Nullable Class)modelClass;

@end

@interface NET_Error : NSObject
@property (nonatomic, strong, readonly, nullable) NSString *message;
@property (nonatomic, assign, readonly) NSInteger code;
+ (nullable instancetype)errorWithErrorObject:(NSError *_Nullable)erroObject;
+ (instancetype _Nullable )errorWithCode:(NSInteger)code message:(NSString *_Nullable)message;
@end
