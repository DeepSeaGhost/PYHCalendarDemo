//
//  PYHCalendarDateSupport.h
//  Created by reset on 2018/6/25.
//  日历区间：1900.01.01-2500.01.01

#import <Foundation/Foundation.h>

@interface PYHCalendarDateSupport : NSObject

///获取具体日期
- (NSDate *)year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

///获取日期所在月总天数
- (NSInteger)monthDaysWithDate:(NSDate *)date;

///获取日期是周几 （1234567 日一二三四五六）
- (NSInteger)weekDayWithDate:(NSDate *)date;

///获取日期所在月第一天日期
- (NSDate *)firstDateInModthWithDate:(NSDate *)date;

///相比1900相差多少月
- (NSInteger)monthIntervalSince1900WithDate:(NSDate *)date;
///获取两个日期之间左右天数
+ (NSInteger)daysWithDate:(NSDate *)date1 betweenDate:(NSDate *)date2;

///获取日
- (NSInteger)dayWithDate:(NSDate *)date;

///获取上几个月
- (NSDate *)preMonthWithDate:(NSDate *)date monthInterval:(NSInteger)months;
///获取下几个月
- (NSDate *)nextMonthWithDate:(NSDate *)date monthInterval:(NSInteger)months;

///获取前多少天
- (NSDate *)preDayWithDate:(NSDate *)date dayInterval:(NSInteger)days;
///获取后多少天
- (NSDate *)nextDayWithDate:(NSDate *)date dayInterval:(NSInteger)days;

///比较两个时间是否是同一天 按照年月日
- (BOOL)compareDate:(NSDate *)date1 toDate:(NSDate *)date2;

///日期格式转换
- (NSString *)dateFormatConversion:(NSDate *)date;
+ (NSString *)dateFormatConversion:(NSDate *)date;
+ (NSDate *)stringFormatConversion:(NSString *)string;//@"1900-01-01" to 1900-01-01

///计算两个日期之间所有日期
- (NSArray *)obtainAllDateWithBeforeDate:(NSDate *)date1 lastDate:(NSDate *)date2;

///判断两个日期是否属于同一月
- (BOOL)sameMonthWithDate1:(NSDate *)date1 date2:(NSDate *)date2;

///date 解析成字典
+ (NSDictionary *)dateToDictionary:(NSDate *)date;
@end
