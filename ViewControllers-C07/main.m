//
//  main.m
//  ViewControllers-C07
//
//  Created by 张保国 on 16/6/11.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

//#define TBVC_02
//#define TBVC_04
//#define TBVC_05
//#define TBVC_06
#define TBVC_07

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
    
#ifdef TBVC_02
    TBVC_02_ModalStyle *tbvc = [[TBVC_02_ModalStyle alloc]init];
#endif
    
#ifdef TBVC_05
    TBVC_05_TabBarController *tbvc = [[TBVC_05_TabBarController alloc]init];
#endif
    
#ifdef TBVC_06
    TBVC_06_PageController *tbvc = [[TBVC_06_PageController alloc]init];
#endif
    
#ifdef TBVC_07
    TBVC_07_ViewControllerContainer *tbvc = [[TBVC_07_ViewControllerContainer alloc] init];
#endif
    
    UIViewController *rootVC = nil;
#ifdef TBVC_04
    TBVC_04_Universal_ColorTVC *colorTVC = [[TBVC_04_Universal_ColorTVC alloc] init];
    colorTVC.title = @"Colors";
    
    if (IS_IPAD) {
        TBVC_04_Universal_DetailVC *detailVC = [[TBVC_04_Universal_DetailVC alloc] init];
        UISplitViewController *splitVC = [[UISplitViewController alloc] init];
        splitVC.viewControllers = @[colorTVC,detailVC];
        splitVC.edgesForExtendedLayout = UIRectEdgeNone;
        rootVC = splitVC;
    }else{
        rootVC = [[UINavigationController alloc] initWithRootViewController:colorTVC];
        rootVC.edgesForExtendedLayout = UIRectEdgeNone;
    }

#else
    rootVC = [[UINavigationController alloc]initWithRootViewController:tbvc];
#endif
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([TestBedAppDelegate class]));
    }
}

