//
//  SCSegmentControlDelegate.h
//  SCSegmentControl
//
//  Created by ty.Chen on 2020/11/18.
//

#import <Foundation/Foundation.h>
@class SCSegmentControl;

@protocol SCSegmentControlDelegate <NSObject>

@optional

- (void)segmentControl:(id)segmentControl didSelectItemAtIndex:(NSInteger)index;

@end

