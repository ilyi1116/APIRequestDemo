//
//  APIClient.m
//  ApiRequest
//
//  Created by YP on 16/3/9.
//  Copyright © 2016年 yp. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworking.h"

@implementation APIClient
//  采用单例方法创建对象
+ (APIClient *)sharedInstance
{
    static APIClient *apiClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        apiClient = [[self alloc] init];
    });
    return apiClient;
}
/** 执行post网络请求 */
+ (void)executePostRequestWithApi:(APIRequest *)api
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    // 这请求头也可以不设置
    manager.requestSerializer.timeoutInterval = api.timeout;

    [manager POST:api.fullUrl parameters:api.params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *outDic = (NSDictionary *)responseObject;
 
        [api callBackFinishedWithDictionary:outDic];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
        [api callBackFailed:error];

    }];
}
/** 执行Get网络请求 */
+ (void)executeGetRequestWithApi:(APIRequest *)api
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.requestSerializer.timeoutInterval = api.timeout;

    [manager GET:api.fullUrl parameters:api.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSDictionary *outDic = (NSDictionary *)responseObject;
        
        [api callBackFinishedWithDictionary:outDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [api callBackFailed:error];
    }];
}

//  执行不同的网络请求
+ (void)execute:(APIRequest *)api
{

    switch (api.accessType)
    {
        case kApiAccessPost:
        {
            [APIClient executePostRequestWithApi:api];
            break;
        }
        case kApiAccessGet:
        {
            [APIClient executeGetRequestWithApi:api];
            break;
        }
        default:
            break;
    }

}

@end
