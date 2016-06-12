//
//  FlipViewController.m
//  ViewControllers-C07
//
//  Created by BobZhang on 16/6/12.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "FlipViewController.h"
#import "UIView+AutoLayout.h"

@implementation FlipViewController{
    UINavigationBar *navBar;
    UIButton *infoButton;
    NSArray *controllers;
    BOOL reversedOrder;
}

- (instancetype)initWithFrontController:(UIViewController *)frontVC andBackController:(UIViewController *)backVC{
    self = [super init];
    if (self) {
        if (!frontVC) {
            NSLog(@"Error: Attempting to create FlipViewController without a root controller.");
            return self;
        }
        if (backVC) {
            controllers = @[frontVC,backVC];
        }else{
            controllers = @[frontVC];
        }
        reversedOrder = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!controllers.count) {
        NSLog(@"Error:No view controller");
        return;
    }
    UIViewController *frontVC = controllers[0];
    UIViewController *backVC = nil;
    if (controllers.count > 1) backVC = controllers[1];
    
    [self addChildViewController:frontVC];
    [self.view addSubview:frontVC.view];
    [frontVC didMoveToParentViewController:self];
    
    //isBeingPresented : Returns a Boolean value that indicates whether the view controller is in the process of being presented by one of its ancestors.
    BOOL isPresented = self.isBeingPresented;
    
    // Clean up instance if re-use
    if (navBar || infoButton) {
        [navBar removeFromSuperview];
        [infoButton removeFromSuperview];
        navBar = nil;
    }
    
    BOOL IS_PHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    CGFloat navbarHeight = IS_PHONE ? 64.0 : 44.0;
    if (isPresented) {
        navBar = [UINavigationBar newAutoLayoutView];
        [navBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [navBar autoSetDimension:ALDimensionHeight toSize:navbarHeight];
    }
    
    // Right button is done when VC is presented
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = isPresented? item : nil;
    // Populate the navigation bar
    if (navBar) [navBar setItems:@[self.navigationItem] animated:NO];
    
    CGFloat verticalOffset = navBar ? navbarHeight : 0.0f;
    CGRect destFrame = CGRectMake(0.0f, verticalOffset, self.view.frame.size.width, self.view.frame.size.height - verticalOffset);
    frontVC.view.frame = destFrame;
    backVC.view.frame = destFrame;
    
    if (controllers.count == 2) {
        // Set up info button
        infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        infoButton.tintColor = [UIColor orangeColor];
        [infoButton addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
        infoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:infoButton];
        [infoButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [infoButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)done:(id)sender{
    
}

- (void)flip:(id)sender{
    
}
@end
