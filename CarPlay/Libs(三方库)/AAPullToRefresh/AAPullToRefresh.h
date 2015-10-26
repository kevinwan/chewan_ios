#import <UIKit/UIKit.h>
#import "ZYRefreshView.h"

typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, AAPullToRefreshState) {
    AAPullToRefreshStateNormal = 0,
    AAPullToRefreshStateStopped,
    AAPullToRefreshStateLoading,
};
typedef NS_ENUM(NSUInteger, AAPullToRefreshPosition) {
    AAPullToRefreshPositionTop,
    AAPullToRefreshPositionBottom,
    AAPullToRefreshPositionLeft,
    AAPullToRefreshPositionRight,
};

@interface AAPullToRefresh : UIView

@property (nonatomic, assign) BOOL isNoAnimation;
@property (nonatomic, assign) CGFloat originalInsetTop;
@property (nonatomic, assign) CGFloat originalInsetBottom;
@property (nonatomic, assign, readonly) AAPullToRefreshPosition position;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^pullToRefreshHandler)(AAPullToRefresh *v);
@property (nonatomic, assign) BOOL isObserving;

// user customizable.
@property (nonatomic, assign) BOOL showPullToRefresh;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, strong) ZYRefreshView *activityIndicatorView;

@property (nonatomic, assign) AAPullToRefreshState state;
- (id)initWithImage:(UIImage *)image position:(AAPullToRefreshPosition)position;
- (void)stopIndicatorAnimation;
- (void)setSize:(CGSize)size;

@end

@interface UIScrollView (AAPullToRefresh)
- (AAPullToRefresh *)addPullToRefreshPosition:(AAPullToRefreshPosition)position actionHandler:(void (^)(AAPullToRefresh *v))handler;
@end
