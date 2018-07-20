//
//  PYHCalendarHandleSupport.h
//  Created by reset on 2018/6/22.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PYHCalendar;
typedef NS_OPTIONS(NSUInteger, PYHCalendarSelectType) {
    PYHCalendarSelectOnly       = 0, //select only day
    PYHCalendarSelectWeek  = 1 << 0,//select one week
    PYHCalendarSelectConnection    = 1 << 1,//two point connection
};

@interface PYHCalendarHandleSupport : NSObject

@property (nonatomic, strong) PYHCalendar *calendar;
@property (nonatomic, assign) NSInteger CMIndex;//current Month index
@property (nonatomic, strong) NSDate *visibleYM;//当前屏幕年月信息
@property (nonatomic, assign) NSInteger todayIndex;
@property (nonatomic) PYHCalendarSelectType selectType;

@property (nonatomic, strong) NSMutableArray *selectDates;
@property (nonatomic, strong) NSDate *preSelectDate;
- (void)selectAddNewobjectAndSort:(NSArray *)dates;

/**
 * 作用：滚动处理 计算当前时间与当前月份下标
 * 返回值：是否超出日历区间
 */
- (BOOL)scrollHandleCurrentDate:(BOOL)isPre changeCount:(NSInteger)changeCount;

///当屏显示行数
- (NSInteger)visibleItemRowsHandle;
///当屏显示数据
- (NSArray *)visibleItemDataHandle:(NSInteger)itemIndex;

///获取当前年月
- (NSString *)currentYMString;

///获取日历初始化最佳高度
- (CGFloat)calendarInitHeight;

///获取日历原始设计默认高度
+ (CGFloat)calendarDefaultHeight;
@end
