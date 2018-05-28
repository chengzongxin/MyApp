//
//  AppDelegate+Config.m
//  MU
//
//  Created by Jason on 2018/3/26.
//  Copyright © 2018年 Matafy. All rights reserved.
//

#import "AppDelegate+Config.h"

@implementation AppDelegate (Config)

- (void)debugMode{
#if defined(DEBUG)||defined(_DEBUG)
//    [NEHTTPEye setEnabled:YES];
    
        // This could also live in a handler for a keyboard shortcut, debug menu item, etc.
//        [[FLEXManager sharedManager] showExplorer];
#endif
}

@end
