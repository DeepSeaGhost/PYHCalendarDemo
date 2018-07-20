//
//  PYHCalendarAppearance.h
//  Created by reset on 2018/6/27.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PYHCalendarAppearance : NSObject

//headBar
@property (nonatomic, strong) UIColor *headBarBackgroundColor;
@property (nonatomic, strong) UIColor *headBarRLTextColor;
@property (nonatomic, strong) UIFont *headBarRLTextFont;
@property (nonatomic, strong) UIColor *headBarCenterSignTextColor;
@property (nonatomic, strong) UIFont *headBarCenterSignTextFont;
@property (nonatomic, assign) CGFloat headBarHeight;

//weekBar
@property (nonatomic, strong) UIColor *weekBarBackgroundColor;
@property (nonatomic, strong) UIColor *weekTextColor;
@property (nonatomic, strong) UIFont *weekTextFont;
@property (nonatomic, assign) CGFloat weekBarHeight;

//day collection
@property (nonatomic, strong) UIColor *dayTextColor;
@property (nonatomic, strong) UIFont *dayTextFont;
@property (nonatomic, strong) UIColor *todayColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, assign) CGFloat dayRowHeight;
@end
