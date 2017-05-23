//
//  NET_HttpHelper.m
//  NET_MyBaby
//
//  Created by 支舍社 on 2017/3/2.
//  Copyright © 2017年 Bohuai Chen. All rights reserved.
//

#import "NET_HttpHelper.h"
#import "NET_RequestID.h"
#import <AFNetworking/AFNetworking.h>
#import "NET_NetworkConstants.h"
#import "NET_APIContext.h"
#import "AFNetworkReachabilityManager.h"


static const NSTimeInterval kRequestTimeout = 60.0f;

@interface NET_HttpHelper ()
{
    dispatch_queue_t    _requestQueue;
    NSLock              *_requestLock;
    NSMutableArray      *_dataTaskArray;
    NSInteger           _nextID;
}
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *uploadSessionManager;

@end

@implementation NET_HttpHelper
- (void)dealloc {
    [self cancelAllRequest];
    if (_requestQueue) {
        _requestQueue = nil;
    }
    if (_delegate) {
        _delegate = nil;
    }
}

+ (instancetype)sharedHelper {
    static NET_HttpHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[self new] initData];
    });
    return _instance;
}

- (instancetype)initHttpWithHelperDelegate:(id<NET_HttpHelperDelegate>)helperDelegate {
    if (self = [super init]) {
        _delegate = helperDelegate;
        [self initData];
    }
    return self;
}

- (void)initData {
    _dataTaskArray = [NSMutableArray array];
    _requestLock = [NSLock new];
    _nextID = 0;
}

#pragma mark 断点下载
+ (NET_RequestID *)downloadWithAPIContext:(NET_APIContext *)APIContext {
    return [self downloadWithAPIContext:APIContext];
}

//- (NET_RequestID *)downloadWithAPIContext:(NET_APIContext *)APIContext {
//    NET_RequestID *requestID = [NET_RequestID requestWithAPIID:APIContext.infoType
//                                                  modelClass:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:APIContext.URLString]];
//    NSURLSessionDownloadTask *downloadTask = nil;
//    downloadTask = [self.sessionManager
//                    downloadTaskWithRequest:request
//                    progress:^(NSProgress * _Nonnull downloadProgress) {
//                        //监听传输进度
//                        if (requestID.progressBlock) {
//                            requestID.progressBlock(downloadProgress);
//                        }
//                    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                        //拼接一个文件路径
//                        NSURL *documentURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//                        
//                        //根据网址信息拼接成一个完整的文件存储路径并返回给block
//                        return [documentURL URLByAppendingPathComponent:response.suggestedFilename];
//                    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                        //执行完成后的操作
//                        [self cancelWithRequestID:requestID];
//                    }];
//    requestID.downloadDataTask = downloadTask;
//    
//    //7、添加到队列中,准备执行
//    [self addRequestID:requestID];
//    [_sessionManager.operationQueue addOperationWithBlock:^{
//        [downloadTask resume];
//    }];
//    //8、将结果标识返回
//    return requestID;
//}

#pragma mark 断点上传
+ (NET_RequestID *)uploadDataWithUploadAPIContext:(NET_UploadAPIContext *)APIContext {
    return [[self new] uploadDataWithUploadAPIContext:APIContext];
}

//- (NET_RequestID *)uploadDataWithUploadAPIContext:(NET_UploadAPIContext *)APIContext {
//    NSData *data = APIContext.uploadData;
//    NET_RequestID *requestID = [NET_RequestID requestWithAPIID:APIContext.infoType
//                                                  modelClass:nil];
//    NSURLSessionDataTask *uploadDataTask  = nil;
//    uploadDataTask = [self.uploadSessionManager POST:APIContext.URLString
//                                          parameters:APIContext.parameterDict
//                           constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                               if (data) {
//                                   [formData appendPartWithFileData:data
//                                                               name:APIContext.serverAcceptField
//                                                           fileName:APIContext.fileName
//                                                           mimeType:APIContext.mimeType];
//                               }
//                               
//                           } progress:^(NSProgress * _Nonnull uploadProgress) {
//                               if (requestID.progressBlock) {
//                                   requestID.progressBlock(uploadProgress);
//                               }
//                           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                               if (requestID.completionHandler) {
//                                   requestID.completionHandler(YES,responseObject);
//                               }
//                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                               if (requestID.completionHandler) {
//                                   requestID.completionHandler(NO,error.localizedDescription);
//                               }
//                           }];
//    requestID.dataTask = uploadDataTask;
//    
//    //7、添加到队列中,准备执行
//    [self addRequestID:requestID];
//    [_sessionManager.operationQueue addOperationWithBlock:^{
//        [uploadDataTask resume];
//    }];
//    //8、将结果标识返回
//    return requestID;
//}

