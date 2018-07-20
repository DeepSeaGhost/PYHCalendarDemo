//
//  UIView+pyh_calendarFrame.h
// Created by reset on 2018/7/13.

#import <UIKit/UIKit.h>

@interface UIView (pyh_calendarFrame)

@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;
@end

@interface UIScrollView (pyh_calendarFrame)

@property (nonatomic, assign, readonly) CGFloat visibleMinX;
@property (nonatomic, assign, readonly) CGFloat visibleMinY;
@property (nonatomic, assign, readonly) CGFloat visibleMaxX;
@property (nonatomic, assign, readonly) CGFloat visibleMaxY;
@property (nonatomic, assign, readonly) CGFloat maxOffsetX;
@property (nonatomic, assign, readonly) CGFloat maxOffsetY;
@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;
@end
