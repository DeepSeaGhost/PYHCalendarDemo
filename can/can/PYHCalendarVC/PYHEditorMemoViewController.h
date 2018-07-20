//
//  PYHEditorMemoViewController.h
//  Created by reset on 2018/6/28.

#import <UIKit/UIKit.h>
typedef void(^memoEditorComplete) (NSDictionary *memoInfo);
@interface PYHEditorMemoViewController : UIViewController

- (instancetype)initWithDates:(NSArray *)dates;
- (instancetype)initWithDatail:(NSDictionary *)memoInfo;
@property (nonatomic, copy) memoEditorComplete memoComplete;
@end

#pragma mark - PYHDatePicker
typedef void(^PYHDatePickerCallback) (NSDate *date);
@interface PYHDatePicker : UIView

- (instancetype)initWithFrame:(CGRect)frame callBack:(PYHDatePickerCallback)callback;
- (void)showAnimation;
- (void)dismissAnimation;
@end
