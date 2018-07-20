//
//  PYHCalendarHeadBar.m
//  Created by reset on 2018/6/27.

#import "PYHCalendarHeadBar.h"

@interface PYHCalendarHeadBar ()

@property (nonatomic, strong) PYHHeadButton *preMonthBT;
@property (nonatomic, strong) PYHHeadButton *nexMonthtBT;
@property (nonatomic, strong) PYHHeadButton *todayBT;
@property (nonatomic, strong) PYHHeadButton *resetBT;
@property (nonatomic, strong) UILabel *centerSignLB;
@end
@implementation PYHCalendarHeadBar {
    CGFloat _rlSpace;
    calendarHeadBlock _callblock;
    extensionHeadBlock _extensionBlock;
    PYHCalendar *_calendar;
}

- (instancetype)initWithCalendar:(PYHCalendar *)calendar preNextMonth:(calendarHeadBlock)callback extensionBlock:(extensionHeadBlock)extensionBlock {
    if (self = [super init]) {
        [self baseConfig:callback extensionBlock:extensionBlock calendar:calendar];
        [self configUI];
    }
    return self;
}
- (void)baseConfig:(calendarHeadBlock)callblock extensionBlock:(extensionHeadBlock)extensionBlock calendar:(PYHCalendar *)calendar {
    _calendar = calendar;
    self.backgroundColor = _calendar.appearance.headBarBackgroundColor;
    _callblock = callblock;
    _extensionBlock = extensionBlock;
    _rlSpace = 10.f;
}
- (void)configUI {
    [self addSubview:self.preMonthBT];
    [self addSubview:self.nexMonthtBT];
    [self addSubview:self.todayBT];
    [self addSubview:self.resetBT];
    [self addSubview:self.centerSignLB];
}


#pragma mark -- click handle
- (void)preBTClick {
    if (_callblock) _callblock(YES);
}
- (void)nextBTClick {
    if (_callblock) _callblock(NO);
}
- (void)backToday {
    if (_extensionBlock) _extensionBlock(1);
}
- (void)resetClick {
    if (_extensionBlock) _extensionBlock(2);
}
- (void)pyh_setDisable:(BOOL)isPre {
    if (isPre) {
        self.preMonthBT.enabled = NO;
    }else {
        self.nexMonthtBT.enabled = NO;
    }
}
- (void)pyh_setEnabled:(BOOL)isPre {
    if (isPre) {
        self.nexMonthtBT.enabled = YES;
    }else {
        self.preMonthBT.enabled = YES;
    }
}
- (void)pyh_setExtensionDisable:(NSInteger)type {
    switch (type) {
        case 1:
            self.todayBT.enabled = NO;
            break;
        case 2:
            self.resetBT.enabled = NO;
            break;
    }
}
- (void)pyh_setExtensionEnabled:(NSInteger)type {
    switch (type) {
        case 1:
            self.todayBT.enabled = YES;
            break;
        case 2:
            self.resetBT.enabled = YES;
            break;
    }
}
- (void)pyh_setSignLBTitle:(NSString *)string {
    self.centerSignLB.text = string;
}

#pragma mark -- lazy loading
- (PYHHeadButton *)preMonthBT {
    if (!_preMonthBT) {
        _preMonthBT = [[PYHHeadButton alloc]initWithFrame:CGRectZero];
        [_preMonthBT setTitle:@"上一月" forState:UIControlStateNormal];
        [_preMonthBT setTitleColor:_calendar.appearance.headBarRLTextColor forState:UIControlStateNormal];
        [_preMonthBT setTitleColor:[_calendar.appearance.headBarRLTextColor colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
        _preMonthBT.titleLabel.font = _calendar.appearance.headBarRLTextFont;
        _preMonthBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_preMonthBT addTarget:self action:@selector(preBTClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preMonthBT;
}
- (PYHHeadButton *)nexMonthtBT {
    if (!_nexMonthtBT) {
        _nexMonthtBT = [[PYHHeadButton alloc]initWithFrame:CGRectZero];
        [_nexMonthtBT setTitle:@"下一月" forState:UIControlStateNormal];
        [_nexMonthtBT setTitleColor:_calendar.appearance.headBarRLTextColor forState:UIControlStateNormal];
        [_nexMonthtBT setTitleColor:[_calendar.appearance.headBarRLTextColor colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
        _nexMonthtBT.titleLabel.font = _calendar.appearance.headBarRLTextFont;
        _nexMonthtBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_nexMonthtBT addTarget:self action:@selector(nextBTClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nexMonthtBT;
}
- (PYHHeadButton *)todayBT {
    if (!_todayBT) {
        _todayBT = [[PYHHeadButton alloc]initWithFrame:CGRectZero];
        [_todayBT setTitle:@"今天" forState:UIControlStateNormal];
        [_todayBT setTitleColor:_calendar.appearance.headBarRLTextColor forState:UIControlStateNormal];
        [_todayBT setTitleColor:[_calendar.appearance.headBarRLTextColor colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
        _todayBT.titleLabel.font = _calendar.appearance.headBarRLTextFont;
        _todayBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_todayBT addTarget:self action:@selector(backToday) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayBT;
}
- (PYHHeadButton *)resetBT {
    if (!_resetBT) {
        _resetBT = [[PYHHeadButton alloc]initWithFrame:CGRectZero];
        [_resetBT setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBT setTitleColor:_calendar.appearance.headBarRLTextColor forState:UIControlStateNormal];
        [_resetBT setTitleColor:[_calendar.appearance.headBarRLTextColor colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
        _resetBT.titleLabel.font = _calendar.appearance.headBarRLTextFont;
        _resetBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _resetBT.enabled = NO;
        [_resetBT addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBT;
}
- (UILabel *)centerSignLB {
    if (!_centerSignLB) {
        _centerSignLB = [[UILabel alloc]initWithFrame:CGRectZero];
        _centerSignLB.textColor = _calendar.appearance.headBarCenterSignTextColor;
        _centerSignLB.textAlignment = NSTextAlignmentCenter;
        _centerSignLB.font = _calendar.appearance.headBarCenterSignTextFont;
        _centerSignLB.text = @"__年__月";
    }
    return _centerSignLB;
}

#pragma mark - config frame
- (void)layoutSubviews {
    [super layoutSubviews];
    self.preMonthBT.frame = CGRectMake(_rlSpace, 0, 44.f, CGRectGetHeight(self.frame));
    self.nexMonthtBT.frame = CGRectMake(CGRectGetWidth(self.frame)-_rlSpace-44.f, 0, 44.f, CGRectGetHeight(self.frame));
    self.todayBT.frame = CGRectMake(CGRectGetMinX(self.nexMonthtBT.frame)-_rlSpace-44.f, 0, 44.f, CGRectGetHeight(self.frame));
    self.resetBT.frame = CGRectMake(CGRectGetMaxX(self.preMonthBT.frame)+_rlSpace, 0, 44.f, CGRectGetHeight(self.frame));
    self.centerSignLB.frame = CGRectMake(CGRectGetMaxX(self.preMonthBT.frame), 0, CGRectGetMinX(self.nexMonthtBT.frame)-CGRectGetMaxX(self.preMonthBT.frame), CGRectGetHeight(self.frame));
}
@end

@implementation PYHHeadButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(50.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(50.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
