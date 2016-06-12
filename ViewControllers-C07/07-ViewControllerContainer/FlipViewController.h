//
//  FlipViewController.h
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/12.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipViewController : UIViewController

/**
 初始化方法 - FlipViewController
 */
- (instancetype) initWithFrontController:(UIViewController *)frontVC andBackController:(UIViewController *)backVC;

@end
