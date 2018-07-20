//
//  PYHMemoModel.h
//  Created by reset on 2018/7/11.

#import <Foundation/Foundation.h>

@interface PYHMemoModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *memos;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

@interface PYHMemoSubModel : NSObject

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, copy) NSString *memoInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