- (nonnull NET_RequestID *)requestWithAPIContext:(NET_APIContext *)APIContext {
    return [self requestWithServerType:HttpServerTypeCommonServer APIContext:APIContext];
}

+ (nonnull NET_RequestID *)requestWithAPIContext:(NET_APIContext *)APIContext {
    return [[self sharedHelper] requestWithAPIContext:APIContext];
}

#pragma mark - 普通httpy请求API总的网络请求
- (NET_RequestID *)requestWithServerType:(HttpServerType)serverType
                             APIContext:(NET_APIContext *)APIContext {
    //0、判断网络状态
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        __block NET_RequestID *r = [NET_RequestID new];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (r.completionHandler) {
                NET_Error *error = [NET_Error errorWithCode:999 message:@"网络不可达"];
                r.completionHandler(error,nil);
            }
        });
        return r;
    }
    //1、创建网络请求实例
    __block AFHTTPSessionManager *sessionManager = self.sessionManager;
    if (serverType != HttpServerTypeCommonServer) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //TODO  这个url需要根据业务情况进行修改
            sessionManager =  [[AFHTTPSessionManager alloc]
                               initWithBaseURL:[NSURL URLWithString:@"http://www.test.com"]];
        });
    }
    //2、组装请求参数
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    //2.0根据InfoType进行参数的组装
    if (
        [APIContext.infoType  isEqual: @80002] ||
        [APIContext.infoType  isEqual: @70018]) {
        [parameterDict addEntriesFromDictionary:APIContext.parameterDict];
    } else if ([APIContext.infoType isEqual:@80001]) {
        [parameterDict addEntriesFromDictionary:APIContext.parameterDict];
    } else {
        NSDictionary *tokenDict = nil;
    //2、1 先判断TOKEN是否有效，无效则跳转登录
#if 0
        if (!KToken && !KCode.length) {
            
            if (![APIContext.infoType isEqual:@60003] && ![APIContext.infoType isEqual:@80014] && ![APIContext.infoType isEqual:@50001] && ![APIContext.infoType isEqual:@50005]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kTokenIsInvalidNotification
                                                                    object:nil];
            }
        } else {
            tokenDict = @{@"token" : [NSString stringWithFormat:@"%@",KToken]};
        }
#endif
        
        [parameterDict addEntriesFromDictionary:APIContext.parameterDict];
        [parameterDict addEntriesFromDictionary:tokenDict];
    }
    //2.2 获取请求路径
    NSString *requestUrlStr = APIContext.URLString;
    //3.0 组装请求标识
    NET_RequestID *requestID = [NET_RequestID requestWithAPIID:APIContext.infoType
                                                  modelClass:APIContext.modelClass];
    //4、发起网络请求
    NSURLSessionDataTask *dataTask = nil;
    if (APIContext.methodType == HttpRequestMothodTypePost) {
        dataTask = [sessionManager POST:APIContext.URLString
                             parameters:parameterDict
                               progress:^(NSProgress * _Nonnull uploadProgress) {
                                   
                               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   requestID.responeObject = responseObject;
                                   [self requestFinished:responseObject requestID:requestID];
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   [self requestFailedWithErrorObject:error requestID:requestID];
                               }];
        
    } else if (APIContext.methodType == HttpRequestMothodTypeGet) {
        dataTask = [sessionManager
                    GET:requestUrlStr
                    parameters:parameterDict
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        requestID.responeObject = responseObject;
                        [self requestFinished:responseObject requestID:requestID];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self requestFailedWithErrorObject:error requestID:requestID];
                    }];
    }
    requestID.dataTask = dataTask;
    //5、执行情况通知出去
    if ([[NET_HttpHelper sharedHelper] delegate] && [[[NET_HttpHelper sharedHelper] delegate] respondsToSelector:@selector(httpRequestStart:requestID:)]) {
        [[[NET_HttpHelper sharedHelper] delegate]httpRequestStart:self requestID:requestID];
    }
    //6、添加到队列中,准备执行
    [self addRequestID:requestID];
    [_sessionManager.operationQueue addOperationWithBlock:^{
        [dataTask resume];
    }];
    //7、将结果标识返回
    return requestID;
}

