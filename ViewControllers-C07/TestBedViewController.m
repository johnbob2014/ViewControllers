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

#pragma mark - TBVC_05_TabBarController

#pragma mark BrightnessController

@interface BrightnessController : UIViewController
@end

@implementation BrightnessController{
    int brightness;
}

- (UIImage *)buildSwatch:(int)aBrightness{
    CGRect rect = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4.0f];
    [[[UIColor blackColor] colorWithAlphaComponent:(float)aBrightness / 10.0f] set];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BrightnessController *)initWithBrightness:(int)aBrightness{
    self = [super init];
    brightness = aBrightness;
    self.title = [NSString stringWithFormat:@"%d%%", brightness * 10];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[self buildSwatch:brightness] tag:0];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return self;
}

- (void)loadView{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithWhite:(brightness / 10.0f) alpha:1.0f];
}

- (void)viewDidLoad{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [super viewDidLoad];
}

+ (instancetype)controllerWithBrightness:(int)brightness{
    BrightnessController *controller = [[BrightnessController alloc] initWithBrightness:brightness];
    return controller;
}
@end

@interface TBVC_05_TabBarController()<UITabBarControllerDelegate>
@end
@implementation TBVC_05_TabBarController{
    UITabBarController *tbc;
}

- (void)viewDidLoad{
    tbc = [[UITabBarController alloc] init];
    tbc.tabBar.barTintColor = [UIColor blackColor];
    tbc.tabBar.translucent = YES;
    NSArray *controllers = [self createBrightnessControllers];
    tbc.viewControllers = controllers;
    tbc.customizableViewControllers = controllers;
    tbc.delegate = self;
    
    // Restore any previously selected tab
    NSNumber *tabNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTab"];
    if (tabNumber)
        tbc.selectedIndex = [tabNumber intValue];
    
    // 一定要加上下面的语句！！！
    [self addChildViewController:tbc];
    [self.view addSubview:tbc.view];
    [tbc didMoveToParentViewController:self];
}

- (NSArray *)createBrightnessControllers{
    NSMutableArray *controllers = [NSMutableArray array];
    NSArray *titles = [[NSUserDefaults standardUserDefaults]
                       objectForKey:@"tabOrder"];
    
    if (titles)
    {
        // titles retrieved from user defaults
        for (NSString *theTitle in titles)
        {
            BrightnessController *controller =
            [BrightnessController controllerWithBrightness:([theTitle intValue] / 10)];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [controllers addObject:nav];
        }
    }
    else
    {
        // generate all new controllers
        for (int i = 0; i <= 10; i++)
        {
            BrightnessController *controller =
            [BrightnessController controllerWithBrightness:i];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [controllers addObject:nav];
        }
    }
    
    return [NSArray arrayWithArray:controllers];
}

#pragma mark UITabBarControllerDelegate

