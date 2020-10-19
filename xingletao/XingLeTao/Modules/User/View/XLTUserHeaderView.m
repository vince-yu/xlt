//
//  XLTUserHeaderView.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserHeaderView.h"
#import "XLTUserManager.h"
#import "XLTAlertViewController.h"
#import "XLTWKWebViewController.h"
#import "XLTHomeCustomHeadView.h"
#import "SDWebImage.h"
#import "XLTTabBarController.h"
#import "AppDelegate.h"
#import "XLTContactMentorVC.h"
#import "XLTUpdateInvaterVC.h"
#import "SPButton.h"
#import "XLTOrderFindVC.h"
#import "XLTRootOrderVC.h"
#import "UIView+Extension.h"
#import "XLTMyWatermarkViewController.h"
#import "XLTNavigationController.h"
#import "XLTUpdateMyInviterVC.h"
#import "XLTMyRecommendVC.h"
#import "XLTBindWXVC.h"
#import "NSString+XLTSourceStringHelper.h"
#import "XLTVipVC.h"
#import "SDCycleScrollView.h"
#import "NSArray+Bounds.h"
#import "XLTTeacherShareContainerVC.h"
#import "XLTTeacherShareListForMeVC.h"

@interface XLTUserHelpViewItemModel : NSObject
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *selectorName;
@property (nonatomic ,copy) NSString *tag;
@end

@implementation XLTUserHelpViewItemModel



@end

@interface XLTUserHeaderView ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *blanceView;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UIView *collectionView;
//headerView
@property (weak, nonatomic) IBOutlet UIImageView *headBGView;
@property (weak, nonatomic) IBOutlet UIImageView *memberLabelBg;
@property (weak, nonatomic) IBOutlet UILabel *todayIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comesoonImcomLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *letaodescribeLabel;
@property (weak, nonatomic) IBOutlet UIButton *avterBtn;
@property (weak, nonatomic) IBOutlet UIButton *settimgBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *vipUpView;
@property (weak, nonatomic) IBOutlet SPButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLabelTop;
@property (weak, nonatomic) IBOutlet UIImageView *tutorIcon;
@property (weak, nonatomic) IBOutlet UILabel *yestodayImcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipCircleImage;
//balance
@property (weak, nonatomic) IBOutlet UIImageView *balanceBgView;
@property (weak, nonatomic) IBOutlet UILabel *frozenLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *balanceQuestionBtn;
@property (weak, nonatomic) IBOutlet UILabel *blanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;
@property (weak, nonatomic) IBOutlet UILabel *estimateLabel;
//orderView
@property (weak, nonatomic) IBOutlet UIButton *topAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *willArrivalBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrivaledBtn;
@property (weak, nonatomic) IBOutlet UIButton *InvalidBtn;
//helpView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;
@property (weak, nonatomic) IBOutlet UIView *coustomHelpView;
@property (weak, nonatomic) IBOutlet UIView *helpContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpViewHeight;

//adView
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adImageHeight;

//memberView
@property (weak, nonatomic) IBOutlet UIView *merberView;
@property (weak, nonatomic) IBOutlet UIButton *vipupBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipUpOderBtn;

//toolView
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *toolContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewHeight;
//contactView
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIView *contactContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactViewHeight;


//审核相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberHeight;

//ad banner
@property (nonatomic ,strong) SDCycleScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIView *earnBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBGHeight;


@end

@implementation XLTUserHeaderView
- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTUserHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        self.balanceBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushtoBalanceVC)];
        [self.balanceBgView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToVipVC)];
        self.vipUpView.userInteractionEnabled = YES;
        [self.vipUpView addGestureRecognizer:tap1];
        
        UIImage *image = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xF8A144],[UIColor colorWithHex:0xFC4402]] gradientType:1 imgSize:CGSizeMake(kScreenWidth, 245)];
        self.headBGView.image = image;
        
        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_circle"];
        CGFloat bottomCircleHeight = ceilf(self.bounds.size.width/375*35);
        UIImageView *letaoCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
        letaoCircleImageView.frame = CGRectMake(0, self.bounds.size.height - bottomCircleHeight, self.bounds.size.width, bottomCircleHeight);
        [self.headBGView addSubview:letaoCircleImageView];
        
        [letaoCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.headBGView);
            make.height.mas_equalTo(bottomCircleHeight);
        }];
//        self.adView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdAction)];
//        [self.adView addGestureRecognizer:tap2];
        self.earnBgView.layer.cornerRadius = 10;
        self.earnBgView.clipsToBounds = YES;
        self.merberView.layer.cornerRadius = 10;
        self.inviteBtn.layer.cornerRadius = 11.25;
        self.inviteBtn.layer.masksToBounds = YES;
        self.inviteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.inviteBtn.layer.borderWidth = 0.5;
