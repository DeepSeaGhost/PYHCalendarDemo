//
//  PYHEditorMemoViewController.m
//  Created by reset on 2018/6/28.
//#import "sys/utsname.h"
#import "PYHEditorMemoViewController.h"
#import "PYHMemoSupport.h"
#define kVisibleHeight ([UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)
#define kVisibleY (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)
#define kISIphone ((int)[UIApplication sharedApplication].statusBarFrame.size.height == 20 ? NO : YES)
#define kNavigationItemTitle (_isDetail ? @"备忘详细资料" : @"编辑备忘资料")
#define kBTTitle (_isDetail ? @"删除备忘资料" : @"确定")

@interface PYHEditorMemoViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLB;

@property (nonatomic, strong) UILabel *beginTimeLB;
@property (nonatomic, strong) UIButton *beginSelectBT;

@property (nonatomic, strong) UILabel *endTimeLB;
@property (nonatomic, strong) UIButton *endSelectBT;

@property (nonatomic, strong) UILabel *memoLB;
@property (nonatomic, strong) UITextView *memoTV;
@property (nonatomic, strong) UIView *memoHudV;//keyboard up

@property (nonatomic, strong) UIButton *sureBT;

@property (nonatomic, strong) PYHDatePicker *picker;
@end

@implementation PYHEditorMemoViewController {
    NSArray *_dates;
    UIButton *_selectTimeBT;
    NSString *_beginStr;
    NSString *_endStr;
    NSDate *_beginSelectDate;
    NSDate *_endSelectDate;
    BOOL _isBeginTimeFull;//开始时间补充完成
    BOOL _isEndTimeFull;//结束时间补充完成
    BOOL _isMemoInfoFull;//备注信息补充完成
    
    BOOL _isDetail;//是否查看详情
    BOOL _isChange;//做出修改
    NSDictionary *_memoDetail;//详细资料
    PYHMemoModel *_model;//父model 用于删除操作
    PYHMemoSubModel *_subModel;//需修改的mdoel
}

- (instancetype)initWithDates:(NSArray *)dates {
    if (self = [super init]) {
        _dates = dates;
        _isBeginTimeFull = NO;
        _isEndTimeFull = NO;
        _isMemoInfoFull = NO;
        _isDetail = NO;
    }
    return self;
}
- (instancetype)initWithDatail:(NSDictionary *)memoInfo {
    if (self = [super init]) {
        _model = [memoInfo objectForKey:@"model"];
        _subModel = [memoInfo objectForKey:@"subModel"];
        _memoDetail = [PYHMemoSupport memeModel:_model subMemoModel:_subModel];
        _dates = @[[_model date]];
        _isBeginTimeFull = YES;
        _isEndTimeFull = YES;
        _isMemoInfoFull = YES;
        _isDetail = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configNavigation];
    [self configUI];
}
- (void)configNavigation {
    self.navigationItem.title = kNavigationItemTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
}
- (void)goBack {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)configUI {
    [self.view addSubview:self.titleLB];
    [self.view addSubview:self.beginTimeLB];
    [self.view addSubview:self.beginSelectBT];
    [self.view addSubview:self.endTimeLB];
    [self.view addSubview:self.endSelectBT];
    [self.view addSubview:self.memoLB];
    [self.view addSubview:self.memoTV];
    [self.view addSubview:self.memoHudV];
    [self.view addSubview:self.sureBT];
    [self.view addSubview:self.picker];
    if (_memoDetail) {
        //return @{@"title":title,@"beginText":beginText,@"endText":endText,@"content":content};
        self.titleLB.text = [_memoDetail objectForKey:@"title"];
        [self.beginSelectBT setTitle:[_memoDetail objectForKey:@"beginText"] forState:UIControlStateNormal];
        [self.endSelectBT setTitle:[_memoDetail objectForKey:@"endText"] forState:UIControlStateNormal];
        self.memoTV.text = [_memoDetail objectForKey:@"content"];
    }
}


#pragma mark - date handle
- (NSString *)timeTogether {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    
    _beginStr = [formatter stringFromDate:_dates.firstObject];
    _endStr = [formatter stringFromDate:_dates.lastObject];
    if ([_beginStr isEqualToString:_endStr]) {
        return _beginStr;
    }
    return [_beginStr stringByAppendingFormat:@"-%@",_endStr];
}

