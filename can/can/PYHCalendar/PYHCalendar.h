//
//  PYHCalendar.h
//  Created by reset on 2018/6/27.

#import <UIKit/UIKit.h>
#import "PYHCalendarHandleSupport.h"
#import "PYHCalendarAppearance.h"
#import "PYHCalendarDateSupport.h"

typedef void(^block) (CGRect frame);
@protocol PYHCalendardelegate <NSObject>
@optional
//日历滚动 高度发生变化 代理回调 frame:新frame
- (void)calendar:(PYHCalendar *)calendar refreshFrame:(CGRect)frame;
//日历滚动 代理回调 date:当前显示日期年月
- (void)calendar:(PYHCalendar *)calendar currentVisibleYearMonthDate:(NSDate *)date;
//选择日期 代理回调 dates：标记日期集合
- (void)calendar:(PYHCalendar *)calendar selectDates:(NSArray *)dates;
@end

@interface PYHCalendar : UIView

@property (nonatomic, weak) id<PYHCalendardelegate> delegate;

@property (nonatomic, strong, readonly) PYHCalendarDateSupport *dateSupport;

@property (nonatomic, strong, readonly) PYHCalendarHandleSupport *handleSupport;

@property (nonatomic, strong, readonly) PYHCalendarAppearance *appearance;

@property (nonatomic, assign) BOOL isChangeHeight;//日历滚动 是否调整高度 默认NO

- (void)backToday;
- (void)resetSelected;
- (void)nextMonth;
- (void)preMonth;
@end
