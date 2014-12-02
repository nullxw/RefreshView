//
//  RefreshView.m
//  CheJingJi
//
//  Created by zhmch0329 on 14-9-23.
//  Copyright (c) 2014年 zhmch0329. All rights reserved.
//

#import "RefreshView.h"
#import <objc/message.h>

const CGFloat RefreshViewViewHeight = 64.0;
const CGFloat RefreshViewFastAnimationDuration = 0.25;
const CGFloat RefreshViewSlowAnimationDuration = 0.4;

NSString *const RefreshViewBundleName = @"RefreshView.bundle";

NSString *const RefreshViewFooterPullToRefresh = @"上拉可以加载更多数据";
NSString *const RefreshViewFooterReleaseToRefresh = @"松开立即加载更多数据";
NSString *const RefreshViewFooterRefreshing = @"正在加载...";

NSString *const RefreshViewHeaderPullToRefresh = @"下拉可以刷新";
NSString *const RefreshViewHeaderReleaseToRefresh = @"松开立即刷新";
NSString *const RefreshViewHeaderRefreshing = @"正在刷新...";
NSString *const RefreshViewHeaderTimeKey = @"RefreshViewHeaderView";

NSString *const RefreshViewContentOffset = @"contentOffset";
NSString *const RefreshViewContentSize = @"contentSize";

#pragma mark -
#pragma mark - UIScrollView + RefreshView

@interface UIScrollView()

@property (weak, nonatomic) RefreshViewHeaderView *header;
@property (weak, nonatomic) RefreshViewFooterView *footer;

@end

@implementation UIScrollView (RefreshView)

#pragma mark - 运行时相关
static char RefreshViewHeaderViewKey;
static char RefreshViewFooterViewKey;

- (void)setHeader:(RefreshViewHeaderView *)header {
    [self willChangeValueForKey:@"RefreshViewHeaderViewKey"];
    objc_setAssociatedObject(self, &RefreshViewHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"RefreshViewHeaderViewKey"];
}

- (RefreshViewHeaderView *)header {
    return objc_getAssociatedObject(self, &RefreshViewHeaderViewKey);
}

- (void)setFooter:(RefreshViewFooterView *)footer {
    [self willChangeValueForKey:@"RefreshViewFooterViewKey"];
    objc_setAssociatedObject(self, &RefreshViewFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"RefreshViewFooterViewKey"];
}

- (RefreshViewFooterView *)footer {
    return objc_getAssociatedObject(self, &RefreshViewFooterViewKey);
}

