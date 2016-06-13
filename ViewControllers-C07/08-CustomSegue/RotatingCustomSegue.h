//
//  RotatingCustomSegue.h
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionHandler) ();

@interface RotatingCustomSegue : UIStoryboardSegue
@property (assign) BOOL goesForward;
@property (copy,nonatomic) CompletionHandler segueDidCompleteHandler;
@end
