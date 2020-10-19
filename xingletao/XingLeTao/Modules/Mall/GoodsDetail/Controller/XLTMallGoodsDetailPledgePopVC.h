//
//  XLTGoodsDetailSukPopVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMallGoodsDetailPledgePopVC : XLTBaseViewController
@property (nonatomic, copy) NSString *letaoTitleText;

@property (nonatomic, weak) IBOutlet UIView *letaoBgView;
@property (nonatomic, weak) IBOutlet UILabel *letaoTitleTextLabel;
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UIButton *letaoCloseBtn;
@end

NS_ASSUME_NONNULL_END
