//
//  SCSegmentControl.m
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import "SCSegmentControl.h"
#import "SCSegmentControlContainerCell.h"

static NSString *const kSCSegmentControlContainerCellKey = @"kSCSegmentControlContainerCellKey";

@interface SCSegmentControl () <
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollisionBehaviorDelegate
>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger totalItemCount;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) BOOL performedReloadData;
@property (nonatomic, assign) NSInteger initialSelectedIndex;
@property (nonatomic, assign) CGSize scrollContentSize;
@property (nonatomic, assign) CGPoint scrollContentOffset;

@end

@implementation SCSegmentControl

@synthesize scrollToCenter = _scrollToCenter;
@synthesize contentInset = _contentInset;
@synthesize currentIndex = _currentIndex;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
        [self addObserver];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        [self addObserver];
    }
    return self;
}

#pragma mark - Public Functions

- (void)reloadData {
    if (!self.dataSource) {
        NSAssert(NO, @"SCSegmentControl must confirm SCSegmentControlDataSource and implement required functions!");
        return;
    }
    
    if (![self.dataSource respondsToSelector:@selector(numberOfItemsInSegmentControl:)]) {
        NSAssert(NO, @"SCSegmentControl must confirm SCSegmentControlDataSource and implement required functions!");
        return;
    }
    
    if (![self.dataSource respondsToSelector:@selector(segmentControl:itemAtIndex:)]) {
        NSAssert(NO, @"SCSegmentControl must confirm SCSegmentControlDataSource and implement required functions!");
        return;
    }
    
    [self.collectionView reloadData];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadData];
    } completion:^(BOOL finished) {
        if (!self.performedReloadData && finished) {
            self.performedReloadData = YES;
            [self setupSelectedIndex:self.initialSelectedIndex];
        }
    }];
}

- (void)setupSelectedIndex:(NSInteger)selectedIndex {
    if (!self.performedReloadData) {
        self.initialSelectedIndex = selectedIndex;
        return;
    }
    
    if (selectedIndex >= self.totalItemCount || selectedIndex < 0 || selectedIndex == self.currentIndex) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - Override Functions

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark - Private Functions

- (void)commonInit {
    _scrollToCenter = YES;
    
    [self addSubview:self.collectionView];
}

#pragma mark - KVO

- (void)addObserver {
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.collectionView] && [keyPath isEqualToString:@"contentSize"]) {
        self.scrollContentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
    } else if ([object isEqual:self.collectionView] && [keyPath isEqualToString:@"contentOffset"]) {
        self.scrollContentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.totalItemCount = [self.dataSource numberOfItemsInSegmentControl:self];
    if (self.totalItemCount <= 0) {
        NSAssert(NO, @"Number of items in SegmentControl must be greater than zero!");
        return 0;
    }
    return self.totalItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCSegmentControlContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSCSegmentControlContainerCellKey forIndexPath:indexPath];
    UIView *itemView = [self.dataSource segmentControl:self itemAtIndex:indexPath.item];
    if (itemView && ![cell.subviews containsObject:itemView]) {
        [cell.contentView addSubview:itemView];
    }
    
    if (CGRectEqualToRect(CGRectZero, itemView.frame)) {
        itemView.frame = cell.bounds;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:self.scrollToCenter ? UICollectionViewScrollPositionCenteredHorizontally : UICollectionViewScrollPositionLeft animated:YES];
    
    self->_currentIndex = indexPath.item;
    
    self->_selectedItemView = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (!self.selectedItemView) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControl:didSelectItemAtIndex:)]) {
        [self.delegate segmentControl:self didSelectItemAtIndex:self.currentIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 解决设置起始选中下标时，selectedItemView为nil的问题
    if (self.selectedItemView) {
        return;
    }
    
    self->_selectedItemView = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControl:didSelectItemAtIndex:)]) {
        [self.delegate segmentControl:self didSelectItemAtIndex:self.currentIndex];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    self.minimumInteritemSpacing = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(minimumInteritemSpacingInSegmentControl:)]) {
        self.minimumInteritemSpacing = [self.dataSource minimumInteritemSpacingInSegmentControl:self];
    }
    return self.minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:widthForItemAtIndex:)]) {
        itemWidth = [self.dataSource segmentControl:self widthForItemAtIndex:indexPath.item];
    }
    
    return CGSizeMake(itemWidth ?: 50, collectionView.frame.size.height - self.contentInset.top - self.contentInset.bottom);
}

#pragma mark - Setter

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    self.collectionView.contentInset = contentInset;
}

#pragma mark - Lazy Load

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[SCSegmentControlContainerCell class] forCellWithReuseIdentifier:kSCSegmentControlContainerCellKey];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