#pragma mark  请求完成执行的方法，包括成功或失败
- (void)requestFinished:(id)responseObject requestID:(NET_RequestID *)requestID {
    if (_requestQueue == nil) {
        _requestQueue = dispatch_queue_create("httpQueue", nil);
    }
    __block __weak typeof(self) weakSelf = self;
    dispatch_async(_requestQueue, ^{
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            //检查网络请求是否成功
            id dict = [self handlerErrorWithDict:responseObject];
            if (nil == dict) {
                //进行数据解析
                id result = [self analysisProtocol:responseObject requestID:requestID];
                //通知处理结果
                [weakSelf notitfySuccessWithResponseObject:result requestID:requestID];
            } else {
                [weakSelf notifyErrorObject:dict requestID:requestID];
            }
        }
        //取消请求操作
        [self cancelWithRequestID:requestID];
    });
}

#pragma mark 请求失败执行的方法
- (void)requestFailedWithErrorObject:(NSError *)errorObject requestID:(NET_RequestID *)requestID{
    //将数据返回给block
    __weak __typeof(self) weakSelf = self;
    NET_dispatch_main_async_safe(^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NET_Error *error = [NET_Error errorWithErrorObject:errorObject];
        if (requestID.completionHandler) {
            requestID.completionHandler(error,nil);
        }
        
        //将数据返回给delegate
        if ([[NET_HttpHelper sharedHelper] delegate] && [[[NET_HttpHelper sharedHelper] delegate] respondsToSelector:@selector(httpRequestDidFailed:requestID:errorObject:)]) {
            [[[NET_HttpHelper sharedHelper] delegate] httpRequestDidFailed:strongSelf
                                      requestID:requestID
                                    errorObject:error];
        }
        //取消请求操作
        [strongSelf cancelWithRequestID:requestID];
        
    });
}

#pragma mark - 成功的回调
- (void)notitfySuccessWithResponseObject:(id)responseObject requestID:(NET_RequestID *)requestID{
    
    __weak __typeof(self) weakSelf = self;
    NET_dispatch_main_async_safe(^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //将数据返回给block
        if (requestID.completionHandler) {
            requestID.completionHandler(nil,responseObject);
        }
        
        //将数据返回给delegate
        if ([[NET_HttpHelper sharedHelper] delegate] &&
            [[[NET_HttpHelper sharedHelper] delegate] respondsToSelector:@selector(httpRequestDidFinish:requestID:successObject:)]) {
            [[[NET_HttpHelper sharedHelper] delegate] httpRequestDidFinish:strongSelf
                                          requestID:requestID
                                      successObject:responseObject];
        }
    });
}

#pragma mark - 失败的回调
- (void)notifyErrorObject:(NSDictionary *)errorObject requestID:(NET_RequestID *)requestID{

    __weak __typeof(self) weakSelf = self;
    NET_dispatch_main_async_safe(^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NET_Error *error = [NET_Error errorWithErrorObject:errorObject];
        //将数据返回给block
        if (requestID.completionHandler) {
            requestID.completionHandler(error,nil);
        }
        
        //将数据返回给delegate
        if ([[NET_HttpHelper sharedHelper] delegate] && [[[NET_HttpHelper sharedHelper] delegate]
                                  respondsToSelector:@selector(httpRequestDidFailed:requestID:errorObject:)]) {
            [[[NET_HttpHelper sharedHelper] delegate] httpRequestDidFailed:strongSelf
                                          requestID:requestID
                                        errorObject:error];
        }
    });
}

