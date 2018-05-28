//
//  Define.h
//
//
//  Created by 朱伟 on 15/12/1.
//  Copyright (c) 2015年 朱伟. All rights reserved.
//

#ifndef WuLiu_Define_h
#define WuLiu_Define_h

#define WEAK(weakSelf)      __weak    __typeof(&*self)weakSelf = self;

#define USER @"shareUser"

// 数字联盟
#define PROCESSCOLOR  @"#157EFB"

// userdefault key
#define kTokenKey  @"MU_token"

#define kLastCheckUpdateDate @"kLastCheckUpdateDate"

#define AppStore_URL @"https://itunes.apple.com/us/app/%E5%B8%81%E9%80%9A/id1362466221?l=zh&ls=1&mt=8"
// 开启状态栏菊花
#define NETWORK_INDICATOR_OPEN      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
// 关闭状态栏菊花
#define NETWORK_INDICATOR_CLOSE     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
// Documents
#define SANDBOX_DOCUMENT_PATH       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//适配
#define IPHONE_FIT KMainScreenWidth/375.0

//获取屏幕宽高
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width

#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define KMainSCALE [UIScreen mainScreen].bounds.size.width / 375


//获取视图宽高
#define KViewWidth(a) (a).view.frame.size.width

#define KViewHeiht(a) (a).view.frame.size.height

#define NUMBERS @"0123456789\n"

//颜色
#define RGBA_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define DARK_GRAY_BG  RGBA_COLOR(125 , 125, 125)
#define GREEN_COLOR  RGBA_COLOR(7 , 186, 8)
#define PECENT_GRAY(per)  [UIColor colorWithWhite:per alpha:1.0] //返回一个百分比灰度的颜色

#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kBgColor                        RGBACOLOR(243, 245, 249, 1.0)






//背景图片
//表视图默认图片
#define USERHEAD_BACK_IMAGE @"userHead_n"
//用户默认图片
#define GOODHEAD_BACK_IMAGE @"text2.jpg"

#define FRIENDCIRCLENUM 37

//获取字符串长度
#define Attributes(font) @{NSFontAttributeName:[UIFont systemFontOfSize:font],}

//判断字符串是否为空(仅适用于NSString)
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)


//
//#define LabelSizeWithStr(str,CGSizeMake,myAttributes) [str sizeWithFont:myAttributes constrainedToSize:CGSizeMake lineBreakMode:UILineBreakModeWordWrap];

#define LabelSizeWithStr(str,CGSizeMake,myAttributes) [str boundingRectWithSize:CGSizeMake options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:myAttributes context:nil].size;

#define kIsLogin    @"isLogin"

#define ImgMainPath @"http://120.24.168.104:8088/upload/images/material/"

/**
 *  进制颜色转RGB
 */
#define JColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define JColorFromRGBClear(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0]

#define kStr(name) @property (nonatomic,copy) NSString *name
#define kUI(UI,name) @property (nonatomic,strong) UI *name
#define kAS(AS,name) @property (nonatomic,assign) AS name






//-----------UI-Macro Definination---------//
#define RCDLive_RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RCDLive_HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]

//当前版本
#define RCDLive_IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#if USE_BUNDLE_RESOUCE
#define RCDLive_IMAGE_BY_NAMED(value) [RCDLiveKitUtility imageNamed:(value)ofBundle:@"RongCloud.bundle"]
#else
#define RCDLive_IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]
#endif // USE_BUNDLE_RESOUCE

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif



#ifdef DEBUG
#define RCDLive_DebugLog( s, ... ) NSLog( @"[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define RCDLive_DebugLog( s, ... )
#endif

#define kMTHomeSeachApi @"l12.90.89.16:5006/hpsearch"


#define UIColorHalfFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.5]

#define UIColorThreeFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.3]

#define  kKeyWindow  [[UIApplication sharedApplication] keyWindow]

/*************************************币通*****************************************/
#define WEBREFRESH  @"webRefresh"
#define NETWORKSTATUS  @"networkstatus"


#endif
