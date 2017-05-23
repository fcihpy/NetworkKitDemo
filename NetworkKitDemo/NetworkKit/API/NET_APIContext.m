//
//  NET_APIContext.m
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/13.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "NET_APIContext.h"

@interface NET_APIContext ()
@property (nonatomic, assign, readwrite) HttpRequestMothodType methodType;
@property (nonatomic, strong, readwrite, nonnull) NSString *URLString;
@property (nonatomic, strong, readwrite, nonnull) NSNumber *infoType;
@property (nonatomic, strong, readwrite, nullable ) NSDictionary *parameterDict;
@property (nonatomic, copy, readwrite, nullable ) Class modelClass;
@property (nonatomic, assign, readwrite) BOOL isEncryption;
@end

@implementation NET_APIContext

+ (nonnull instancetype)contextWithURLString:(nonnull NSString *)URLString
                            infoType:(nonnull NSNumber *)infoType
                       parameterDict:(nullable NSDictionary *)parameterDict
                          modelClass:(nullable Class)modelClass {
    return [self contextWithMethodType:HttpRequestMothodTypePost
                             URLString:URLString
                              infoType:infoType
                         parameterDict:parameterDict
                            modelClass:modelClass isEncryption:NO];
}

+ (nonnull instancetype)contextWithMethodType:(HttpRequestMothodType)methodType
                                    URLString:(nonnull NSString *)URLString
                                     infoType:(nonnull NSNumber *)infoType
                                parameterDict:(nullable NSDictionary *)parameterDict
                                   modelClass:(nullable Class)modelClass {
    return [self contextWithMethodType:methodType
                             URLString:URLString
                              infoType:infoType
                         parameterDict:parameterDict
                            modelClass:modelClass
                          isEncryption:NO];
}

+ (nonnull instancetype)contextWithMethodType:(HttpRequestMothodType)methodType
                                    URLString:(nonnull NSString *)URLString
                                     infoType:(nonnull NSNumber *)infoType
                                parameterDict:(nullable NSDictionary *)parameterDict
                                   modelClass:(nullable Class)modelClass
                                 isEncryption:(BOOL)isEncryption {
    return [[self alloc] initWithMethodType:methodType
                                  URLString:URLString
                                   infoType:infoType
                              parameterDict:parameterDict
                                 modelClass:modelClass
                               isEncryption:isEncryption];
}

- (nonnull instancetype)initWithMethodType:(HttpRequestMothodType)methodType
                                 URLString:(nonnull NSString *)URLString
                                  infoType:(nonnull NSNumber *)infoType
                             parameterDict:(nullable NSDictionary *)parameterDict
                                modelClass:(nullable Class)modelClass
                              isEncryption:(BOOL)isEncryption {
    if (self = [super init]) {
        _methodType = methodType;
        _URLString = URLString;
        _parameterDict = parameterDict;
        _modelClass = modelClass;
        _isEncryption = isEncryption;
        _infoType = infoType;
    }
    return self;
}

@end

@implementation NET_UploadAPIContext
+ (instancetype)contextWithURLString:(NSString *)URLString
                            infoType:(NSNumber *)infoType
                          uploadData:(NSData *)uploadData {
    return [self contextWithMethodType:HttpRequestMothodTypePost
                             URLString:URLString
                              infoType:infoType
                         parameterDict:nil
                            modelClass:nil
                          isEncryption:NO];
}
@end