#pragma mark - 返回数据的解析
- (id)analysisProtocol:(NSDictionary *)dict requestID:(NET_RequestID *)requestID{
    
    @autoreleasepool {
        id resultData = [dict objectForKey:@"data"];
        //取出要转换的model类，可以为空
        Class modelClassName = requestID.modelClass;
        NETLog(@"数据解析--modelName:%@  APIID = %@ API URL: %@",
               modelClassName,requestID.APIID,requestID.modelClass);
        if (resultData) {
            //根据返回的modelclasss名字进行判断，有值则进行解析，否则，直接返回原数据
            if (modelClassName && [resultData isKindOfClass:[NSDictionary class]]){
                if ([resultData isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *modelArray = [NSMutableArray array];
                    [resultData enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                             NSUInteger idx,
                                                             BOOL * _Nonnull stop) {
                        id modelClass = [[modelClassName alloc]initWithDictionary:obj];
                        [modelArray addObject:modelClass];
                    }];
                    return modelArray;
                }else if ([resultData isKindOfClass:[NSDictionary class]]) {
                    id modelClass = [[modelClassName alloc]initWithDictionary:resultData];
                    return modelClass;
                } else {
                    id modelClass = [[modelClassName alloc]initWithDictionary:resultData];
                    return modelClass;
                }
            }else{
                return resultData;
            }
        }
    }
    return dict;
}

#pragma mark - 判断返回的错误码
- (NET_Error *)handlerErrorWithDict:(NSDictionary *)dict {
    if (!dict) {
        NSDictionary *d = @{@"errorCode" : @999, @"message" :@"服务器异常,没有返回数据"};
        return [NET_Error errorWithErrorObject:dict];
    }
    
    if ([dict[@"state"] integerValue] == 0) {
        return nil;
    } else {
        return [NET_Error errorWithErrorObject:dict];
    }
    return nil;
}

#pragma mark - -------------- LAZY
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        
        //0、判断业务环境是正式，还是测试
        NSURL *baseURL = [NSURL URLWithString:ServerBaseURL()];
        
        // 1.创建http请求对象
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        
        //1.0设置超时时间
        _sessionManager.requestSerializer.timeoutInterval = kRequestTimeout;
        
        //1.1设置请求和返回格式
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //1.2设置可接受的JSON类型
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                                     @"application/json",
                                                                     @"text/json",
                                                                     @"text/javascript", nil];
    }
    return _sessionManager;
}

- (AFHTTPSessionManager *)uploadSessionManager {
    if (!_uploadSessionManager) {
        //0、判断业务环境是正式，还是测试
        NSString *uploadDatabaseUrlString = kNetworkDevelopENVDomain;
#if (kIsAppStoreENV == 1)
        uploadDatabaseUrlString = kNetworkAppStoreENVDomain;
#endif
        
        //1、创建http请求对象
        _uploadSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:uploadDatabaseUrlString]];
        
        //2.0设置超时时间
        _uploadSessionManager.requestSerializer.timeoutInterval = kRequestTimeout;
        
        //2.1设置请求和返回格式
        _uploadSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_uploadSessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        _uploadSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //2.2设置可接受的JSON类型
        _uploadSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                                           @"application/json",
                                                                           @"text/json",
                                                                           @"text/javascript",
                                                                           @"text/plain", nil];
    }
    return _uploadSessionManager;
}
@end

@implementation NET_HttpHelper (RequestID)
#pragma mark - request相关
- (void)addRequestID:(NET_RequestID *)requestID {
    [_requestLock lock];
    [_dataTaskArray addObject:requestID];
    [_requestLock unlock];
}

- (NET_RequestID *)currentRequest {
    NET_RequestID *requestID = nil;
    [_requestLock lock];
    if (_dataTaskArray.count > 0) {
        requestID = [_dataTaskArray lastObject];
    }
    [_requestLock unlock];
    return requestID;
}

- (void)cancelWithRequestID:(NET_RequestID *)requestID {
    if (!_requestQueue) {
        return;
    }
    [_requestLock lock];
    [requestID.dataTask cancel];
    [_dataTaskArray removeObject:requestID];
    [_requestLock unlock];
}

- (void)cancelAllRequest {
    [_requestLock lock];
    [_dataTaskArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[NET_RequestID class]]) {
            NET_RequestID *r = obj;
            [r.dataTask cancel];
        }
    }];
    _delegate = nil;
    [_dataTaskArray removeAllObjects];
    [_requestLock unlock];
}

@end
