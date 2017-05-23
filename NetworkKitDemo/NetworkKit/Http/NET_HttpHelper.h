//
//  NET_HttpHelper.h
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NET_NetworkConstants.h"
@class NET_RequestID;
@class AFHTTPSessionManager;
@class NET_HttpHelper;
@class NET_APIContext;
@class NET_UploadAPIContext;
@class NET_Error;


@protocol NET_HttpHelperDelegate <NSObject>
/*!
 @auth          zhisheshe
 @date          2017-03-15
 @method        httpRequestDidFinish
 @abstract      请求完成（请求有返回）后的回调方法
 @discussion    代理类中实现
 @param         successObject  LWJHttpRequestHelper对象
 */
- (void)httpRequestDidFinish:(nonnull NET_HttpHelper *)httpHelper
                   requestID:(nonnull NET_RequestID *)requestID
               successObject:(nonnull id)successObject;

/*!
 @auth          zhisheshe
 @date          2017-03-15
 @method        httpRequestDidFailed
 @abstract      请求失败（超时，网络未链接等错误）后的回调方法
 @discussion    代理类中实现
 @param         errorObject  LWJHttpRequestHelper对象
 */
- (void)httpRequestDidFailed:(nonnull NET_HttpHelper *)httpHelper
                   requestID:(nonnull NET_RequestID *)requestID
                 errorObject:(nullable NET_Error *)errorObject;

/*!
 @auth          zhisheshe
 @date          2017-03-15
 @method        httpRequestStart
 @abstract      请求开始的回调方法
 @discussion    代理类中实现
 */

- (void)httpRequestStart:(nonnull NET_HttpHelper *)httpHelper
               requestID:(nonnull NET_RequestID *)requestID;

@end

@interface NET_HttpHelper : NSObject

@property (nonatomic, weak, nullable) id<NET_HttpHelperDelegate>delegate;

+ (nullable instancetype)sharedHelper;

- (nonnull instancetype)initHttpWithHelperDelegate:(_Nonnull id <NET_HttpHelperDelegate>)helperDelegate;

+ (nonnull NET_RequestID *)requestWithAPIContext:(nonnull NET_APIContext *)APIContext;

//! 上传文件
+ (nonnull NET_RequestID *)uploadDataWithUploadAPIContext:(nonnull NET_UploadAPIContext *)APIContext;

//! 下载文件
//TODO! 暂示启用
+ (nonnull NET_RequestID *)downloadWithAPIContext:(nonnull NET_APIContext *)APIContext;

@end

@interface NET_HttpHelper (RequestID)
//!请求标识的操作
- (void)addRequestID:(NET_RequestID *_Nonnull)requestID;
- (void)cancelWithRequestID:(NET_RequestID * _Nonnull)requestID;
- (void)cancelAllRequest;
@end
