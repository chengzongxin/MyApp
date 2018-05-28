//
//  NetworkManager.h
//  213123
//
//  Created by liman on 15-1-7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
//#import "AFHTTPRequestOperationManager.h"


typedef void(^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface NetworkManager : NSObject

// GCD单例
+ (NetworkManager *)sharedInstance;

- (void)requestDataTextHtmlWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  @brief  上传网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
 */
// egg >>> uploadData:data name:@"" fileName:@"test.png" mimeType:@"image/jpeg"
//- (void)uploadData:(NSData *)data withURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;



/**
 *  @brief  上传网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数) || 断点续传
 */
//- (void)multipartUploadWithFilePath:(NSString *)path withURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock progress:(void (^)(CGFloat progress))progressBlock;


/**
 *  @brief  请求网络数据 (POST或PUT时, 需要手动拼接url?后面的参数)
 */
//- (void)requestDataWithFrontURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


/**
 *  下载
 */
- (void)downloadWithAddressOfHTTP:(NSString *)httpAdr success:(void (^)(NSString *filePath))successBlock failure:(void (^)(NSNumber *statusCode, NSString *message))failureBlock;

/**
 *  @brief  form/data请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
 */
- (void)requestDataWithMultipartFormData:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;





/**
 HTTP网络请求

 @param url 请求的Url
 @param method http方法:GET/POST/DELETE/PUT
 @param parameter 请求参数
 @param header 请求头
 @param body 请求体
 @param timeoutInterval 超时时间
 @param successBlock 成功的回调
 @param failureBlock 成功的回调
 */
- (void)requestDataWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  集成显示无网络界面网络请求

 @param url 请求的Url
 @param method http方法:GET/POST/DELETE/PUT
 @param parameter 请求参数
 @param header 请求头
 @param body 请求体
 @param VC 需要显示无网络界面的VC
 @param isNeedHUD 是否需要显示SVProgressHub
 @param isAlert 是否需要显示Toast
 @param IsAvailable 网络是否可用
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 */
- (void)requestDataWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body VC:(UIViewController *)VC isHUD:(BOOL)isNeedHUD isAlert:(BOOL)isAlert result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock connect:(void (^)(BOOL))IsAvailable;



- (void)requestDataWithRawURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSDictionary *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
@end
