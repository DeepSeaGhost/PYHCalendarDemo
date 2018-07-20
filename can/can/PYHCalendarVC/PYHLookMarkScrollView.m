//
//  PYHLookMarkScrollView.m
//  Created by reset on 2018/7/11.

#import "PYHLookMarkScrollView.h"
#import "PYHMarkScrollSupport.h"
#define kSignCount self.support.signCount
#define kSignH self.support.signHeight
#define kSignBS self.support.signBetweenSpace
#define kTop self.support.top
#define kBottom self.support.bottom
@interface PYHLookMarkScrollView ()

@property (nonatomic, strong) PYHMarkScrollSupport *support;
@end
@implementation PYHLookMarkScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
        [self configBaseSetup];
        [self configLayer];
    }
    return self;
}
- (void)configBaseSetup {
    self.support = [[PYHMarkScrollSupport alloc]initWithTarget:self];
    self.contentSize = CGSizeMake(0, kSignCount * (kSignH + kSignBS) + kTop + kBottom);
    __weak typeof(self) wself = self;
    [self.support addTapGestureRecognizerWithCallback:^(PYHLookMarkLabel *objc){
            //跳详情 presend 查看详情
            PYHMemoSubModel *model = [wself.model.memos objectAtIndex:[wself.support.markLabels indexOfObject:objc]];
            if (wself.tapBlock) wself.tapBlock(model);
    }];
    [self.support addLongPressGestureRecognizerWithCallback:^(UILongPressGestureRecognizer *longPress){
        NSString *time = [wself.support timeFromTouchPoint:[longPress locationInView:wself]];
        if (wself.longPressSelectBlock) wself.longPressSelectBlock(time);
    }];
}
- (void)configLayer {
    for (int i = 0; i < kSignCount + 1; i ++) {
        CGFloat y = (kSignBS + kSignH) * i + 10.f;
        CATextLayer *signTimeLayer = [[CATextLayer alloc]init];
        signTimeLayer.frame = CGRectMake(0, y, 45.f, kSignH);
        signTimeLayer.string = [NSString stringWithFormat:@"%02d:00",i];
        signTimeLayer.fontSize = 10.f;
        signTimeLayer.contentsScale = [UIScreen mainScreen].scale;
        signTimeLayer.foregroundColor = [UIColor colorWithRed:170/255.f green:166/255.f blue:162/255.f alpha:1.f].CGColor;
        signTimeLayer.alignmentMode = kCAAlignmentCenter;
        signTimeLayer.truncationMode = kCATruncationMiddle;
        [self.layer addSublayer:signTimeLayer];
        
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc]init];
        lineLayer.frame = CGRectMake(CGRectGetMaxX(signTimeLayer.frame), CGRectGetMaxY(signTimeLayer.frame) - kSignH/2, CGRectGetWidth(self.frame) - CGRectGetMaxX(signTimeLayer.frame) - 5.f, 1);
        lineLayer.backgroundColor = [UIColor colorWithRed:170/255.f green:166/255.f blue:162/255.f alpha:0.5f].CGColor;
        [self.layer addSublayer:lineLayer];
    }
}

#pragma mark - setModel
- (void)setModel:(PYHMemoModel *)model {
    _model = model;
    [self.support.markLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.support.markLabels removeAllObjects];
    if (!model) return;
    for (int i = 0; i < model.memos.count; i ++) {
        PYHMemoSubModel *obj = model.memos[i];
        CGRect frame = [self.support initMarkFrameWithSuperWidth:CGRectGetWidth(self.frame) begindate:obj.beginDate endDate:obj.endDate];
        PYHLookMarkLabel *lb = [[PYHLookMarkLabel alloc]initWithFrame:frame];
        lb.content = obj.memoInfo;
        [self addSubview:lb];
        [self.support.markLabels addObject:lb];
    }
}

