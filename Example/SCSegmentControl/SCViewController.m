//
//  SCViewController.m
//  SCSegmentControl
//
//  Created by samueler.chen@gmail.com on 11/18/2020.
//  Copyright (c) 2020 samueler.chen@gmail.com. All rights reserved.
//

#import "SCViewController.h"
#import <SCTextLineSegmentControl.h>

@interface SCViewController () <
SCSegmentControlDataSource,
SCSegmentControlDelegate
>

@property (nonatomic, strong) SCTextLineSegmentControl *control;

@end

@implementation SCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCTextLineSegmentControl *control = [[SCTextLineSegmentControl alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44)];
    control.backgroundColor = UIColor.orangeColor;
    control.scrollToCenter = YES;
    control.dataSource = self;
    control.delegate = self;
    control.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [control setupSelectedIndex:10];
    control.indicatorBackgroundColor = UIColor.greenColor;
    [control reloadData];
    [self.view addSubview:control];
    self.control = control;
}

- (NSInteger)numberOfItemsInSegmentControl:(SCTextLineSegmentControl *)segmentControl {
    return 100;
}

- (UIView *)segmentControl:(SCTextLineSegmentControl *)segmentControl itemAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"item:%zd", index];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)minimumInteritemSpacingInSegmentControl:(SCTextLineSegmentControl *)segmentControl {
    return 20;
}

- (CGFloat)segmentControl:(SCTextLineSegmentControl *)segmentControl widthForItemAtIndex:(NSInteger)index {
    UILabel *label = (UILabel *)[self segmentControl:segmentControl itemAtIndex:index];
    [label sizeToFit];
    return label.frame.size.width;
}

- (void)segmentControl:(SCTextLineSegmentControl *)segmentControl didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"currentIndex: %zd", segmentControl.currentIndex);
}

@end
