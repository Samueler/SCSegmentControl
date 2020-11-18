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

- (NSInteger)numberOfItemsInSegmentControl:(SCSegmentControl *)segmentControl;

- (UIView *)segmentControl:(SCSegmentControl *)segmentControl itemAtIndex:(NSInteger)index;

@optional

- (UIView *)progressForSegmentControl:(SCSegmentControl *)segmentControl;

- (CGFloat)segmentControl:(SCSegmentControl *)segmentControl minimumInteritemSpacingAtIndex:(NSInteger)index;

- (CGFloat)segmentControl:(SCSegmentControl *)segmentControl widthForItemAtIndex:(NSInteger)index;

@end
