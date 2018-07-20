//
//  PYHCalendarDateSupport.m
//  Created by reset on 2018/6/25.

#import "PYHCalendarDateSupport.h"

@implementation PYHCalendarDateSupport{
    NSDate *_beginDate;
    NSDate *_endDate;
    NSCalendar *_calendar;
}
- (instancetype)init {
    if (self = [super init]) {
        _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _beginDate = [self year:1900 month:1 day:1];
        _endDate = [self year:2500 month:1 day:1];
    }
    return self;
}
- (NSDate *)year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *com = [[NSDateComponents alloc]init];
    com.year = year;
    com.month = month;
    com.day = day;
    return [_calendar dateFromComponents:com];
}

- (NSInteger)monthDaysWithDate:(NSDate *)date {
    NSRange range = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

- (NSInteger)weekDayWithDate:(NSDate *)date {
    NSDateComponents *com = [_calendar components:NSCalendarUnitWeekday  fromDate:date];
    return com.weekday;
}


- (NSDate *)firstDateInModthWithDate:(NSDate *)date {
    NSDateComponents *com = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:date];
    com.day = 1;
    return [_calendar dateFromComponents:com];
}

- (NSInteger)monthIntervalSince1900WithDate:(NSDate *)date {
    NSInteger interval = [NSTimeZone localTimeZone].secondsFromGMT;
    NSDate *beginDate = [_beginDate dateByAddingTimeInterval:interval];
    NSDate *parameterDate = [date dateByAddingTimeInterval:interval];
    NSDateComponents * com = [_calendar components:NSCalendarUnitMonth fromDate:beginDate toDate:parameterDate options:NSCalendarWrapComponents];
    return ABS(com.month);
}
///获取两个日期之间左右天数
+ (NSInteger)daysWithDate:(NSDate *)date1 betweenDate:(NSDate *)date2 {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger interval = [NSTimeZone localTimeZone].secondsFromGMT;
    NSDate *beginDate = [date1 dateByAddingTimeInterval:interval];
    NSDate *parameterDate = [date2 dateByAddingTimeInterval:interval];
    NSDateComponents * com = [calendar components:NSCalendarUnitDay fromDate:beginDate toDate:parameterDate options:NSCalendarWrapComponents];
    return ABS(com.day);
}


///获取日
- (NSInteger)dayWithDate:(NSDate *)date {
    NSDateComponents *com = [_calendar components:NSCalendarUnitDay fromDate:date];
    return com.day;
}

///获取上几个月
- (NSDate *)preMonthWithDate:(NSDate *)date monthInterval:(NSInteger)months {
    NSDateComponents *com = [[NSDateComponents alloc]init];
    com.month = - months;
    return [_calendar dateByAddingComponents:com toDate:date options:0];
}
///获取下几个月
- (NSDate *)nextMonthWithDate:(NSDate *)date monthInterval:(NSInteger)months {
    NSDateComponents *com = [[NSDateComponents alloc]init];
    com.month = months;
    return [_calendar dateByAddingComponents:com toDate:date options:0];
}

///获取前几天
- (NSDate *)preDayWithDate:(NSDate *)date dayInterval:(NSInteger)days {
    return [NSDate dateWithTimeInterval:-(24 * 60 * 60 * days) sinceDate:date];
}
///获取后几天
- (NSDate *)nextDayWithDate:(NSDate *)date dayInterval:(NSInteger)days {
    return [NSDate dateWithTimeInterval:24 * 60 * 60 * days sinceDate:date];
}

///比较两个时间是否是同一天 按照年月日
- (BOOL)compareDate:(NSDate *)date1 toDate:(NSDate *)date2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str1 = [formatter stringFromDate:date1];
    NSString *str2 = [formatter stringFromDate:date2];
    return [str1 isEqualToString:str2];
}


///日期格式转换 yyyy-MM-dd yyyy年MM月dd日
- (NSString *)dateFormatConversion:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter stringFromDate:date];
}
+ (NSString *)dateFormatConversion:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter stringFromDate:date];
}
+ (NSDate *)stringFormatConversion:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:string];
}


- (NSArray *)obtainAllDateWithBeforeDate:(NSDate *)date1 lastDate:(NSDate *)date2 {
    NSDate *date = [date1 earlierDate:date2];
    NSDateComponents *comDay = [_calendar components:NSCalendarUnitDay fromDate:date1 toDate:date2 options:NSCalendarWrapComponents];
    NSMutableArray *dates = [NSMutableArray arrayWithObject:date];
    for (int i = 0; i < ABS(comDay.day); i ++) {
        NSDateComponents *com = [[NSDateComponents alloc]init];
        com.day = 1;
        date = [_calendar dateByAddingComponents:com toDate:date options:0];
        [dates addObject:date];
    }
    return dates;
}

- (BOOL)sameMonthWithDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *str1 = [formatter stringFromDate:date1];
    NSString *str2 = [formatter stringFromDate:date2];
    return [str1 isEqualToString:str2];
}

///date 解析成字典
+ (NSDictionary *)dateToDictionary:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return @{@"year":@(com.year),@"month":@(com.month),@"day":@(com.day),@"hour":@(com.hour),@"minute":@(com.minute),@"second":@(com.second)};
}
@end
