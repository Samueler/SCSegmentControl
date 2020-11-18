//
//  SCSegmentControl.h
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import <UIKit/UIKit.h>
#import "SCSegmentControlDataSource.h"
#import "SCSegmentControlDelegate.h"

@interface SCSegmentControl : UIView

@property (nonatomic, assign) BOOL scrollToCenter;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, weak) id<SCSegmentControlDelegate> delegate;
@property (nonatomic, weak) id<SCSegmentControlDataSource> dataSource;

@property (nonatomic, assign) CGFloat progressHeight;
@property (nonatomic, assign) CGFloat progressBottomSpace;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (void)reloadData;

- (void)setupSelectedIndex:(NSInteger)selectedIndex;

@end
