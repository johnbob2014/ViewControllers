//
//  RotatingCustomSegue.m
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "RotatingCustomSegue.h"
//#import "UIImage+GM.h"

@implementation RotatingCustomSegue{
    CALayer *transformationLayer;
    UIView __weak *hostView;
}

-(void)perform{
    [self constructRotationLayer];
    [self animateWithDuration:0.5];
}

- (void)constructRotationLayer{
    UIViewController *sourceVC = (UIViewController *) super.sourceViewController;
    UIViewController *destVC = (UIViewController *) super.destinationViewController;
    hostView = sourceVC.view.superview;
    
    transformationLayer = [CALayer layer];
    transformationLayer.frame = CGRectInset(hostView.bounds, 50, 50);
    transformationLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 0);
    CALayer *sourceSubLayer = [self createLayerFromView:sourceVC.view transform:transform];
    [transformationLayer addSublayer:sourceSubLayer];
    
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    if (self.goesForward == NO) {
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        transform = CATransform3DTranslate(transform, hostView.frame.size.width, 0, 0);
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        transform = CATransform3DTranslate(transform, hostView.frame.size.width, 0, 0);
    }
    CALayer *destSubLayer = [self createLayerFromView:destVC.view transform:transform];
    [transformationLayer addSublayer:destSubLayer];
    
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -1000;
    transformationLayer.sublayerTransform = sublayerTransform;
    
    [hostView.layer addSublayer:transformationLayer];
}

- (CALayer *)createLayerFromView:(UIView *)aView transform:(CATransform3D)transform{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.anchorPoint = CGPointMake(1.0f, 1.0f);
    imageLayer.frame = (CGRect){.size = hostView.frame.size};
    imageLayer.transform = transform;
    UIImage *screenShot = [self screenShot:aView];
    imageLayer.contents = (__bridge id) screenShot.CGImage;
    return imageLayer;
}

- (UIImage *)screenShot:(UIView *)aView{
    // Arbitrarily masks to 40%. Use whatever level you like
    UIGraphicsBeginImageContext(hostView.frame.size);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 0.4f);
    CGContextFillRect(UIGraphicsGetCurrentContext(), hostView.frame);
    UIGraphicsEndImageContext();
    return image;
}

- (void)animateWithDuration:(CGFloat)aDuration{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = aDuration;
    
    CGFloat halfWidth = hostView.frame.size.width / 2.0f;
    float multiplier = self.goesForward ? -1.0f : 1.0f;
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"subplayTransform.translation.x"];
    translationX.toValue = @(multiplier * halfWidth);
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"subplayTransform.rotation.y"];
    rotationY.toValue = @(multiplier * M_PI_2);
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"subplayTransform.translation.z"];
    translationZ.toValue = @(-halfWidth);
    
    group.animations = @[rotationY,translationX,translationZ];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [CATransaction flush];
    [transformationLayer addAnimation:group forKey:@"kAnimation"];
}

#pragma mark - CAAnimation Delegate

//Called when the animation begins its active duration.
- (void)animationDidStart:(CAAnimation *)anim{
    UIViewController *sourceVC = (UIViewController *) super.sourceViewController;
    [sourceVC.view removeFromSuperview];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    UIViewController *destVC = (UIViewController *) super.destinationViewController;
    [hostView addSubview:destVC.view];
    [transformationLayer removeFromSuperlayer];
    
    if (self.segueDidCompleteHandler) {
        self.segueDidCompleteHandler();
    }
}

@end
