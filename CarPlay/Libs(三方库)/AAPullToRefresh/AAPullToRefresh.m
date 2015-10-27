#import "AAPullToRefresh.h"

//#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
//#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

@implementation UIScrollView (AAPullToRefresh)

- (AAPullToRefresh *)addPullToRefreshPosition:(AAPullToRefreshPosition)position actionHandler:(void (^)(AAPullToRefresh *v))handler
{
    // dont dupuricate add.
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[AAPullToRefresh class]])
            if (((AAPullToRefresh *)v).position == position)
                return (AAPullToRefresh *)v;
    }

    AAPullToRefresh *view = [[AAPullToRefresh alloc] initWithImage:[UIImage imageNamed:@"centerIcon"]
                                                          position:position];
    switch (view.position) {
        case AAPullToRefreshPositionTop:
        case AAPullToRefreshPositionBottom:
            view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                    -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
            break;
        case AAPullToRefreshPositionLeft:
            view.frame = CGRectMake(-view.bounds.size.width, self.bounds.size.height/2.0f, view.bounds.size.width, view.bounds.size.height);
            break;
        case AAPullToRefreshPositionRight:
            view.frame = CGRectMake(self.bounds.size.width, self.bounds.size.height/2.0f, view.bounds.size.width, view.bounds.size.height);
            break;
        default:
            break;
    }
    
    view.pullToRefreshHandler = handler;
    view.scrollView = self;
    view.originalInsetTop = self.contentInset.top;
    view.originalInsetBottom = self.contentInset.bottom;
    view.showPullToRefresh = YES;
    view.alpha = 0.0;
    [self addSubview:view];
    
    return view;
}
@end

@interface AAPullToRefreshBackgroundLayer : CALayer

@property (nonatomic, assign) CGFloat outlineWidth;
@property (nonatomic, assign, getter = isGlow) BOOL glow;
- (id)initWithBorderWidth:(CGFloat)width;
@end

@implementation AAPullToRefreshBackgroundLayer

- (id)initWithBorderWidth:(CGFloat)width
{
    if ((self = [super init])) {
        self.outlineWidth = width;
        self.contentsScale = [UIScreen mainScreen].scale;
        self.shadowColor = [UIColor whiteColor].CGColor;
        self.shadowOffset = CGSizeZero;
        self.shadowRadius = 7.0f;
        self.shadowOpacity = 0.0f;
        [self setNeedsDisplay];
    }
    return self;
}

@end

/*-----------------------------------------------------------------*/
@interface AAPullToRefresh()

@property (nonatomic, assign) BOOL isUserAction;
@property (nonatomic, assign, readonly) BOOL isSidePosition;
@property (nonatomic, assign) double progress;
@property (nonatomic, assign) double prevProgress;

@property (nonatomic, strong) NSDate *startDate;
@end

@implementation AAPullToRefresh

#pragma mark - init
- (id)initWithImage:(UIImage *)image position:(AAPullToRefreshPosition)position
{
    if ((self = [super init])) {
        _position = position;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit
{
    self.threshold = 60.0f;
    self.isUserAction = NO;
    self.state = AAPullToRefreshStateNormal;
//    if (self.isSidePosition)
//        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    else
//        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.backgroundColor = [UIColor clearColor];
    _activityIndicatorView = [ZYRefreshView new];
    _activityIndicatorView.center = self.centerInSelf;
    [self addSubview:_activityIndicatorView];

}

#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    _activityIndicatorView.center = self.centerInSelf;
}

#pragma mark - ScrollViewInset
- (void)setupScrollViewContentInsetForLoadingIndicator:(actionHandler)handler
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    if (self.position == AAPullToRefreshPositionTop) {
        CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
        currentInsets.top = MIN(offset, self.originalInsetTop + self.bounds.size.height + 20.0f);
    } else {
        //CGFloat overBottomOffsetY = self.scrollView.contentOffset.y - self.scrollView.contentSize.height + self.scrollView.frame.size.height;
        //currentInsets.bottom = MIN(overBottomOffsetY, self.originalInsetBottom + self.bounds.size.height + 40.0);
        currentInsets.bottom = MIN(self.threshold, self.originalInsetBottom + self.bounds.size.height + 40.0f);
    }
    [self setScrollViewContentInset:currentInsets handler:handler];
}

- (void)resetScrollViewContentInset:(actionHandler)handler
{
    if (self.position == AAPullToRefreshPositionTop){
        ZYMainThread(^{
            
            if (iPhone4) {
                
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffsetX, -self.scrollView.contentInsetTop) animated:YES];
            }else{
                
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffsetX, 0) animated:YES];
            }
        });
    }else if (self.position == AAPullToRefreshPositionLeft){
        ZYMainThread(^{
            
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
        });
    }else if (self.position == AAPullToRefreshPositionBottom){
        if (iPhone4) {
            
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInsetTop) animated:YES];
        }else{
            
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height) animated:YES];
        }
    }else if (self.position == AAPullToRefreshPositionRight){
        ZYMainThread(^{
            
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSizeWidth - self.scrollView.width,self.scrollView.contentOffset.y) animated:YES];
        });
    }
    if (handler) {
        handler();
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset handler:(actionHandler)handler
{
    if (handler) {
        handler();
    }
}
#pragma mark - property
- (void)setShowPullToRefresh:(BOOL)showPullToRefresh
{
    self.hidden = !showPullToRefresh;
    
    if (showPullToRefresh) {
        
        [RACObserve(self.scrollView, contentOffset) subscribeNext:^(id x) {
            
            [self scrollViewDidScroll:[x CGPointValue]];
        }];
        
        [RACObserve(self.scrollView, contentSize) subscribeNext:^(id x) {
            [self setNeedsLayout];
            [self setNeedsDisplay];
        }];
        
        [RACObserve(self.scrollView, frame) subscribeNext:^(id x) {
            [self setNeedsLayout];
            [self setNeedsDisplay];
        }];
        
    }
}


- (void)dealloc
{
    self.showPullToRefresh = NO;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil)
        if (self.isObserving)
            self.showPullToRefresh = NO;
}