#pragma mark - time select click handle
- (void)selectTime:(UIButton *)bt {
    _selectTimeBT = bt;
    [self isChange];
    [self.picker showAnimation];
}
- (void)sure:(UIButton *)bt {
    __weak typeof(self) wself = self;
    if ((_isDetail && _isChange) || !_isDetail) {
        //修改 或者 添加
        if (_isBeginTimeFull && _isEndTimeFull && _isMemoInfoFull) {
            if (_isChange) {
                [self memoUnreasonableAlert:@"确定修改备忘" cancle:YES sureCallback:^{
                    [PYHMemoSupport updateSubModel:_subModel model:_model memoBeginText:wself.beginSelectBT.titleLabel.text endText:wself.endSelectBT.titleLabel.text content:wself.memoTV.text];
                    if (wself.memoComplete) wself.memoComplete(nil);
                    [wself goBack];
                }];
            }else {
                NSDictionary *memoInfo = @{@"memoBeginDate":_beginSelectDate,@"memoEndDate":_endSelectDate,@"memoText":self.memoTV.text,@"memoDates":_dates};
                if (wself.memoComplete) wself.memoComplete(memoInfo);
                [wself goBack];
            }
        }else {
            [self memoUnreasonableAlert:@"请完善备忘信息" cancle:NO sureCallback:nil];
        }
    }
    if (_isDetail && !_isChange) {
        //删除
        [self memoUnreasonableAlert:@"确定删除备忘" cancle:YES sureCallback:^{
            [PYHMemoSupport deleteMemoInfoWithModel:_model subModel:_subModel];
            if (wself.memoComplete) wself.memoComplete(nil);
            [wself goBack];
        }];
    }
}
- (void)pickerDateChange:(NSDate *)date {
    [self.picker dismissAnimation];
    
    if (!date) return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH点mm分";
    
    NSString *str = [formatter stringFromDate:date];
    if ([_selectTimeBT isEqual:self.beginSelectBT]) {
//        str = [_beginStr stringByAppendingFormat:@" %@",str];
        NSString *compareStr = self.endSelectBT.titleLabel.text;
        if ([compareStr compare:str] == NSOrderedAscending && ![compareStr hasPrefix:@"选择"]) {
            [self memoUnreasonableAlert:@"请合理安排时间" cancle:NO sureCallback:nil];
            return;
        }
        _isBeginTimeFull = YES;
        _beginSelectDate = date;
    }else {
//        str = [_endStr stringByAppendingFormat:@" %@",str];
        NSString *compareStr = self.beginSelectBT.titleLabel.text;
        if ([str compare:compareStr] == NSOrderedAscending && ![compareStr hasPrefix:@"选择"]) {
            [self memoUnreasonableAlert:@"请合理安排时间" cancle:NO sureCallback:nil];
            return;
        };
        _isEndTimeFull = YES;
        _endSelectDate = date;
    }
    [_selectTimeBT setTitle:str forState:UIControlStateNormal];
}
- (void)memoUnreasonableAlert:(NSString *)alertMessage cancle:(BOOL)cancle sureCallback:(void(^)(void))callback {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    if (cancle) {
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cancle];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (callback) callback();
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 键盘相关 textViewDelegate
- (void)hudDismiss {
    [self.memoTV resignFirstResponder];
}
- (void)handleKeyBoardNotification:(NSNotification *)sender {
    NSValue *value = [sender.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGFloat animationSecond = [[sender.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    CGFloat keyboardY = [value CGRectValue].origin.y;
    CGRect selfFrame = self.view.frame;
    CGRect memoTVFrame = self.memoTV.frame;
    if (keyboardY >= [UIScreen mainScreen].bounds.size.height-50) {
        //隐藏
        self.memoHudV.hidden = YES;
        selfFrame.origin.y = kVisibleY;
        memoTVFrame.size.height = CGRectGetMinY(self.sureBT.frame)-CGRectGetMaxY(self.memoLB.frame)-25.f;
        _isMemoInfoFull = ![self.memoTV.text isEqualToString:@""];
    }else {
        //显示
        [self isChange];
        self.memoHudV.hidden = NO;
        memoTVFrame.size.height = kVisibleHeight - keyboardHeight - (CGRectGetMinY(memoTVFrame)-CGRectGetMinY(self.memoLB.frame)) - 10.f;
        selfFrame.origin.y = kVisibleY - CGRectGetMinY(self.memoLB.frame);
    }
    [UIView animateWithDuration:animationSecond animations:^{
        self.view.frame = selfFrame;
        self.memoTV.frame = memoTVFrame;
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - lazy loading
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 20.f, CGRectGetWidth(self.view.frame), 30.f)];
        _titleLB.text = [self timeTogether];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.font = [UIFont systemFontOfSize:18];
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}
- (UILabel *)beginTimeLB {
    if (!_beginTimeLB) {
        _beginTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLB.frame)+20.f, 100.f, 30.f)];
        _beginTimeLB.text = @"开始时间";
        _beginTimeLB.textColor = [UIColor blackColor];
        _beginTimeLB.font = [UIFont systemFontOfSize:15];
        _beginTimeLB.textAlignment = NSTextAlignmentLeft;
    }
    return _beginTimeLB;
}
- (UIButton *)beginSelectBT {
    if (!_beginSelectBT) {
        _beginSelectBT = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.beginTimeLB.frame), CGRectGetMinY(self.beginTimeLB.frame)-7.f, CGRectGetWidth(self.view.frame)-CGRectGetMaxX(self.beginTimeLB.frame)-40.f, 44.f)];
        [_beginSelectBT setTitle:@"选择开始时分" forState:UIControlStateNormal];
        [_beginSelectBT setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
        _beginSelectBT.titleLabel.font = [UIFont systemFontOfSize:15];
        _beginSelectBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _beginSelectBT.layer.borderColor = [UIColor blackColor].CGColor;
        _beginSelectBT.layer.borderWidth = 0.6f;
        [_beginSelectBT addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginSelectBT;
}
- (UILabel *)endTimeLB {
    if (!_endTimeLB) {
        _endTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.beginTimeLB.frame)+20.f, 100.f, 30.f)];
        _endTimeLB.text = @"结束时间";
        _endTimeLB.textColor = [UIColor blackColor];
        _endTimeLB.font = [UIFont systemFontOfSize:15];
        _endTimeLB.textAlignment = NSTextAlignmentLeft;
    }
    return _endTimeLB;
}
- (UIButton *)endSelectBT {
    if (!_endSelectBT) {
        _endSelectBT = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.endTimeLB.frame), CGRectGetMinY(self.endTimeLB.frame)-7.f, CGRectGetWidth(self.view.frame)-CGRectGetMaxX(self.endTimeLB.frame)-40.f, 44.f)];
        [_endSelectBT setTitle:@"选择结束时分" forState:UIControlStateNormal];
        [_endSelectBT setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
        _endSelectBT.titleLabel.font = [UIFont systemFontOfSize:15];
        _endSelectBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _endSelectBT.layer.borderColor = [UIColor blackColor].CGColor;
        _endSelectBT.layer.borderWidth = 0.6f;
        [_endSelectBT addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endSelectBT;
}
- (UILabel *)memoLB {
    if (!_memoLB) {
        _memoLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.endSelectBT.frame)+20.f, 150.f, 30.f)];
        _memoLB.text = @"备注：";
        _memoLB.textColor = [UIColor blackColor];
        _memoLB.font = [UIFont systemFontOfSize:15];
        _memoLB.textAlignment = NSTextAlignmentLeft;
    }
    return _memoLB;
}
- (UITextView *)memoTV {
    if (!_memoTV) {
        _memoTV = [[UITextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.memoLB.frame)+5.f, CGRectGetWidth(self.view.frame)-40, CGRectGetMinY(self.sureBT.frame)-CGRectGetMaxY(self.memoLB.frame)-25.f)];
        _memoTV.textColor = [UIColor blackColor];
        _memoTV.font = [UIFont systemFontOfSize:14];
        _memoTV.layer.cornerRadius = 10.f;
        _memoTV.layer.masksToBounds = YES;
        _memoTV.layer.borderWidth = 0.6f;
        _memoTV.layer.borderColor = [UIColor blackColor].CGColor;
        _memoTV.returnKeyType = UIReturnKeyDone;
        _memoTV.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return _memoTV;
}
- (UIView *)memoHudV {
    if (!_memoHudV) {
        _memoHudV = [[UIView alloc]initWithFrame:self.view.bounds];
        _memoHudV.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hudDismiss)];
        [_memoHudV addGestureRecognizer:tap];
    }
    return _memoHudV;
}
- (UIButton *)sureBT {
    if (!_sureBT) {
        CGFloat w = (CGRectGetWidth(self.view.frame)-260.f) / 2;
        _sureBT = [[UIButton alloc]initWithFrame:CGRectMake(w, kVisibleHeight - (kISIphone ? 84 : 64), 260.f, 44.f)];
        [_sureBT setTitle:kBTTitle forState:UIControlStateNormal];
        [_sureBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sureBT.titleLabel.font = [UIFont systemFontOfSize:20];
        _sureBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _sureBT.layer.cornerRadius = 5.f;
        _sureBT.layer.masksToBounds = YES;
        _sureBT.layer.borderColor = [UIColor blackColor].CGColor;
        _sureBT.layer.borderWidth = 0.6f;
        _sureBT.backgroundColor = [UIColor brownColor];
        [_sureBT addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBT;
}
- (PYHDatePicker *)picker {
    if (!_picker) {
        __weak typeof(self) wself =self;
        _picker = [[PYHDatePicker alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kVisibleHeight) callBack:^(NSDate *date) {
            [wself pickerDateChange:date];
        }];
    }
    return _picker;
}
- (void)isChange {
    if (_isDetail) {
        _isChange = YES;
        [self.sureBT setTitle:@"保存修改" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end




#pragma mark - PYHDatePicker
@implementation PYHDatePicker {
    PYHDatePickerCallback _callback;
    NSDate *_date;
    UIView *_backView;
    CGFloat _backVHeight;
}
- (instancetype)initWithFrame:(CGRect)frame callBack:(PYHDatePickerCallback)callback {
    if (self = [super initWithFrame:frame]) {
        _callback = callback;
        _backVHeight = 200.f + (kISIphone ? 20.f : 0.f);
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        [self configBackView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancle)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)configBackView {
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _backVHeight)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    UIButton *cancleBT = [[UIButton alloc]initWithFrame:CGRectMake(20.f, 0, 60.f, 44.f)];
    [cancleBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleBT addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancleBT];
    
    UIButton *sureBT = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_backView.frame)-80.f, 0, 60.f, 44.f)];
    [sureBT setTitle:@"确定" forState:UIControlStateNormal];
    [sureBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBT addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:sureBT];
    
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc]init];
    lineLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor;
    lineLayer.frame = CGRectMake(0, CGRectGetMaxY(sureBT.frame), CGRectGetWidth(_backView.frame), 1.f);
    [_backView.layer addSublayer:lineLayer];
    
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sureBT.frame)+1, CGRectGetWidth(_backView.frame), 156.f)];
    picker.datePickerMode = UIDatePickerModeTime;
    picker.minimumDate = [self dateWithFormatter:@"00:00"];
    picker.maximumDate = [self dateWithFormatter:@"24:00"];
    _date = [NSDate date];
    [picker addTarget:self action:@selector(pickerDateChange:) forControlEvents:UIControlEventValueChanged];
    [_backView addSubview:picker];
    
    //截断响应
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [_backView addGestureRecognizer:tap];
}
- (void)sure {
    if (_callback) _callback(_date);
}
- (void)cancle {
    if (_callback) _callback(nil);
}
- (void)pickerDateChange:(UIDatePicker *)picker {
    _date = picker.date;
}

- (void)showAnimation {
    self.hidden = NO;
    CGRect frame = _backView.frame;
    frame.origin.y = CGRectGetHeight(self.frame)-_backVHeight;
    [UIView animateWithDuration:0.25f animations:^{
        _backView.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
}
- (void)dismissAnimation {
    CGRect frame = _backView.frame;
    frame.origin.y = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:0.25f animations:^{
        _backView.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
       self.hidden = YES;
    }];
}
- (NSDate *)dateWithFormatter:(NSString *)hm {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm";
    return [formatter dateFromString:hm];
}
@end
