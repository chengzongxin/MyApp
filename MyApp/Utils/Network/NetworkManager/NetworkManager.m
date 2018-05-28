//
//  NetworkManager.m
//  213123
//
//  Created by liman on 15-1-7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import "NetworkManager.h"
#import "AFURLSessionManager.h"
#import "AFNetworking.h"
#import "UIViewController+FDNotNetController.h"
#import "ProgressHub.h"
#import "NSDictionary+JsonString.h"
#import "Reachability.h"

@implementation NetworkManager

#pragma mark - public method
// GCD单例
+ (NetworkManager *)sharedInstance
{
    static NetworkManager *__singletion = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        __singletion = [[self alloc] init];
        

    });

    
    return __singletion;
}

// 请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)requestDataTextHtmlWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    NETWORK_INDICATOR_OPEN;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //==============================================----  GET方法 ==============================================----
    
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,nil];
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
        
    }
    
    //==============================================----  DELETE方法 ==============================================----
    
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
    }
    
    
    //==============================================----  POST方法 ==============================================----
    
    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager .securityPolicy setAllowInvalidCertificates:YES];
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //        [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //
        //
        //        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //            // 成功
        //            successBlock(nil, responseObject);
        //
        //            // 关闭状态栏菊花
        //            NETWORK_INDICATOR_CLOSE
        //
        //        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"=======================%@", error);
        //            // 失败
        //            failureBlock(nil, error);
        //
        //            // 关闭状态栏菊花
        //            NETWORK_INDICATOR_CLOSE
        //        }];
        
        [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
        
    }
    
    
    //==============================================----  PUT方法 ==============================================----
    
    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
    }
}




// 上传网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)uploadData:(NSData *)data withURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    NETWORK_INDICATOR_OPEN;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //==============================================----  POST方法 ==============================================----

    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];


        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式


        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;

        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {

            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }


        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];


        // 6.请求
        /*
         [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

         // 成功
         successBlock(operation, responseObject);

         // 关闭状态栏菊花
         [self close];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

         // 失败
         failureBlock(operation, error);

         // 关闭状态栏菊花
         [self close];
         }];
         */

        [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 处理上传的数据(非空判断, 否则crash)
            if (data && name && fileName && mimeType) {
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            // 成功
            successBlock(nil, responseObject);

            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 失败
            failureBlock(nil, error);

            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
        
        
        
        // [op start];
    }


    //==============================================----  PUT方法 ==============================================----

    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];


        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式


        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;

        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {

            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }


        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];


        // 6.请求
        [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            // 成功
            successBlock(nil, responseObject);

            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            // 失败
            failureBlock(nil, error);

            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
    }
}





/*
 // 请求网络数据 (POST或PUT时, 需要手动拼接url?后面的参数)
 - (void)requestDataWithFrontURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
 {
 // 开启状态栏菊花
 NETWORK_INDICATOR_OPEN;

 //==============================================---- GET方法 ==============================================----

 if ([method isEqualToString:@"GET"])
 {
 // 1.初始化
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


 // 2.设置请求格式 (默认二进制, 这里不用改也OK)
 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
 //        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式


 // 3.设置超时时间
 manager.requestSerializer.timeoutInterval = timeoutInterval;


 // 4.设置消息头
 if (header) {

 for (NSString *key in [header allKeys]) {
 [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
 }
 }


 // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
 manager.responseSerializer = [AFHTTPResponseSerializer serializer];


 // 6.请求
 [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

 // 成功
 successBlock(operation, responseObject);

 // 关闭状态栏菊花
 [self close];

 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

 // 失败
 failureBlock(operation, error);

 // 关闭状态栏菊花
 [self close];
 }];
 }


 //==============================================----  DELETE方法 ==============================================----

 if ([method isEqualToString:@"DELETE"])
 {
 // 1.初始化
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


 // 2.设置请求格式 (默认二进制, 这里不用改也OK)
 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
 //        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式


 // 3.设置超时时间
 manager.requestSerializer.timeoutInterval = timeoutInterval;


 // 4.设置消息头
 if (header) {

 for (NSString *key in [header allKeys]) {
 [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
 }
 }


 // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
 manager.responseSerializer = [AFHTTPResponseSerializer serializer];


 // 6.请求
 [manager DELETE:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

 // 成功
 successBlock(operation, responseObject);

 // 关闭状态栏菊花
 [self close];

 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

 // 失败
 failureBlock(operation, error);

 // 关闭状态栏菊花
 [self close];
 }];
 }


 //==============================================----  POST方法, PUT方法 ==============================================----

 if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])
 {
 // 0. 拼接完整的URL地址
 NSMutableArray *laterArr = [NSMutableArray array];

 for (NSString *key in [parameter allKeys]) {

 NSString *keyValue = [key stringByAppendingFormat:@"=%@",[parameter objectForKey:key]];
 [laterArr addObject:keyValue];
 }

 NSString *laterURL = [laterArr componentsJoinedByString:@"&"];
 NSString *finalURL = [url stringByAppendingFormat:@"?%@", laterURL];


 // 1.初始化
 //        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
 //        NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:url parameters:parameter error:nil];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalURL]];


 // 2.设置请求类型
 request.HTTPMethod = method;


 // 3.设置超时时间
 request.timeoutInterval = timeoutInterval;


 // 4.设置消息头
 if (header) {

 for (NSString *key in [header allKeys]) {
 [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
 }
 }


 // 5.设置消息体
 if (body) {

 request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
 }


 // 6.请求
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

 // 成功
 successBlock(operation, responseObject);

 // 关闭状态栏菊花
 [self close];

 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

 // 失败
 failureBlock(operation, error);

 // 关闭状态栏菊花
 [self close];
 }];

 [operation start];
 //        [operation waitUntilFinished]; //同步 
 }
 }
*/



