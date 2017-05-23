//
//  NET_APIContext.h
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/13.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NET_NetworkConstants.h"

@interface NET_APIContext : NSObject
//! http请求的方法，如get post,是个枚举
@property (nonatomic, assign, readonly) HttpRequestMothodType methodType;
//! 除域名以外的请求ulr 如 /httpHeader/Webservice/authURL
@property (nonatomic, strong, readonly, nonnull) NSString *URLString;
//! 本地接口标识ID，用于标识每一条请求的URL,
@property (nonatomic, strong, readonly, nonnull) NSNumber *infoType;
//! 接口请求的参数
@property (nonatomic, strong, readonly, nullable) NSDictionary *parameterDict;
//! 要解析的model名
@property (nonatomic, copy, readonly, nullable) Class modelClass;
//! 加密选项
@property (nonatomic, assign, readonly,getter = isEncryption) BOOL Encryption;

/**
 通过网络请求方法、APIURL、infoType，信息字典、要解析的Model名，是否加密等参数实例化一个网络请求类
 @auth                  zhisheshe
 @date                  2017-03-15
 @param URLString       除域名以外的请求ulr，
 @param infoType        接口标识ID，
 @param parameterDict   除去token外的用户请求字典，
 @param modelClass      要解析的model名
 @return 返回一个NET_APIContext实例对象
 */
+ (nonnull instancetype)contextWithURLString:(nonnull NSString *)URLString
                                    infoType:(nonnull NSNumber *)infoType
                               parameterDict:(nullable NSDictionary *)parameterDict
                                  modelClass:(nullable Class)modelClass;

/**
 通过网络请求方法、APIURL、infoType，信息字典、要解析的Model名，是否加密等参数实例化一个网络请求类
 @auth                  zhisheshe
 @date                  2017-03-15
 @param methodType      网络请求方法，是个枚举
 @param URLString       除域名以外的请求ulr，
 @param infoType        接口标识ID，
 @param parameterDict   除去token外的用户请求字典，
 @param modelClass      要解析的model名
 @return 返回一个NET_APIContext实例对象
 */
+ (nonnull instancetype)contextWithMethodType:(HttpRequestMothodType)methodType
                                    URLString:(nonnull NSString *)URLString
                                     infoType:(nonnull NSNumber *)infoType
                                parameterDict:(nullable NSDictionary *)parameterDict
                                   modelClass:(nullable Class)modelClass;

/**
 通过网络请求方法、APIURL、infoType，信息字典、要解析的Model名，是否加密等参数实例化一个网络请求类
 @auth                  zhisheshe
 @date                  2017-03-15
 @param methodType      网络请求方法，是个枚举
 @param URLString       除域名以外的请求ulr，
 @param infoType        接口标识ID，
 @param parameterDict   除去token外的用户请求字典，
 @param modelClass      要解析的model名
 @param isEncryption    是否加密
 @return 返回一个NET_APIContext实例对象
 */
+ (nonnull instancetype)contextWithMethodType:(HttpRequestMothodType)methodType
                                    URLString:(nonnull NSString *)URLString
                                     infoType:(nonnull NSNumber *)infoType
                                parameterDict:(nullable NSDictionary *)parameterDict
                                   modelClass:(nullable Class)modelClass
                                 isEncryption:(BOOL)isEncryption;
@end

@interface NET_UploadAPIContext : NET_APIContext

@property (nonatomic, strong, nonnull) NSData *uploadData;
@property (nonatomic, strong, nonnull) NSString *serverAcceptField;
@property (nonatomic, strong, nonnull) NSString *fileName;
@property (nonatomic, strong, nonnull) NSString *mimeType;

+(nonnull instancetype)contextWithURLString:(nonnull NSString *)URLString
                                   infoType:(nonnull NSNumber *)infoType
                                 uploadData:(nonnull NSData *)uploadData;

@end
