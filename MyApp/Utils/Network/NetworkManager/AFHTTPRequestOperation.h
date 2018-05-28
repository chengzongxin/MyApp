//
//  AFHTTPRequestOperation.h
//  silu
//
//  Created by 一路走一路寻 on 17/3/7.
//  Copyright © 2017年 upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFHTTPRequestOperation : NSOperation

/**
 The request used by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;

/**
 The last response received by the operation's connection.
 */
@property (readonly, nonatomic, strong, nullable) NSURLResponse *response;

/**
 The error, if any, that occurred in the lifecycle of the request.
 */
@property (readonly, nonatomic, strong, nullable) NSError *error;

///----------------------------
/// @name Getting Response Data
///----------------------------

/**
 The data received during the request.
 */
@property (readonly, nonatomic, strong, nullable) NSData *responseData;

/**
 The string representation of the response data.
 */
@property (readonly, nonatomic, copy, nullable) NSString *responseString;

/**
 The string encoding of the response.

 If the response does not specify a valid string encoding, `responseStringEncoding` will return `NSUTF8StringEncoding`.
 */
@property (readonly, nonatomic, assign) NSStringEncoding responseStringEncoding;

///-------------------------------
/// @name Managing URL Credentials
///-------------------------------

/**
 Whether the URL connection should consult the credential storage for authenticating the connection. `YES` by default.

 This is the value that is returned in the `NSURLConnectionDelegate` method `-connectionShouldUseCredentialStorage:`.
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/**
 The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.

 This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong, nullable) NSURLCredential *credential;

@end