#pragma mark - touches
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view {
    CGPoint point = [touches.anyObject locationInView:self];
    if (self.support.cMarkLabel && [self.support.cMarkLabel touchInRect:point]) [self allEnabled:NO];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.support.touchPoint = CGPointZero;
    self.support.markType = CMarkTypeMove;
    
    if (!self.support.cMarkLabel) return;
    CGPoint point = [touches.anyObject locationInView:self];
    if (![self.support.cMarkLabel touchInRect:point]) return;

    self.support.noMoveScrollV = self.support.cMarkLabel.minY > self.visibleMinY || self.support.cMarkLabel.maxY < self.visibleMaxY;
    self.support.touchPoint = point;
    self.support.markType = [self.support.cMarkLabel touchInRectType:self.support.touchPoint];
    NSLog(@"begin");
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.support.cMarkLabel || CGPointEqualToPoint(self.support.touchPoint, CGPointZero)) {
        [self allEnabled:YES];//对拖动结束后不走end的补救
        return;
    };

    //计算markLabel需要做出的变化
    CGPoint point = [touches.anyObject locationInView:self];
    CGRect frame = self.support.cMarkLabel.frame;
    CGFloat y = point.y - self.support.touchPoint.y;
    switch (self.support.markType) {
        case CMarkTypeUP:
        {
            frame.origin.y = frame.origin.y + y;
            frame.size.height = frame.size.height - y;
        }
            break;
        case CMarkTypeMove:
            frame.origin.y = frame.origin.y + y;
            break;
        case CMarkTypeDown:
            frame.size.height = frame.size.height + y;
            break;
        default:
            break;
    }
    
    //判断变化带来的后果 是否还存在于可视区域内 还是在可视区域外:上悬 还是下悬
    //可视区域外
    if (CGRectGetMinY(frame) <= self.visibleMinY && y < 0 && (self.support.markType == CMarkTypeUP || (self.support.markType == CMarkTypeMove && self.support.noMoveScrollV))) {
        self.support.isUP = YES;
        [self.support runDisplayLink];
        return;
    }
    if (CGRectGetMaxY(frame) >= self.visibleMaxY && y > 0 && (self.support.markType == CMarkTypeDown || (self.support.markType == CMarkTypeMove && self.support.noMoveScrollV))) {
        self.support.isUP = NO;
        [self.support runDisplayLink];
        return;
    }
    
    
    //可视区域内 change frame
    if (frame.size.height < (kSignBS + kSignH)/2) {
        frame.size.height = (kSignH + kSignBS) / 2;
    }else if (frame.size.height > 24 * (kSignBS + kSignH)) {
        frame.size.height = 24 * (kSignBS + kSignH);
    }else if (frame.origin.y < (kTop + kSignH/2)) {
        frame.origin.y = (kTop + kSignH/2);
    }else if (CGRectGetMaxY(frame) > (24 * (kSignBS + kSignH) + (kTop + kSignH/2))) {
        frame.origin.y = (24 * (kSignBS + kSignH) + (kTop + kSignH/2)) - CGRectGetHeight(frame);
    };
    self.support.cMarkLabel.frame = frame;
    self.support.touchPoint = point;
    self.support.noMoveScrollV ++;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.support stopDisplayLink];
    if (!self.support.cMarkLabel || CGPointEqualToPoint(self.support.touchPoint, CGPointZero)) return;
    
    self.support.cMarkLabel.frame = [self.support moveEndedAdjustFrameAndRefeshModel:self.model];
    [self allEnabled:YES];
    NSLog(@"end");
}


#pragma mark - enabled config
- (void)allEnabled:(BOOL)isEnabled {
    [[self returnSuperCollectionView:self] setScrollEnabled:isEnabled];
    self.scrollEnabled = isEnabled;
    [self.support gestureRecognizerEnabled:isEnabled];
}
- (UICollectionView *)returnSuperCollectionView:(UIView *)view {
    if (![view.superview isKindOfClass:[UICollectionView class]]) {
        return [self returnSuperCollectionView:view.superview];
    }
    return (UICollectionView *)view.superview;
}
@end


