//
//  CHCAPIManager+Common.m
//  CHCMyBaby
//
//  Created by 支舍社 on 2017/3/16.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "CHCAPIManager+Common.h"
#import "CHCZSS_PassporModel.h"

@implementation CHCAPIManager (Common)

+ (CHCRequestID *)getServerTime {
    NSString *serverTimeStr = CHC_API_URL(@"/system/getServerTime");
    CHCAPIContext *context = [CHCAPIContext contextWithURLString:serverTimeStr infoType:@8004 parameterDict:nil modelClass:nil];
    return [self requestWithAPIContext:context];
}

@end
