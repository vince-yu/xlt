//
//  XLTMyRecommendHeaderView.m
//  XingLeTao
//
//  Created by SNQU on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyRecommendHeaderView.h"
#import "XLTSortView.h"
#import "XLTUserManager.h"

@interface XLTMyRecommendHeaderView ()<XLTSortViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *settledLabel;
@property (weak, nonatomic) IBOutlet UILabel *unsettledLabel;

@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (nonatomic ,strong) XLTSortView *sortContentView;
@end

@implementation XLTMyRecommendHeaderView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTMyRecommendHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        self.avatorImageView.layer.cornerRadius = 27;
        self.avatorImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToRuleVC)];
        [self.ruleLabel addGestureRecognizer:tap];
        self.ruleLabel.userInteractionEnabled = YES;
        
        [self.sortView addSubview:self.sortContentView];
    }
    return self;
}
- (XLTSortView *)sortContentView{
    if (!_sortContentView) {
        NSArray *array = @[
            @{
                @"title":@"下单量",
                @"titleCloler":@"000000",
                @"selectColer":@"FF8101",
                @"code":@"order_count",
                @"type":@"2",
                @"normalImage":@"xingletao_mine_team_sort",
                @"upImage":@"xingletao_mine_member_sort_up",
                @"downImage":@"xingletao_mine_member_sort_down",
                @"normalFont":[UIFont letaoRegularFontWithSize:13],
                @"selectFont":[UIFont letaoMediumBoldFontWithSize:13],
            },
            @{
                @"title":@"奖励",
                @"titleCloler":@"000000",
                @"selectColer":@"FF8101",
                @"code":@"reward_amount",
                @"type":@"2",
                @"normalImage":@"xingletao_mine_team_sort",
                @"upImage":@"xingletao_mine_member_sort_up",
                @"downImage":@"xingletao_mine_member_sort_down",
                @"normalFont":[UIFont letaoRegularFontWithSize:13],
                @"selectFont":[UIFont letaoMediumBoldFontWithSize:13],
            },
            @{
                @"title":@"筛选",
                @"titleCloler":@"000000",
                @"selectColer":@"FF8101",
                @"code":@"itime",
                @"type":@"0",
                @"normalImage":@"xingletao_mine_team_filter",
                @"upImage":@"",
                @"downImage":@"",
                @"normalFont":[UIFont letaoRegularFontWithSize:13],
                @"selectFont":[UIFont letaoMediumBoldFontWithSize:13],
            },
        ];
        _sortContentView = [[XLTSortView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) sorts:array];
        _sortContentView.delegate = self;
    }
    return _sortContentView;
}
- (void)setModel:(id)model{
    _model = model;
    XLTUserInfoModel *user = [XLTUserManager shareManager].curUserInfo;
    
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    self.nameLabel.text = user.userNameInfo.length ? user.userNameInfo : @"--";
    self.settledLabel.text = self.model.settlement.length ? [self.model.settlement priceStr] : @"0.00";
    self.unsettledLabel.text = self.model.wait_settlement.length ? [self.model.wait_settlement priceStr] : @"0.00";
    self.nameLabel.text = self.model.nickname;
}
- (void)goToRuleVC{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ruleClick)]) {
        [self.delegate ruleClick];
    }
}
#pragma mark SortDelegate
- (void)selectItem:(XLTSortItemModel *)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sortSelect:)]) {
        [self.delegate sortSelect:item];
    }
}
@end
