//
//  ProgressHub.m
//  Futures
//
//  Created by Cheng on 2017/7/28.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import "ProgressHub.h"
#import <SVProgressHUD.h>

@implementation ProgressHub

+ (void)show{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:20];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

+ (void)showProgress{
    [SVProgressHUD show];
    // 延迟10秒后消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([SVProgressHUD isVisible]){
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    });
}

+ (void)showProgressWithStatus:(NSString *)status{
    [SVProgressHUD showWithStatus:status];
    // 延迟10秒后消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([SVProgressHUD isVisible]){
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    });
}

+ (void)dismiss{
    [SVProgressHUD dismiss];
}

@end
