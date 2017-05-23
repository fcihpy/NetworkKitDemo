//
//  NSObject+JSON.h
//  ChinaHealthCloud
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 JKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

//! JSON 转对象
- (id)objectWithJSON:(id)JSON;

//! 对象转JSON字符串
- (NSString *)objectToJSONString;

@end