- (BOOL)showPullToRefresh
{
    return !self.hidden;
}

- (void)setProgress:(double)progress
{
    self.alpha = 1.0 * progress;
    
    self.prevProgress = self.progress;
    _progress = progress;
}

- (BOOL)isSidePosition
{
    return (self.position == AAPullToRefreshPositionLeft || self.position == AAPullToRefreshPositionRight);
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    CGFloat yOffset = contentOffset.y;
    CGFloat xOffset = contentOffset.x;
    CGFloat overBottomOffsetY = yOffset - self.scrollView.contentSize.height + self.scrollView.frame.size.height;
    CGFloat centerX;
    CGFloat centerY;
    switch (self.position) {
        case AAPullToRefreshPositionTop:
            self.progress = ((yOffset + self.originalInsetTop) / -self.threshold);
            centerX = self.scrollView.center.x + xOffset;
            centerY = (yOffset + self.originalInsetTop) / 2.0f + 64;
            break;
        case AAPullToRefreshPositionBottom:
            self.progress = overBottomOffsetY / self.threshold;
            centerX = self.scrollView.center.x + xOffset;
            CGFloat itemH = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250 + 383;
            CGFloat ss = self.scrollView.height - itemH - 20 - 49;
            if (self.isNoAnimation) {
                ss = 2;
            }
            centerY = self.scrollView.frame.size.height + self.frame.size.height / 2.0f + yOffset - ss;
            if (overBottomOffsetY >= 0.0f) {
                centerY -= overBottomOffsetY / 1.5f;
            }
            break;
        case AAPullToRefreshPositionLeft:
            self.progress = xOffset / -self.threshold;
            centerX = xOffset / 2.0f + 20;
            centerY = self.scrollView.bounds.size.height / 2.0f + yOffset;
            break;
        case AAPullToRefreshPositionRight: {
            CGFloat rightEdgeOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
            centerX = self.scrollView.contentSize.width + MAX((xOffset - rightEdgeOffset) / 2.0f, 0) - 10;
            centerY = self.scrollView.bounds.size.height / 2.0f + yOffset;
            self.progress = MAX((xOffset - rightEdgeOffset) / self.threshold, 0);
            break;
        }
        default:
            break;
    }
    
    self.center = CGPointMake(centerX, centerY);
    switch (self.state) {
        case AAPullToRefreshStateNormal: //detect action
            if (self.isUserAction && !self.scrollView.dragging && !self.scrollView.isZooming && self.prevProgress > 0.99f) {
                [self actionTriggeredState];
            }
            break;
        case AAPullToRefreshStateStopped: // finish
        case AAPullToRefreshStateLoading: // wait until stopIndicatorAnimation
            break;
        default:
            break;
    }
    
    self.isUserAction = (self.scrollView.dragging) ? YES : NO;
}

- (void)actionTriggeredState
{
    self.state = AAPullToRefreshStateLoading;
//    [UIView animateWithDuration:0.1f delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         [self setLayerOpacity:0.0f];
//                     } completion:^(BOOL finished) {
//                         [self setLayerHidden:YES];
//                     }];
    
    [self.activityIndicatorView startAnimation];
//    [self setupScrollViewContentInsetForLoadingIndicator:nil];
    if (self.pullToRefreshHandler)
        self.pullToRefreshHandler(self);
    self.startDate = [NSDate date];
}

- (void)actionStopState
{
    
    [self.activityIndicatorView stopAnimation];
    [self resetScrollViewContentInset:^{
        self.activityIndicatorView.transform = CGAffineTransformIdentity;
        self.state = AAPullToRefreshStateNormal;
    }];
    return ;
//    CGFloat duration = 0.0;
//    CGFloat offsetDuration = [NSDate date].timeIntervalSince1970 - self.startDate.timeIntervalSince1970;
//    if (offsetDuration < 2.0) {
//        duration = 2.0 - offsetDuration;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.startDate = nil;
//        };
//    });
}

#pragma mark - public method
- (void)stopIndicatorAnimation
{
    [self actionStopState];
}

- (void)setSize:(CGSize) size
{
    CGRect rect = CGRectMake((self.scrollView.bounds.size.width - size.width)/2.0f,
                             -size.height, size.width, size.height);
    
    self.frame = rect;
    self.activityIndicatorView.center = self.centerInSelf;
}


- (void)setActivityIndicatorView:(ZYRefreshView *)activityIndicatorView
{
    if(_activityIndicatorView)
        [activityIndicatorView removeFromSuperview];
    _activityIndicatorView = activityIndicatorView;
    _activityIndicatorView.center = self.centerInSelf;
    [self addSubview:_activityIndicatorView];
    
}

@end
