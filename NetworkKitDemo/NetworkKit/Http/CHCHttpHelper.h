//
//  CHCHttpHelper.h
//  CHCMyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCNetworkConstants.h"
@class CHCRequestID;
@class AFHTTPSessionManager;
@class CHCHttpHelper;
@class CHCAPIContext;
@class CHCUploadAPIContext;


@protocol CHCHttpHelperDelegate <NSObject>
/*!
 @auth          zhisheshe
 @date          2017-03-15
 @method        httpRequestDidFinish
 @abstract      请求完成（请求有返回）后的回调方法
 @discussion    代理类中实现
 @param         successObject  LWJHttpRequestHelper对象
 */
- (void)httpRequestDidFinish:(nonnull CHCHttpHelper *)httpHelper
                   requestID:(nonnull CHCRequestID *)requestID
               successObject:(nonnull id)successObject;

/*!
 @auth          zhisheshe
 @date          2017-03-15
 @method        httpRequestDidFailed
 @abstract      请求失败（超时，网络未链接等错误）后的回调方法
 @discussion    代理类中实现
 @param         errorObject  LWJHttpRequestHelper对象
 */
- (void)httpRequestDidFailed:(nonnull CHCHttpHelper *)httpHelper
                   requestID:(nonnull CHCRequestID *)requestID
                 errorObject:(nullable NSDictionary *)errorObject;

/*!
 @auth          zhisheshe
 @date          2017-03-15
 @method        httpRequestStart
 @abstract      请求开始的回调方法
 @discussion    代理类中实现
 */

- (void)httpRequestStart:(nonnull CHCHttpHelper *)httpHelper
               requestID:(nonnull CHCRequestID *)requestID;

@end

@interface CHCHttpHelper : NSObject

@property (nonatomic, weak, nullable) id<CHCHttpHelperDelegate>delegate;


+ (nullable instancetype)sharedHelper;

- (nonnull instancetype)initHttpWithHelperDelegate:(_Nonnull id <CHCHttpHelperDelegate>)helperDelegate;

+ (nonnull CHCRequestID *)requestWithAPIContext:(nonnull CHCAPIContext *)APIContext;

//! 上传文件
+ (nonnull CHCRequestID *)uploadDataWithUploadAPIContext:(nonnull CHCUploadAPIContext *)APIContext;

//! 下载文件
//TODO! 暂示启用
+ (nonnull CHCRequestID *)downloadWithAPIContext:(nonnull CHCAPIContext *)APIContext;

@end

@interface CHCHttpHelper (RequestID)
//!请求标识的操作
- (void)addRequestID:(CHCRequestID *_Nonnull)requestID;
- (void)cancelWithRequestID:(CHCRequestID * _Nonnull)requestID;
- (void)cancelAllRequest;
@end
