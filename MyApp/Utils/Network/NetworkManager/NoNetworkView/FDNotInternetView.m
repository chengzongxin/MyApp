//
//  FDNotInternetView.m
//  FTAgreement
//
//  Created by syf on 16/1/7.
//  Copyright © 2016年 SYF. All rights reserved.
//



#import "FDNotInternetView.h"
#import "Masonry.h"
@interface FDNotInternetView(){
    UIImageView * _alertIMg;// 没有网络的提示图片
    UILabel * _alertLab;
    UIButton * _alertBtn;
}
@end

@implementation FDNotInternetView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _alertIMg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nonetwork"]];
        [self addSubview:_alertIMg];
        [_alertIMg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@(190));
        }];
        
        _alertLab = [[UILabel alloc] init];
        _alertLab.font = [UIFont boldSystemFontOfSize:14];
        _alertLab.userInteractionEnabled = YES;
        [_alertLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadNetworkDataSourcer)]];
        _alertLab.textAlignment = NSTextAlignmentCenter;
        _alertLab.textColor = [UIColor colorWithHex:0x203F58];
        _alertLab.text = @"网络不给力";
        [self addSubview:_alertLab];
        [_alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(_alertIMg.mas_bottom).with.offset(31);
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadNetworkDataSourcer)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)reloadNetworkDataSourcer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNetworkDataSource:)]) {
        [self.delegate performSelector:@selector(reloadNetworkDataSource:) withObject:nil];
    }
}
@end
