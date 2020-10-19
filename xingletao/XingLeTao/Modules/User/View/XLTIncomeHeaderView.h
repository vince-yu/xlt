//
//  XLTIncomeHeaderView.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTIncomeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (instancetype)initWithNib;
@end

NS_ASSUME_NONNULL_END
