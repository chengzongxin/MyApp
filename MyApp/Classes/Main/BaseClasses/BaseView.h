//
//  BaseView.h
//  MyApp
//
//  Created by Jason on 2018/5/28.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

/**
 获取一个实例对象（与new方法类似）
 
 @return 返回对象
 */
+ (instancetype)view;

/**
 获取一个xib关联的对象（保证xib文件名与类名一致）
 
 @return 返回对象
 */
+ (instancetype)xibView;

@end
