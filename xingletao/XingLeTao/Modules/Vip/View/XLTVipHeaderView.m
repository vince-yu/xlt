//
//  XLTVipHeaderView.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipHeaderView.h"
#import "SPButton.h"
#import "HMSegmentedControl.h"
#import "XLTVipRightCollectionVIew.h"
#import "XLTVipProgressCell.h"
#import "XLTVipRightCollectionVIew.h"
#import "XLTUserManager.h"
#import "XLTRightCell.h"
#import "XLTUserManager.h"
#import "NSArray+Bounds.h"

@interface XLTVipHeaderView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bigVIew;

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIButton *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userVipBg;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipLevelWitdh;


@property (weak, nonatomic) IBOutlet UIView *vipProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *vipProgressBg;
@property (nonatomic ,strong) UITableView *progressTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipTaskHeight;

@property (weak, nonatomic) IBOutlet UIView *vipRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipRightTop;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segemetnVIew;
@property (nonatomic ,strong) UIScrollView *rightScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsTitleTop;
@property (weak, nonatomic) IBOutlet UIView *vipContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHeight;

@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *vipVIewTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnLabelHeight;
@property (weak, nonatomic) IBOutlet UIImageView *goodsTitleRImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsTitleLImageView;

//data

@property (nonatomic ,strong) NSMutableArray *rightArray;
@property (nonatomic ,copy) NSString *level;

@end

@implementation XLTVipHeaderView
@synthesize rightModel = _rightModel;

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTVipHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, kScreenWidth, 715);
    self.upBtn.layer.cornerRadius = 15;
    self.upBtn.layer.masksToBounds = YES;
    
    self.avatorImageView.layer.cornerRadius = 25;
    self.avatorImageView.layer.masksToBounds = YES;
    
    
    
    self.vipRightView.userInteractionEnabled = YES;
    self.vipRightView.layer.cornerRadius = 10;
    self.vipRightView.clipsToBounds = YES;
    
    self.userInteractionEnabled = YES;
    self.vipContentView.userInteractionEnabled = YES;
    self.userView.userInteractionEnabled = YES;
    self.vipProgressView.userInteractionEnabled = YES;
    
//    [self configVipBag];
    [self configSegement];
    
    [self.vipProgressView addSubview:self.progressTableView];
    [self.progressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.vipProgressView);
        make.top.equalTo(self.vipVIewTitle.mas_bottom);
        make.bottom.equalTo(self.warnLabel.mas_top);
    }];
    
    [self.vipRightView addSubview:self.rightScrollView];
    [self.rightScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.vipRightView);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.top.equalTo(self.segemetnVIew.mas_bottom).offset(1);
        make.height.mas_equalTo(260);
