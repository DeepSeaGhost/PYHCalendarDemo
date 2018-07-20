//
//  PYHCalendarHeadBar.h
//  Created by reset on 2018/6/27.

#import <UIKit/UIKit.h>
#import "PYHCalendar.h"
typedef void(^calendarHeadBlock) (BOOL isPre);
typedef void(^extensionHeadBlock) (NSInteger type);//1 today 2 reset

@interface PYHCalendarHeadBar : UIView

- (instancetype)initWithCalendar:(PYHCalendar *)calendar preNextMonth:(calendarHeadBlock)callback extensionBlock:(extensionHeadBlock)extensionBlock;

- (void)pyh_setDisable:(BOOL)isPre;
- (void)pyh_setEnabled:(BOOL)isPre;
- (void)pyh_setExtensionDisable:(NSInteger)type;
- (void)pyh_setExtensionEnabled:(NSInteger)type;
- (void)pyh_setSignLBTitle:(NSString *)string;
@end

@interface PYHHeadButton : UIButton
@end
