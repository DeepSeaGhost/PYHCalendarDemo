//
//  PYHMemoSupport.m
//  Created by reset on 2018/7/11.

#import "PYHMemoSupport.h"
#import "PYHCalendarDateSupport.h"
#import "NSFileManager+pyhCanlendar.h"


@implementation PYHMemoSupport {
    NSMutableDictionary *_memoInfos;
}

- (instancetype)init {
    if (self = [super init]) {
        _memoInfos = [NSMutableDictionary dictionary];
    }
    return self;
}

- (PYHMemoModel *)getMemoInfo:(NSInteger)index {
    NSDate *date = [NSDate dateWithTimeInterval:24 * 60 * 60 * index sinceDate:[PYHCalendarDateSupport stringFormatConversion:@"1900-01-01"]];
    PYHMemoModel *memo = [_memoInfos objectForKey:[self stringWithDate:date]];
    if (!memo) {
        //从沙盒数据库中取
        memo = [PYHMemoSupport readSendbox:date];
        //取出来后添加进memoinfos
        if(memo) [_memoInfos setValue:memo forKey:[self stringWithDate:date]];
    }
    return memo;
}
- (void)addMemoInfo:(NSDictionary *)memoInfo {
    NSArray *dates = [memoInfo objectForKey:@"memoDates"];
    NSDate *beginDate = [memoInfo objectForKey:@"memoBeginDate"];
    NSDate *endDate = [memoInfo objectForKey:@"memoEndDate"];
    NSString *memoText = [memoInfo objectForKey:@"memoText"];
    for (NSDate *date in dates) {
        PYHMemoModel *memo = [_memoInfos objectForKey:[self stringWithDate:date]];
        if (memo) {
            NSMutableArray *nmMemos = [NSMutableArray arrayWithArray:memo.memos];
            [nmMemos addObject:@{@"beginDate":beginDate,@"endDate":endDate,@"memoInfo":memoText}];
            memo.memos = nmMemos.copy;
        }else {
            memo = [[PYHMemoModel alloc]initWithDict:@{@"date":date,@"memos":@[@{@"beginDate":beginDate,@"endDate":endDate,@"memoInfo":memoText}]}];
        }
        [_memoInfos setValue:memo forKey:[self stringWithDate:date]];
        [PYHMemoSupport writeSandbox:memo];
    }
}
+ (void)updateSubModel:(PYHMemoSubModel *)subModel model:(PYHMemoModel *)model memoBeginText:(NSString *)beginText endText:(NSString *)endText content:(NSString *)content {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH点mm分";
    subModel.beginDate = [formatter dateFromString:beginText];
    subModel.endDate = [formatter dateFromString:endText];
    subModel.memoInfo = content;
    [PYHMemoSupport writeSandbox:model];
}
+ (void)deleteMemoInfoWithModel:(PYHMemoModel *)model subModel:(PYHMemoSubModel *)subModel {
    NSMutableArray *memos = [NSMutableArray arrayWithArray:model.memos];
    [memos removeObject:subModel];
    model.memos = memos.copy;
    [PYHMemoSupport writeSandbox:model];
}

///获取指定日期之间的天数
- (NSInteger)daysWith1900Between2500 {
    NSDate *date1900 = [PYHCalendarDateSupport stringFormatConversion:@"1900-01-01"];
    NSDate *date2500 = [PYHCalendarDateSupport stringFormatConversion:@"2500-01-01"];
    return [PYHCalendarDateSupport daysWithDate:date1900 betweenDate:date2500] + 2;
}
///获取初始下标
- (NSInteger)daysWith1900BetweenToday {
    NSDate *today = [NSDate date];
    NSDate *date1900 = [PYHCalendarDateSupport stringFormatConversion:@"1900-01-01"];
    _todayIndex = [PYHCalendarDateSupport daysWithDate:today betweenDate:date1900] + 1;
    return _todayIndex;
}
- (NSString *)stringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

///根据indexpath获取年月日
+ (NSString *)dateStringFromIndex:(NSInteger)index {
    NSDate *date = [NSDate dateWithTimeInterval:24 * 60 * 60 * index sinceDate:[PYHCalendarDateSupport stringFormatConversion:@"1900-01-01"]];
    return [PYHCalendarDateSupport dateFormatConversion:date];
}

///获取日期字典数据
+ (NSDictionary *)memoSupportDateToDictionary:(NSDate *)date {
    return [PYHCalendarDateSupport dateToDictionary:date];
}

///model to dictionary
+ (NSDictionary *)memeModel:(PYHMemoModel *)memoModel subMemoModel:(PYHMemoSubModel *)subMemoModel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *title = [formatter stringFromDate:memoModel.date];
    
    formatter.dateFormat = @"HH点mm分";
    NSString *beginText = [formatter stringFromDate:subMemoModel.beginDate];
    NSString *endText = [formatter stringFromDate:subMemoModel.endDate];
    NSString *content = subMemoModel.memoInfo;
    
    return @{@"title":title,@"beginText":beginText,@"endText":endText,@"content":content};
}


#pragma mark - 数据持久化
+ (void)writeSandbox:(PYHMemoModel *)model {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [formatter stringFromDate:model.date];
    formatter.dateFormat = @"HH点mm分";
    NSMutableArray *nmArr = [NSMutableArray array];
    for (PYHMemoSubModel *sModel in model.memos) {
        NSString *beginText = [formatter stringFromDate:sModel.beginDate];
        NSString *endText = [formatter stringFromDate:sModel.endDate];
        NSString *content = sModel.memoInfo;
        [nmArr addObject:@{@"beginText":beginText,@"endText":endText,@"content":content}];
    }
    [NSFileManager writeDataToFileDirectory:@"用户账号" key:key data:nmArr.copy];
}
+ (PYHMemoModel *)readSendbox:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [formatter stringFromDate:date];
    NSArray *arr = [NSFileManager readDataWithFileDirectory:@"用户账号" withKey:key];
    PYHMemoModel *model = [[PYHMemoModel alloc]init];
    model.date = date;
    formatter.dateFormat = @"HH点mm分";
    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *beginText = [obj objectForKey:@"beginText"];
        NSString *endText = [obj objectForKey:@"endText"];
        NSString *content = [obj objectForKey:@"content"];
        [obj setValue:[formatter dateFromString:endText] forKey:@"endDate"];
        [obj setValue:[formatter dateFromString:beginText] forKey:@"beginDate"];
        [obj setValue:content forKey:@"memoInfo"];
    }];
    model.memos = arr;
    return model;
}
@end
