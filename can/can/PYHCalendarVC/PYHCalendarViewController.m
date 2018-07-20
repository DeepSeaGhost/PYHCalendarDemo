//
//  PYHCalendarViewController.m
//  Created by reset on 2018/6/21.

#import "PYHCalendarViewController.h"
#import "PYHLookMemoViewController.h"
#import "PYHEditorMemoViewController.h"
#import "PYHCalendar.h"
#define kTopBarY (self.navigationController ? 0 : [UIApplication sharedApplication].statusBarFrame.size.height)
//#define kVisibleHeight ([UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)

@interface PYHCalendarViewController ()<PYHCalendardelegate>

@property (nonatomic, strong) PYHCalendar *calendarV;
@property (nonatomic, strong) UIButton *lookMemoBT;
@property (nonatomic, strong) UIButton *editorMemoBT;
@end

@implementation PYHCalendarViewController {
    NSArray *_dates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    [self configUI];
}

#pragma mark - base config
- (void)baseConfig {
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - config UI
- (void)configUI {
    [self.view addSubview:self.calendarV];
    [self.view addSubview:self.lookMemoBT];
    [self.view addSubview:self.editorMemoBT];
}

#pragma mark - PYHCalendarDelegate
- (void)calendar:(PYHCalendar *)calendar currentVisibleYearMonthDate:(NSDate *)date {
//    NSLog(@"%@%@",calendar,date);
}
- (void)calendar:(PYHCalendar *)calendar refreshFrame:(CGRect)frame {
//    NSLog(@"%@%@",calendar,NSStringFromCGRect(frame));
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.2 animations:^{
        wself.calendarV.frame = frame;
    }];
}
- (void)calendar:(PYHCalendar *)calendar selectDates:(NSArray *)dates {
    NSLog(@"%@%@",calendar,dates);
    self.editorMemoBT.hidden = !dates.count && dates.count != 1;
    _dates = dates;
}


#pragma mark - handle click
- (void)lookMemoClcik {
    PYHLookMemoViewController *vc = [[PYHLookMemoViewController alloc]initWithDates:nil isEditor:NO];
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }
}
- (void)editorMemoClcik {
    PYHLookMemoViewController *vc = [[PYHLookMemoViewController alloc]initWithDates:_dates isEditor:YES];
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }
}

#pragma mark - lazy loading
- (PYHCalendar *)calendarV {
    if (!_calendarV) {
        _calendarV = [[PYHCalendar alloc]initWithFrame:CGRectMake(0, kTopBarY, [UIScreen mainScreen].bounds.size.width, [PYHCalendarHandleSupport calendarDefaultHeight])];
        _calendarV.delegate = self;
        _calendarV.isChangeHeight = YES;
//        _calendarV.handleSupport.selectType = PYHCalendarSelectConnection;
    }
    return _calendarV;
}
- (UIButton *)lookMemoBT {
    if (!_lookMemoBT) {
        _lookMemoBT = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarV.frame) + (CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.calendarV.frame) - 118.f)/2, CGRectGetWidth(self.view.frame), 44.f)];
        _lookMemoBT.backgroundColor = [UIColor brownColor];
        [_lookMemoBT setTitle:@"查看备忘录" forState:UIControlStateNormal];
        [_lookMemoBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lookMemoBT.titleLabel.font = [UIFont systemFontOfSize:15];
        [_lookMemoBT addTarget:self action:@selector(lookMemoClcik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookMemoBT;
}
- (UIButton *)editorMemoBT {
    if (!_editorMemoBT) {
        _editorMemoBT = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lookMemoBT.frame) + 30, CGRectGetWidth(self.view.frame), 44.f)];
        _editorMemoBT.hidden = YES;
        _editorMemoBT.backgroundColor = [UIColor brownColor];
        [_editorMemoBT setTitle:@"编辑备忘录" forState:UIControlStateNormal];
        [_editorMemoBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _editorMemoBT.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editorMemoBT addTarget:self action:@selector(editorMemoClcik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorMemoBT;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
