//
//  FlipViewController.m
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/12.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "FlipViewController.h"
#import "UIView+AutoLayout.h"

@interface FlipViewController()
@property (strong,nonatomic,readwrite) NSArray *controllers;
@end

@implementation FlipViewController{
    UINavigationBar *navbar;
    UIButton *infoButton;
    BOOL reversedOrder;
}

- (instancetype _Nonnull)initWithFrontController:(UIViewController * _Nonnull)frontVC
                      andBackController:(UIViewController * _Nullable)backVC{
    self = [super init];
    if (self) {
        if (!frontVC) {
            NSLog(@"Error: Attempting to create FlipViewController without a root controller.");
            return nil;
        }
        if (backVC) {
            self.controllers = @[frontVC,backVC];
        }else{
            self.controllers = @[frontVC];
        }
        reversedOrder = NO;
    
        self.view.clipsToBounds = YES;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.controllers.count) {
        NSLog(@"Error:No view controller");
        return;
    }
    UIViewController *frontVC = self.controllers[0];
    UIViewController *backVC = nil;
    if (self.controllers.count > 1) backVC = self.controllers[1];
    
    // 添加前视图
    [self addChildViewController:frontVC];
    [self.view addSubview:frontVC.view];
    [frontVC didMoveToParentViewController:self];
    
    // Clean up instance if re-use
    if (navbar || infoButton) {
        [navbar removeFromSuperview];
        [infoButton removeFromSuperview];
        navbar = nil;
    }
    
    // isBeingPresented : Returns a Boolean value that indicates whether the view controller is in the process of being presented by one of its ancestors.
    BOOL isBeingPresented = self.isBeingPresented;
    NSLog(@"FlipViewController isBeingPresented : %@",isBeingPresented ? @"YES" : @"NO");
    // 添加一个UINavigationBar
    BOOL IS_PHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    CGFloat navbarHeight = IS_PHONE ? 64.0 : 44.0;
    if (isBeingPresented) {
        navbar = [UINavigationBar newAutoLayoutView];
        [self.view addSubview:navbar];
        [navbar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [navbar autoSetDimension:ALDimensionHeight toSize:navbarHeight];
        
        // 如果视图控制器的isBeingPresented属性为真，也就是，则在UINavigationBar右侧添加一个done按钮
        // Right button is done when VC is presented
        self.navigationItem.leftBarButtonItem = nil;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = isBeingPresented? item : nil;
        // Populate the navigation bar
        if (navbar) [navbar setItems:@[self.navigationItem] animated:NO];
    }
    
    // 添加子视图，这里没有使用约束，而是使用的框架，这样进行变换比较简单
    CGFloat verticalOffset = navbar ? navbarHeight : 0.0f;
    CGRect destFrame = CGRectMake(0.0f, verticalOffset, self.view.frame.size.width, self.view.frame.size.height - verticalOffset);
    frontVC.view.frame = destFrame;
    backVC.view.frame = destFrame;
    
    if (self.controllers.count == 2) {
        // 如果有2个子控制器，就添加一个infoButton，用于子控制器之间的切换
        infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        infoButton.tintColor = [UIColor orangeColor];
        [infoButton addTarget:self action:@selector(flipChildController:) forControlEvents:UIControlEventTouchUpInside];
        infoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:infoButton];
        [infoButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0 relation:NSLayoutRelationLessThanOrEqual];
        [infoButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0 relation:NSLayoutRelationLessThanOrEqual];
    }
}

- (void)done:(id)sender{
    // presentingViewController : The view controller that presented this view controller. (read-only)
    // presentedViewController : The view controller that is presented by this view controller, or one of its ancestors in the view controller hierarchy. (read-only)
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 视图消失时，释放当前的子视图控制器
    UIViewController *currentController = (UIViewController *)self.controllers[0];
    [currentController willMoveToParentViewController:nil];
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
}

- (void)flipChildController:(id)sender{
    // Only deal with 2
    if (self.controllers.count < 2) return;
    UIViewController *frontVC =  (UIViewController *)self.controllers[0];
    UIViewController *backVC =  (UIViewController *)self.controllers[1];
    UIViewAnimationOptions transition = reversedOrder ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    infoButton.alpha = 0.0f;
    
    // Prepare the front for removal, the back for adding
    [frontVC willMoveToParentViewController:nil];
    [self addChildViewController:backVC];
    
    // Perform the transition
    [self transitionFromViewController:frontVC
                      toViewController:backVC
                              duration:0.8f
                               options:transition
                            animations:nil
                            completion:^(BOOL finished) {
                                // Bring the Info button back into view
                                [self.view bringSubviewToFront:infoButton];
                                [UIView animateWithDuration:0.5f animations:^{
                                    infoButton.alpha = 1.0f;
                                }];
                                
                                // Finish up transition
                                [frontVC removeFromParentViewController];
                                [backVC didMoveToParentViewController:self];
                                
                                reversedOrder = !reversedOrder;
                                self.controllers = @[backVC,frontVC];
                            }];
}
@end
