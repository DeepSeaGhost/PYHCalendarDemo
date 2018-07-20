//
//  PYHCalendarWeekBar.m
//  Created by reset on 2018/6/27.

#import "PYHCalendarWeekBar.h"
#define kWeekBarTag 1000

@implementation PYHCalendarWeekBar {
    PYHCalendar *_calendar;
}
- (instancetype)initWithCalendar:(PYHCalendar *)calendar {
    if (self = [super init]) {
        [self baseConfig:calendar];
        [self configSubViews];
    }
    return self;
}
- (void)baseConfig:(PYHCalendar *)calendar {
    _calendar = calendar;
    self.backgroundColor = _calendar.appearance.weekBarBackgroundColor;
}
- (void)configSubViews {
    NSArray *texts = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < 7; i ++) {
        UILabel *lb = [[UILabel alloc]init];
        lb.font = _calendar.appearance.weekTextFont;
        lb.textColor = _calendar.appearance.weekTextColor;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = [texts objectAtIndex:i];
        lb.tag = i + kWeekBarTag;
        [self addSubview:lb];
    }
}

#pragma mark - config frame 
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *lb = (UILabel *)obj;
            NSInteger tag = lb.tag - kWeekBarTag;
            CGFloat w = CGRectGetWidth(self.frame) / 7;
            CGFloat x = w * tag;
            lb.frame = CGRectMake(x, 0, w, CGRectGetHeight(self.frame));
        }
    }];
}
@end
