//
//  BaseView.m
//  MyApp
//
//  Created by Jason on 2018/5/28.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

+ (instancetype)view {
    return [[self alloc] init];
}

+ (instancetype)xibView {
    NSString* nibName = NSStringFromClass(self);
    
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nibName options:nil];
    for (UIView* view in views) {
        if ([nibName isEqualToString:NSStringFromClass(view.class)]) {
            return (BaseView *)view;
        }
    }
    
    return nil;
}


@end
