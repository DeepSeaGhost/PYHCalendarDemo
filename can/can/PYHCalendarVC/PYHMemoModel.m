//
//  PYHMemoModel.m
//  Created by reset on 2018/7/11.

#import "PYHMemoModel.h"

@implementation PYHMemoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (void)setMemos:(NSArray *)memos {
    NSMutableArray *nmArr = [NSMutableArray array];
    for (id objc in memos) {
        if ([objc isKindOfClass:[PYHMemoSubModel class]]) {
            [nmArr addObject:objc];
        }else {
            PYHMemoSubModel *model = [[PYHMemoSubModel alloc] initWithDict:(NSDictionary *)objc];
            [nmArr addObject:model];
        }
    }
    _memos = nmArr.copy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%@",self.date,self.memos];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@%@",self.date,self.memos];
}
@end

@implementation PYHMemoSubModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%@%@",self.beginDate,self.memoInfo,self.endDate];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@%@%@",self.beginDate,self.memoInfo,self.endDate];
}
@end
