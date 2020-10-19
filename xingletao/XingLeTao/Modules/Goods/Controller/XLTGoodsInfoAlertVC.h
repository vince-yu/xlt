//
//  XLTGoodsInfoAlertVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsInfoAlertVC : XLTBaseViewController
@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIView *letaoCouponSpace;
@property (nonatomic, weak) IBOutlet UILabel *couponTipLabel;

@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UIView *letaoBgView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *letaoCancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *letaoOkBtn;

@property (nonatomic, strong) NSDictionary *letaoItemDictionary;

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
                               itemInfo:(NSDictionary * _Nullable)itemInfo;
@end

NS_ASSUME_NONNULL_END
