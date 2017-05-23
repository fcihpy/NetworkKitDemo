//
//  NET_APIManager+Common.m
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/16.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "NET_APIManager+Common.h"

@implementation NET_APIManager (Common)

+ (NET_RequestID *)getServerTime {
    NSString *serverTimeStr = NET__API_URL(@"/system/getServerTime");
    NET_APIContext *context = [NET_APIContext contextWithURLString:serverTimeStr
                                                          infoType:@8004
                                                     parameterDict:nil
                                                        modelClass:nil];
    return [self requestWithAPIContext:context];
}

@end