//        self.memberLabelBg.layer.cornerRadius = 7.5;
        self.memberLabelBg.layer.masksToBounds = YES;
        self.merberView.layer.cornerRadius = 10;
        self.coustomHelpView.layer.cornerRadius = 10;
        self.coustomHelpView.layer.masksToBounds = YES;
//        self.blanceView.layer.shadowColor = [UIColor colorWithRed:243/255.0 green:66/255.0 blue:100/255.0 alpha:0.4].CGColor;
//        self.blanceView.layer.shadowOffset = CGSizeMake(0,5);
//        self.blanceView.layer.shadowOpacity = 1;
//        self.blanceView.layer.shadowRadius = 18;
        
        self.avterBtn.layer.cornerRadius = 27;
        self.avterBtn.layer.masksToBounds = YES;
        
        self.vipupBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.vipupBtn.layer.borderWidth = 1;
        self.vipupBtn.layer.masksToBounds = YES;
        self.vipupBtn.layer.cornerRadius = 12.5;
        self.vipupBtn.userInteractionEnabled = NO;
        
        self.withDrawBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.withDrawBtn.layer.borderWidth = 1;
        
        
        [self.memberLabelBg addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight withRadii:CGSizeMake(7.5, 7.5) viewRect:CGRectMake(0, 0, 75, 15)];
        self.memberLabelBg.layer.masksToBounds = YES;
        
        
        [self reloadView:[XLTUserManager shareManager].isLogined];
        
        // 默认值
        self.headerViewHeight.constant = 245;
        self.headerBGHeight.constant = 200;
        self.memberLabelBg.hidden = YES;
        
        self.blanceLabel.adjustsFontSizeToFitWidth = YES;
        self.blanceLabel.minimumScaleFactor = 0.2;
        
        self.toolView.layer.cornerRadius = 10;
        self.toolView.layer.masksToBounds = YES;
        
        self.contactView.layer.cornerRadius = 10;
        self.contactView.layer.masksToBounds = YES;
        
        [self.adView addSubview:self.adScrollView];
        
        [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.top.equalTo(self.adView);
        }];
        self.adImageView.hidden = YES;
    }
    return self;
}
- (NSArray *)configHelpViewData{
    NSMutableArray *section1Array = [[NSMutableArray alloc] initWithArray:@[@{
        @"title":@"地推宣传",
        @"icon":@"xingletao_mine_header_ditui",
        @"selectorName":@"pushToDiTuiVC",
        @"tag":@""
    }
    ]];
    NSMutableArray *section2Array = [[NSMutableArray alloc] initWithArray:@[@{
        @"title":@"我的收藏",
        @"icon":@"xingletao_mine_collection",
        @"selectorName":@"collectionVIew:",
        @"tag":@""
    },@{
        @"title":@"找回订单",
        @"icon":@"xlt_mine_header_backoder",
        @"selectorName":@"pushToFindOrder",
        @"tag":@""
    }]];
    NSMutableArray *section3Array = [[NSMutableArray alloc] initWithArray:@[@{
        @"title":@"常见问题",
        @"icon":@"xingletao_mine_header_askicon",
        @"selectorName":@"pushToHelpVC",
        @"tag":@""
    },@{
        @"title":@"商家合作",
        @"icon":@"xingletao_mine_header_hz",
        @"selectorName":@"pushToCooperationVC",
        @"tag":@""
    },@{
        @"title":@"推广规范",
        @"icon":@"xingletao_mine_tg",
        @"selectorName":@"pushToTGVC",
        @"tag":@""
    },@{
        @"title":@"联系我们",
        @"icon":@"xingletao_mine_contact",
        @"selectorName":@"pushToContactUsVC",
        @"tag":@""
    }]];
    
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        [section1Array insertObject:@{
            @"title":@"任务中心",
            @"icon":@"xinletao_mine_task",
            @"selectorName":@"pushToTaskVC",
            @"tag":@""
        } atIndex:0];
        [section1Array addObject:@{
            @"title":@"云发单",
            @"icon":@"mine_fadan_icon",
            @"selectorName":@"pushToWXinAssistant",
            @"tag":@""
        }];
        
        [section2Array addObject:@{
            @"title":@"批量转链",
            @"icon":@"xingletao_mine_header_link",
            @"selectorName":@"pushToLinksVC",
            @"tag":@""
        }];
        [section2Array addObject:@{
            @"title":@"专属水印",
            @"icon":@"mywatermark_icon",
            @"selectorName":@"pushToMyWatermarkViewController",
            @"tag":@""
        }];
        [section2Array addObject:@{
            @"title":@"出单榜",
            @"icon":@"xingletao_mine_header_cdb",
            @"selectorName":@"pushToCDBVC",
            @"tag":@""
        }];
        [section2Array addObject:@{
            @"title":@"新手教程",
            @"icon":@"xingletao_mine_header_guide",
            @"selectorName":@"pushToNewGuideVC",
            @"tag":@""
        }];
    }
    
    if ([XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid.length) {
        [section1Array addObject:@{
            @"title":@"导师微信",
            @"icon":@"xingletao_mine_metor",
            @"selectorName":@"pushToContactMentorVC",
            @"tag":@""
        }];
    }
    
        [section2Array insertObject:@{
            @"title":@"导师分享",
            @"icon":@"xingletao_mine_header_wx",
            @"selectorName":@"pushToBindWeiXin",
            @"tag":@""
        } atIndex:section2Array.count - 1];
    if ([XLTUserManager shareManager].curUserInfo.level.intValue >= 3) {
        [section2Array addObject:@{
            @"title":@"我的推荐",
            @"icon":@"xingletao_mine_myrec",
            @"selectorName":@"pushToMyRecommendVC",
            @"tag":@""
        }];
    }
    
    self.configHelpArray = @[section1Array,section2Array,section3Array];
    return @[
            [NSArray modelArrayWithClass:[XLTUserHelpViewItemModel class] json:section1Array],
             [NSArray modelArrayWithClass:[XLTUserHelpViewItemModel class] json:section2Array],
             [NSArray modelArrayWithClass:[XLTUserHelpViewItemModel class] json:section3Array]];
    
}
- (void)reloadEarnToolView:(NSArray *)dataArray{
    for (UIView *view in self.helpContentView.subviews) {
            [view removeFromSuperview];
        }
    //    CGFloat space = 10;
        CGFloat itemWith = (kScreenWidth - 20) / 4;
        CGFloat itemHeight = 75;
        for (int i = 0 ; i < dataArray.count ; i ++) {
            NSInteger section = ceil(i / 4);
            NSInteger itemIndex = i % 4;
            XLTUserHelpViewItemModel *item = [dataArray objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            if (item.selectorName.length) {
                SEL selector = NSSelectorFromString(item.selectorName);
                [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            }
            [self.helpContentView addSubview:btn];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.icon]];
            [btn addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            //todo:字体有问题
            label.font = [UIFont letaoRegularFontWithSize:12];
            label.textColor = [UIColor colorWithHex:0x25282D];
            label.text = item.title;
            label.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:label];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(itemIndex * itemWith);
                make.top.equalTo(self.helpContentView).offset(itemHeight * section);
                make.width.mas_equalTo(itemWith);
                make.height.mas_equalTo(itemHeight );
            }];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn);
                make.top.mas_equalTo(10);
                make.width.mas_equalTo(32);
                make.height.mas_equalTo(32);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView.mas_bottom).offset(10);
                //            make.centerX.equalTo(imageView);
                make.height.mas_equalTo(12);
                make.left.right.equalTo(btn);
            }];
            
        }
        self.helpViewHeight.constant = 35 + 20 + ceil(dataArray.count / 4.0) * itemHeight;
}
- (void)reloadToolView:(NSArray *)dataArray{
    for (UIView *view in self.toolContentView.subviews) {
            [view removeFromSuperview];
        }
    //    CGFloat space = 10;
        CGFloat itemWith = (kScreenWidth - 20) / 4;
        CGFloat itemHeight = 75;
        for (int i = 0 ; i < dataArray.count ; i ++) {
            NSInteger section = ceil(i / 4);
            NSInteger itemIndex = i % 4;
            XLTUserHelpViewItemModel *item = [dataArray objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            if (item.selectorName.length) {
                SEL selector = NSSelectorFromString(item.selectorName);
                [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            }
            [self.toolContentView addSubview:btn];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.icon]];
            [btn addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            //todo:字体有问题
            label.font = [UIFont letaoRegularFontWithSize:12];
            label.textColor = [UIColor colorWithHex:0x25282D];
            label.text = item.title;
            label.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:label];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(itemIndex * itemWith);
                make.top.equalTo(self.toolContentView).offset(itemHeight * section);
                make.width.mas_equalTo(itemWith);
                make.height.mas_equalTo(itemHeight );
            }];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn);
                make.top.mas_equalTo(10);
                make.width.mas_equalTo(32);
                make.height.mas_equalTo(32);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView.mas_bottom).offset(10);
                //            make.centerX.equalTo(imageView);
                make.height.mas_equalTo(12);
                make.left.right.equalTo(btn);
            }];
            
        }
        self.toolViewHeight.constant = 35 + 20 + ceil(dataArray.count / 4.0) * itemHeight;
}
- (void)reloadContactView:(NSArray *)dataArray{
    for (UIView *view in self.contactContentView.subviews) {
            [view removeFromSuperview];
        }
        
    //    CGFloat space = 10;
        CGFloat itemWith = (kScreenWidth - 20) / 4;
        CGFloat itemHeight = 75;
        for (int i = 0 ; i < dataArray.count ; i ++) {
            NSInteger section = ceil(i / 4);
            NSInteger itemIndex = i % 4;
            XLTUserHelpViewItemModel *item = [dataArray objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            if (item.selectorName.length) {
                SEL selector = NSSelectorFromString(item.selectorName);
                [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            }
            [self.contactContentView addSubview:btn];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.icon]];
            [btn addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            //todo:字体有问题
            label.font = [UIFont letaoRegularFontWithSize:12];
            label.textColor = [UIColor colorWithHex:0x25282D];
            label.text = item.title;
            label.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:label];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(itemIndex * itemWith);
                make.top.equalTo(self.contactContentView).offset(itemHeight * section);
                make.width.mas_equalTo(itemWith);
                make.height.mas_equalTo(itemHeight );
            }];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn);
                make.top.mas_equalTo(10);
                make.width.mas_equalTo(32);
                make.height.mas_equalTo(32);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView.mas_bottom).offset(10);
                //            make.centerX.equalTo(imageView);
                make.height.mas_equalTo(12);
                make.left.right.equalTo(btn);
            }];
            
        }
        self.contactViewHeight.constant = 20 + ceil(dataArray.count / 4.0) * itemHeight;
}
- (void)reloadHelpView{
    NSArray *dataArray = [self configHelpViewData];
    [self reloadEarnToolView:dataArray.firstObject];
    [self reloadToolView:dataArray[1]];
    [self reloadContactView:dataArray.lastObject];
}
- (void)reloadView:(BOOL )islogin{
    self.balanceQuestionBtn.hidden = !islogin;
//    if (islogin && self.balanceInfo.amountUseable.doubleValue > 0) {
//        self.withDrawBtn.hidden = !islogin;
//    }else{
//        self.withDrawBtn.hidden = YES;
//    }
    
    //审核开关，会员中心处理
    if (![XLTAppPlatformManager shareManager].checkEnable) {
//        self.memberHeight.constant = 0;
        self.merberView.hidden = YES;
        self.memberLabelBg.hidden = YES;
        self.letaodescribeLabel.hidden = YES;
        self.inviteBtn.hidden = YES;
        self.editBtn.hidden = YES;
        self.merberView.hidden = YES;
        self.orderView.hidden = NO;
    }else{
//        self.memberHeight.constant = 140;
        self.merberView.hidden = NO;
        self.memberLabelBg.hidden = NO;
        self.letaodescribeLabel.hidden = NO;
        self.inviteBtn.hidden = NO;
        self.editBtn.hidden = !islogin;
        self.orderView.hidden = YES;
        self.merberView.hidden = NO;
//        self.vipUpView.hidden = YES;
    }
    
    self.frozenLabel.hidden = !islogin;
    self.estimateLabel.hidden = !islogin;
//    self.inviteBtn.hidden = !islogin;
    if (islogin) {
        if (self.balanceInfo.amountFrozen.doubleValue > 0) {
            self.frozenLabel.text = [NSString stringWithFormat:@"提现中：¥%@",[self.balanceInfo.amountFrozen priceStr]];
            self.frozenLabel.hidden = NO;
        }else{
            self.frozenLabel.hidden = YES;
        }
        [self reloadHelpView];
    }else{
        _userInfo = nil;
        _income = nil;
        _balanceInfo = nil;
        self.tutorIcon.hidden = YES;
        self.vipupBtn.hidden = YES;
        self.comesoonImcomLabel.text = @"0.00";
        self.totalIncomeLabel.text = @"0.00";
        self.todayIncomeLabel.text = @"0.00";
        self.yestodayImcomeLabel.text = @"0.00";
        self.blanceLabel.text = @"0.00";
        self.userNameLabel.text = @"登录/注册";
        self.letaodescribeLabel.text = @"美好生活，从这里开始";
        self.memberLabelBg.hidden = YES;
        self.inviteBtn.hidden = YES;
        self.vipUpView.hidden = YES;
        self.headerViewHeight.constant = 245;
        self.headerBGHeight.constant = 200;
        [self.avterBtn setImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"] forState:UIControlStateNormal];
        
        self.comesoonImcomLabel.textColor = [UIColor colorWithHex:0xFDDEBD];
        self.totalIncomeLabel.textColor = [UIColor colorWithHex:0xFDDEBD];
        self.todayIncomeLabel.textColor = [UIColor colorWithHex:0xFDDEBD];
//        self.todayIncomeLabel.text = @"0.00";
        [self reloadHelpText:NO];
        [self reloadHelpView];
    }
    [self reloadHeaderHeight];
}
- (CGFloat)headerHeight{
    CGFloat userHeaderHeight = 245;
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        if (self.userInfo.level.intValue == 2 || self.userInfo.level.intValue == 3 || self.userInfo.level.intValue == 1 || self.userInfo.level.intValue == 4) {
            userHeaderHeight = 308;
        }else{
            userHeaderHeight = 245;
        }
    }
    CGFloat blanceHeight = 113;
    if ([self.balanceInfo.helptext isKindOfClass:[NSString class]] && self.balanceInfo.helptext.length) {
        CGSize size = [self.balanceInfo.helptext sizeWithFont:[UIFont fontWithName:kSDPFRegularFont size:11] maxSize:CGSizeMake(kScreenWidth - 50 - 30, 50)];
        CGFloat helpHeight = size.height > 35 ? 35 : size.height;
        blanceHeight = blanceHeight + helpHeight + 3 + 21 - 18;
    }
    CGFloat memberHeight = 100;
    CGFloat earnHelpHeiht = 35 + 20 + ceil([self.configHelpArray[0] count] / 4.0) * 75;
    CGFloat toolHelpHeiht = 35 + 20 + ceil([self.configHelpArray[1] count] / 4.0) * 75;
    CGFloat contactHelpHeiht = 20 + ceil([self.configHelpArray[2] count] / 4.0) * 75;
    CGFloat adHeight = self.adImageHeight.constant;
    
    CGFloat totalHeight = userHeaderHeight + blanceHeight + 10 + memberHeight + earnHelpHeiht + 15 + toolHelpHeiht + 15 + contactHelpHeiht;
    if (!self.adView.isHidden) {
        totalHeight = totalHeight + 20 + adHeight;
    }
    
    _headerHeight = totalHeight;
    return _headerHeight;
}
- (void)setHeaderMoneyColor{

    self.comesoonImcomLabel.textColor =  self.income.nowmonth_estimate.floatValue == 0 ? [UIColor colorWithHex:0xFDDEBD] : [UIColor colorWithHex:0xFDDEBD];
    self.totalIncomeLabel.textColor = self.income.today_estimate.floatValue == 0 ? [UIColor colorWithHex:0xFDDEBD] : [UIColor colorWithHex:0xFDDEBD];
    self.todayIncomeLabel.textColor = self.income.lastmonth_estimate.floatValue == 0 ? [UIColor colorWithHex:0xFDDEBD] : [UIColor colorWithHex:0xFDDEBD];
    self.yestodayImcomeLabel.textColor = self.income.yesterday_estimate.floatValue == 0 ? [UIColor colorWithHex:0xFDDEBD] : [UIColor colorWithHex:0xFDDEBD];
//    }
}
- (SDCycleScrollView *)adScrollView{
    if (!_adScrollView) {
        _adScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
        _adScrollView.autoScroll = YES;
        _adScrollView.delegate = self;
        _adScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _adScrollView.backgroundColor = [UIColor clearColor];
    }
    return _adScrollView;
}
- (void)setAdModel:(id)adModel{
    _adModel = adModel;
    if ([adModel isKindOfClass:[NSArray class]] && [adModel count]) {
//        self.collectionViewTop.constant = (kScreenWidth - 30) / 4.6 + 30;
        XLT_WeakSelf;
        NSString *urlStr = [[[adModel firstObject] objectForKey:@"image"] letaoConvertToHttpsUrl];
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        [self.adModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *image = obj[@"image"];
            if ([obj isKindOfClass:[NSDictionary class]] && image.length) {
                [imageArray addObject:[image letaoConvertToHttpsUrl]];
            }
        }];
        self.adScrollView.imageURLStringsGroup = imageArray;
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            XLT_StrongSelf;
            if (image) {
                CGFloat bili = image.size.width / image.size.height;
                bili = 6;
                CGFloat imageHeight = (kScreenWidth - 30) / bili;
                self.collectionViewTop.constant = imageHeight + 20;
                self.adImageHeight.constant = imageHeight;
                [self reloadHeaderHeight];
            }
        }];
        self.adView.hidden = NO;
    }else{
        self.collectionViewTop.constant = 10;
        self.adView.hidden = YES;
        [self reloadHeaderHeight];
    }
}
- (void)reloadHeaderHeight{
//    self.headerHeight = self.merberView.y + self.merberView.height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadUserHeadView:)]) {
        [self.delegate reloadUserHeadView:self.headerHeight];
    }
}
- (void)setIncome:(XLTUserIncomeModel *)income{
    _income = income;
    if (!_income) {
        return;
    }
    self.totalIncomeLabel.text = [self.income.today_estimate priceStr];
    self.comesoonImcomLabel.text = [self.income.nowmonth_estimate priceStr];
    self.todayIncomeLabel.text = [self.income.lastmonth_estimate priceStr];
    self.yestodayImcomeLabel.text = [self.income.yesterday_estimate priceStr];
    
    NSMutableString *estimateStr = [[NSMutableString alloc] init];
    if (self.income.today_estimate.length) {
        [estimateStr appendFormat:@"今日预估(元) %@  ",[self.income.today_estimate priceStr]];
        
    }else{
        estimateStr = [NSMutableString stringWithString:@"今日预估(元) 0.00"];
    }
//    if (self.income.yesterday_estimate.length) {
//        [estimateStr appendFormat:@"昨日预估(元) %@",[self.income.yesterday_estimate priceStr]];
//    }
//    if (estimateStr.length) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:estimateStr];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12]} range:NSMakeRange(0, 7)];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:15]} range:NSMakeRange(8,estimateStr.length - 8)];
        self.estimateLabel.attributedText = attrStr;
//    }
    
    
    [self setHeaderMoneyColor];
}
- (void)setUserInfo:(XLTUserInfoModel *)userInfo{
    _userInfo = userInfo;
    if (!userInfo) {
        [self reloadView:NO];
        return;
    }
    [self reloadHelpView];
    self.tutorIcon.hidden = !self.userInfo.isTutor.boolValue;
    [self.avterBtn sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    if (self.userInfo.invite_link_code.length) {
        NSString *contentText = [NSString stringWithFormat:@"邀请码：%@",self.userInfo.invite_link_code];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:contentText];
        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:14],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFFFFF]} range:NSMakeRange(0, 4)];
        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFFFFF]} range:NSMakeRange(4, contentText.length - 4)];
        self.letaodescribeLabel.attributedText = attr;
    }else{
        self.letaodescribeLabel.text = @"美好生活，从这里开始";
    }
    self.userNameLabel.text = self.userInfo.userNameInfo;
    switch (userInfo.level.intValue) {
        case 1:
        {
            self.memberLabelBg.hidden = YES;
            self.inviteBtn.hidden = NO;
            self.inviteBtn.backgroundColor = [UIColor clearColor];
            self.vipUpView.hidden = NO;
            [self.vipUpView setImage:[UIImage imageNamed:@"xlt_mine_update_super"]];
            self.vipupBtn.hidden = NO;
            self.vipCircleImage.image = [UIImage imageNamed:@"xlt_mine_vip_circle"];
        }
            break;
        case 2:
        {
            self.memberLabelBg.hidden = NO;
            self.inviteBtn.hidden = NO;
            [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFAE01],[UIColor colorWithHex:0xFF6E02]] gradientType:1 imgSize:self.memberLabelBg.size];
