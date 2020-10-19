//
//  XLTStartRecommedFooterCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTStartRecommedFooterCell : UICollectionViewCell
@property (nonatomic ,copy) void(^selectBlock)(NSString *isTomorrow);
@property (nonatomic ,assign) BOOL showTomorrow;
@end

NS_ASSUME_NONNULL_END