-(void)tabBarController:(UITabBarController *)tabBarController
didEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
                changed:(BOOL)changed{
    // Collect the view controller order
    NSMutableArray *titles = [NSMutableArray array];
    for (UIViewController *vc in viewControllers)
        [titles addObject:vc.title];
    
    [[NSUserDefaults standardUserDefaults] setObject:titles forKey:@"tabOrder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tabBarController:(UITabBarController *)tabBarController
didSelectViewController:(UIViewController *)viewController{
    NSNumber *tabNumber = [NSNumber numberWithInt:[tabBarController selectedIndex]];
    [[NSUserDefaults standardUserDefaults] setObject:tabNumber forKey:@"selectedTab"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - TBVC_07_ViewControllerContainer
#import "FlipViewController.h"

@implementation TBVC_07_ViewControllerContainer

- (void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Modal", @selector(modal:));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Push", @selector(push:));
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        FlipViewController *flip = [self createAFlipVC];
        flip.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:flip];
        [self.view addSubview:flip.view];
        [flip.view autoCenterInSuperview];
        [flip.view autoSetDimensionsToSize:CGSizeMake(400, 300)];
        [flip didMoveToParentViewController:self];
    }
}

- (void)modal:(id)sender{
    [self.navigationController presentViewController:[self createAFlipVC] animated:YES completion:nil];
}

- (void)push:(id)sender{
    [self.navigationController pushViewController:[self createAFlipVC] animated:YES];
}

- (FlipViewController *)createAFlipVC{
    UIViewController *blueVC = [[UIViewController alloc] init];
    blueVC.view.backgroundColor = [UIColor blueColor];
    UIViewController *cyanVC = [[UIViewController alloc] init];
    cyanVC.view.backgroundColor = [UIColor cyanColor];
    
    FlipViewController *flipVC = [[FlipViewController alloc] initWithFrontController:blueVC andBackController:cyanVC];
    flipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    flipVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    return flipVC;
}
@end

#pragma mark - TBVC_08_CustomSegue
#import "RotatingCustomSegue.h"
#define Inset_Float 50.0

@implementation TBVC_08_CustomSegue{
    NSArray *childControllers;
    UIView *backSplashView;
    UIPageControl *pageControl;
    int vcIndex;
    int nextIndex;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Create backSplash for animation support
    backSplashView = [UIView newAutoLayoutView];
    [self.view addSubview:backSplashView];
    //[backSplashView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 50, -50, -50)];
    [backSplashView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // Add a page view controller
    pageControl = [UIPageControl newAutoLayoutView];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 4;
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    [pageControl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // Load child array from storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"child" bundle:[NSBundle mainBundle]];
    childControllers = @[[storyboard instantiateViewControllerWithIdentifier:@"0"],
                         [storyboard instantiateViewControllerWithIdentifier:@"1"],
                         [storyboard instantiateViewControllerWithIdentifier:@"2"],
                         [storyboard instantiateViewControllerWithIdentifier:@"3"]];
    
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(progress:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeGR.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:leftSwipeGR];
    
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(regress:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipeGR.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:rightSwipeGR];
    
    // Set each child's tag
    for (UIViewController *controller in childControllers)
    {
        controller.view.tag = 1066;
    }
    
    // Initialize scene with first child controller
    vcIndex = 0;
    UIViewController *controller = [childControllers firstObject];
    [self addChildViewController:controller];
    [backSplashView addSubview:controller.view];
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [controller.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(Inset_Float, Inset_Float, Inset_Float, Inset_Float)];
    [controller didMoveToParentViewController:self];
}

// Go forward
- (void)progress:(id)sender
{
    int newIndex = ((vcIndex + 1) % childControllers.count);
    [self switchToView:newIndex goingForward:YES];
}

// Go backwards
- (void)regress:(id) sender
{
    int newIndex = vcIndex - 1;
    if (newIndex < 0) newIndex = childControllers.count - 1;
    [self switchToView:newIndex goingForward:NO];
}

// Transition to new view using custom segue
- (void)switchToView:(int)newIndex goingForward:(BOOL)goesForward{
    if (vcIndex == newIndex) return;
    
    nextIndex = newIndex;
    // Segue to the new controller
    UIViewController *sourceVC = [childControllers objectAtIndex:vcIndex];
    UIViewController *destinationVC = [childControllers objectAtIndex:newIndex];
    destinationVC.view.bounds = sourceVC.view.bounds;
    [sourceVC.view removeConstraints:sourceVC.view.constraints];
    [sourceVC willMoveToParentViewController:nil];
    [self addChildViewController:destinationVC];
    
    RotatingCustomSegue *segue = [[RotatingCustomSegue alloc] initWithIdentifier:@"segue" source:sourceVC destination:destinationVC];
    segue.goesForward = goesForward;
    segue.segueDidCompleteHandler = ^(){
        UIViewController *sourceVC = [childControllers objectAtIndex:vcIndex];
        UIViewController *destinationVC = [childControllers objectAtIndex:nextIndex];
        
        //[sourceVC.view removeFromSuperview]; //在RotatingCustomSegue中实现
        [sourceVC removeFromParentViewController];
        
        [destinationVC didMoveToParentViewController:self];
        //[backSplashView addSubview:destinationVC.view]; //在RotatingCustomSegue中实现
        destinationVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [destinationVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(Inset_Float, Inset_Float, Inset_Float, Inset_Float)];
        
        vcIndex = newIndex;
        pageControl.currentPage = vcIndex;
    };
    [segue perform];
}


@end