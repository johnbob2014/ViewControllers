//
//  GCBookController.m
//  ViewControllers-C07
//
//  Created by 张保国 on 16/6/11.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "GCBookController.h"

@implementation GCBookController

#pragma mark - Init

+ (instancetype)bookWithDelegate:(id)theDelegate{
    return [self bookWithDelegate:theDelegate style:GCBookLayoutStyleBook];
}

+ (instancetype)bookWithDelegate:(id)theDelegate style:(GCBookLayoutStyle)aStyle{
    UIPageViewControllerNavigationOrientation navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
    if (aStyle == GCBookLayoutStyleFlipBook || aStyle == GCBookLayoutStyleVerticalScroll) {
        navigationOrientation = UIPageViewControllerNavigationOrientationVertical;
    }
    
    UIPageViewControllerTransitionStyle transitionStyle = UIPageViewControllerTransitionStylePageCurl;
    if (aStyle == GCBookLayoutStyleHorizontalScroll || aStyle == GCBookLayoutStyleVerticalScroll) {
        transitionStyle = UIPageViewControllerTransitionStyleScroll;
    }
    
    GCBookController *book = [[GCBookController alloc] initWithTransitionStyle:transitionStyle
                                                         navigationOrientation:navigationOrientation
                                                                       options:nil];
    book.layoutStyle = aStyle;
    book.dataSource = book;
    book.delegate = book;
    book.bookDelegate = theDelegate;
    
    return book;
}

#pragma mark Page Handling

- (NSInteger)currentPage{
    UIViewController *currentVC = [self.viewControllers firstObject];
    return currentVC.view.tag;
}

- (BOOL)useSideBySide:(UIInterfaceOrientation)orientation{
    BOOL isLandScape = UIInterfaceOrientationIsLandscape(orientation);
    
    switch (self.layoutStyle) {
        case GCBookLayoutStyleBook:return YES;
        case GCBookLayoutStyleFlipBook:return isLandScape;
        case GCBookLayoutStyleHorizontalScroll:return NO;
        case GCBookLayoutStyleVerticalScroll:return NO;
    }
}

- (void)updatePageTo:(NSUInteger)newPageNumber{
    self.pageNumber = newPageNumber;
    [[NSUserDefaults standardUserDefaults] setInteger:self.pageNumber forKey:DEFAULTS_BOOKPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.bookDelegate respondsToSelector:@selector(bookControllerDidTurnToPage:)]) {
        [self.bookDelegate bookControllerDidTurnToPage:@(self.pageNumber)];
    }
}

- (UIViewController *)controllerAtPage:(NSInteger)aPageNumber{
    if (self.bookDelegate && [self.bookDelegate respondsToSelector:@selector(viewControllerForPage:)]) {
        UIViewController *vc = [self.bookDelegate viewControllerForPage:aPageNumber];
        vc.view.tag = aPageNumber;
        return vc;
    }else{
        return nil;
    }
}

//Update interface to the given page
- (void)fetchControllersForPage:(NSUInteger)requestedPage orientation:(UIInterfaceOrientation)orientation{
    BOOL sideBySide = [self useSideBySide:orientation];
    NSInteger numberOfPagesNeeded = sideBySide ? 2 : 1;
    NSInteger currentCount = [self.viewControllers count];
    
    NSUInteger leftPage = requestedPage;
    if (sideBySide && (leftPage % 2))
        leftPage = floor(leftPage / 2) * 2;
    
    // Only check against current page when count is appropriate
    if (currentCount && (currentCount == numberOfPagesNeeded)) {
        if (self.pageNumber == requestedPage || self.pageNumber == leftPage) return;
    }
    
    // Decide the prevailing direction by checking the new page against the old
    UIPageViewControllerNavigationDirection direction = (requestedPage > self.pageNumber) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    // Update the controllers
    NSMutableArray *pageControllers = [NSMutableArray array];
    UIViewController *leftVC = [self controllerAtPage:leftPage];
    if (leftVC) [pageControllers addObject:leftVC];
    
    if (sideBySide) {
        UIViewController *ritghVC = [self controllerAtPage:leftPage + 1];
        if (ritghVC) [pageControllers addObject:ritghVC];
    }
    
    [self setViewControllers:pageControllers direction:direction animated:YES completion:nil];
    [self updatePageTo:leftPage];
}

- (void)moveToPage:(NSUInteger)requestedPage{
    [self fetchControllersForPage:requestedPage orientation:self.interfaceOrientation];
}

#pragma mark - UIPageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    [self updatePageTo:_pageNumber + 1];
    return [self controllerAtPage:(viewController.view.tag + 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    [self updatePageTo:_pageNumber - 1];
    return [self controllerAtPage:(viewController.view.tag - 1)];
}

#pragma mark Presentation indices for page indicatoer (Data Source)

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    if (self.bookDelegate && [self.bookDelegate respondsToSelector:@selector(numberOfPages)]) {
        return [self.bookDelegate numberOfPages];
    }else{
        return 0;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
#warning Slightly borked in iOS 6 & 7
    //return 0;
    return [self currentPage];
}

#pragma mark - UIPageViewController Delegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    NSInteger indexOfCurrentViewController = [self currentPage];
    [self fetchControllersForPage:indexOfCurrentViewController orientation:orientation];
    
    BOOL sideBySide = [self useSideBySide:orientation];
    UIPageViewControllerSpineLocation spineLocation = sideBySide ? UIPageViewControllerSpineLocationMid : UIPageViewControllerSpineLocationMin;
    self.doubleSided = sideBySide;
    
    return spineLocation;
}
@end
