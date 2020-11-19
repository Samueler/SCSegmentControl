//
//  SCTextLineSegmentControl.m
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/19.
//

#import "SCTextLineSegmentControl.h"
#import "SCSegmentControl.h"
#import "SCSegmentControlLineIndicator.h"

@interface SCTextLineSegmentControl () <
SCSegmentControlDataSource,
SCSegmentControlDelegate
>

@property (nonatomic, strong) SCSegmentControl *segmentControl;
@property (nonatomic, strong) UIScrollView *indicatorScrollView;
@property (nonatomic, strong) SCSegmentControlLineIndicator *indicator;
@property (nonatomic, strong) CAGradientLayer *indicatorGradientLayer;

@end

@implementation SCTextLineSegmentControl

@synthesize scrollToCenter = _scrollToCenter;
@synthesize contentInset = _contentInset;
@synthesize currentIndex = _currentIndex;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Override Functions

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.segmentControl.frame = self.bounds;
    self.indicator.frame = CGRectMake(0, self.frame.size.height - self.indicatorHeight - self.indicatorBottomSpace, self.indicatorRegularWidth, self.indicatorHeight);
    self.indicatorGradientLayer.frame = self.indicator.bounds;
}

#pragma mark - Public Functions

- (void)setupIndicatorGradientWithColors:(NSArray *)indicatorGradientColors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray<NSNumber *> *)locations {
    if (self.indicatorGradientLayer) {
        [self.indicatorGradientLayer removeFromSuperlayer];
    }
    
    self.indicatorGradientLayer = [CAGradientLayer layer];
    self.indicatorGradientLayer.colors = indicatorGradientColors;
    self.indicatorGradientLayer.startPoint = startPoint;
    self.indicatorGradientLayer.endPoint = endPoint;
    self.indicatorGradientLayer.locations = locations;
    [self.indicator.layer insertSublayer:self.indicatorGradientLayer atIndex:0];
    
    [self setNeedsLayout];
}

#pragma mark - SCSegmentControlProtocol

- (void)reloadData {
    [self.segmentControl reloadData];
}

- (void)setupSelectedIndex:(NSInteger)selectedIndex {
    [self.segmentControl setupSelectedIndex:selectedIndex];
}

#pragma mark - Private Functions

- (void)commonInit {
    _indicatorHeight = 4;
    _indicatorRegularWidth = 50;
    _indicatorBackgroundColor = UIColor.orangeColor;
    
    [self addSubview:self.segmentControl];
    [self addSubview:self.indicator];
}

#pragma mark - SCSegmentControlDataSource

- (NSInteger)numberOfItemsInSegmentControl:(UIView *)segmentControl {
    return [self.dataSource numberOfItemsInSegmentControl:self];
}

- (UIView *)segmentControl:(UIView *)segmentControl itemAtIndex:(NSInteger)index {
    return [self.dataSource segmentControl:self itemAtIndex:index];
}

- (CGFloat)minimumInteritemSpacingInSegmentControl:(id)segmentControl {
    return [self.dataSource minimumInteritemSpacingInSegmentControl:self];
}

- (CGFloat)segmentControl:(UIView *)segmentControl widthForItemAtIndex:(NSInteger)index {
    return [self.dataSource segmentControl:self widthForItemAtIndex:index];
}

#pragma mark - Delegate

- (void)segmentControl:(UIView *)segmentControl didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"originFrame: %@", NSStringFromCGRect(self.segmentControl.selectedItemView.frame));
    CGRect convertFrame = [self.segmentControl.selectedItemView.superview convertRect:self.segmentControl.selectedItemView.frame toView:self.segmentControl];
    convertFrame = [self.segmentControl convertRect:convertFrame toView:self];
    
    NSLog(@"convertFrame: %@", NSStringFromCGRect(convertFrame));
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.indicator.frame;
        rect.origin.x = convertFrame.origin.x;
        self.indicator.frame = rect;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControl:didSelectItemAtIndex:)]) {
        [self.delegate segmentControl:self didSelectItemAtIndex:index];
    }
}

#pragma mark - Getter

- (NSInteger)currentIndex {
    return self.segmentControl.currentIndex;
}

#pragma mark - Setter

- (void)setScrollToCenter:(BOOL)scrollToCenter {
    _scrollToCenter = scrollToCenter;
    self.segmentControl.scrollToCenter = scrollToCenter;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    
    self.segmentControl.contentInset = contentInset;
}

- (void)setHideIndicator:(BOOL)hideIndicator {
    _hideIndicator = hideIndicator;
    
    self.indicator.hidden = hideIndicator;
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    _indicatorHeight = indicatorHeight;
    
    [self setNeedsLayout];
}

- (void)setIndicatorBottomSpace:(CGFloat)indicatorBottomSpace {
    _indicatorBottomSpace = indicatorBottomSpace;
    
    [self setNeedsLayout];
}

- (void)setIndicatorRegularWidth:(CGFloat)indicatorRegularWidth {
    if (self.indicatorStyle != SCTextLineIndicatorStyleRegular) {
        return;
    }
    
    _indicatorRegularWidth = indicatorRegularWidth;
    
    [self setNeedsLayout];
}

- (void)setIndicatorStyle:(SCTextLineIndicatorStyle)indicatorStyle {
    _indicatorStyle = indicatorStyle;
    
    [self setNeedsLayout];
}

- (void)setIndicatorCorner:(CGFloat)indicatorCorner {
    _indicatorCorner = indicatorCorner;
    
    self.indicator.layer.cornerRadius = indicatorCorner;
    self.indicator.clipsToBounds = YES;
}

- (void)setIndicatorBackgroundColor:(UIColor *)indicatorBackgroundColor {
    _indicatorBackgroundColor = indicatorBackgroundColor;
    
    self.indicator.backgroundColor = indicatorBackgroundColor;
}

- (void)setIndicatorLayer:(CALayer *)indicatorLayer {
    _indicatorLayer = indicatorLayer;
    self.indicator.indicatorLayer = indicatorLayer;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    _indicatorImage = indicatorImage;
    self.indicator.indicatorImage = indicatorImage;
}

- (void)setIndicatorImageViewMode:(UIViewContentMode)indicatorImageViewMode {
    _indicatorImageViewMode = indicatorImageViewMode;
    self.indicator.indicatorImageViewMode = indicatorImageViewMode;
}

#pragma mark - Lazy Load

- (SCSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[SCSegmentControl alloc] init];
        _segmentControl.dataSource = self;
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}

- (UIScrollView *)indicatorScrollView {
    if (!_indicatorScrollView) {
        _indicatorScrollView = [[UIScrollView alloc] init];
    }
    return _indicatorScrollView;
}

- (SCSegmentControlLineIndicator *)indicator {
    if (!_indicator) {
        _indicator = [[SCSegmentControlLineIndicator alloc] init];
    }
    return _indicator;
}

@end
