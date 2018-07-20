//
//  PYHCalendarCollectionView.m
//  Created by reset on 2018/6/27.

#import "PYHCalendarCollectionView.h"

@implementation PYHCalendarCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.calendar.handleSupport.todayIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
@end
