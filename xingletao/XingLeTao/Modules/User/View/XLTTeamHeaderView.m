//
//  XLTTeamHeaderView.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTTeamHeaderView.h"
#import "SPButton.h"
#import "XLTAlertViewController.h"

@interface XLTTeamHeaderView  ()
//teamview
@property (weak, nonatomic) IBOutlet UIView *teamView;
@property (weak, nonatomic) IBOutlet UILabel *totalMember;
@property (weak, nonatomic) IBOutlet UILabel *subMember;
@property (weak, nonatomic) IBOutlet UILabel *seSubMember;
//addView
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *todayAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *yestAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthLabel;
//searchView
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *letaoSearchTextField;
//sortView
@property (weak, nonatomic) IBOutlet SPButton *creatTimeBtn;
@property (weak, nonatomic) IBOutlet SPButton *fanBtn;
//memberView
@property (weak, nonatomic) IBOutlet UIView *memberVIew;
@property (weak, nonatomic) IBOutlet SPButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *activeMember;
@property (weak, nonatomic) IBOutlet UILabel *otherMember;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnTop;


@property (nonatomic ,assign) NSInteger timeStatus;
@property (nonatomic ,assign) NSInteger fanStatus;
@property (nonatomic ,assign) NSInteger estimateTotalStatus;
@end

@implementation XLTTeamHeaderView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTTeamHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        self.teamView.layer.cornerRadius = 10;
        self.teamView.layer.masksToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledChange:) name:UITextFieldTextDidEndEditingNotification object:nil];
        self.searchView.layer.cornerRadius = 15;
        self.searchView.layer.masksToBounds = YES;
        
//        self.timeStatus = 1;
//        [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
//        [self.creatTimeBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];

    }
    return self;
}
- (void)setModel:(XLTUserTeamInfoModel *)model{
    _model = model;
    if (!self.model) {
        return;
    }
    self.totalMember.text = [self addSymbolWithStr:self.model.fansOnetwo];
    self.subMember.text = [self addSymbolWithStr:self.model.fansOne];
    self.seSubMember.text = [self addSymbolWithStr:self.model.fansTwo];
    self.todayAddLabel.text = [self addSymbolWithStr:self.model.today];
    self.yestAddLabel.text = [self addSymbolWithStr:self.model.yesterday];
    self.thisMonthLabel.text = [self addSymbolWithStr:self.model.month];
    self.lastMonthLabel.text = [self addSymbolWithStr:self.model.lastmonth];
    self.activeMember.text = [self addSymbolWithStr:self.model.vaild_direct_vip];
    self.otherMember.text = [self addSymbolWithStr:self.model.vaild_indirect_vip];
//    self
}
- (NSString *)addSymbolWithStr:(NSString *)str{
    
    if (str.length>3) {
        NSMutableString *resutlStr = [[NSMutableString alloc] init];
        NSMutableString *temStr = [[NSMutableString alloc] initWithString:str];
        while (temStr.length > 3) {
            NSString *subStr = [temStr substringWithRange:NSMakeRange(temStr.length - 3, 3)];
            
            [temStr deleteCharactersInRange:NSMakeRange(temStr.length - 3, 3)];
            if (temStr.length == 0) {
                [resutlStr insertString:subStr atIndex:0];
            }else{
                [resutlStr insertString:[NSString stringWithFormat:@",%@",subStr] atIndex:0];
            }
        }
        if (temStr.length) {
            [resutlStr insertString:temStr atIndex:0];
        }
        return resutlStr;
    }else{
        if (str.length) {
            return str;
        }else{
            return @"0";
        }
    }
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
    [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_filter"] forState:UIControlStateNormal];
    
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
    [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_filter"] forState:UIControlStateNormal];
    if (self.sortBlock) {
        self.sortBlock(1, self.fanStatus);
    }
}
- (IBAction)estimateTotalBtnClick:(id)sender {
//    [self.sortBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
//    switch (self.estimateTotalStatus) {
//        case 2:
//            self.estimateTotalStatus = 1;
//            [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
//            break;
//        case 1:
//            self.estimateTotalStatus = 2;
//            [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_up"] forState:UIControlStateNormal];
//            break;
//        case 0:
//            [self.sortBtn setImage:[UIImage imageNamed:@"xingletao_mine_member_sort_down"] forState:UIControlStateNormal];
//            self.estimateTotalStatus = 1;
//            break;
//        default:
//
//            break;
//    }
//    self.timeStatus = 0;
//    self.fanStatus = 0;
//    [self.creatTimeBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
//
//    [self.creatTimeBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
//
//    [self.fanBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
//    [self.fanBtn setImage:[UIImage imageNamed:@"xingletao_mine_team_sort"] forState:UIControlStateNormal];
    if (self.sortBlock) {
        self.sortBlock(2, 0);
    }
}
- (IBAction)sortBtnClick:(id)sender {
    if (self.sortBlock) {
        self.sortBlock(3, 0);
    }
}
- (IBAction)moreAction:(id)sender {
    BOOL show = self.memberVIew.hidden;
    [self showMemberView:show];
    CGFloat height = 0;
    if (show) {
        height = 510;
    }else{
        height = 400;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadHeader:)]) {
        [self.delegate reloadHeader:height];
    }
}
- (void)showMemberView:(BOOL )show{
    self.memberVIew.hidden = !show;
    if (show) {
        self.moreBtnTop.constant = 110;
        [self.moreBtn setTitle:@"收起数据" forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor colorWithHex:0x848487] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"xlt_mine_myteam_up"] forState:UIControlStateNormal];
    }else{
        self.moreBtnTop.constant = 0;
        [self.moreBtn setTitle:@"查看更多数据" forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor colorWithHex:0xFF8228] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"xlt_mine_myteam_dwon"] forState:UIControlStateNormal];
    }
}
- (IBAction)subBtnClick:(id)sender {
    XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
           alertViewController.displayNotShowButton = NO;
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"专属粉丝" message:@"通过你直接邀请的用户"messageTextAlignment:NSTextAlignmentCenter  sureButtonText:@"知道了" cancelButtonText:nil];
}
- (IBAction)secSubBtnClick:(id)sender {
    XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
           alertViewController.displayNotShowButton = NO;
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"其他粉丝"  message:@"除专属粉丝以外的其他粉丝" messageTextAlignment:NSTextAlignmentCenter sureButtonText:@"知道了" cancelButtonText:nil];
}
- (void)textFiledChange:(NSNotification *)note{
    UITextField *object = [note object];
    if (![object isEqual:self.letaoSearchTextField]) {
        return;
    }
    if (self.searchBlock) {
        self.searchBlock(object.text);
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
