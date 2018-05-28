//
//  UIScrollView+PeerEmpty.h
//  EmptyDemo
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>

@interface UIScrollView (PeerEmpty)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
typedef void(^ClickBlock)(void);
@property (nonatomic) ClickBlock clickBlock;                // 点击事件
@property (nonatomic, assign) CGFloat offset;               // 垂直偏移量
@property (nonatomic, strong) NSString *emptyText;          // 空数据显示内容
@property (nonatomic, strong) UIImage *emptyImage;          // 空数据的图片
@property (nonatomic, assign) BOOL isLoading;               // 是否正在加载,如果在加载就不显示


/**
 * 以下方法必须和isLoading属性一起使用,只有isLoading为false,才会显示无数据界面,一般建议在数据加载完成后设置 isloading = false
 */

- (void)setupEmptyData:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock;

@end
