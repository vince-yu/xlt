//
//  XLTGoodsDetailSukPopVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsDetailSukPopVC : XLTBaseViewController
@property (nonatomic, assign) BOOL letaoIsSafeguardCell;
@property (nonatomic, assign) BOOL letaoIsSingleCellType;

@property (nonatomic, copy)NSDictionary *letaoDataInfo;
@property (nonatomic, copy) NSString *letaoTitleText;

@property (nonatomic, weak) IBOutlet UIView *letaoBgView;
@property (nonatomic, weak) IBOutlet UILabel *letaoTitleTextLabel;
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UIButton *letaoCloseBtn;

@end

NS_ASSUME_NONNULL_END
