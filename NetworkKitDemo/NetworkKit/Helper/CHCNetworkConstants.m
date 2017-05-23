//
//  CHCNetworkConstants.m
//  CHCMyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "CHCNetworkConstants.h"

NSString * const kNetworkAppStoreENVDomain = @"https://wjyb.zgjky.cn"; //生产环境
//NSString * const kNetworkDevelopENVDomain = @"http://192.168.17.54:8080";//罗刚电脑IP(开发环境)
NSString * const kNetworkDevelopENVDomain = @"http://192.168.19.208:8080";//测试环境(208环境)
NSString * const kNetworkAuthServiceUrl = @"/webservice/wtWebApiH/GetAuthService";
NSString * const kNetworkDataServiceUrl = @"/webservice/wtWebApiH/";
NSString * const kDataServicePrefixURL = @"/Hec_HBC";
NSString * const kWebNetWorkURL = @"https://risk.zgjky.cn/";

NSString * const kShareNetWorkURL = @"https://www.baidu.com";
NSString *ServerBaseURL() {
    NSString *baseUrlString = kNetworkDevelopENVDomain;
#if (kIsAppStoreENV == 1)
    baseUrlString = kNetworkAppStoreENVDomain;
#endif
    return baseUrlString;
}
