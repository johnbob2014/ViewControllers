//
//  FlipViewController.h
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/12.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 FlipViewController是一个包含1-2个子控制器的容器(Container)
 */
@interface FlipViewController : UIViewController

/**
 初始化方法 - FlipViewController
 */
- (instancetype _Nonnull) initWithFrontController:(UIViewController * _Nonnull)frontVC
                                andBackController:(UIViewController * _Nullable)backVC;

/**
 子视图控制器数组
 */
@property (strong,nonatomic,readonly) NSArray *controllers;

@end
