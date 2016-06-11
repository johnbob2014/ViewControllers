//
//  main.m
//  ViewControllers-C07
//
//  Created by 张保国 on 16/6/11.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#define TBVC_06

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "TestBedViewController.h"

@interface TestBedAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong,nonatomic) UIWindow *window;
@end

@implementation TestBedAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = COOKBOOK_PURPLE_COLOR;
    
#ifdef TBVC_06
    TBVC_06_PageController *tbvc = [[TBVC_06_PageController alloc]init];
#endif
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tbvc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([TestBedAppDelegate class]));
    }
}

