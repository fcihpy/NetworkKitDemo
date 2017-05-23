//
//  NSObject+JSON.m
//  ChinaHealthCloud
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 JKY. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)


#pragma mark - Generate JSON data from a Foundation object.
- (NSString *)objectToJSONString {
    NSError *error = nil;
    NSData *JSONdata = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!error) {
        NSLog(@"转换json失败");
        return nil;
    }
    return [[NSString alloc] initWithData:JSONdata
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark - Create a Foundation object from JSON data
- (id)objectWithJSON:(id)JSON {
    NSError *error = nil;
    NSData *objectData = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        return nil;
    }
    return objectData;
}


@end
