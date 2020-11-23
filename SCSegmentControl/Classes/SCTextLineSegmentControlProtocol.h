//
//  SCTextLineSegmentControlProtocol.h
//  SCSegmentControl
//
//  Created by 妈妈网 on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import "SCSegmentControlProtocol.h"

@class SCSegmentControl;

@protocol SCTextLineSegmentControlProtocol <
SCSegmentControlProtocol
>

- (NSAttributedString *)segmentControl:(UIView *)segmentControl selectItemTitle:(NSString *)title  attributeAtIndex:(NSInteger)index;

- (NSAttributedString *)segmentControl:(UIView *)segmentControl normalItemTitle:(NSString *)title  attributeAtIndex:(NSInteger)index;

@end
