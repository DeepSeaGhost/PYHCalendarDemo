//
//  PYHMemoSupport.h
//  Created by reset on 2018/7/11.

#import <Foundation/Foundation.h>
#import "PYHMemoModel.h"

@interface PYHMemoSupport : NSObject

@property (nonatomic, assign) NSInteger todayIndex;

- (PYHMemoModel *)getMemoInfo:(NSInteger)index;
- (void)addMemoInfo:(NSDictionary *)memoInfo;
+ (void)updateSubModel:(PYHMemoSubModel *)subModel model:(PYHMemoModel *)model memoBeginText:(NSString *)beginText endText:(NSString *)endText content:(NSString *)content;
+ (void)deleteMemoInfoWithModel:(PYHMemoModel *)model subModel:(PYHMemoSubModel *)subModel;

///获取指定日期之间的天数
- (NSInteger)daysWith1900Between2500;
///获取初始下标
- (NSInteger)daysWith1900BetweenToday;

///根据indexpath获取年月日
+ (NSString *)dateStringFromIndex:(NSInteger)index;

///获取日期字典数据
+ (NSDictionary *)memoSupportDateToDictionary:(NSDate *)date;

///model to dictionary
+ (NSDictionary *)memeModel:(PYHMemoModel *)memoModel subMemoModel:(PYHMemoSubModel *)subMemoModel;

///数据持久化
+ (void)writeSandbox:(PYHMemoModel *)model;
@end
