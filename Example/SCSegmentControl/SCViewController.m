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
    
    SCTextLineSegmentControl *control = [[SCTextLineSegmentControl alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70)];
    control.backgroundColor = UIColor.lightGrayColor;
    control.scrollToCenter = NO;
    control.dataSource = self;
    control.delegate = self;
    control.contentInset = UIEdgeInsetsMake(15, 5, 15, 5);
//    [control setupSelectedIndex:10];
    control.indicatorBackgroundColor = UIColor.greenColor;
//    control.indicatorImage = [UIImage imageNamed:@"waveIndicator"];
    control.indicatorStyle = SCTextLineIndicatorStyleFollowContent;
    control.indicatorRegularWidth = 20;
    control.indicatorHeight = 10;
    control.selectItemTitleColor = UIColor.redColor;
    control.selectItemTitleFont = [UIFont boldSystemFontOfSize:25];
    control.normalItemTitleColor = UIColor.orangeColor;
    control.normalItemTitleFont = [UIFont systemFontOfSize:12];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (NSInteger idx = 0; idx < 20; idx++) {
        [titles addObject:[NSString stringWithFormat:@"item:%zd", idx]];
    }
    control.titles = titles;
    
    UIBezierPath *indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath moveToPoint:CGPointZero];
    [indicatorPath addLineToPoint:CGPointMake(20, 0)];
    [indicatorPath addLineToPoint:CGPointMake(10, 5)];
    
    CAShapeLayer *indicatorLayer = [CAShapeLayer layer];
    indicatorLayer.fillColor = UIColor.redColor.CGColor;
    indicatorLayer.path = indicatorPath.CGPath;
//    control.indicatorLayer = indicatorLayer;
    
    UILabel *indicatorLabel = [[UILabel alloc] init];
    indicatorLabel.text = @"indicator";
    indicatorLabel.font = [UIFont systemFontOfSize:10];
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.textColor = UIColor.redColor;
    control.indicatorView = indicatorLabel;
    
    [self.view addSubview:control];
    self.control = control;
    [self.control processDataSource];
}

- (NSInteger)numberOfItemsInSegmentControl:(SCTextLineSegmentControl *)segmentControl {
    return self.control.titles.count;
}

- (CGFloat)itemSpacingInSegmentControl:(UIView *)segmentControl {
    return 30;
}

//- (CGFloat)segmentControl:(SCTextLineSegmentControl *)segmentControl widthForItemAtIndex:(NSInteger)index {
//
//    return (self.view.frame.size.width - 30) / 2;
//}

- (void)segmentControl:(SCTextLineSegmentControl *)segmentControl didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"currentIndex: %zd", segmentControl.currentIndex);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.control setupSelectedIndex:80];
}

@end
