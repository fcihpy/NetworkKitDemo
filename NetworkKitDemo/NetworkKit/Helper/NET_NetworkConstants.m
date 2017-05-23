//
//  NET_NetworkConstants.m
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "NET_NetworkConstants.h"
#import <UIKit/UIKit.h>

#define net_force_inline __inline__ __attribute__((always_inline))

NSString * const kNetworkAppStoreENVDomain = @"https://wjyb.zgjky.cn"; 
NSString * const kNetworkDevelopENVDomain = @"http://192.168.19.208:8080";
NSString * const kNetworkTestENVDomain = @"http://www.test.com";

NSString * const kDataServicePrefixURL = @"/Hec_HBC";
NSString * const kWebNetWorkURL = @"https://risk.zgjky.cn/";
NSString * const kShareNetWorkURL = @"https://www.baidu.com";

NSString *ServerBaseURL() {
    NSString *baseUrlString = kNetworkDevelopENVDomain;
#if (kIsAppStoreENV == 1)
    baseUrlString = kNetworkAppStoreENVDomain;
#elif (kIsAppStoreENV == 3)
    baseUrlString = kNetworkTestENVDomain;
#endif
    return baseUrlString;
}

extern net_force_inline void NET_dispatch_main_async_safe(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
