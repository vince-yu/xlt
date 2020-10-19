//
//  XLTMemberDetailHeader.m
//  XingLeTao
//
//  Created by SNQU on 2020/3/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMemberDetailHeader.h"
#import "SPButton.h"

@interface XLTMemberDetailHeader ()
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet SPButton *tipBtn;
@property (weak, nonatomic) IBOutlet UILabel *vailedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *todayIncome;
@property (weak, nonatomic) IBOutlet UILabel *yestIncome;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthIncome;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthTotal;
@property (weak, nonatomic) IBOutlet UILabel *totalIncome;
@property (weak, nonatomic) IBOutlet UILabel *activeOrder;
@property (weak, nonatomic) IBOutlet UILabel *activeMember;

@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet SPButton *creatTimeBtn;
@property (weak, nonatomic) IBOutlet SPButton *fanBtn;
@property (weak, nonatomic) IBOutlet SPButton *sortBtn;

@property (nonatomic ,assign) NSInteger timeStatus;
@property (nonatomic ,assign) NSInteger fanStatus;
@property (nonatomic ,assign) NSInteger estimateTotalStatus;
@property (nonatomic ,weak) IBOutlet NSLayoutConstraint *nameLabelLeft;
@property (weak, nonatomic) IBOutlet UIImageView *outTipView;

@end