//        make.bottom.equalTo(self.goodsTitle.mas_top).offset(-35);
    }];
    
    self.titleTop.constant = kStatusBarHeight + 13;
    
    
    [self.userVipBg addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight withRadii:CGSizeMake(7.5, 7.5) viewRect:CGRectMake(0, 0, 75, 15)];
    self.userVipBg.layer.masksToBounds = YES;
    
    
    
    [self configWithLevel];
}
- (XLTVipRightItem *)getItemWithLevel:(NSInteger )le{
    if (self.rightModel.list.count < le) {
        return nil;
    }
    for (XLTVipRightItem *item in self.rightModel.list) {
        if (item.level.intValue == le) {
            return item;
        }
    }
    return  nil;
}
- (void)configWithLevel{
//    [NSLock ]
    NSInteger level = [XLTUserManager shareManager].curUserInfo.level.intValue;
    self.segemetnVIew.selectedSegmentIndex = 0;
    self.level = [NSString stringWithFormat:@"%ld",(long)level];
    self.rightScrollView.contentOffset = CGPointMake(kScreenWidth * (level - 1), 0);
    
    NSString *upHeader = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;
    if (upHeader.length) {
        self.upBtn.hidden = NO;
    }else{
        self.upBtn.hidden = YES;
    }
    
    if (level != 4) {
        self.vipProgressView.hidden = NO;
        self.vipRightTop.constant = 140;
    }else{
        self.vipProgressView.hidden = YES;
        self.vipRightTop.constant = 15;
    }
    switch (level) {
        case 1:
        {
            
            XLTVipRightItem *item = [self getItemWithLevel:level + 1];
            if (item) {
                self.segemetnVIew.sectionTitles = @[@"当前权益",item.level_name];
                self.vipVIewTitle.text = [NSString stringWithFormat:@"升级%@进度",item.level_name];
            }else{
                self.segemetnVIew.sectionTitles = @[@"当前权益",@"会员"];
                self.vipVIewTitle.text = @"升级会员进度";
            }
            
        }
            break;
        case 2:
        {
            XLTVipRightItem *item = [self getItemWithLevel:level + 1];
            if (item) {
                self.segemetnVIew.sectionTitles = @[@"当前权益",item.level_name];
                self.vipVIewTitle.text = [NSString stringWithFormat:@"升级%@进度",item.level_name];
            }else{
                self.segemetnVIew.sectionTitles = @[@"当前权益",@"超级会员"];
                self.vipVIewTitle.text = @"升级超级会员进度";
            }

        }
            break;
        case 3:
        {
            XLTVipRightItem *item = [self getItemWithLevel:level + 1];
            if (item) {
                self.segemetnVIew.sectionTitles = @[@"当前权益",item.level_name];
                self.vipVIewTitle.text = [NSString stringWithFormat:@"升级%@进度",item.level_name];
            }else{
                self.segemetnVIew.sectionTitles = @[@"当前权益",@"运营总监"];
                self.vipVIewTitle.text = @"升级运营总监进度";
            }

        }
            break;
        case 4:
        {
            self.segemetnVIew.sectionTitles = @[@"当前权益"];
        }
            break;
        default:
            break;
    }
    [self configVipBag];
//    [self configSegement];
    [self configRightViewWith:level];
    self.warnLabel.text = self.model.explain.length ? [NSString stringWithFormat:@"%@",self.model.explain] : @"";
    [self.warnLabel sizeToFit];
    
    [self setSelectRight:self.segemetnVIew.selectedSegmentIndex];
}
- (void)configRightViewWith:(NSInteger )level{
    [self.rightArray removeAllObjects];
    if (level == 4) {
        XLTVipRightItem *item = [self getItemWithLevel:level];
        if (item.rights.count) {
            [self.rightArray addObject:item.rights];
        }
        
//        [self.rightArray addObject:[self configRightWithLevel:level - 1]];
    }else{
        XLTVipRightItem *item = [self getItemWithLevel:level];
        if (item.rights.count) {
            [self.rightArray addObject:item.rights];
        }
        XLTVipRightItem *item1 = [self getItemWithLevel:level + 1];
        if (item1.rights.count) {
            [self.rightArray addObject:item1.rights];
        }
//        [self.rightArray addObject:[self configRightWithLevel:level - 1]];
//        [self.rightArray addObject:[self configRightWithLevel:level]];
    }
    [self resetRightScrollViewWithLevel:level];
}
- (NSArray *)configRightWithLevel:(NSInteger )level{
    NSInteger i = level;
    NSMutableArray *curRightArray = [[NSMutableArray alloc] init];
    if (i == 0 || i == 1) {
        for (int j = 0; j < 4; j ++) {
            XLTRightCellModel *model = [[XLTRightCellModel alloc] init];
            model.level = [NSString stringWithFormat:@"%ld",(long)i + 1];
            switch (j) {
                case 0:
                {
                    if (i == 0) {
                        model.bili = @"1";
                        model.content = @"自购返利比例100% ";
                        model.type = XLTRightTypeBuyBili;
                    }else{
                        model.bili = @"1.421";
                        model.content = @"自购返利比例100% + 补贴48.2%";
                        model.type = XLTRightTypeBuyBili;
                    }
                    
                }
                    break;
                 case 1:
                 {
                     if (i == 0) {
                         model.bili = @"1";
                         model.content = @"分享赚返利比例100%";
                         model.type = XLTRightTypeShareBili;
                     }else{
                         model.bili = @"1.41.2";
                         model.content = @"分享赚返利比例100% + 补贴48.2%";
                         model.type = XLTRightTypeShareBili;
                     }
                     
                 }
                     break;
                 case 2:
                 {
                     model.bili = @"0.4";
                     model.content = @"免费领取平台大额隐藏优惠券";
                     model.type = XLTRightTypeGetBigCoupon;
                 }
                     break;
                 case 3:
                 {
                     model.bili = @"0.4";
                     model.content = @"免费分享发圈素材免费查看拉新教程 ";
                     model.type = XLTRightTypeGetNew;
                 }
                     break;
                default:
                    break;
            }
            [curRightArray addObject:model];
        }
    }else{
        for (int j = 0; j < 6; j ++) {
            XLTRightCellModel *model = [[XLTRightCellModel alloc] init];
            model.level = [NSString stringWithFormat:@"%ld",i + 1];
            switch (j) {
                case 0:
                {
                    if (i == 2) {
                        model.bili = @"1.862";
                        model.content = @"自购返利比例145% + 补贴48.2%";
                        model.type = XLTRightTypeBuyBili;
                    }else{
                        model.bili = @"2.122";
                        model.content = @"自购返利比例170% + 补贴48.2%";
                        model.type = XLTRightTypeBuyBili;
                    }
                }
                    break;
                 case 1:
                 {
                     if (i == 2) {
                         model.bili = @"1.862";
                         model.content = @"分享赚返利比例145% + 补贴48.2%";
                         model.type = XLTRightTypeShareBili;
                     }else{
                         model.bili = @"2.122";
                         model.content = @"分享赚返利比例170% + 补贴48.2%";
                         model.type = XLTRightTypeShareBili;
                     }
                     
                 }
                     break;
                 case 2:
                 {
                     model.bili = @"0.4";
                     model.content = @"粉丝奖励享受整个粉丝佣金奖励";
                     model.type = XLTRightTypeCommission;
                 }
                     break;
                 case 3:
                 {
                     if (i == 2) {
                         model.bili = @"0.4";
                         model.content = @"会员升级奖励";
                         model.type = XLTRightTypeVipUp;
                     }else{
                         model.bili = @"0.4";
                         model.content = @"会员或超级会员升级奖励";
                         model.type = XLTRightTypeVipUp;
                     }
                     
                 }
                     break;
                 case 4:
                 {
                     if (i == 2) {
                         model.bili = @"0.4";
                         model.content = @"免费领取平台大额隐藏优惠券";
                         model.type = XLTRightTypeGetBigCoupon;
                     }else{
                         model.bili = @"0.4";
                         model.content = @"官方培训\n年度旅游";
                         model.type = XLTRightTypeFH;
                     }
                     
                 }
                     break;
                 case 5:
                 {
                     if (i == 2) {
                         model.bili = @"0.4";
                         model.content = @"免费分享发圈素材免费查看拉新教程";
                         model.type = XLTRightTypeGetNew;
                     }else{
                         model.bili = @"0.4";
                         model.content = @"购买六险一金\n基本工资1600元";
                         model.type = XLTRightTypeGZ;
                     }
                     
                 }
                     break;
                default:
                    break;
            }
             [curRightArray addObject:model];
        }
    }
    return curRightArray;
}
- (void)setModel:(XLTVipTaskModel *)model{
    _model = model;
    self.taskArray = _model.event_rules;
    
    [self configWithLevel];
    if (self.model.process_explain.length) {
        self.vipVIewTitle.text = self.model.process_explain;
    }
}
- (void)setRightModel:(XLTVipRightsModel *)rightModel{
    _rightModel = rightModel;
}
- (XLTVipRightsModel *)rightModel{
    if (_rightModel == nil) {
        _rightModel = [XLTUserManager shareManager].rightModel;
    }
    return _rightModel;
}
//- (XLTVipRightsModel *)rightModel{
//    if (_rig) {
//        <#statements#>
//    }
//    return _rig
//}
- (void)reloadData{
    [self configWithLevel];
}
- (void)configSegement{
    self.segemetnVIew.userInteractionEnabled = YES;
    self.segemetnVIew.sectionTitles = @[@"普通用户",@"会员",@"超级会员",@"运营总监"];
    self.segemetnVIew.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segemetnVIew.selectionIndicatorWidth = 30;
    self.segemetnVIew.backgroundColor = [UIColor clearColor];
    self.segemetnVIew.selectionIndicatorHeight = 2.0;
    self.segemetnVIew.segmentEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.segemetnVIew.type = HMSegmentedControlTypeText;
//    self.segemetnVIew.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segemetnVIew.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segemetnVIew.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segemetnVIew.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
    self.segemetnVIew.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0x888888]};
    self.segemetnVIew.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF8202]};
    [self.segemetnVIew addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    self.segemetnVIew.width
}
- (void)configVipBag{
    NSInteger vipLeve = self.level.intValue;
    self.nameLabel.text = [XLTUserManager shareManager].curUserInfo.userNameInfo;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[XLTUserManager shareManager].curUserInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    XLTVipRightItem *item = [self getItemWithLevel:vipLeve];
    switch (vipLeve) {
        case 1:
            self.vipProgressView.hidden = NO;
            self.userVipBg.hidden = YES;
            self.vipProgressBg.image = [UIImage imageNamed:@"xlt_vip_vipbg_noaml"];
            self.bigVIew.image = [UIImage imageNamed:@"xlt_vip_headerbg_black"];
            self.timeLabel.hidden = YES;
            break;
        case 2:
        {
            self.vipProgressView.hidden = NO;
            self.userVipBg.hidden = NO;
            XLT_WeakSelf;
            [self.userVipBg sd_setImageWithURL:[NSURL URLWithString:item.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image.size.width && image.size.height) {
                    XLT_StrongSelf;
                    self.vipLevelWitdh.constant = 15 / image.size.height * image.size.width;
                }
            }];
//            = [UIImage imageNamed:@"xlt_vip_tag"];
            self.vipProgressBg.image = [UIImage imageNamed:@"xlt_vip_vipbg_vip"];
            self.bigVIew.image = [UIImage imageNamed:@"xlt_vip_headerbg_black"];
            self.timeLabel.hidden = YES;
        }
            break;
        case 3:
        {
            self.vipProgressView.hidden = NO;
            self.userVipBg.hidden = NO;
            XLT_WeakSelf;
            [self.userVipBg sd_setImageWithURL:[NSURL URLWithString:item.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 if (image.size.width && image.size.height) {
                     XLT_StrongSelf;
                     self.vipLevelWitdh.constant = 15 / image.size.height * image.size.width;
                 }
            }];
//            self.userVipBg.image = [UIImage imageNamed:@"xlt_vip_tag_supper"];
            self.vipProgressBg.image = [UIImage imageNamed:@"xlt_vip_vipbg_suppervip"];
            self.bigVIew.image = [UIImage imageNamed:@"xlt_vip_headerbg_black"];
            self.timeLabel.hidden = NO;
            NSString *svip_expire = [XLTUserManager shareManager].curUserInfo.svip_expire;
            if ([svip_expire isKindOfClass:[NSString class]] && [svip_expire isEqualToString:@"-1"]) {
                self.timeLabel.text = @"永久";
            } else {
                NSString *expireDate = [svip_expire isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@到期",[svip_expire convertDateStringWithSecondTimeStr:@"yyyy.MM.dd"]] : @"";
                self.timeLabel.text = expireDate;
            }

    }
            break;
        case 4:
        {
            self.userVipBg.hidden = NO;
            XLT_WeakSelf;
            [self.userVipBg sd_setImageWithURL:[NSURL URLWithString:item.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 if (image.size.width && image.size.height) {
                     XLT_StrongSelf;
                     self.vipLevelWitdh.constant = 15 / image.size.height * image.size.width;
                 }
            }];
//            self.userVipBg.image = [UIImage imageNamed:@"xlt_vip_tag_md"];
            self.vipProgressView.hidden = YES;
            self.bigVIew.image = [UIImage imageNamed:@"xlt_vip_headerbg_gold"];
            self.timeLabel.hidden = YES;
        }
            break;
        default:{
            self.userVipBg.hidden = YES;
            self.timeLabel.hidden = YES;
        }
            break;
    }
    UIImage *bgImage = self.bigVIew.image;
    UIImage *bgVipImage = self.vipProgressBg.image;
    
    self.bigVIew.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(150, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    self.vipProgressBg.image = [bgVipImage resizableImageWithCapInsets:UIEdgeInsetsMake(150, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
    
}
- (UIScrollView *)rightScrollView{
    if (!_rightScrollView) {
        _rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
        _rightScrollView.scrollEnabled = YES;
        _rightScrollView.pagingEnabled = YES;
        _rightScrollView.delegate = self;
        _rightScrollView.showsHorizontalScrollIndicator = NO;
        _rightScrollView.showsVerticalScrollIndicator = NO;
//        _rightScrollView.
        
        _rightScrollView.userInteractionEnabled = YES;
//        _rightScrollView.backgroundColor = [UIColor greenColor];
//        [self resetRightScrollView];
//        for (int i = 0; i < 4; i ++) {
//            UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//            XLTVipRightCollectionVIew * contentView = [[XLTVipRightCollectionVIew alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) collectionViewLayout:flow index:i];
//            contentView.dataArray = [self.rightArray by_ObjectAtIndex:i];
//            [_rightScrollView addSubview:contentView];
////            contentView.backgroundColor = i%2 ==0 ? [UIColor grayColor] : [UIColor redColor];
//
//            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_rightScrollView);
//                make.height.mas_equalTo(_rightScrollView.height);
//                make.left.mas_equalTo(kScreenWidth * i);
//                make.width.mas_equalTo(kScreenWidth);
//            }];
//        }
    }
    return _rightScrollView;
}
- (UITableView *)progressTableView{
    if (!_progressTableView) {
        _progressTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _progressTableView.delegate = self;
        _progressTableView.dataSource = self;
        _progressTableView.scrollEnabled = NO;
        _progressTableView.backgroundView = nil;
        _progressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _progressTableView.backgroundColor = [UIColor clearColor];
        [_progressTableView registerNib:[UINib nibWithNibName:@"XLTVipProgressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTVipProgressCell"];
    }
    return _progressTableView;
}
- (NSMutableArray *)rightArray{
    if (!_rightArray) {
        _rightArray = [[NSMutableArray alloc] init];
           for (int i = 0; i < 4; i ++) {
               NSMutableArray *curRightArray = [[NSMutableArray alloc] init];
               if (i == 0 || i == 1) {
                   for (int j = 0; j < 4; j ++) {
                       XLTRightCellModel *model = [[XLTRightCellModel alloc] init];
                       model.level = [NSString stringWithFormat:@"%d",i + 1];
                       switch (j) {
                           case 0:
                           {
                               if (i == 0) {
                                   model.bili = @"1";
                                   model.content = @"自购返利比例100% ";
                                   model.type = XLTRightTypeBuyBili;
                               }else{
                                   model.bili = @"1.421";
                                   model.content = @"自购返利比例100% + 补贴48.2%";
                                   model.type = XLTRightTypeBuyBili;
                               }
                               
                           }
                               break;
                            case 1:
                            {
                                if (i == 0) {
                                    model.bili = @"1";
                                    model.content = @"分享赚返利比例100%";
                                    model.type = XLTRightTypeShareBili;
                                }else{
                                    model.bili = @"1.41.2";
                                    model.content = @"分享赚返利比例100% + 补贴48.2%";
                                    model.type = XLTRightTypeShareBili;
                                }
                                
                            }
                                break;
                            case 2:
                            {
                                model.bili = @"0.4";
                                model.content = @"免费领取平台大额隐藏优惠券";
                                model.type = XLTRightTypeGetBigCoupon;
                            }
                                break;
                            case 3:
                            {
                                model.bili = @"0.4";
                                model.content = @"免费分享发圈素材免费查看拉新教程 ";
                                model.type = XLTRightTypeGetNew;
                            }
                                break;
                           default:
                               break;
                       }
                       [curRightArray addObject:model];
                   }
               }else{
                   for (int j = 0; j < 6; j ++) {
                       XLTRightCellModel *model = [[XLTRightCellModel alloc] init];
                       model.level = [NSString stringWithFormat:@"%d",i + 1];
                       switch (j) {
                           case 0:
                           {
                               if (i == 2) {
                                   model.bili = @"1.862";
                                   model.content = @"自购返利比例145% + 补贴48.2%";
                                   model.type = XLTRightTypeBuyBili;
                               }else{
                                   model.bili = @"2.122";
                                   model.content = @"自购返利比例170% + 补贴48.2%";
                                   model.type = XLTRightTypeBuyBili;
                               }
                           }
                               break;
                            case 1:
                            {
                                if (i == 2) {
                                    model.bili = @"1.862";
                                    model.content = @"分享赚返利比例145% + 补贴48.2%";
                                    model.type = XLTRightTypeShareBili;
                                }else{
                                    model.bili = @"2.122";
                                    model.content = @"分享赚返利比例170% + 补贴48.2%";
                                    model.type = XLTRightTypeShareBili;
                                }
                                
                            }
                                break;
                            case 2:
                            {
                                model.bili = @"0.4";
                                model.content = @"粉丝奖励享受整个粉丝佣金奖励";
                                model.type = XLTRightTypeCommission;
                            }
                                break;
                            case 3:
                            {
                                if (i == 2) {
                                    model.bili = @"0.4";
                                    model.content = @"会员升级奖励";
                                    model.type = XLTRightTypeVipUp;
                                }else{
                                    model.bili = @"0.4";
                                    model.content = @"会员或超级会员升级奖励";
                                    model.type = XLTRightTypeVipUp;
                                }
                                
                            }
                                break;
                            case 4:
                            {
                                if (i == 2) {
                                    model.bili = @"0.4";
                                    model.content = @"免费领取平台大额隐藏优惠券";
                                    model.type = XLTRightTypeGetBigCoupon;
                                }else{
                                    model.bili = @"0.4";
                                    model.content = @"官方培训\n年度旅游";
                                    model.type = XLTRightTypeFH;
                                }
                                
                            }
                                break;
                            case 5:
                            {
                                if (i == 2) {
                                    model.bili = @"0.4";
                                    model.content = @"免费分享发圈素材免费查看拉新教程";
                                    model.type = XLTRightTypeGetNew;
                                }else{
                                    model.bili = @"0.4";
                                    model.content = @"购买六险一金\n基本工资1600元";
                                    model.type = XLTRightTypeGZ;
                                }
                                
                            }
                                break;
                           default:
                               break;
                       }
                        [curRightArray addObject:model];
                   }
               }
               [_rightArray addObject:curRightArray];
           }
        
    }
   
    return _rightArray;
}
#pragma mark Setter and Action
- (void)resetRightScrollViewWithLevel:(NSInteger )level{
//    if (self.level.intValue == level) {
//        return;
//    }
    for (UIView *view in self.rightScrollView.subviews) {
        if ([view isKindOfClass:[XLTVipRightCollectionVIew class]]) {
            [view removeFromSuperview];
        }
    }
    int max = 2;

    if (level == 4) {
        max = 1;
        self.rightScrollView.contentSize = CGSizeMake(kScreenWidth * 1, 0);
    }else{
        self.rightScrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    }
    if (!self.rightArray.count) {
        return;
    }
    for (int i = 0; i < max; i ++) {

        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        CGFloat rightCollectHeight = 85 * ceil([[self.rightArray by_ObjectAtIndex:i] count] / 2.0);
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, rightCollectHeight)];
//        view.backgroundColor = [UIColor blueColor];
//        [self.rightScrollView addSubview:view];
        XLTVipRightCollectionVIew * contentView = [[XLTVipRightCollectionVIew alloc] initWithFrame:CGRectMake((kScreenWidth - 20)* i, 15, kScreenWidth - 20, rightCollectHeight) collectionViewLayout:flow index:i];
        contentView.contentSize = CGSizeMake(kScreenWidth, rightCollectHeight);
        contentView.dataArray = [self.rightArray by_ObjectAtIndex:i];
//        contentView.backgroundColor = [UIColor redColor];
        [self.rightScrollView addSubview:contentView];
//        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.rightScrollView);
//            make.height.mas_equalTo(self.rightScrollView.height);
//            make.left.mas_equalTo(kScreenWidth * i);
//            make.width.mas_equalTo(kScreenWidth);
//        }];
//        [contentView reloadData];
    }
    self.rightScrollView.contentOffset = CGPointMake(0, 0);
}
- (void)setSelectRight:(NSInteger )index{
    
    CGFloat height = 0;
    
    CGFloat userHeight = kTopHeight + 50 + 17;
    NSInteger rightLine = ceil([[self.rightArray by_ObjectAtIndex:index] count] / 2.0);
    CGFloat rightCollectHeight = index < self.rightArray.count ? (70 + 10)* rightLine + 5 : 0;
    CGFloat taskHeight = 20 + self.taskArray.count * 40 + 15 + 10 + 15;
    CGFloat rightHeight = 75 + 76 + rightCollectHeight + 30 + 5;
    
    self.vipProgressView.hidden = !self.taskArray.count;
    self.rightHeight.constant = 92 + rightCollectHeight + 15;
    
    [self.rightScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(rightCollectHeight);
    }];
    self.goodsTitleTop.constant = rightCollectHeight + 35;
    if (self.level.intValue == 4) {
        self.vipRightTop.constant = 20;
        height = userHeight + 20 + rightHeight;
    }else{
        height = userHeight + taskHeight + rightHeight;
        if (self.warnLabel.hidden == NO) {
            CGFloat warnHeight = 0;
            if (self.model.explain.length) {
                CGSize size = [self.model.explain sizeWithFont:self.warnLabel.font maxSize:CGSizeMake(kScreenWidth - 50, 1000)];
                warnHeight = size.height + 5;
            }
            self.warnLabelHeight.constant = warnHeight;
            height = height + warnHeight;
            self.vipRightTop.constant = taskHeight + warnHeight + 30;
            self.vipTaskHeight.constant = taskHeight + warnHeight;
        }else{
            self.vipRightTop.constant = taskHeight;
            self.vipTaskHeight.constant = taskHeight;
        }
    }
    
    height = height - 60;
    height = height + 80;
    self.contentHeight = height;
    
    self.height = height;
    NSLog(@"header height is ......%f",height);
    [self.progressTableView reloadData];
    
    if (![XLTAppPlatformManager shareManager].showVipBuy) {
        self.goodsTitle.hidden = YES;
        self.goodsTitleLImageView.hidden = YES;
        self.goodsTitleRImageView.hidden = YES;
    }else{
        self.goodsTitle.hidden = NO;
        self.goodsTitleLImageView.hidden = NO;
        self.goodsTitleRImageView.hidden = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollVipRight:headerHeight:)]) {
        [self.delegate scrollVipRight: index headerHeight:height];
    }
}
- (IBAction)upAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(upScrollAction)]) {
        [self.delegate upScrollAction];
    }
}
#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTVipProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTVipProgressCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.taskArray by_ObjectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma makr segeMentSelect
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
//    self.rightScrollView.contentSize = CGSizeMake(kScreenWidth * 4, 0);
    [self.rightScrollView setContentOffset:CGPointMake((kScreenWidth - 20) * index, 0)];
     [self setSelectRight:index];
}
#pragma mark ScrollerView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat index = scrollView.contentOffset.x / (kScreenWidth - 20);
    self.segemetnVIew.selectedSegmentIndex = index;
    [self setSelectRight:self.segemetnVIew.selectedSegmentIndex];
}
@end
