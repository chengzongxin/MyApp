//
//  ProgressHub.h
//  Futures
//
//  Created by Cheng on 2017/7/28.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHub : NSObject

+ (void)show;

+ (void)showProgress;

+ (void)showProgressWithStatus:(NSString *)status;

+ (void)dismiss;

@end