//            self.memberLabelBg.image = bgImage;
            self.memberLabelBg.image = [UIImage imageNamed:@"xlt_mine_tag"];
            self.vipCircleImage.image = [UIImage imageNamed:@"xlt_mine_vip_circle"];
            self.inviteBtn.backgroundColor = [UIColor clearColor];
            self.vipUpView.hidden = NO;
            [self.vipUpView setImage:[UIImage imageNamed:@"xlt_mine_update_super"]];
            
            self.vipupBtn.hidden = NO;

        }
            break;
        case 3:
        {
            self.memberLabelBg.hidden = NO;
            self.inviteBtn.hidden = NO;
            [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.vipCircleImage.image = [UIImage imageNamed:@"xlt_mine_super_circle"];
//            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xEBBF79],[UIColor colorWithHex:0xCB9239]] gradientType:1 imgSize:self.memberLabelBg.size];
//            self.memberLabelBg.image = bgImage;
            self.memberLabelBg.image = [UIImage imageNamed:@"xlt_mine_tag_supper"];
            self.inviteBtn.backgroundColor = [UIColor clearColor];
            self.vipUpView.hidden = NO;
            [self.vipUpView setImage:[UIImage imageNamed:@"xlt_mine_update_first"]];
            
            self.vipupBtn.hidden = NO;

    }
            break;
        case 4:
        {
          
            self.memberLabelBg.hidden = NO;
            self.inviteBtn.hidden = NO;
            [self.inviteBtn setTitleColor:[UIColor colorWithHex:0xE8C48B] forState:UIControlStateNormal];
//            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0x000000],[UIColor colorWithHex:0x312F2B]] gradientType:1 imgSize:self.memberLabelBg.size];
//            self.memberLabelBg.image = bgImage;
            self.memberLabelBg.image = [UIImage imageNamed:@"xlt_mine_tag_md"];
            self.inviteBtn.backgroundColor = [UIColor colorWithHex:0x312F2B];
            self.vipUpView.hidden = NO ;
            self.vipupBtn.hidden = YES;
            self.vipCircleImage.image = [UIImage imageNamed:@"xlt_mine_md_circle"];
            [self.vipUpView setImage:[UIImage imageNamed:@"xlt_mine_update_qy"]];
        }
            break;
        default:{
            self.memberLabelBg.hidden = YES;
            self.inviteBtn.hidden = NO;
            self.inviteBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
            self.vipUpView.hidden = NO;
//            [self.vipUpView setImage:[UIImage imageNamed:@"xlt_vip_up_nomal"]];
            self.vipupBtn.hidden = YES;
        }
            break;
    }
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        if (self.userInfo.level.intValue == 2 || self.userInfo.level.intValue == 3 || self.userInfo.level.intValue == 1 || self.userInfo.level.intValue == 4) {
            self.headerViewHeight.constant = 308;
            self.vipupBtn.hidden = YES;
            self.vipUpView.hidden = NO;
            self.headerBGHeight.constant = 260;
        }else{
            self.headerViewHeight.constant = 245;
            self.headerBGHeight.constant = 200;
            self.vipUpView.hidden = YES;
            self.vipupBtn.hidden = YES;
        }
        
    }else{
        self.headerViewHeight.constant = 245;
        self.headerBGHeight.constant = 200;
        self.vipUpView.hidden = YES;
        self.vipupBtn.hidden = YES;
    }
    
