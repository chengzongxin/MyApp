//
//  UIScrollView+PeerRefresh.m
//  EmptyDemo
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UIScrollView+PeerRefresh.h"
#define kAnimateDuration 1.0f
#define kAspectRatio(var)   var/375.f * [[UIApplication sharedApplication].delegate window].frame.size.width

@implementation UIScrollView (PeerRefresh)
- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock{
//    NSMutableArray *refreshGiftArr = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=8; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loading_%02zd", i]];
//        [refreshGiftArr addObject:image];
//    }
    
    if (headerBlock) {
        MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (headerBlock) {
                headerBlock();
            }
        }];
        
        header.stateLabel.textColor = [UIColor colorWithHexString:@"#e9e9e9"];
        header.lastUpdatedTimeLabel.textColor = [UIColor colorWithHexString:@"#e9e9e9"];
        header.stateLabel.font = [UIFont systemFontOfSize:kAspectRatio(14)];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:kAspectRatio(14)];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
//        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        self.mj_header = header;
    }
    if (footerBlock) {
        MJRefreshFooter * footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            footerBlock();
        }];
//        [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
//        [footer setTitle:@"" forState:MJRefreshStateIdle];
//        footer.refreshingTitleHidden = YES;
//        footer.stateLabel.hidden = YES;
//        [footer setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
//        [footer setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        self.mj_footer = footer;
    }
    
}

//下拉刷新
- (void)setOnlyRefreshWithHeaderBlock:(void (^)(void))headerBlock {
    
    NSMutableArray *refreshGiftArr = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loading_%02zd", i]];
        [refreshGiftArr addObject:image];
    }
    if (headerBlock) {
  
        MJRefreshGifHeader *header= [MJRefreshGifHeader headerWithRefreshingBlock:^{
            if (headerBlock) {
                headerBlock();
            }
        }];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        self.mj_header = header;
        
    }
   
}

//上拉加载更多
- (void)setRefreshWithFooterBlock:(void (^)(void))footerBlock{
    
    if (footerBlock) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            footerBlock();
        }];
        footer.stateLabel.textColor = [UIColor colorWithHexString:@"#e9e9e9"];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据了..." forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:kAspectRatio(14)];
        
        
        self.mj_footer = footer;
    }
    
}


- (void)headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)footerNoMoreData
{
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}

- (void)hideFooterRefresh{
    self.mj_footer.hidden = YES;
}


- (void)hideHeaderRefresh{
    self.mj_header.hidden = YES;
}

@end