#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback
{
    // 1.创建新的header
    if (!self.header) {
        RefreshViewHeaderView *header = [RefreshViewHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshingCallback = callback;
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的header
    if (!self.header) {
        RefreshViewHeaderView *header = [RefreshViewHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置目标和回调方法
    self.header.beginRefreshingTaget = target;
    self.header.beginRefreshingAction = action;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing
{
    [self.header endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setHeaderHidden:(BOOL)hidden
{
    self.header.hidden = hidden;
}

- (BOOL)isHeaderHidden
{
    return self.header.isHidden;
}

- (BOOL)isHeaderRefreshing
{
    return self.header.state == RefreshViewStateRefreshing;
}

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback
{
    // 1.创建新的footer
    if (!self.footer) {
        RefreshViewFooterView *footer = [RefreshViewFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshingCallback = callback;
}

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的footer
    if (!self.footer) {
        RefreshViewFooterView *footer = [RefreshViewFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置目标和回调方法
    self.footer.beginRefreshingTaget = target;
    self.footer.beginRefreshingAction = action;
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing
{
    [self.footer beginRefreshing];
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)hidden
{
    self.footer.hidden = hidden;
}

- (BOOL)isFooterHidden
{
    return self.footer.isHidden;
}

- (BOOL)isFooterRefreshing
{
    return self.footer.state == RefreshViewStateRefreshing;
}

/**
 *  文字
 */
- (void)setFooterPullToRefreshText:(NSString *)footerPullToRefreshText
{
    self.footer.pullToRefreshText = footerPullToRefreshText;
}

- (NSString *)footerPullToRefreshText
{
    return self.footer.pullToRefreshText;
}

- (void)setFooterReleaseToRefreshText:(NSString *)footerReleaseToRefreshText
{
    self.footer.releaseToRefreshText = footerReleaseToRefreshText;
}

- (NSString *)footerReleaseToRefreshText
{
    return self.footer.releaseToRefreshText;
}

- (void)setFooterRefreshingText:(NSString *)footerRefreshingText
{
    self.footer.refreshingText = footerRefreshingText;
}

- (NSString *)footerRefreshingText
{
    return self.footer.refreshingText;
}

- (void)setHeaderPullToRefreshText:(NSString *)headerPullToRefreshText
{
    self.header.pullToRefreshText = headerPullToRefreshText;
}

- (NSString *)headerPullToRefreshText
{
    return self.header.pullToRefreshText;
}

- (void)setHeaderReleaseToRefreshText:(NSString *)headerReleaseToRefreshText
{
    self.header.releaseToRefreshText = headerReleaseToRefreshText;
}

- (NSString *)headerReleaseToRefreshText
{
    return self.header.releaseToRefreshText;
}

- (void)setHeaderRefreshingText:(NSString *)headerRefreshingText
{
    self.header.refreshingText = headerRefreshingText;
}

- (NSString *)headerRefreshingText
{
    return self.header.refreshingText;
}

@end

#pragma mark - 
#pragma mark - RefreshView

@interface  RefreshView()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIActivityIndicatorView *_activityView;
}
@end

@implementation RefreshView
#pragma mark - 控件初始化
/**
 *  状态标签
 */
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = RefreshViewLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

/**
 *  箭头图片
 */
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:RefreshViewSrcName(@"arrow.png")]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

/**
 *  状态标签
 */
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = RefreshViewViewHeight;
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = RefreshViewStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.箭头
    CGFloat arrowX = self.frame.size.width * 0.5 - 100;
    self.arrowImage.center = CGPointMake(arrowX, self.frame.size.height * 0.5);
    
    // 2.指示器
    self.activityView.center = self.arrowImage.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:RefreshViewContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:RefreshViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        CGRect frame = self.frame;
        // 设置宽度
        frame.size.width = newSuperview.frame.size.width;
        // 设置位置
        frame.origin.x = 0;
        self.frame = frame;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect
{
    if (self.state == RefreshViewStateWillRefreshing) {
        self.state = RefreshViewStateRefreshing;
    }
}

#pragma mark - 刷新相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return RefreshViewStateRefreshing == self.state;
}

#pragma mark 开始刷新
typedef void (*send_type)(void *, SEL, UIView *);
- (void)beginRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = RefreshViewStateRefreshing;
    });
//    if (self.state == RefreshViewStateRefreshing) {
//        // 回调
//        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
//            msgSend((__bridge void *)(self.beginRefreshingTaget), self.beginRefreshingAction, self);
//        }
//        
//        if (self.beginRefreshingCallback) {
//            self.beginRefreshingCallback();
//        }
//    } else {
//        if (self.window) {
//            self.state = RefreshViewStateRefreshing;
//        } else {
//            // 不能调用set方法
//            _state = RefreshViewStateNormal;
//            [super setNeedsDisplay];
//        }
//    }
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = RefreshViewStateNormal;
    });
}

#pragma mark - 设置状态
- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    _pullToRefreshText = [pullToRefreshText copy];
    [self settingLabelText];
}
- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    _releaseToRefreshText = [releaseToRefreshText copy];
    [self settingLabelText];
}
- (void)setRefreshingText:(NSString *)refreshingText
{
    _refreshingText = [refreshingText copy];
    [self settingLabelText];
}
- (void)settingLabelText
{
    switch (self.state) {
        case RefreshViewStateNormal:
            // 设置文字
            self.statusLabel.text = self.pullToRefreshText;
            break;
        case RefreshViewStatePulling:
            // 设置文字
            self.statusLabel.text = self.releaseToRefreshText;
            break;
        case RefreshViewStateRefreshing:
            // 设置文字
            self.statusLabel.text = self.refreshingText;
            break;
        default:
            break;
    }
}

- (void)setState:(RefreshViewState)state
{
    // 0.存储当前的contentInset
    if (self.state != RefreshViewStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
        case RefreshViewStateNormal: // 普通状态
        {
            if (self.state == RefreshViewStateRefreshing) {
                [UIView animateWithDuration:RefreshViewSlowAnimationDuration * 0.6 animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                    [self.activityView stopAnimating];
                    
                    // 恢复alpha
                    self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshViewSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 再次设置回normal
                    _state = RefreshViewStatePulling;
                    self.state = RefreshViewStateNormal;
                });
                // 直接返回
                return;
            } else {
                // 显示箭头
                self.arrowImage.hidden = NO;
                
                // 停止转圈圈
                [self.activityView stopAnimating];
            }
            break;
        }
            
        case RefreshViewStatePulling:
            break;
            
        case RefreshViewStateRefreshing:
        {
            // 开始转圈圈
            [self.activityView startAnimating];
            // 隐藏箭头
            self.arrowImage.hidden = YES;
            
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                objc_msgSend(self.beginRefreshingTaget, self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        }
        default:
            break;
    }
    
    // 3.存储状态
    _state = state;
    
    // 4.设置文字
    [self settingLabelText];
}
@end

#pragma mark -
#pragma mark - RefreshViewHeaderView

@interface RefreshViewHeaderView()
// 最后的更新时间
@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, weak) UILabel *lastUpdateTimeLabel;
@end

