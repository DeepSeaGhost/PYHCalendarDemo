//
//  UIView+pyh_calendarFrame.m
// Created by reset on 2018/7/13.

#import "UIView+pyh_calendarFrame.h"

@implementation UIView (pyh_calendarFrame)
- (void)setMinX:(CGFloat)minX {
    CGRect frame = self.frame;
    frame.origin.x = minX;
    self.frame = frame;
}
- (CGFloat)minX {
    return self.frame.origin.x;
}
- (void)setMinY:(CGFloat)minY {
    CGRect frame = self.frame;
    frame.origin.y = minY;
    self.frame = frame;
}
- (CGFloat)minY {
    return self.frame.origin.y;
}
- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}
- (void)setW:(CGFloat)w {
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}
- (CGFloat)w {
    return self.frame.size.width;
}
- (void)setH:(CGFloat)h {
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}
- (CGFloat)h {
    return self.frame.size.height;
}

@end

@implementation UIScrollView (pyh_calendarFrame)
- (CGFloat)visibleMinX {
    CGPoint contentOffset = self.contentOffset;
    return contentOffset.x;
}
- (CGFloat)visibleMinY {
    CGPoint contentOffset = self.contentOffset;
    return contentOffset.y;
}
- (CGFloat)visibleMaxX {
    CGPoint contentOffset = self.contentOffset;
    return contentOffset.x + self.w;
}
- (CGFloat)visibleMaxY {
    CGPoint contentOffset = self.contentOffset;
    return contentOffset.y + self.h;
}
- (CGFloat)maxOffsetX {
    CGFloat x = self.contentSize.width - self.frame.size.width;
    return x < 0 ? 0 : x;
}
- (CGFloat)maxOffsetY {
    CGFloat y = self.contentSize.height - self.frame.size.height;
    return y < 0 ? 0 : y;
}
- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    CGPoint point = self.contentOffset;
    point.x = contentOffsetX;
    self.contentOffset = point;
}
- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}
- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    CGPoint point = self.contentOffset;
    point.y = contentOffsetY;
    self.contentOffset = point;
}
- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}
@end
