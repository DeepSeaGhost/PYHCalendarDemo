//
//  PYHMarkScrollSupport.h
// Created by reset on 2018/7/13.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PYHLookMarkLabel.h"
#import "PYHMemoSupport.h"
#import "UIView+pyh_calendarFrame.h"
typedef void(^CallBack) (id objc);
typedef NS_ENUM(NSInteger, CMarkType) {
    CMarkTypeUP = 1,
    CMarkTypeMove = 2,
    CMarkTypeDown = 3,
    CMarkTypeNone
};

@interface PYHMarkScrollSupport : NSObject
- (instancetype)initWithTarget:(UIScrollView *)target;

///基础配置
@property (nonatomic, assign) NSInteger signCount;//标签数量 默认24小时
@property (nonatomic, assign) CGFloat signHeight;//标签高度
@property (nonatomic, assign) CGFloat signBetweenSpace;//标签间距
@property (nonatomic, assign) CGFloat top;//标签距离顶部间距
@property (nonatomic, assign) CGFloat bottom;//标签距离底部间距
@property (nonatomic, strong) NSMutableArray *markLabels;//所有备注框

///操作备注框需要缓存的数据
@property (nonatomic, strong) PYHLookMarkLabel *cMarkLabel;//当前选中备注框
@property (nonatomic) CMarkType markType;//操作类型
@property (nonatomic) CGPoint touchPoint;//手指位置
@property (nonatomic) CGRect markFrame;//备注框的frame 结束操作及时更新
@property (nonatomic, assign) BOOL noMoveScrollV;//不需要移动scrollView
@property (nonatomic, assign) BOOL isUP;//是否是向上移动
- (void)runDisplayLink;
- (void)stopDisplayLink;

///手势
- (void)addTapGestureRecognizerWithCallback:(CallBack)callback;
- (void)addLongPressGestureRecognizerWithCallback:(CallBack)callback;
- (void)gestureRecognizerEnabled:(BOOL)enabled;

///time to frame    frame to time
- (CGRect)initMarkFrameWithSuperWidth:(CGFloat)width begindate:(NSDate *)beginDate endDate:(NSDate *)endDate;
- (CGRect)moveEndedAdjustFrameAndRefeshModel:(PYHMemoModel *)model;
- (NSString *)timeFromTouchPoint:(CGPoint)point;
@end