//    self.letaodescribeLabel.text = @"";
}
- (void)setBalanceInfo:(XLTBalanceInfoModel *)balanceInfo{
    if (!balanceInfo) {
        return;
    }
    _balanceInfo = balanceInfo;
    self.blanceLabel.text = [self.balanceInfo.amountUseable priceStr];
    if (self.balanceInfo.amountFrozen.doubleValue > 0) {
        self.frozenLabel.text = [NSString stringWithFormat:@"提现中：¥%@",[self.balanceInfo.amountFrozen priceStr]];
        self.frozenLabel.hidden = NO;
    }else{
        self.frozenLabel.hidden = YES;
    }
    
    self.frozenLabel.text = [NSString stringWithFormat:@"提现中：¥%@",[self.balanceInfo.amountFrozen priceStr]];
//    _balanceInfo.helptext = @"每月25日可提现上月确定收货的订单收益每月25日可提现上月确定收货的订单收益";
    [self reloadHelpText:YES];
    [self reloadHeaderHeight];
}
- (void)reloadHelpText:(BOOL )login{
    if (login && _balanceInfo.helptext.length) {
        self.helpTextLabel.hidden = NO;
        self.helpTextLabel.text = _balanceInfo.helptext;
        CGSize size = [_balanceInfo.helptext sizeWithFont:self.helpTextLabel.font maxSize:CGSizeMake(kScreenWidth - 50 - 30, 50)];
        [self.helpTextLabel sizeToFit];
        
        self.balanceLabelTop.constant = size.height + 3 + 21;
        self.balanceViewHeight.constant = 113 + size.height + 3 + 21 - 18;
    }else{
        self.helpTextLabel.hidden = YES;
        self.balanceViewHeight.constant = 113;
        self.balanceLabelTop.constant = 18;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)pushtoBalanceVC{
    if (self.pushWithBalanceBlock) {
        self.pushWithBalanceBlock();
    }
}
- (IBAction)pushToSetVC:(id)sender {
    if (self.pushSettingBlock) {
        self.pushSettingBlock();
    }
}
- (IBAction)blanceQuestionClick:(id)sender {
    XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"余额说明" message:@"余额：指已结算的返利金，可进行提现\n提现中金额：即提现中的返利金，提现到账时间1~7天" sureButtonText:@"知道了" cancelButtonText:nil];
    alertViewController.letaoalertViewAction = ^(NSInteger clickIndex,BOOL noneShow) {
        
    };
}
- (IBAction)withdrawAction:(id)sender {
    if (self.pushWithDrawBlock) {
        self.pushWithDrawBlock();
    }
}
- (IBAction)allOrderAtion:(id)sender {
    if (self.orderButtonClickBlock) {
        self.orderButtonClickBlock(0);
    }
}
- (IBAction)willArrivalOrderAction:(id)sender {
    if (self.orderButtonClickBlock) {
        self.orderButtonClickBlock(1);
    }
}
- (IBAction)arrivaledAction:(id)sender {
    if (self.orderButtonClickBlock) {
        self.orderButtonClickBlock(2);
    }
}
- (IBAction)invalidAction:(id)sender {
    if (self.orderButtonClickBlock) {
        self.orderButtonClickBlock(3);
    }
}
- (IBAction)findBackOrder:(id)sender {
    if (self.orderButtonClickBlock) {
        self.orderButtonClickBlock(4);
    }
}
- (IBAction)avatarAction:(id)sender {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    }
}
- (IBAction)editInviterAction:(id)sender {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTUpdateInvaterVC *web =  [[XLTUpdateInvaterVC alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
}
- (void)userNameClick{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    }
}
- (IBAction)questionAction:(id)sender {
    [self pushToHelpVC];
}
- (IBAction)customServerAction:(id)sender {
    [self pushToServerVC];
}
- (IBAction)collectionVIew:(id)sender {
    if (self.pushCollectionBlock) {
        self.pushCollectionBlock();
    }
}
- (IBAction)taskAction:(id)sender {
    [self pushToTaskVC];
}
- (void)pushToFindOrder{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTOrderFindVC *vc = [[XLTOrderFindVC alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:vc animated:YES];
}
- (void)pushToCDBVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        XLTNavigationController *mainNavigationController =  appDelegate.mainNavigationController;
        if (![XLTUserManager shareManager].isInvited) {
            if ([XLTAppPlatformManager shareManager].checkEnable) {
                // 邀请页面
                [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
                XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
                [mainNavigationController pushViewController:updateMyInviterVC animated:YES];
                return;
            }
        }
        XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
        web.jump_URL = kXLTCDPH5Url;
        web.fullScreen = YES;
        web.title = @"出单榜";
        [mainNavigationController pushViewController:web animated:YES];
    }
}
- (void)pushToBindWeiXin{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    UIViewController *vc = nil;
    if ([XLTUserManager shareManager].curUserInfo.level.intValue >= 3) {
        vc = [[XLTTeacherShareContainerVC alloc] init];
    }else{
        vc = [[XLTTeacherShareListForMeVC alloc] init];
    }
    [[XLTRepoDataManager shareManager] umeng_repoEvent:@"tutor_share" params:nil];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:vc animated:YES];
}
- (void)pushToMyRecommendVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTMyRecommendVC *watermarkViewController =  [[XLTMyRecommendVC alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:watermarkViewController animated:YES];
}
- (void)pushToTGVC{
    if (![XLTUserManager shareManager].isLogined) {
            [[XLTUserManager shareManager] displayLoginViewController];
            return;
        }
        XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
        web.jump_URL = kXLTTGGFeH5Url;
        web.isLightBarStyle = NO;
    //    web.fullScreen = YES;
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [nav pushViewController:web animated:YES];
}
- (void)pushToContactUsVC{
    if (![XLTUserManager shareManager].isLogined) {
            [[XLTUserManager shareManager] displayLoginViewController];
            return;
        }
        XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
        web.jump_URL = kXLTContactUsH5Url;
        web.isLightBarStyle = NO;
    //    web.fullScreen = YES;
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [nav pushViewController:web animated:YES];
}
- (void)pushToNewGuideVC{
    if (![XLTUserManager shareManager].isLogined) {
            [[XLTUserManager shareManager] displayLoginViewController];
            return;
        }
        XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
        web.jump_URL = kXLTNewJCH5Url;
        web.isLightBarStyle = NO;
    //    web.fullScreen = YES;
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [nav pushViewController:web animated:YES];
}
- (void)pushToMyWatermarkViewController {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTMyWatermarkViewController *watermarkViewController =  [[XLTMyWatermarkViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:watermarkViewController animated:YES];
}

- (void)pushToWXinAssistant {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTWXinAssistant5Url;
    web.isLightBarStyle = NO;
//    web.fullScreen = YES;
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
}
- (void)pushToDiTuiVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTCloudH5Url;
    web.title = @"地推物料";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
}
- (void)pushToLinksVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTZhuanLianH5Url;
    
    web.title = @"批量转链";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
}
- (void)pushToCooperationVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTMerchantsH5Url;
    web.title = @"商家合作";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
}
- (void)pushToHelpVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTHelpUrl;
    web.title = @"常见问题列表";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];

    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_PROBLEM properties:nil];
}
- (void)pushToContactMentorVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTContactMentorVC *vc = [[XLTContactMentorVC alloc] init];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:vc animated:YES];

    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_MENTOR properties:nil];
}
- (void)pushToTaskVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTUserTaskH5Url;
    web.fullScreen = YES;
    web.title = @"任务中心";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
    
    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_TASK properties:nil];
}
- (void)pushToServerVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTServerUrl;
    web.title = @"在线客服";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
    
    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_SERVICE properties:nil];
}
- (IBAction)uerLabelClick:(id)sender {
    [self avatarAction:nil];
}
- (IBAction)incomeClick:(id)sender {
    if (self.merberClickBlock) {
        self.merberClickBlock(0);
    }
}
- (IBAction)teamOrderClick:(id)sender {
    if (self.merberClickBlock) {
        self.merberClickBlock(1);
    }
}
- (IBAction)myTeamClick:(id)sender {
    if (self.merberClickBlock) {
        self.merberClickBlock(2);
    }
}
- (IBAction)inviteFriClick:(id)sender {
    if (self.merberClickBlock) {
        self.merberClickBlock(3);
    }
}
- (IBAction)copyInvateCode:(id)sender {
    [UIPasteboard generalPasteboard].string = [XLTUserManager shareManager].curUserInfo.invite_link_code;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功！"];
}
- (IBAction)vipOderClick:(id)sender {
    if (self.pushVipOderVCBlock) {
        self.pushVipOderVCBlock();
    }
}
- (void)pushToVipVC{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)delegate.window.rootViewController;
    XLTVipVC *vc = [[XLTVipVC alloc] init];
    vc.needBack = YES;
    [nav pushViewController:vc animated:YES];
}
#pragma mark SrollerView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.adClickBlock) {
        self.adClickBlock([self.adModel by_ObjectAtIndex:index]);
    }
}
@end
