
网络工具类使用方法

1、创建一个CHCAPIManager的分类作为各个业务模块网络请求的助手
如：CHCAPIManager+login

2、声明一个方法供业务模块调用的方法
如：   + (CHCRequestID *)loginWithparameter:(NSDictionary *)parameterDict;

3、实现这个网络请求方法，使用类方法实例化CHCAPIContext，

/**
通过网络请求方法、APIURL、infoType，信息字典、要解析的Model名，是否加密等参数实例化一个网络请求类

@param methodType      网络请求方法，是个枚举
@param URLString       除域名以外的请求ulr，
@param infoType        接口标识ID，
@param parameterDict   除去token外的用户请求字典，
@param modelClass      要解析的model名
@param isEncryption    是否加密
@return 返回一个CHCAPIContext实例对象
*/
CHCAPIContext *apiContext = [CHCAPIContext contextWithMethodType:HttpRequestMothodTypePost
URLString:tt
infoType:@1
parameterDict:parameterDict
modelClass:CHCZSS_PassporModel.class
isEncryption:NO];
4、将些实例化对象作为参数传入总的网络请求方法中，此时返回的是一个CHCRequestID
return [[self new] requestWithAPIContext:apiContext];

5、通过调用setresultBlock方法接收返回数据
如：
[[CHCAPIManager loginWithparameter:dict]; setResultBlock:^(BOOL isSuccess, id object) {
NSLog(@"");
}];
6、也可以通过协议，在代理方法中接收返回数据，在baseController中已经继承
- (void)httpRequestStart:(CHCHttpHelper *)httpHelper
requestID:(CHCRequestID *)requestID {}

- (void)httpRequestDidFinish:(CHCHttpHelper *)httpHelper
requestID:(CHCRequestID *)requestID
successObject:(id)successObject {}

- (void)httpRequestDidFailed:(CHCHttpHelper *)httpHelper
requestID:(CHCRequestID *)requestID
errorObject:(NSError *)errorObject {}

7、根据需要，可以通过CHCRequestID.dataTask取消单个或所有网络请求
[CHCRequestID.dataTask cancel]

