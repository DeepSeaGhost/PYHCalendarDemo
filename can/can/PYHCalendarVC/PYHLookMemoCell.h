//
//  PYHLookMemoCell.h
//  can
//
//  Created by reset on 2018/6/28.
//  Copyright © 2018年 HangzhouVongi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYHMemoModel.h"
typedef void(^PYHLookMemoBlock) (id obj);

@interface PYHLookMemoCell : UICollectionViewCell

- (void)model:(PYHMemoModel *)model index:(NSInteger)index;
@property (nonatomic, copy) PYHLookMemoBlock longPressCallback;
@property (nonatomic, copy) PYHLookMemoBlock tapBlock;
@end
