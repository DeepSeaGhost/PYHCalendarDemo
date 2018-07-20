//
//  PYHCalendarCell.m
//  Created by reset on 2018/6/22.

#import "PYHCalendarCell.h"
#import "PYHCalendar.h"
#define kCalendarCell 1000
#define kDayBTW (CGRectGetWidth(self.frame) / 7)

@interface PYHCalendarCell ()
@property (nonatomic, strong) NSArray *dates;
@end
@implementation PYHCalendarCell {
    PYHCalendar *_calendar;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
- (void)configItemDate:(NSInteger)itemIndex calendar:(PYHCalendar *)calendar {
    _calendar = calendar;
    self.dates = [_calendar.handleSupport visibleItemDataHandle:itemIndex];
    [self configData];
}

#pragma mark - config data
- (void)configData {
    for (int i = 0; i < 42; i ++) {
        PYHCalendarCellButton *bt = [self.contentView viewWithTag:i + kCalendarCell];
        [bt disableAll];
        bt.titleLabel.font = _calendar.appearance.dayTextFont;
        bt.titleLabel.textColor = _calendar.appearance.dayTextColor;
        if (i > self.dates.count-1) {
            bt.hidden = YES;
        }else {
            bt.hidden = NO;
            NSDate *date = [self.dates objectAtIndex:i];
            bt.titleLabel.text = [NSString stringWithFormat:@"%zd",[_calendar.dateSupport dayWithDate:[date dateByAddingTimeInterval:[NSTimeZone systemTimeZone].secondsFromGMT]]];
            
            //判断是否是显示月 透明度
            if (![_calendar.dateSupport sameMonthWithDate1:date date2:[self.dates objectAtIndex:self.dates.count / 2]]) {
                bt.titleLabel.textColor = [_calendar.appearance.dayTextColor colorWithAlphaComponent:0.3];
            }
            //判断是否是今天
            if ([_calendar.dateSupport compareDate:date toDate:[NSDate date]]) {
                bt.titleLabel.backgroundColor = _calendar.appearance.todayColor;
            }
            //判断选中日期集合中是否有当前日期 进行标选
            if([_calendar.handleSupport.selectDates containsObject:date]) {
                NSInteger index = [_calendar.handleSupport.selectDates indexOfObject:date];
                if (_calendar.handleSupport.selectType == PYHCalendarSelectOnly) {
                    bt.titleLabel.backgroundColor = _calendar.appearance.selectColor;
                }else {
                    if (index == 0) {
                        [bt enabledRightLayer:_calendar.appearance.selectColor];
                        bt.titleLabel.backgroundColor = _calendar.appearance.selectColor;
                    }else if (index == _calendar.handleSupport.selectDates.count -1) {
                        bt.titleLabel.backgroundColor = _calendar.appearance.selectColor;
                        [bt enabledLeftLayer:_calendar.appearance.selectColor];
                    }else {
                        [bt enabledRightLayer:_calendar.appearance.selectColor];
                        [bt enabledLeftLayer:_calendar.appearance.selectColor];
                    }
                }
            }
        }
    }
}

#pragma mark - config ui
- (void)configUI {
    for (int i = 0; i < 6 * 7; i ++) {
        PYHCalendarCellButton *bt = [[PYHCalendarCellButton alloc]init];
        bt.tag = kCalendarCell + i;
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bt disableAll];
        [bt addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bt];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PYHCalendarCellButton class]]) {
            PYHCalendarCellButton *bt = (PYHCalendarCellButton *)obj;
            NSInteger tag = bt.tag - kCalendarCell;
            CGFloat x = kDayBTW * (tag % 7);
            CGFloat y = _calendar.appearance.dayRowHeight * (tag / 7);
            bt.frame = CGRectMake(x, y, kDayBTW, _calendar.appearance.dayRowHeight);
        }
    }];
}