@implementation RefreshViewHeaderView
#pragma mark - 控件初始化
/**
 *  时间标签
 */
- (UILabel *)lastUpdateTimeLabel
{
    if (!_lastUpdateTimeLabel) {
        // 1.创建控件
        UILabel *lastUpdateTimeLabel = [[UILabel alloc] init];
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        lastUpdateTimeLabel.textColor = RefreshViewLabelTextColor;
        lastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
        lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdateTimeLabel = lastUpdateTimeLabel];
        
        // 2.加载时间
        self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:RefreshViewHeaderTimeKey];
    }
    return _lastUpdateTimeLabel;
}

+ (instancetype)header
{
    return [[RefreshViewHeaderView alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pullToRefreshText = RefreshViewHeaderPullToRefresh;
        self.releaseToRefreshText = RefreshViewHeaderReleaseToRefresh;
        self.refreshingText = RefreshViewHeaderRefreshing;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat statusX = 0;
    CGFloat statusY = 0;
    CGFloat statusHeight = self.frame.size.height * 0.5;
    CGFloat statusWidth = self.frame.size.width;
    // 1.状态标签
    self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 2.时间标签
    CGFloat lastUpdateY = statusHeight;
    CGFloat lastUpdateX = 0;
    CGFloat lastUpdateHeight = statusHeight;
    CGFloat lastUpdateWidth = statusWidth;
    self.lastUpdateTimeLabel.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 设置自己的位置和尺寸
    self.frame = CGRectMake(self.frame.origin.x, - self.frame.size.height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:RefreshViewHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
    [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!self.lastUpdateTime) return;
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:self.lastUpdateTime];
    
    // 3.显示日期
    self.lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    // 如果正在刷新，直接返回
    if (self.state == RefreshViewStateRefreshing) return;
    
    if ([RefreshViewContentOffset isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY - self.frame.size.height;
        
        if (self.state == RefreshViewStateNormal && currentOffsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = RefreshViewStatePulling;
        } else if (self.state == RefreshViewStatePulling && currentOffsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = RefreshViewStateNormal;
        }
    } else if (self.state == RefreshViewStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = RefreshViewStateRefreshing;
    }
}

#pragma mark 设置状态
- (void)setState:(RefreshViewState)state
{
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.保存旧状态
    RefreshViewState oldState = self.state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态执行不同的操作
    switch (state) {
        case RefreshViewStateNormal: // 下拉可以刷新
        {
            // 刷新完毕
            if (RefreshViewStateRefreshing == oldState) {
                self.arrowImage.transform = CGAffineTransformIdentity;
                // 保存刷新时间
                self.lastUpdateTime = [NSDate date];
                
                [UIView animateWithDuration:RefreshViewSlowAnimationDuration animations:^{
                    // 这句代码修复了，top值不断累加的bug
                    UIEdgeInsets contentInset = self.scrollView.contentInset;
                    contentInset.top -= self.frame.size.height;
                    self.scrollView.contentInset = contentInset;
                }];
            } else {
                // 执行动画
                [UIView animateWithDuration:RefreshViewFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case RefreshViewStatePulling: // 松开可立即刷新
        {
            // 执行动画
            [UIView animateWithDuration:RefreshViewFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            break;
        }
            
        case RefreshViewStateRefreshing: // 正在刷新中
        {
            // 执行动画
            [UIView animateWithDuration:RefreshViewFastAnimationDuration animations:^{
                // 1.增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.frame.size.height;
                UIEdgeInsets contentInset = self.scrollView.contentInset;
                contentInset.top = top;
                self.scrollView.contentInset = contentInset;
                
                // 2.设置滚动位置
                CGPoint contentOffset = self.scrollView.contentOffset;
                contentOffset.y = -top;
                self.scrollView.contentOffset = contentOffset;
            }];
            break;
        }
            
        default:
            break;
    }
}
@end



#pragma mark -
#pragma mark - RefreshViewFooterView

@interface RefreshViewFooterView()
@property (assign, nonatomic) int lastRefreshCount;
@end

@implementation RefreshViewFooterView

+ (instancetype)footer
{
    return [[RefreshViewFooterView alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pullToRefreshText = RefreshViewFooterPullToRefresh;
        self.releaseToRefreshText = RefreshViewFooterReleaseToRefresh;
        self.refreshingText = RefreshViewFooterRefreshing;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.statusLabel.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:RefreshViewContentSize context:nil];
    
    if (newSuperview) { // 新的父控件
        // 监听
        [newSuperview addObserver:self forKeyPath:RefreshViewContentSize options:NSKeyValueObservingOptionNew context:nil];
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}

#pragma mark 重写调整frame
- (void)adjustFrameWithContentSize
{
    // 内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    CGRect frame = self.frame;
    frame.origin.y = MAX(contentHeight, scrollHeight);
    self.frame = frame;
}

#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互，直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if ([RefreshViewContentSize isEqualToString:keyPath]) {
        // 调整frame
        [self adjustFrameWithContentSize];
    } else if ([RefreshViewContentOffset isEqualToString:keyPath]) {
        // 这个返回一定要放这个位置
        // 如果正在刷新，直接返回
        if (self.state == RefreshViewStateRefreshing) return;
        
        // 调整状态
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.frame.size.height;
        
        if (self.state == RefreshViewStateNormal && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = RefreshViewStatePulling;
        } else if (self.state == RefreshViewStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = RefreshViewStateNormal;
        }
    } else if (self.state == RefreshViewStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = RefreshViewStateRefreshing;
    }
}

#pragma mark - 状态相关
#pragma mark 设置状态
- (void)setState:(RefreshViewState)state
{
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.保存旧状态
    RefreshViewState oldState = self.state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态来设置属性
    switch (state)
    {
        case RefreshViewStateNormal:
        {
            // 刷新完毕
            if (RefreshViewStateRefreshing == oldState) {
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                [UIView animateWithDuration:RefreshViewSlowAnimationDuration animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.bottom = self.scrollViewOriginalInset.bottom;
                    self.scrollView.contentInset = inset;
                }];
            } else {
                // 执行动画
                [UIView animateWithDuration:RefreshViewFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
            
            CGFloat deltaH = [self heightForContentBreakView];
            int currentCount = [self totalDataCountInScrollView];
            // 刚刷新完毕
            if (RefreshViewStateRefreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = self.scrollView.contentOffset.y;
                self.scrollView.contentOffset = offset;
            }
            break;
        }
            
        case RefreshViewStatePulling:
        {
            [UIView animateWithDuration:RefreshViewFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformIdentity;
            }];
            break;
        }
            
        case RefreshViewStateRefreshing:
        {
            // 记录刷新前的数量
            self.lastRefreshCount = [self totalDataCountInScrollView];
            
            [UIView animateWithDuration:RefreshViewFastAnimationDuration animations:^{
                CGFloat bottom = self.frame.size.height + self.scrollViewOriginalInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.bottom = bottom;
                self.scrollView.contentInset = inset;
            }];
            break;
        }
            
        default:
            break;
    }
}

- (int)totalDataCountInScrollView
{
    int totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (int section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (int section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark - 在父类中用得上
/**
 *  刚好看到上拉刷新控件时的contentOffset.y
 */
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}
@end