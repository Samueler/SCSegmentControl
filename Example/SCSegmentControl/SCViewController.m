//
//  SCViewController.m
//  SCSegmentControl
//
//  Created by samueler.chen@gmail.com on 11/18/2020.
//  Copyright (c) 2020 samueler.chen@gmail.com. All rights reserved.
//

#import "SCViewController.h"
#import <SCSegmentControl.h>

@interface SCViewController () <
SCSegmentControlDataSource,
SCSegmentControlDelegate
>

@property (nonatomic, strong) SCSegmentControl *control;

@end

@implementation SCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCSegmentControl *control = [[SCSegmentControl alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44)];
    control.backgroundColor = UIColor.orangeColor;
    control.scrollToCenter = YES;
    control.dataSource = self;
    control.delegate = self;
    control.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [control setupSelectedIndex:10];
    [control reloadData];
    [self.view addSubview:control];
    self.control = control;
}

- (NSInteger)numberOfItemsInSegmentControl:(SCSegmentControl *)segmentControl {
    return 100;
}

- (UIView *)segmentControl:(SCSegmentControl *)segmentControl itemAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"item:%zd", index];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)minimumInteritemSpacingInSegmentControl:(SCSegmentControl *)segmentControl {
    return 20;
}

- (CGFloat)segmentControl:(SCSegmentControl *)segmentControl widthForItemAtIndex:(NSInteger)index {
    UILabel *label = (UILabel *)[self segmentControl:segmentControl itemAtIndex:index];
    [label sizeToFit];
    return label.frame.size.width;
}

- (void)segmentControl:(SCSegmentControl *)segmentControl didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"currentIndex: %zd", segmentControl.currentIndex);
}

@end
