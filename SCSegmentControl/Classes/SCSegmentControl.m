//
//  SCSegmentControl.m
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import "SCSegmentControl.h"
#import "SCSegmentControlContainerCell.h"
#import "SCSegmentControlProgress.h"

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
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, assign) BOOL performedReloadData;
@property (nonatomic, assign) NSInteger initialSelectedIndex;

@end

@implementation SCSegmentControl

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
    
    if (!self.progressView) {
        self.progressView = [[SCSegmentControlProgress alloc] init];
    }
    
    if (![self.subviews containsObject:self.progressView]) {
        [self addSubview:self.progressView];
    }
    
    [self.collectionView reloadData];
    if (!self.performedReloadData) {
        self.performedReloadData = YES;
        [self setupSelectedIndex:self.initialSelectedIndex];
    }
}

- (void)setupSelectedIndex:(NSInteger)selectedIndex {
    if (!self.performedReloadData) {
        self.initialSelectedIndex = selectedIndex;
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (selectedIndex >= self.totalItemCount || selectedIndex < 0 || selectedIndex == self.currentIndex) {
            return;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
        
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        
        if (self.scrollToCenter) {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    });
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
    self->_currentIndex = indexPath.item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControl:didSelectItemAtIndex:)]) {
        [self.delegate segmentControl:self didSelectItemAtIndex:self.currentIndex];
    }
    
    if (self.scrollToCenter) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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

@end
