//
//  RotatingCustomSegue.h
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 segue完成时调用的块
 */
typedef void (^CompletionHandler) ();

@interface RotatingCustomSegue : UIStoryboardSegue

/**
 是否向前翻页
 */
@property (assign) BOOL goesForward;

/**
 设置块属性，该块将在segue完成时调用
 */
@property (copy,nonatomic) CompletionHandler segueDidCompleteHandler;

@end
