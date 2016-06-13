//
//  RotatingCustomSegue.m
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "RotatingCustomSegue.h"
#import "UIImage+GM.h"

@implementation RotatingCustomSegue{
    CALayer *transformationLayer;
    UIView __weak *hostView;
}

-(void)perform{
    [self constructRotationLayer];
    [self animateWithDuration:0.5];
}

- (void)constructRotationLayer{
    
}

-(void)animateWithDuration:(CGFloat)aDuration{
    
}
@end
