//
//  PYHCalendarAppearance.m
//  Created by reset on 2018/6/27.

#import "PYHCalendarAppearance.h"
#define rgb(r,g,b,a) [UIColor colorWithRed:(r*1.0)/255 green:(g*1.0)/255 blue:(b*1.0)/255 alpha:(a*1.0)]

@implementation PYHCalendarAppearance

- (instancetype)init {
    if (self = [super init]) {
       
        
        //headBar
        _headBarBackgroundColor = [UIColor whiteColor];
        _headBarRLTextColor = rgb(19, 60, 77, 1.0);
        _headBarRLTextFont = [UIFont systemFontOfSize:13];
        _headBarCenterSignTextColor = rgb(60, 67, 80, 1.0);
        _headBarCenterSignTextFont = [UIFont systemFontOfSize:18];
        _headBarHeight = 44.f;
     
        //weekBar
        _weekBarBackgroundColor = rgb(188, 192, 200, 0.2f);
        _weekTextColor = rgb(170, 166, 162, 1.0);
        _weekTextFont = [UIFont systemFontOfSize:13];
        _weekBarHeight = 30.f;
     
        //day collection
        _dayTextColor = [UIColor blackColor];
        _dayTextFont = [UIFont systemFontOfSize:15];
        _todayColor = rgb(46, 184, 114, 1.0);
        _selectColor = rgb(135, 206, 235, 1.0);
        _dayRowHeight = 44.f;
    }
    return self;
}
@end
