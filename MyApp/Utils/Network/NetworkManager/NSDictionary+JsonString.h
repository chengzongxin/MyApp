//
//  NSDictionary+JsonString.h
//  MyApp
//
//  Created by Jason on 2018/5/28.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonString)
//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
