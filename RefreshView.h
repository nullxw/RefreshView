//
//  RefreshView.h
//  CheJingJi
//
//  Created by zhmch0329 on 14-9-23.
//  Copyright (c) 2014年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)


#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define RefreshViewLabelTextColor Color(150, 150, 150)

extern const CGFloat RefreshViewViewHeight;
extern const CGFloat RefreshViewFastAnimationDuration;
extern const CGFloat RefreshViewSlowAnimationDuration;

extern NSString *const RefreshViewBundleName;
#define RefreshViewSrcName(file) [RefreshViewBundleName stringByAppendingPathComponent:file]

extern NSString *const RefreshViewFooterPullToRefresh;
extern NSString *const RefreshViewFooterReleaseToRefresh;
extern NSString *const RefreshViewFooterRefreshing;

extern NSString *const RefreshViewHeaderPullToRefresh;
extern NSString *const RefreshViewHeaderReleaseToRefresh;
extern NSString *const RefreshViewHeaderRefreshing;
extern NSString *const RefreshViewHeaderTimeKey;

extern NSString *const RefreshViewContentOffset;
extern NSString *const RefreshViewContentSize;

#pragma mark - 控件的刷新状态
typedef enum {
    RefreshViewStatePulling = 1, // 松开就可以进行刷新的状态
    RefreshViewStateNormal = 2, // 普通状态
    RefreshViewStateRefreshing = 3, // 正在刷新中的状态
    RefreshViewStateWillRefreshing = 4
} RefreshViewState;

#pragma mark - 控件的类型
typedef enum {
    RefreshViewTypeHeader = -1, // 头部控件
    RefreshViewTypeFooter = 1 // 尾部控件
} RefreshViewType;

@interface RefreshView : UIView

#pragma mark - 父控件
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;

#pragma mark - 内部的控件
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;
@property (nonatomic, weak, readonly) UIActivityIndicatorView *activityView;

#pragma mark - 回调
/**
 *  开始进入刷新状态的监听器
 */
@property (weak, nonatomic) id beginRefreshingTaget;
/**
 *  开始进入刷新状态的监听方法
 */
@property (assign, nonatomic) SEL beginRefreshingAction;
/**
 *  开始进入刷新状态就会调用
 */
@property (nonatomic, copy) void (^beginRefreshingCallback)();

#pragma mark - 刷新相关
/**
 *  是否正在刷新
 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/**
 *  开始刷新
 */
- (void)beginRefreshing;
/**
 *  结束刷新
 */
- (void)endRefreshing;

#pragma mark - 交给子类去实现 和 调用
@property (assign, nonatomic) RefreshViewState state;

/**
 *  文字
 */
@property (copy, nonatomic) NSString *pullToRefreshText;
@property (copy, nonatomic) NSString *releaseToRefreshText;
@property (copy, nonatomic) NSString *refreshingText;

@end

/**
 *  下拉刷新
 */
@interface RefreshViewHeaderView : RefreshView

+ (instancetype)header;

@end

/**
 *  上拉刷新
 */
@interface RefreshViewFooterView : RefreshView

+ (instancetype)footer;

@end


@interface UIScrollView (RefreshView)
#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback;

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing;

/**
 *  下拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isHeaderHidden) BOOL headerHidden;

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeaderRefreshing) BOOL headerRefreshing;

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback;

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action;

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing;

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing;

/**
 *  上拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isFooterHidden) BOOL footerHidden;

/**
 *  是否正在上拉刷新
 */
@property (nonatomic, assign, readonly, getter = isFooterRefreshing) BOOL footerRefreshing;

/**
 *  设置尾部控件的文字
 */
@property (copy, nonatomic) NSString *footerPullToRefreshText; // 默认:@"上拉可以加载更多数据"
@property (copy, nonatomic) NSString *footerReleaseToRefreshText; // 默认:@"松开立即加载更多数据"
@property (copy, nonatomic) NSString *footerRefreshingText; // 默认:@"MJ哥正在帮你加载数据..."

/**
 *  设置头部控件的文字
 */
@property (copy, nonatomic) NSString *headerPullToRefreshText; // 默认:@"下拉可以刷新"
@property (copy, nonatomic) NSString *headerReleaseToRefreshText; // 默认:@"松开立即刷新"
@property (copy, nonatomic) NSString *headerRefreshingText; // 默认:@"MJ哥正在帮你刷新..."
@end

