//
//  PYHLookMarkLabel.h
//  Created by reset on 2018/7/11.

#import <UIKit/UIKit.h>

@interface PYHLookMarkLabel : UILabel

@property (nonatomic, copy) NSString *content;
- (BOOL)touchInRect:(CGPoint)point;
- (NSInteger)touchInRectType:(CGPoint)point;
- (void)setSelectType;
- (void)reset;
@end