@implementation XLTMemberDetailHeader

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTMemberDetailHeader" owner:nil options:nil] lastObject];
    if (self) {
        

        self.avatorImageView.layer.cornerRadius = 32;
        self.avatorImageView.layer.masksToBounds = YES;
        
        self.vailedLabel.layer.cornerRadius = 7.5;
        self.vailedLabel.layer.masksToBounds = YES;
        
        self.storeBtn.layer.cornerRadius = 10;
        self.storeBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        self.storeBtn.layer.borderWidth = 1;
        
        self.timeStatus = 1;
        [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
        [self.creatTimeBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    }
    return self;
}
- (void)setModel:(XLTUserIncomeModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    self.vailedLabel.hidden = !self.model.recent.boolValue;
    self.outTipView.hidden = self.model.status.integerValue != -1;
    if (self.vailedLabel.hidden) {
        self.nameLabelLeft.constant = - 32;
    } else {
        self.nameLabelLeft.constant = 10;
    }
    [self.tipBtn setTitle:self.model.tip forState:UIControlStateNormal];
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    self.nameLabel.text = self.model.username.length ? self.model.username : @"";
    self.creatTimeLabel.text =
    self.todayIncome.text = self.model.today_estimate.length ? [self.model.today_estimate priceStr] : @"0";
    self.yestIncome.text = self.model.yesterday_estimate.length ? [self.model.yesterday_estimate priceStr] : @"0";
    self.lastMonthIncome.text = self.model.lastmonth_estimate.length ? [self.model.lastmonth_estimate priceStr] : @"0";
    self.lastMonthTotal.text = self.model.lastmonth_total.length ? [self.model.lastmonth_total priceStr] : @"0";

    self.totalIncome.text = self.model.unsettled_amount.length ? [self.model.unsettled_amount priceStr] : @"0";
    
//    self.activeMember.text = self.model.vaild_direct_vip.length ? self.model.vaild_direct_vip : @"0";
    
    NSString *vailedOrder = self.model.valid_order_count_total.length ? self.model.valid_order_count_total : @"0";
    NSString *invailedOrder = self.model.invalid_order_count_total.length ? self.model.invalid_order_count_total : @"0";
    NSMutableAttributedString *orderAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",vailedOrder,invailedOrder]];
    [orderAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, vailedOrder.length)];
    [orderAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC6C6C6]} range:NSMakeRange(vailedOrder.length,orderAttr.length - vailedOrder.length)];
    self.activeOrder.attributedText = orderAttr;
    
    NSString *vailedMember = self.model.valid_order_count.length ? self.model.vaild_direct_vip : @"0";
    NSString *invailedMember = self.model.invalid_order_count.length ? self.model.invaild_direct_vip : @"0";
    NSMutableAttributedString *memberAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",vailedMember,invailedMember]];
    [memberAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, vailedMember.length)];
    [memberAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC6C6C6]} range:NSMakeRange(vailedMember.length,memberAttr.length - vailedMember.length)];
    self.activeMember.attributedText = memberAttr;
    
    NSString *phoneText = [NSString stringWithFormat:@"注册手机 %@",self.model.phone.length ? self.model.phone : @"--"];
    NSMutableAttributedString *phoneAttr = [[NSMutableAttributedString alloc] initWithString:phoneText];
    [phoneAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 4)];
    [phoneAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4,phoneText.length - 4)];
    self.phoneLabel.attributedText = phoneAttr;
    
    NSString *creatTimeText = self.model.itime.length ? [self.model.itime convertDateStringWithSecondTimeStr:@"注册时间 yyyy-MM-dd hh:mm:ss"] : @"注册时间 --";
    NSMutableAttributedString *createTimeAttr = [[NSMutableAttributedString alloc] initWithString:creatTimeText];
    [createTimeAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 4)];
    [createTimeAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4,creatTimeText.length - 4)];
    self.creatTimeLabel.attributedText = createTimeAttr;
    
    [self reloadView];
}
- (IBAction)timeBtnClick:(id)sender {
    [self.creatTimeBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    switch (self.timeStatus) {
        case 2:
            self.timeStatus = 1;
            [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
            break;
        case 1:
            self.timeStatus = 2;
            [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_up"] forState:UIControlStateNormal];
            break;
        case 0:
            [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
            self.timeStatus = 1;
            break;
        default:
            
            break;
    }
    self.fanStatus = 0;
    self.estimateTotalStatus = 0;
    [self.fanBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
    [self.fanBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    
    [self.sortBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
    [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    
    if (self.sortBlock) {
        self.sortBlock(0, self.timeStatus);
    }
}
- (IBAction)fanBtnClick:(id)sender {
    [self.fanBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    switch (self.fanStatus) {
        case 2:
            self.fanStatus = 1;
            [self.fanBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
            break;
        case 1:
            self.fanStatus = 2;
            [self.fanBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_up"] forState:UIControlStateNormal];
            break;
        case 0:
            [self.fanBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
            self.fanStatus = 1;
            break;
        default:
            
            break;
    }
    self.timeStatus = 0;
    self.estimateTotalStatus = 0;
    [self.creatTimeBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];

    [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    
    [self.sortBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
    [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    if (self.sortBlock) {
        self.sortBlock(1, self.fanStatus);
    }
}
- (IBAction)estimateTotalBtnClick:(id)sender {
    [self.sortBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    switch (self.estimateTotalStatus) {
        case 2:
            self.estimateTotalStatus = 1;
            [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
            break;
        case 1:
            self.estimateTotalStatus = 2;
            [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_up"] forState:UIControlStateNormal];
            break;
        case 0:
            [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
            self.estimateTotalStatus = 1;
            break;
        default:
            
            break;
    }
    self.timeStatus = 0;
    self.fanStatus = 0;
    [self.creatTimeBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];

    [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    
    [self.fanBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
    [self.fanBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    if (self.sortBlock) {
        self.sortBlock(2, self.estimateTotalStatus);
    }
}
- (void)reloadView{
    
    if (self.model.canCopy.boolValue) {
//        self.phoneLabel.text = self.model.phone;
        self.storeBtn.hidden = NO;
//        self.tipBtn.hidden = NO;
    }else{
//        self.phoneLabel.text = @"";
        self.storeBtn.hidden = YES;
        
    }
    if (self.model.tip.length) {
        self.tipBtn.hidden = NO;
    }else{
        self.tipBtn.hidden = YES;
    }
    switch (self.model.level.intValue) {
        case 3:
            [self.levelImageView setImage:[UIImage imageNamed:@"xlt_mine_tag_supper"]];
            break;
        case 4:
            [self.levelImageView setImage:[UIImage imageNamed:@"xlt_mine_tag_md"]];
            break;
        default:
            [self.levelImageView setImage:[UIImage imageNamed:@"xlt_mine_tag"]];
            break;
    }
    self.levelImageView.hidden = NO;
}
- (IBAction)storeAction:(id)sender {
    if (![self.model.phone isKindOfClass:[NSString class]]) {
        return;
    }
    [UIPasteboard generalPasteboard].string = self.model.phone;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功！"];
}

@end
