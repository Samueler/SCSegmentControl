//
//  SCSegmentControlLineIndicator.m
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import "SCSegmentControlLineIndicator.h"

@implementation SCSegmentControlLineIndicator

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

#pragma mark - Private Functions

- (void)commonInit {
    self.backgroundColor = [UIColor redColor];
}

#pragma mark - Lazy Load

@end
