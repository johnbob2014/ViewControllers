//
//  UIImage+GM.m
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "UIImage+GM.h"

@implementation UIImage (GM)

+ (UIImage *)screenShot:(UIView *)aView{
    UIGraphicsBeginImageContext(aView.frame.size);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

@end
