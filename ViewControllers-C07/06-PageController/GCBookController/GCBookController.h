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

/**
 翻页方式枚举 - GCBookController
 */
typedef enum{
    GCBookLayoutStyleBook, // side by side in landscape
    GCBookLayoutStyleFlipBook, // side by side in portrait
    GCBookLayoutStyleHorizontalScroll,
    GCBookLayoutStyleVerticalScroll,
}GCBookLayoutStyle;

@protocol GCBookControllerDelegate <NSObject>
@required
/**
 必须：提供指定页面的视图 - GCBookControllerDelegate
 */
- (id)viewControllerForPage:(NSInteger)pageNumber;

@optional
/**
 可选：页面数量 - GCBookControllerDelegate
 */
- (NSInteger)numberOfPages;

/**
 可选：翻转页面时，通过此代理方法获得通知 - GCBookControllerDelegate
 */
- (void)bookControllerDidTurnToPage:(NSNumber *)pageNumber;
@end

@interface GCBookController : UIPageViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

/**
 生成GCBookController类实例，指定代理 - GCBookController
 */
+ (instancetype)bookWithDelegate:(id<GCBookControllerDelegate>)theDelegate;

/**
 生成GCBookController类实例，指定代理和翻页方式 - GCBookController
 */
+ (instancetype)bookWithDelegate:(id<GCBookControllerDelegate>)theDelegate style:(GCBookLayoutStyle)aStyle;

/**
 翻到指定页码 - GCBookController
 */
- (void)moveToPage:(NSUInteger)requestedPage;

/**
 获取当前页码 - GCBookController
 */
- (NSInteger)currentPage;

/**
 代理 - GCBookController
 */
@property (nonatomic, weak) id <GCBookControllerDelegate> bookDelegate;

/**
 翻页方式 - GCBookController
 */
@property (nonatomic) GCBookLayoutStyle layoutStyle;

@end
