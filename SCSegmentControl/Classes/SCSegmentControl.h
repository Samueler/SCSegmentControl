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

@property (nonatomic, weak) id<SCSegmentControlDelegate> dataSource;
@property (nonatomic, weak) id<SCSegmentControlDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, assign) CGFloat progressBottomSpace;

- (void)reloadData;

@end