// 上传网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数) || 断点续传
- (void)multipartUploadWithFilePath:(NSString *)path withURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock progress:(void (^)(CGFloat progress))progressBlock;
{
    if ([method isEqualToString:@"POST"]) {

        // 1. Create `AFHTTPRequestSerializer` which will create your request.
        //    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        AFHTTPRequestSerializer *serializer = [AFJSONRequestSerializer serializer];


        // 2. Create an `NSMutableURLRequest`.
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:method URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

            [formData appendPartWithFileURL:[NSURL URLWithString:path] name:name fileName:fileName mimeType:mimeType error:nil];

        } error:nil];

        // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //        AFHTTPRequestOperation *operation =
        //        [manager HTTPRequestOperationWithRequest:request
        //                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                                             NSLog(@"Success %@", responseObject);
        //                                             successBlock(operation, responseObject);
        //
        //                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //                                             NSLog(@"Failure %@", error.description);
        //                                             failureBlock(operation, error);
        //
        //                                         }];



        // 4. Set the progress block of the operation.
        //        [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
        //                                            long long totalBytesWritten,
        //                                            long long totalBytesExpectedToWrite) {
        //            NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        //            progressBlock(totalBytesWritten/totalBytesExpectedToWrite);
        //        }];
        //
        //        // 5. Begin!
        //        [operation start];
    }
}

// 下载
- (void)downloadWithAddressOfHTTP:(NSString *)httpAdr success:(void (^)(NSString *filePath))successBlock failure:(void (^)(NSNumber *statusCode, NSString *message))failureBlock
{
    // 先判断文件是否已下载
    NSString *filePath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:[httpAdr lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 文件已存在
        successBlock(filePath);
        return;
    }


    //==========================================================================================================================================----

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpAdr]];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {

        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];

    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了

        if (filePath) {
            NSString *filePathString = [[filePath absoluteString] substringFromIndex:7];
            successBlock(filePathString);
        }else{
            failureBlock([NSNumber numberWithInteger:[error code]], [error localizedDescription]);
        }
    }];

    [downloadTask resume];
}


// form/data请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)requestDataWithMultipartFormData:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    NETWORK_INDICATOR_OPEN;

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    //==============================================----  GET方法 ==============================================----
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //JSON请求格式
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {

            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 6.请求

        [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successBlock(nil, responseObject);
             // 关闭状态栏菊花
             NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            failureBlock(nil, error);
             // 关闭状态栏菊花
             NETWORK_INDICATOR_CLOSE;
        }];
        
    }

    //==============================================----  DELETE方法 ==============================================----
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            successBlock(nil, responseObject);
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
    }

    //==============================================----  POST方法 ==============================================----
    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //JSON请求格式
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        // 4.设置消息头
        if (header) {

            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 6.请求
        [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            successBlock(nil, responseObject);
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
    }
    //==============================================----  PUT方法 ==============================================----
    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 6.请求
        [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            successBlock(nil, responseObject);
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
    }
}


