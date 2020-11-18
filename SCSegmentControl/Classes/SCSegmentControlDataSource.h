//
//  SCSegmentControlDataSource.h
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import <Foundation/Foundation.h>
@class SCSegmentControl;

@protocol SCSegmentControlDataSource <NSObject>

@required

/// 指定SCSegmentControl的item总数
/// @param segmentControl segmentControl实例
- (NSInteger)numberOfItemsInSegmentControl:(SCSegmentControl *)segmentControl;

/// 自定义特定index下的view
/// @param segmentControl segmentControl实例
/// @param index index
- (UIView *)segmentControl:(SCSegmentControl *)segmentControl itemAtIndex:(NSInteger)index;

@optional

/// 指定每个item之间的间距
/// @param segmentControl segmentControl实例
- (CGFloat)minimumInteritemSpacingInSegmentControl:(SCSegmentControl *)segmentControl;

/// 指定对应下标item的宽度
/// @param segmentControl segmentControl实例
/// @param index index
- (CGFloat)segmentControl:(SCSegmentControl *)segmentControl widthForItemAtIndex:(NSInteger)index;

@end
