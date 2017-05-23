//
//  NET_NetworkConstants.h
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//


#ifndef NET_NetworkConstants_h
#define NET_NetworkConstants_h
#import <Foundation/Foundation.h>

//！ 确定开发环境
#define  kIsAppStoreENV         2 //正式发布:1，开发:2，测试：3

typedef NS_ENUM(NSInteger,HttpRequestMothodType) {
    HttpRequestMothodTypeGet,
    HttpRequestMothodTypePost,
    HttpRequestMothodTypePut,
};

typedef NS_ENUM(NSInteger, HttpServerType) {
    HttpServerTypeCommonServer,
    HttpServerTypeImageServver,
    HttpServerTypeOtherServer,
};
//域名地址及前缀
extern NSString * const kNetworkAppStoreENVDomain;
extern NSString * const kNetworkDevelopENVDomain;
extern NSString * const kNetworkTestENVDomain;

extern NSString * const kDataServicePrefixURL;
//! 获取服务器地址的方法
extern NSString *ServerBaseURL();

//! H5 文卷地址
extern NSString * const kWebNetWorkURL;
//! 下载页
extern NSString * const kShareNetWorkURL;
//要求在主线程操作
extern void NET_dispatch_main_async_safe(dispatch_block_t block);
//url
#define NET__API_URL(_URL) [NSString stringWithFormat:@"%@",_URL];//.9测试

/*打印日志*/
#ifdef DEBUG
#   define NETLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NETLog(...) (void)0
#endif

#undef NETAssert
#if DEBUG
#define NETAssert(a) (!(a) ? assert_output(__func__, __FILE__, __LINE__, #a) : (void)0)
#else
#define NETAssert(a) (void)0
#endif

//判断字符是否为空
#define NET_IS_STR_NIL(objStr)                  (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0 || [objStr isKindOfClass:[NSNull class]])
#define NET_IS_DICT_NIL(objDict)                (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0 || [objDict isKindOfClass:[NSNull class]])
#define NET_IS_ARRAY_NIL(objArray)              (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0 || [objArray isKindOfClass:[NSNull class]])
#define NET_IS_NUM_NIL(objNum)                  (![objNum isKindOfClass:[NSNumber class]] || objNum == nil || [objNum isKindOfClass:[NSNull class]])
#define NET_IS_DATA_NIL(objData)                (![objData isKindOfClass:[NSData class]] || objData == nil || [objData length] <= 0 || [objData isKindOfClass:[NSNull class]])
#define NET_IS_SET_NIL(objData)                 (![objData isKindOfClass:[NSSet class]] || objData == nil || [objData count] <= 0 || [objData isKindOfClass:[NSNull class]])
#endif
