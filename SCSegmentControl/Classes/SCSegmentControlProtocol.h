//
//  SCSegmentControlProtocol.h
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import "SCSegmentControlDataSource.h"
#import "SCSegmentControlDelegate.h"

@protocol SCSegmentControlProtocol <NSObject>

/// 指定被点击的item是否滚动至控件中间位置，默认为YES
@property (nonatomic, assign) BOOL scrollToCenter;

/// 指定内容内边距，默认均为0
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// 当前选中的item的下标
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/// SCSegmentControl的一些回调
@property (nonatomic, weak) id<SCSegmentControlDelegate> delegate;

/// SCSegmentControl的数据源
@property (nonatomic, weak) id<SCSegmentControlDataSource> dataSource;

@optional

/// 刷新数据
- (void)reloadData;

/// 指定item被选中
/// @param selectedIndex item的下标
- (void)setupSelectedIndex:(NSInteger)selectedIndex;

@end


