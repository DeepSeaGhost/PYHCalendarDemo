//
//  PYHLookMemoViewController.m
//  Created by reset on 2018/6/28.

#import "PYHLookMemoViewController.h"
#import "PYHEditorMemoViewController.h"
#import "PYHCalendarDateSupport.h"
#import "PYHLookMemoCell.h"
#import "PYHMemoModel.h"
#import "PYHMemoSupport.h"
#define kVisibleHeight ([UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)

@interface PYHLookMemoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) PYHMemoSupport *support;
@property (nonatomic, strong) UICollectionView *collectionV;
@end

@implementation PYHLookMemoViewController {
    NSArray *_dates;
    NSInteger _cIndex;
    BOOL _isEditor;
    BOOL _isReset;
}

- (instancetype)initWithDates:(NSArray *)dates isEditor:(BOOL)isEditor {
    if (self = [super init]) {
        _dates = dates;
        _isEditor = isEditor;
        _isReset = NO;
        _support = [[PYHMemoSupport alloc]init];
        _cIndex = [_support daysWith1900BetweenToday];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self configNavigation];
    [self.view addSubview:self.collectionV];
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_cIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    if (_isEditor) [self goMemoVC:_dates modelInfo:nil];
}
- (void)configNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"备忘录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
}
- (void)goBack {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)resetMemo:(NSDictionary *)modelInfo {
    _isReset = YES;
    [self goMemoVC:nil modelInfo:modelInfo];
}
- (void)goMemoVC:(NSArray *)dates modelInfo:(NSDictionary *)modelInfo {
    _isReset = NO;
    PYHEditorMemoViewController *vc;
    if (modelInfo) {
        vc = [[PYHEditorMemoViewController alloc]initWithDatail:modelInfo];
    }else {
        vc = [[PYHEditorMemoViewController alloc]initWithDates:dates];
    }
    __weak typeof(self) wself = self;
    vc.memoComplete = ^(NSDictionary *memoInfo) {
        [wself editorCallbackReloadData:memoInfo];
    };
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - editor callback reload data
- (void)editorCallbackReloadData:(NSDictionary *)memoInfo {
    if (_isReset) {
        //修改原有数据
//        [self.support updateMemoInfo:memoInfo];
    }else {
        //添加新数据
        [self.support addMemoInfo:memoInfo];
    }
    [self.collectionV reloadData];
}

#pragma mark - collection delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.support daysWith1900Between2500];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PYHLookMemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PYHLookMemoCell" forIndexPath:indexPath];
    [cell model:[self.support getMemoInfo:indexPath.item] index:indexPath.item];
    __weak typeof(self) wself = self;
    cell.longPressCallback = ^(NSDate *time) {
        [wself goMemoVC:@[time] modelInfo:nil];
    };
    cell.tapBlock = ^(NSDictionary *obj) {
        [wself resetMemo:obj];
    };
    return cell;
}

#pragma mark - lazy loading
- (UICollectionView *)collectionV {
    if (!_collectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), kVisibleHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kVisibleHeight) collectionViewLayout:layout];
        _collectionV.backgroundColor = [UIColor clearColor];
        [_collectionV registerClass:[PYHLookMemoCell class] forCellWithReuseIdentifier:@"PYHLookMemoCell"];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.pagingEnabled = YES;
        _collectionV.showsVerticalScrollIndicator = NO;
        _collectionV.showsHorizontalScrollIndicator = NO;
    }
    return _collectionV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
