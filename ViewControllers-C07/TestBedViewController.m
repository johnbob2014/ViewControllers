//
//  TestBedViewController.m
//  ViewControllers-C07
//
//  Created by 张保国 on 16/6/11.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "TestBedViewController.h"
#import "Utility.h"
#import "UIView+AutoLayout.h"

#pragma mark - TBVC_02_ModalStyle

#pragma mark Custom Modal View Controller
@interface ModalViewController : UIViewController
@end

@implementation ModalViewController
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor magentaColor];
    
    UIButton *btn = [UIButton newAutoLayoutView];
    [self.view addSubview:btn];
    [btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [btn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [btn setTitle:@"Done" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchDown];
}

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


@implementation TBVC_02_ModalStyle{
    UISegmentedControl *segmentedControl;
    UISegmentedControl *iPadStyleControl;
}

- (void)viewDidLoad{
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[@"Slide Fade Flip Curl" componentsSeparatedByString:@" "]];
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
    if (IS_IPAD) {
        iPadStyleControl = [[UISegmentedControl alloc] initWithItems:[@"FormSheet PageSheet CurrentContext OverCC FullScreen OverFS Custom None" componentsSeparatedByString:@" "]];
        iPadStyleControl.selectedSegmentIndex = 0;
        iPadStyleControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:iPadStyleControl];
        [iPadStyleControl autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [iPadStyleControl autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:100 relation:NSLayoutRelationGreaterThanOrEqual];
    }
}

- (void)action:(id)sender{
    ModalViewController *modalVC = [[ModalViewController alloc] init];
    
    int transitionStyles[4]={
        UIModalTransitionStyleCoverVertical,
        UIModalTransitionStyleCrossDissolve,
        UIModalTransitionStyleFlipHorizontal,
        UIModalTransitionStylePartialCurl
    };
    
    modalVC.modalTransitionStyle = transitionStyles[segmentedControl.selectedSegmentIndex];
    
    if (IS_IPAD) {
        int presentationStyles[8]={
            UIModalPresentationFormSheet,
            UIModalPresentationPageSheet,
            //UIModalPresentationPopover,
            UIModalPresentationCurrentContext,
            UIModalPresentationOverCurrentContext,
            UIModalPresentationFullScreen,
            UIModalPresentationOverFullScreen,
            UIModalPresentationCustom,
            UIModalPresentationNone
        };
        
        modalVC.modalPresentationStyle = presentationStyles[iPadStyleControl.selectedSegmentIndex];
        
        /*
        // Partial curl with any non-full screen presentation raises an exception
        if (modalVC.modalTransitionStyle == UIModalTransitionStylePartialCurl) {
            modalVC.modalPresentationStyle = UIModalPresentationFullScreen;
        }
         */
    }
    
    [self.navigationController presentViewController:modalVC animated:YES completion:nil];
}

@end

#pragma mark - TBVC_04_Universal

@interface TBVC_04_Universal_DetailVC ()<UIPopoverControllerDelegate,UISplitViewControllerDelegate>
@property (nonatomic,strong) UIPopoverController *pop;
@end

@implementation TBVC_04_Universal_DetailVC
+ (instancetype)controller{
    TBVC_04_Universal_DetailVC *vc=[[TBVC_04_Universal_DetailVC alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    return vc;
}

// Called upon going into portrait mode, hiding the normal table view
- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    switch (displayMode) {
        case UISplitViewControllerDisplayModeAllVisible:
            NSLog(@"UISplitViewControllerDisplayModeAllVisible");
            break;
        case UISplitViewControllerDisplayModeAutomatic:
            NSLog(@"UISplitViewControllerDisplayModeAutomatic");
            break;
        case UISplitViewControllerDisplayModePrimaryHidden:
            NSLog(@"UISplitViewControllerDisplayModePrimaryHidden");
            break;
        case UISplitViewControllerDisplayModePrimaryOverlay:
            NSLog(@"UISplitViewControllerDisplayModePrimaryOverlay");
            break;
        default:
            break;
    }
}

@end

@implementation TBVC_04_Universal_ColorTVC

+ (instancetype)controller{
    TBVC_04_Universal_ColorTVC *controller = [[TBVC_04_Universal_ColorTVC alloc] init];
    controller.title = @"Colors";
    [controller.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    return controller;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSArray *)selectors
{
    return @[@"whiteColor",@"blackColor", @"redColor", @"greenColor", @"blueColor", @"cyanColor", @"yellowColor", @"magentaColor", @"orangeColor", @"purpleColor", @"brownColor", @"grayColor"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self selectors].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    NSString *selectorString = [self selectors][indexPath.row];
    cell.textLabel.text = selectorString;
    cell.textLabel.textColor = [UIColor performSelector:NSSelectorFromString(selectorString) withObject:nil];
    cell.accessoryType = IS_IPAD ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (IS_IPAD) {
        UIViewController *detailVC = [self.splitViewController.viewControllers lastObject];
        detailVC.view.backgroundColor = cell.textLabel.textColor;
    }else{
        TBVC_04_Universal_DetailVC *detailVC = [TBVC_04_Universal_DetailVC controller];
        detailVC.title = cell.textLabel.text;
        detailVC.view.backgroundColor = cell.textLabel.textColor;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end

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
