//
//  SCSegmentControlContainerCell.m
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import "SCSegmentControlContainerCell.h"

@implementation SCSegmentControlContainerCell

- (void)prepareForReuse {
    
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [super prepareForReuse];
}

@end
