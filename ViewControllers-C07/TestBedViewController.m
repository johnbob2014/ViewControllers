//
//  TestBedViewController.m
//  ViewControllers-C07
//
//  Created by 张保国 on 16/6/11.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "TestBedViewController.h"
#import "Utility.h"

#pragma mark - TBVC_06_PageController

#import "GCBookController.h"
@interface TBVC_06_PageController()<GCBookControllerDelegate>
@end
@implementation TBVC_06_PageController{
    GCBookController *bookController;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bookController = [GCBookController bookWithDelegate:self style:GCBookLayoutStyleHorizontalScroll];
    [self addChildViewController:bookController];
    [self.view addSubview:bookController.view];
    [bookController didMoveToParentViewController:self];
    
    [bookController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    bookController.view.frame = self.view.bounds;
    
    [bookController moveToPage:0];
    
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark GCBookControllerDelegate

- (NSInteger)numberOfPages{
    return 10;
}

// Provide a view controller on demand for the given page number
- (id)viewControllerForPage:(NSInteger)pageNumber
{
    if ((pageNumber < 0) || (pageNumber > 9)) return nil;
    float targetWhite = 0.9f - (pageNumber / 10.0f);
    
    // Establish a new controller
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *destinationColor = [UIColor colorWithWhite:targetWhite alpha:1.0f];
    CGFloat destinationOffset = (IS_IPAD) ? 20.0f : 10.0f;
    CGRect fullRect = (CGRect){.size = [[UIScreen mainScreen] applicationFrame].size};
    
    // Draw a shaded swatch
    UIGraphicsBeginImageContext(fullRect.size);
    
    // Border
    [[UIColor blackColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), fullRect);
    [[UIColor whiteColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectInset(fullRect, 3.0f, 3.0f));
    
    // Shadow underneath
    [[UIColor colorWithWhite:0.0f alpha:0.35f] set];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectOffset(CGRectInset(fullRect, 120.0f, 120.0f), destinationOffset, destinationOffset) cornerRadius:32.0f] fill];
    
    // Swatch on top
    [destinationColor set];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(fullRect, 124.0f, 124.0f) cornerRadius:32.0f] fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Add it as an image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [controller.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    ALIGN_VIEW_LEFT(controller.view, imageView);
    ALIGN_VIEW_RIGHT(controller.view, imageView);
    ALIGN_VIEW_TOP(controller.view, imageView);
    ALIGN_VIEW_BOTTOM(controller.view, imageView);
    
    // Add a label
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = [NSString stringWithFormat:@"%0.0f%% White", 100 * targetWhite];
    textLabel.font = [UIFont fontWithName:@"Futura" size:30.0f];
    [controller.view addSubview:textLabel];
    PREPCONSTRAINTS(textLabel);
    ALIGN_VIEW_LEFT_CONSTANT(controller.view, textLabel, 50);
    ALIGN_VIEW_TOP_CONSTANT(controller.view, textLabel, 30);
    
    return controller;
}

@end
