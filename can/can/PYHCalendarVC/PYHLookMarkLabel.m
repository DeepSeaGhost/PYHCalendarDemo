//
//  PYHLookMarkLabel.m
//  Created by reset on 2018/7/11.

#import "PYHLookMarkLabel.h"
@implementation PYHLookMarkLabel {
    CAShapeLayer *_lLineLayer;
    CAShapeLayer *_topLayer;
    CAShapeLayer *_bottomLayer;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:13];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.layer.backgroundColor = [UIColor colorWithRed:210/255.f green:240/255.f blue:254/255.f alpha:1.0].CGColor;
        _lLineLayer = [[CAShapeLayer alloc]init];
        _lLineLayer.frame = CGRectMake(0, 0, 3, CGRectGetHeight(self.frame));
        _lLineLayer.backgroundColor = [UIColor colorWithRed:54/255.f green:177/255.f blue:241/255.f alpha:1.0].CGColor;
        [self.layer addSublayer:_lLineLayer];
    }
    return self;
}
- (void)setContent:(NSString *)content {
    self.text = content;
    
    _topLayer = [self tbLayer:CGRectMake(30.f, - 4.f, 8.f, 8.f)];
    _bottomLayer = [self tbLayer:CGRectMake(CGRectGetWidth(self.frame)-40.f, CGRectGetHeight(self.frame)-4.f, 8.f, 8.f)];
    [self.layer addSublayer:_topLayer];
    [self.layer addSublayer:_bottomLayer];
}
- (CAShapeLayer *)tbLayer:(CGRect)frame {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 8.f, 8.f) cornerRadius:4.f];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor colorWithRed:54/255.f green:177/255.f blue:241/255.f alpha:1.0].CGColor;
    layer.frame = frame;
    layer.hidden = YES;
    return layer;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _lLineLayer.frame = CGRectMake(0, 0, 3, CGRectGetHeight(frame));
    _topLayer.frame = CGRectMake(30.f, - 4.f, 8.f, 8.f);
    _bottomLayer.frame = CGRectMake(CGRectGetWidth(frame)-40.f, CGRectGetHeight(frame)-4.f, 8.f, 8.f);
    [CATransaction commit];
}

#pragma mark 点击相关
- (BOOL)touchInRect:(CGPoint)point {
    return CGRectContainsPoint(self.frame, point);
}
- (NSInteger)touchInRectType:(CGPoint)point {
    CGRect topFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), 68.f, CGRectGetHeight(self.frame));
    CGRect bottomFrame = CGRectMake(CGRectGetMaxX(self.frame) - 68.f, CGRectGetMinY(self.frame), 68.f, CGRectGetHeight(self.frame));
    if (CGRectContainsPoint(topFrame, point)) {
        return 1;
    }else if (CGRectContainsPoint(bottomFrame, point)){
        return 3;
    }
    return 2;
}
- (void)setSelectType {
    self.layer.backgroundColor = [UIColor colorWithRed:54/255.f green:177/255.f blue:241/255.f alpha:1.0].CGColor;
    _topLayer.hidden = NO;
    _bottomLayer.hidden = NO;
}
- (void)reset {
    self.layer.backgroundColor = [UIColor colorWithRed:210/255.f green:240/255.f blue:254/255.f alpha:1.0].CGColor;
    _topLayer.hidden = YES;
    _bottomLayer.hidden = YES;
}
@end
