//
//  CHCNetworkConstants.h
//  CHCMyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#ifndef CHCNetworkConstants_h
#define CHCNetworkConstants_h

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

extern NSString * const kNetworkAppStoreENVDomain;
extern NSString * const kNetworkDevelopENVDomain;
extern NSString * const kNetworkAuthServiceUrl;
extern NSString * const kNetworkDataServiceUrl;
extern NSString * const kDataServicePrefixURL;
extern NSString *ServerBaseURL();

//! H5 文卷地址
extern NSString * const kWebNetWorkURL;
//! 下载页
extern NSString * const kShareNetWorkURL;

//#define CHC_API_URL(_URL) [NSString stringWithFormat:@"/HBC%@",_URL];//开发环境
#define CHC_API_URL(_URL) [NSString stringWithFormat:@"%@",_URL];//测试环境(208环境)和生产环境

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
#define NET_IS_STR_NIL(objStr)                  (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)
#define NET_IS_DICT_NIL(objDict)                (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0)
#define NET_IS_ARRAY_NIL(objArray)              (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)
#define NET_IS_NUM_NIL(objNum)                  (![objNum isKindOfClass:[NSNumber class]] || objNum == nil)
#define NET_IS_DATA_NIL(objData)                (![objData isKindOfClass:[NSData class]] || objData == nil || [objData length] <= 0)
#define NET_IS_SET_NIL(objData)                 (![objData isKindOfClass:[NSSet class]] || objData == nil || [objData count] <= 0)

//确定开发环境
#define  kIsAppStoreENV         1 //正式发布:1  ，开发:0

#endif
