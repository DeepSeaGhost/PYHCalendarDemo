//
//  PYHMarkScrollSupport.m
// Created by reset on 2018/7/13.

#import "PYHMarkScrollSupport.h"
@interface PYHMarkScrollSupport ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, weak) UIScrollView *target;
@property (nonatomic, copy) CallBack tapCallback;
@property (nonatomic, copy) CallBack longpressCallback;

@end
@implementation PYHMarkScrollSupport
- (instancetype)initWithTarget:(UIScrollView *)target {
    if (self = [super init]) {
        _target = target;
        _signCount = 24;
        _signHeight = 15.f;
        _signBetweenSpace = 30.f;
        _top = 10.f;
        _bottom = 10.f;
        _markLabels = [NSMutableArray array];
        
        _markFrame = CGRectZero;
        _isUP = NO;
    }
    return self;
}

#pragma mark - displayLink
- (void)runDisplayLink {
    //启动的时候先对cMarkLabel进行初始的对齐操作
    if (_markType != CMarkTypeMove) _cMarkLabel.h += (_isUP ? ABS(_cMarkLabel.minY - self.target.visibleMinY) : ABS(_cMarkLabel.maxY - self.target.visibleMaxY));
    _cMarkLabel.minY = _isUP ? self.target.visibleMinY : (self.target.visibleMaxY - _cMarkLabel.h);
    
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeContentOffset)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}
- (void)stopDisplayLink {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}
- (void)changeContentOffset {
    CGFloat operand = self.isUP ? -2.f : 2.f;
    
    if (self.markType != CMarkTypeMove) self.cMarkLabel.h += ABS(operand);
    if (self.markType != CMarkTypeDown) self.cMarkLabel.minY += operand;
    _target.contentOffsetY += operand;
    
    if (self.isUP && self.cMarkLabel.minY < (_top + _signHeight/2)) {
        self.cMarkLabel.minY = _top + _signHeight/2;
        if (self.markType != CMarkTypeMove) self.cMarkLabel.h = CGRectGetMaxY(self.markFrame) - self.cMarkLabel.minY;
    }else if (!self.isUP && self.cMarkLabel.maxY > _signCount * (_signHeight + _signBetweenSpace) + _top - _signHeight/2) {
        if (self.markType != CMarkTypeMove) self.cMarkLabel.h = _signCount * (_signHeight + _signBetweenSpace) + _top - _signHeight/2 - CGRectGetMinY(self.markFrame);
        self.cMarkLabel.minY = _signCount * (_signHeight + _signBetweenSpace) + _top - _signHeight/2 - self.cMarkLabel.h;
    }
    if (_target.visibleMinY < 0 || _target.visibleMinY > _target.maxOffsetY) {
        _target.contentOffsetY = _target.visibleMinY < 0 ? 0 : _target.maxOffsetY;
        [self stopDisplayLink];
    }
}

#pragma mark - GestureRecognizer
- (void)addTapGestureRecognizerWithCallback:(CallBack)callback {
    _tapCallback = callback;
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.target addGestureRecognizer:self.tap];
}
- (void)addLongPressGestureRecognizerWithCallback:(CallBack)callback {
    _longpressCallback = callback;
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    [self.target addGestureRecognizer:self.longPress];
}
- (void)longPressClick:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPress locationInView:self.target];
        for (PYHLookMarkLabel *lb in self.markLabels) {
            BOOL isIN = [lb touchInRect:point];
            if (isIN) {
                if ([lb isEqual:self.cMarkLabel]) return;
                [lb setSelectType];
                if (self.cMarkLabel) [self.cMarkLabel reset];
                self.cMarkLabel = lb;
                self.markFrame = self.cMarkLabel.frame;
                return;
            }
        }
        if (self.longpressCallback) self.longpressCallback(longPress);
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tapGR {
    CGPoint point = [tapGR locationInView:self.target];
    for (PYHLookMarkLabel *lb in self.markLabels) {
        BOOL isIN = [lb touchInRect:point];
        if (isIN) {//点击备忘
            if (![lb isEqual:self.cMarkLabel]) {
                if (self.cMarkLabel) [self.cMarkLabel reset];
                self.cMarkLabel = nil;
                if (self.tapCallback) self.tapCallback(lb);
            }
            return;
        }
    }
    //点击的地方是空白区域
    if (self.cMarkLabel) [self.cMarkLabel reset];
    self.cMarkLabel = nil;
}
- (void)gestureRecognizerEnabled:(BOOL)enabled {
    self.tap.enabled = enabled;
    self.longPress.enabled = enabled;
}

