//
//  PYHLookMemoCell.m
//  can
//
//  Created by reset on 2018/6/28.
//  Copyright © 2018年 HangzhouVongi. All rights reserved.
//

#import "PYHLookMemoCell.h"
#import "PYHMemoModel.h"
#import "PYHMemoSupport.h"
#import "PYHLookMarkScrollView.h"
#define kISIphone ((int)[UIApplication sharedApplication].statusBarFrame.size.height == 20 ? NO : YES)

@interface PYHLookMemoCell ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) PYHLookMarkScrollView *markScrollV;
@property (nonatomic, strong) PYHMemoModel *model;
@end
@implementation PYHLookMemoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selected = NO;
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.markScrollV];
    }
    return self;
}
- (void)model:(PYHMemoModel *)model index:(NSInteger)index {
    self.model = model;
    self.titleLB.text = [PYHMemoSupport dateStringFromIndex:index];
    self.markScrollV.model = model;
}

#pragma mark - lazy loading
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30.f)];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.font = [UIFont systemFontOfSize:16];
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}
- (PYHLookMarkScrollView *)markScrollV {
    if (!_markScrollV) {
        _markScrollV = [[PYHLookMarkScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(self.titleLB.frame) - (kISIphone ? 44 : 0))];
        __weak typeof(self) wself = self;
        _markScrollV.longPressSelectBlock = ^(NSString *time) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy年MM月dd日 HH点mm分";
            NSDate *date = [formatter dateFromString:[wself.titleLB.text stringByAppendingFormat:@" %@",time]];
            if (wself.longPressCallback) wself.longPressCallback(date);
        };
        _markScrollV.tapBlock = ^(PYHMemoSubModel *model) {
            if (wself.tapBlock) wself.tapBlock(@{@"model":wself.model,@"subModel":model});
        };
    }
    return _markScrollV;
}
@end

