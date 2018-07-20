//
//  PYHCalendarHandleSupport.m
//  Created by reset on 2018/6/22.

#import "PYHCalendarHandleSupport.h"
#import "PYHCalendar.h"

@implementation PYHCalendarHandleSupport
- (instancetype)init {
    if (self = [super init]) {
        [self baseConfig];
    }
    return self;
}
- (void)baseConfig {
    _visibleYM = [[NSDate date] dateByAddingTimeInterval:[NSTimeZone systemTimeZone].secondsFromGMT];
    _CMIndex = [self cmIndex];
    _todayIndex = _CMIndex;
    _selectType = PYHCalendarSelectOnly;
    _selectDates = [NSMutableArray array];
}
- (NSInteger)cmIndex {
    NSDateComponents *com = [[NSDateComponents alloc]init];
    com.year = 1900;
    com.month = 1;
    com.day = 1;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSInteger interval = [NSTimeZone localTimeZone].secondsFromGMT;
    NSDate *beginDate = [[calendar dateFromComponents:com] dateByAddingTimeInterval:interval];
    NSDate *parameterDate = [[NSDate date] dateByAddingTimeInterval:interval];
    com = [calendar components:NSCalendarUnitMonth fromDate:beginDate toDate:parameterDate options:NSCalendarWrapComponents];
    return com.month;
}

- (void)selectAddNewobjectAndSort:(NSArray *)dates {
    [self.selectDates addObjectsFromArray:dates];
    NSSet *set = [NSSet setWithArray:self.selectDates.copy];//去重
    self.selectDates = [NSMutableArray arrayWithArray:[set.allObjects sortedArrayUsingSelector:@selector(compare:)]];//排序
}

- (BOOL)scrollHandleCurrentDate:(BOOL)isPre changeCount:(NSInteger)changeCount {
    NSDate *date = _visibleYM;
    if (isPre) {
        _CMIndex -= changeCount;
        _visibleYM = [self.calendar.dateSupport preMonthWithDate:date monthInterval:changeCount];
    }else {
        _CMIndex += changeCount;
        _visibleYM = [self.calendar.dateSupport nextMonthWithDate:date monthInterval:changeCount];
    }
    return [self.calendar.dateSupport compareDate:date toDate:_visibleYM];
}

- (NSInteger)visibleItemRowsHandle {
    if (!self.calendar.isChangeHeight) return 6;
    NSInteger year = (_CMIndex + 1) / 12 + 1900;
    NSInteger month = (_CMIndex + 1) % 12;
    NSDate *date = [self.calendar.dateSupport year:year month:month day:1];
    date = [date dateByAddingTimeInterval:[NSTimeZone systemTimeZone].secondsFromGMT];
    NSInteger totalDays = [self.calendar.dateSupport monthDaysWithDate:date];
    NSInteger weekday = [self.calendar.dateSupport weekDayWithDate:date];
    
    //有多少排
    NSInteger rows = (totalDays + weekday - 1) / 7;
    if (((totalDays + weekday - 1) % 7) > 0) rows++;
    return rows;
}
- (NSArray *)visibleItemDataHandle:(NSInteger)itemIndex {
    NSInteger year = (itemIndex + 1) / 12 + 1900;
    NSInteger month = (itemIndex + 1) % 12;
    NSDate *date = [self.calendar.dateSupport year:year month:month day:1];
    date = [date dateByAddingTimeInterval:[NSTimeZone systemTimeZone].secondsFromGMT];
    NSInteger totalDays = [self.calendar.dateSupport monthDaysWithDate:date];
    NSInteger weekday = [self.calendar.dateSupport weekDayWithDate:date];
    
    //有多少排
    NSInteger rows = 6;
    if (self.calendar.isChangeHeight) {
        rows = (totalDays + weekday - 1) / 7;
        if (((totalDays + weekday - 1) % 7) > 0) rows++;
    }
    
    //当屏显示数据
    NSDate *visibleDate = [self.calendar.dateSupport preDayWithDate:date dayInterval:weekday-1];//显示的第一个日期
    NSMutableArray *visibleDates = [NSMutableArray arrayWithObject:visibleDate];
    for (int i = 1; i < rows*7; i ++) {
        visibleDate = [self.calendar.dateSupport nextDayWithDate:visibleDate dayInterval:1];
        [visibleDates addObject:visibleDate];
    }
    return visibleDates.copy;
}

- (NSString *)currentYMString {
    NSString *dateStr = [self.calendar.dateSupport dateFormatConversion:_visibleYM];
    return [dateStr substringToIndex:8];
}

- (CGFloat)calendarInitHeight {
    NSInteger rows = [self visibleItemRowsHandle];
    return self.calendar.appearance.headBarHeight + self.calendar.appearance.weekBarHeight + rows * self.calendar.appearance.dayRowHeight;
}
+ (CGFloat)calendarDefaultHeight {
    return 44 + 30 + 44 * 6;//headBarHeight weekBarHeight dayRowHeight
}
@end