#pragma mark - HTTP网络请求
// 请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)requestDataWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    NETWORK_INDICATOR_OPEN;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //==============================================----  GET方法 ==============================================----
    
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *result = [NSDictionary dictionaryWithJsonString:[responseObject mj_JSONString]];
            NSLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",parameter,url,result);
            // 成功
            successBlock(nil, result);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",parameter,url,error.userInfo);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
        
    }
    
    //==============================================----  POST方法 ==============================================----
    
    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager .securityPolicy setAllowInvalidCertificates:YES];
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *result = [NSDictionary dictionaryWithJsonString:[responseObject mj_JSONString]];
            NSLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",parameter,url,result);
            // 成功
            successBlock(nil, result);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",parameter,url,error.userInfo);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
        
    }
    
    //==============================================----  DELETE方法 ==============================================----
    
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
    }
    
    
    //==============================================----  PUT方法 ==============================================----
    
    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
    }
}

#pragma mark - 集成显示无网络界面网络请求
// 请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)requestDataWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body VC:(UIViewController *)VC isHUD:(BOOL)isNeedHUD isAlert:(BOOL)isAlert result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock connect:(void (^)(BOOL))IsAvailable
{
    
    //1. 检测网络
    BOOL isServiceAvailable = YES;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if ((reachability.isConnectionRequired) || (NotReachable == reachability.currentReachabilityStatus)) {
        isServiceAvailable = NO;
        
    } else if((ReachableViaWiFi == reachability.currentReachabilityStatus) || (ReachableViaWWAN == reachability.currentReachabilityStatus)){
        isServiceAvailable = YES;
    }else{
        
    }
    
    if(IsAvailable){// 回调网络状态
        IsAvailable(isServiceAvailable);
    }
    if(!isServiceAvailable){// M没有网
        [VC showNonetWork];
        
        if(isAlert)
//            [SVProgressHUD showErrorWithStatus:@"网络不给力，请稍后再试"];
        return;
    }
    else{// 有网
        [VC hiddenNonetWork];
    }
    
    if(isNeedHUD) [ProgressHub show];
    
    // 开启状态栏菊花
    NETWORK_INDICATOR_OPEN;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSTimeInterval timeoutInterval = 25;
    
    //==============================================----  GET方法 ==============================================----
    
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            // 成功
            NSDictionary *result = [NSDictionary dictionaryWithJsonString:[responseObject mj_JSONString]];
            NSLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",parameter,url,result);
            
            successBlock(nil, result);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
            if(isNeedHUD) [ProgressHub dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",parameter,url,error.userInfo);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
            if(isNeedHUD) [ProgressHub dismiss];
        }];
        
    }
    
    //==============================================----  POST方法 ==============================================----
    
    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager .securityPolicy setAllowInvalidCertificates:YES];
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            NSDictionary *result = [NSDictionary dictionaryWithJsonString:[responseObject mj_JSONString]];
            NSLog(@"Success: 参数是 %@,接口url是 %@ 请求成功,结果是 %@",parameter,url,result);
            
            successBlock(nil, result);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
            
            if(isNeedHUD) [ProgressHub dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@" NET_failure:参数是 %@,接口url是 %@, 网络错误 %@",parameter,url,error.userInfo);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
            
            if(isNeedHUD) [ProgressHub dismiss];
        }];
        
    }
    
    //==============================================----  DELETE方法 ==============================================----
    
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
            if(isNeedHUD) [ProgressHub dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
            
            if(isNeedHUD) [ProgressHub dismiss];
        }];
    }
    
    
    //==============================================----  PUT方法 ==============================================----
    
    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
            if(isNeedHUD) [ProgressHub dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
            if(isNeedHUD) [ProgressHub dismiss];
        }];
    }
}

#pragma mark - HTTP-RAW-网络请求
// Ares

// 请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)requestDataWithRawURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSDictionary *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    NETWORK_INDICATOR_OPEN;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //==============================================----  GET方法 ==============================================----
    
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
        
    }
    
    //==============================================----  DELETE方法 ==============================================----
    
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE
        }];
    }
    
    
    //==============================================----  POST方法 ==============================================----
    
    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameter error:nil];
        
         [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (body.count) {
            NSData *postData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
            [request setHTTPBody:postData];
        }
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                     @"text/html",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"text/plain",
                                                     nil];
        manager.responseSerializer = responseSerializer;
        
        
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                successBlock(nil,responseObject);
                
            } else {
                failureBlock(nil,error);
            }
        }] resume];
        
    }
    
    
    //==============================================----  PUT方法 ==============================================----
    
    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //JSON请求格式
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"ios-version"];
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 成功
            successBlock(nil, responseObject);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"=======================%@", error);
            // 失败
            failureBlock(nil, error);
            
            // 关闭状态栏菊花
            NETWORK_INDICATOR_CLOSE;
        }];
    }
}


/*

 */


@end
