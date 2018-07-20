//
//  PYHCalendarCell.h
//  Created by reset on 2018/6/22.

#import <UIKit/UIKit.h>
@class PYHCalendar;
typedef void(^CalendarCellSelectBlock) (NSArray *dates);
@interface PYHCalendarCell : UICollectionViewCell

- (void)configItemDate:(NSInteger)itemIndex calendar:(PYHCalendar *)calendar;
@property (nonatomic, copy) CalendarCellSelectBlock selectBlock;
@end

@interface PYHCalendarCellButton : UIControl
@property (nonatomic, strong) UILabel *titleLabel;
- (void)enabledLeftLayer:(UIColor *)color;
- (void)enabledRightLayer:(UIColor *)color;
- (void)disableLeftLayer;
- (void)disableRightLayer;
- (void)disableAll;
@end