#pragma mark - time to frame   frame to time
- (CGRect)initMarkFrameWithSuperWidth:(CGFloat)width begindate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    NSDictionary *beginInfo = [PYHMemoSupport memoSupportDateToDictionary:beginDate];
    NSDictionary *endInfo = [PYHMemoSupport memoSupportDateToDictionary:endDate];
    NSInteger beginY = ([beginInfo[@"hour"] integerValue] + ([beginInfo[@"minute"] integerValue] >= 30 ? 0.5 : 0)) * 2;
    NSInteger endY = ([endInfo[@"hour"] integerValue] + ([endInfo[@"minute"] integerValue] >= 30 ? 0.5 : 0)) * 2;
    
    CGFloat y = beginY * (_signHeight + _signBetweenSpace)/2 + _top + _signHeight/2;
    CGFloat h = ((endY - beginY) < 1 ? 1 : ((endY - beginY) > 48 ? 48 : (endY - beginY))) * (_signHeight + _signBetweenSpace)/2;
    return CGRectMake(45.f, y, width - 45.f, h);
}
- (CGRect)moveEndedAdjustFrameAndRefeshModel:(PYHMemoModel *)model {
    CGRect frame = self.cMarkLabel.frame;
    int yCount = (frame.origin.y - (_top + _signHeight/2)) / ((_signHeight + _signBetweenSpace)/2);
    frame.origin.y = yCount * ((_signBetweenSpace + _signHeight)/2)  + _top + _signHeight/2;
    
    int hCount = frame.size.height / ((_signBetweenSpace + _signHeight)/2);
    //当向上扩展的时候 如果y变化不是以半个间隔的整数倍运动 那么有便会将多余的数据丢弃 然而想要以精确整数倍运动几乎为零
    //向上运动最大y轴位置是不变的  因此需要将丢弃的数据在高度上面补回来  才有了这个判断 +1
    hCount = self.markType == CMarkTypeUP ? hCount + 1 : hCount;
    frame.size.height = hCount * ((_signBetweenSpace + _signHeight)/2);
    
    //刷新model
    NSString *beginTime = [NSString stringWithFormat:@"%2d-%2d",yCount / 2,yCount % 2 ? 30 : 0];
    NSString *endTIme = [NSString stringWithFormat:@"%2d-%2d",(yCount+hCount) / 2,(yCount+hCount) % 2 ? 30 : 0];
    PYHMemoSubModel *subModel = [model.memos objectAtIndex:[self.markLabels indexOfObject:self.cMarkLabel]];
    subModel.beginDate = [self formatConversion:beginTime];
    subModel.endDate = [self formatConversion:endTIme];
    
    [PYHMemoSupport writeSandbox:model];
    self.markFrame = frame;
    return frame;
}
- (NSString *)timeFromTouchPoint:(CGPoint)point {
    CGFloat y = point.y - (_top + _signHeight/2);
    int hour =  (int)y / (int)(_signHeight + _signBetweenSpace);
    int minute = (int)y % (int)(_signHeight + _signBetweenSpace);
    return [NSString stringWithFormat:@"%02d点%02d分",hour,minute];
}
- (NSDate *)formatConversion:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm";
    return [formatter dateFromString:time];
}


- (void)dealloc {
    if (!_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}
@end
