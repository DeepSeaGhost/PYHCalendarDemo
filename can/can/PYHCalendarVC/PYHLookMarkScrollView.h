//
//  PYHLookMarkScrollView.h
//  Created by reset on 2018/7/11.

#import <UIKit/UIKit.h>
#import "PYHMemoModel.h"
typedef void(^PYHLookMemoBlock) (id obj);

@interface PYHLookMarkScrollView : UIScrollView

@property (nonatomic, strong) PYHMemoModel *model;
@property (nonatomic, copy) PYHLookMemoBlock longPressSelectBlock;
@property (nonatomic, copy) PYHLookMemoBlock tapBlock;
@end

