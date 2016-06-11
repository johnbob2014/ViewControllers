//
//  GCBookController.h
//  ViewControllers-C07
//
//  Created by 张保国 on 16/6/11.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

// Used for storing the most recent book page used
#define DEFAULTS_BOOKPAGE   @"BookControllerMostRecentPage"

typedef enum{
    GCBookLayoutStyleBook, // side by side in landscape
    GCBookLayoutStyleFlipBook, // side by side in portrait
    GCBookLayoutStyleHorizontalScroll,
    GCBookLayoutStyleVerticalScroll,
}GCBookLayoutStyle;

@protocol GCBookControllerDelegate <NSObject>
- (id)viewControllerForPage:(NSInteger)pageNumber;
@optional
- (NSInteger)numberOfPages;
- (void)bookControllerDidTurnToPage:(NSNumber *)pageNumber;
@end

@interface GCBookController : UIPageViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
/**
 - GCBookController
 */
+ (instancetype)bookWithDelegate:(id<GCBookControllerDelegate>)theDelegate;
+ (instancetype)bookWithDelegate:(id<GCBookControllerDelegate>)theDelegate style:(GCBookLayoutStyle)aStyle;
- (void)moveToPage:(NSUInteger)requestedPage;
- (NSInteger)currentPage;

@property (nonatomic, weak) id <GCBookControllerDelegate> bookDelegate;
@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) GCBookLayoutStyle layoutStyle;

@end
