//
//  NavigationController.m
//  NewStart
//
//  Created by  ZhuHong on 2017/12/27.
//  Copyright © 2017年 CoderHG. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id popDelegate;

@end

@implementation NavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    
    //navigationBar样式设置
//    self.navigationBar.barTintColor = MAIN_GROUNDCOLOR;
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : WHITCOLOR, NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
//    [self.navigationBar setTintColor:WHITCOLOR];    // Do any additional setup after loading the view.
}

//解决手势失效问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

//设置返回按钮样式
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemAction)];
    viewController.navigationItem.backBarButtonItem = backBarButtonItem;
    
}

- (void)backBarButtonItemAction
{
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
