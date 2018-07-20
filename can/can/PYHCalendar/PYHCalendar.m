//
//  PYHCalendar.m
//  can
//
//  Created by reset on 2018/6/27.
//  Copyright © 2018年 HangzhouVongi. All rights reserved.
//

#import "PYHCalendar.h"
#import "PYHCalendarHeadBar.h"
#import "PYHCalendarWeekBar.h"
#import "PYHCalendarCollectionView.h"
#import "PYHCalendarCell.h"
#define kRowH (self.appearance.dayRowHeight)
#define kHeadBarH (self.appearance.headBarHeight)
#define kWeekBarH (self.appearance.weekBarHeight)

@interface PYHCalendar ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) PYHCalendarHeadBar *headBar;
@property (nonatomic, strong) PYHCalendarWeekBar *weekBar;
@property (nonatomic, strong) PYHCalendarCollectionView *collectionV;
@end
@implementation PYHCalendar {
    NSInteger _preRows;
    PYHCalendarHandleSupport *_handleSupport;
    CAShapeLayer *_bLayer;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseConfig];
        [self configUI];
    }
    return self;
}
- (void)baseConfig {
    self.backgroundColor = [UIColor whiteColor];
    _bLayer = [[CAShapeLayer alloc]init];
    _bLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:_bLayer];
    
    _preRows = 0;
    _dateSupport = [[PYHCalendarDateSupport alloc]init];
    _handleSupport = [[PYHCalendarHandleSupport alloc]init];
    _appearance = [[PYHCalendarAppearance alloc]init];
    _handleSupport.calendar = self;
    _isChangeHeight = NO;
}
- (void)configUI {
    [self addSubview:self.headBar];
    [self addSubview:self.weekBar];
    [self addSubview:self.collectionV];
}


#pragma mark -- handle
- (void)headBarExtensionClickHandle:(NSInteger)type {
    switch (type) {
        case 1://回到今天
            [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.handleSupport.todayIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            break;
        case 2://重置 清除选中日期
        {
            [self.handleSupport.selectDates removeAllObjects];
            self.handleSupport.preSelectDate = nil;
            [self handleDaySelect:self.handleSupport.selectDates];
        }
            break;
        default:
            break;
    }
}
- (void)headBarClickHandle:(BOOL)isPre {
    NSInteger scrollIndex = self.handleSupport.CMIndex;
    scrollIndex = isPre ? (scrollIndex - 1) : (scrollIndex + 1);
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
- (void)scrollDrag:(UIScrollView *)scrollView {
//  CGPoint point = [scrollView.panGestureRecognizer translationInView:self];
    NSInteger count = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    NSInteger preCount = self.handleSupport.CMIndex;
    if (count == preCount) return;
    
    BOOL isPre = count > preCount ? NO : YES;
    [self refreshData:isPre changeCount:(NSInteger)ABS((count - preCount))];
}
- (void)refreshData:(BOOL)isPre changeCount:(NSInteger)changeCount {
    BOOL isBeyondDomain = [self.handleSupport scrollHandleCurrentDate:isPre changeCount:changeCount];
    if (isBeyondDomain) {
        //超出区间 不做任何处理
        [self.headBar pyh_setDisable:isPre];
        return;
    }else {
        [self.headBar pyh_setEnabled:isPre];
        [self.headBar pyh_setSignLBTitle:[self.handleSupport currentYMString]];
        if ([self.delegate respondsToSelector:@selector(calendar:currentVisibleYearMonthDate:)]) {
            [self.delegate calendar:self currentVisibleYearMonthDate:self.handleSupport.visibleYM];
        }
        
        //高度调整
        if (!self.isChangeHeight) return;
        NSInteger rows = [self.handleSupport visibleItemRowsHandle];
        if (rows != _preRows) {
            _preRows = rows;
            CGRect selfFrame = self.frame;
            selfFrame.size.height = CGRectGetMaxY(self.weekBar.frame) + rows*kRowH;
            if ([self.delegate respondsToSelector:@selector(calendar:refreshFrame:)]) {
                [self.delegate calendar:self refreshFrame:selfFrame];
            }
        }
    }
}
- (void)handleDaySelect:(NSArray *)dates {
    if (dates.count) {
        [self.headBar pyh_setExtensionEnabled:2];
    }else {
        [self.headBar pyh_setExtensionDisable:2];
    }
    [self.collectionV reloadData];
    if ([self.delegate respondsToSelector:@selector(calendar:selectDates:)]) {
        [self.delegate calendar:self selectDates:dates];
    }
}

#pragma mark -- CollectionDelegate dataDelagate scrollViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7200;//1900.01.01-2500.01.01
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PYHCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PYHCalendarCell" forIndexPath:indexPath];
    [cell configItemDate:indexPath.item calendar:self];
    __weak typeof(self) wself = self;
    cell.selectBlock = ^(NSArray *dates) {
        [wself handleDaySelect:dates];
    };
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollDrag:scrollView];
}


#pragma mark - public api
- (void)backToday {
    [self headBarExtensionClickHandle:1];
}
- (void)resetSelected {
    [self headBarExtensionClickHandle:2];
}
- (void)nextMonth {
    [self headBarClickHandle:NO];
}
- (void)preMonth {
    [self headBarClickHandle:YES];
}

#pragma mark -- lazy loading
- (PYHCalendarHeadBar *)headBar {
    if (!_headBar) {
        __weak typeof(self) wself = self;
        _headBar = [[PYHCalendarHeadBar alloc]initWithCalendar:self preNextMonth:^(BOOL isPre) {
            [wself headBarClickHandle:isPre];
        } extensionBlock:^(NSInteger type) {
            [wself headBarExtensionClickHandle:type];
        }];
        [_headBar pyh_setSignLBTitle:[self.handleSupport currentYMString]];
    }
    return _headBar;
}
- (PYHCalendarWeekBar *)weekBar {
    if (!_weekBar) {
        _weekBar = [[PYHCalendarWeekBar alloc]initWithCalendar:self];
    }
    return _weekBar;
}
- (PYHCalendarCollectionView *)collectionV {
    if (!_collectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionV = [[PYHCalendarCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionV registerClass:[PYHCalendarCell class] forCellWithReuseIdentifier:@"PYHCalendarCell"];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.calendar = self;
    }
    return _collectionV;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectGetWidth(self.headBar.frame) != CGRectGetWidth(self.frame)) {
        self.headBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kHeadBarH);
        self.weekBar.frame = CGRectMake(0, CGRectGetMaxY(self.headBar.frame), CGRectGetWidth(self.frame), kWeekBarH);
        [(UICollectionViewFlowLayout *)self.collectionV.collectionViewLayout setItemSize:CGSizeMake(CGRectGetWidth(self.frame),kRowH * 6)];
        self.collectionV.frame = CGRectMake(0, CGRectGetMaxY(self.weekBar.frame), CGRectGetWidth(self.frame), kRowH * 6);
    }
    _bLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
}
@end