#pragma mark - bt click handle
- (void)dateSelect:(PYHCalendarCellButton *)bt {
    NSInteger tag = bt.tag;
    NSMutableArray *dateArr = [NSMutableArray array];
    BOOL isBlock = YES;
    switch (_calendar.handleSupport.selectType) {
        case PYHCalendarSelectOnly:
        {
            [_calendar.handleSupport.selectDates removeAllObjects];
            NSDate *date = [self.dates objectAtIndex:bt.tag-kCalendarCell];
            [dateArr addObject:date];
        }
            break;
        case PYHCalendarSelectWeek:
        {
            [_calendar.handleSupport.selectDates removeAllObjects];
            NSArray *dateIndexs = [self weekDateIndexs:tag];
            [dateIndexs enumerateObjectsUsingBlock:^(NSNumber *indexNumber, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger index = [indexNumber integerValue];
                NSDate *date = [self.dates objectAtIndex:index];
                [dateArr addObject:date];
            }];
        }
            break;
        case PYHCalendarSelectConnection:
        {
            if (!_calendar.handleSupport.preSelectDate ||  [_calendar.handleSupport.preSelectDate isEqualToDate:[self.dates objectAtIndex:tag - kCalendarCell]]) {
                isBlock = NO;
                bt.titleLabel.backgroundColor = _calendar.appearance.selectColor;
            }
            [dateArr addObjectsFromArray:[self betweenTwoDatesIndexs:tag]];
        }
            break;
    }
    [_calendar.handleSupport selectAddNewobjectAndSort:dateArr.copy];
    if (self.selectBlock && isBlock) self.selectBlock(_calendar.handleSupport.selectDates);
}

//一周日期在当前日期集合中的下标
- (NSArray *)weekDateIndexs:(NSInteger)btTag {
    btTag = btTag - kCalendarCell;
    if (btTag < 7) {
        return @[@0,@1,@2,@3,@4,@5,@6];
    }else if (btTag < 14) {
        return @[@7,@8,@9,@10,@11,@12,@13];
    }else if (btTag < 21) {
        return @[@14,@15,@16,@17,@18,@19,@20];
    }else if (btTag < 28) {
        return @[@21,@22,@23,@24,@25,@26,@27];
    }else if (btTag < 35) {
        return @[@28,@29,@30,@31,@32,@33,@34];
    }
    return @[@35,@36,@37,@38,@39,@40,@41];
}
//两个日期之前左右日期
- (NSArray *)betweenTwoDatesIndexs:(NSInteger)btTag {
    NSDate *lastDate = [self.dates objectAtIndex:btTag - kCalendarCell];
    if (_calendar.handleSupport.preSelectDate) {
        NSDate *beforeDate = _calendar.handleSupport.preSelectDate;
        //计算两个日期之间所有日期
        return [_calendar.dateSupport obtainAllDateWithBeforeDate:beforeDate lastDate:lastDate];
    }
    _calendar.handleSupport.preSelectDate = lastDate;
    return @[lastDate];
}
@end

#pragma mark - PYHCalendarCellButton
@implementation PYHCalendarCellButton {
    CALayer *_lLayer;
    CALayer *_rLayer;
    UILabel *_titleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _lLayer = [[CALayer alloc]init];
        _rLayer = [[CALayer alloc]init];
        _titleLabel = [[UILabel alloc]init];
        [self.layer addSublayer:_lLayer];
        [self.layer addSublayer:_rLayer];
        [self addSubview:_titleLabel];
    }
    return self;
}
- (void)enabledLeftLayer:(UIColor *)color {
    _lLayer.hidden = NO;
    _lLayer.backgroundColor = color.CGColor;
}
- (void)enabledRightLayer:(UIColor *)color {
    _rLayer.hidden = NO;
    _rLayer.backgroundColor = color.CGColor;
}
- (void)disableLeftLayer {
    _lLayer.hidden = YES;
    _lLayer.backgroundColor = [UIColor clearColor].CGColor;
}
- (void)disableRightLayer {
    _rLayer.hidden = YES;
    _rLayer.backgroundColor = [UIColor clearColor].CGColor;
}
- (void)disableAll {
    _lLayer.hidden = YES;
    _lLayer.backgroundColor = [UIColor clearColor].CGColor;
    _rLayer.hidden = YES;
    _rLayer.backgroundColor = [UIColor clearColor].CGColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat wh = MIN(w, h);
    wh = wh > 30 ? 30.f : wh;
    CGFloat x = (w - wh)/2;
    CGFloat y = (h - wh)/2;
    
    _lLayer.frame = CGRectMake(0, y, w/2, wh);
    _rLayer.frame = CGRectMake(w/2, y, w/2, wh);
    _titleLabel.frame = CGRectMake(x, y, wh, wh);
    _titleLabel.layer.cornerRadius = wh / 2;
    _titleLabel.layer.masksToBounds = YES;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(50.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(50.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
