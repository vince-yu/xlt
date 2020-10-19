//
//  XLTActivityVC.m
//  XingLeTao
//
//  Created by SNQU on 2020/4/23.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTActivityVC.h"
#import "XLTHomePageLogic.h"
#import "XLTActivityModel.h"
#import "LetaoEmptyCoverView.h"
#import "XLTWKWebViewController.h"
#import "XLTAliManager.h"
#import "XLTJingDongManager.h"
#import "XLTPDDManager.h"
#import "XLTWPHManager.h"
#import "XLTUserManager.h"
#import "XLTAdManager.h"
#import "XLTAdManager.h"
#import "XLTGoodsDetailLogic.h"
#import "XLTALiTradeWebViewController.h"
#import "XLTAliManager.h"

@interface XLTActivityVC ()
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *headerBgView;

@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIView *arcView;
@property (nonatomic ,strong) UIView *contentView;

//content
@property (nonatomic ,strong) UIButton *goActivityBtn;
@property (nonatomic ,strong) UIButton *storeBtn;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UIView *labelBgView;

@property (nonatomic ,strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic ,strong) XLTActivityModel *model;
@property (nonatomic ,strong) XLTActivityLinkModel *linkModel;
@end

@implementation XLTActivityVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAction) name:kXLTAuthTaoBaoCompleteNotificationName object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerBgView];
    [self.scrollView addSubview:self.bottomView];
    [self.bottomView addSubview:self.arcView];
    [self.bottomView addSubview:self.contentView];
    
    [self.contentView addSubview:self.goActivityBtn];
    [self.contentView addSubview:self.storeBtn];
    [self.contentView addSubview:self.labelBgView];
    [self.labelBgView addSubview:self.contentLabel];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kScreenHeight - kTopHeight);
    }];
    [self.headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(200);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.headerBgView.mas_bottom).offset(-40);
        make.height.mas_equalTo(500);
    }];
    [self.arcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(33);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.arcView.mas_bottom);
    }];
    [self.goActivityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(45);
    }];

    [self.storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goActivityBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(45);
    }];

    [self.labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.equalTo(self.storeBtn.mas_bottom).offset(25);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(25);
        make.bottom.mas_equalTo(-25);
    }];
    
    [self requestAction];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.scrollView.hidden = YES;
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
}

#pragma mark Action
- (void)requestAction{
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTHomePageLogic xingletaonetwork_requestActivityCode:self.acCode success:^(XLTActivityModel *model) {
        XLT_StrongSelf;
        NSArray *link_type = model.link_type;
        NSString *link_url = model.link_url;
        NSString *tid = model.tid;
        NSString *platform = model.platform;
        self.model = model;
        [self requestLinkModel:link_url link_type:link_type tid:tid item_source:platform];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
    }];
}

- (void)requestLinkModel:(NSString *)link link_type:(NSArray *)link_type tid:(NSString *)tid item_source:(NSString *)item_source {
    NSString *needTkl = @"";
    if ([self.model.platform isEqualToString:XLTTaobaoPlatformIndicate] || [self.model.platform isEqualToString:XLTTianmaoPlatformIndicate]) {
        needTkl = @"1";
    }
    XLT_WeakSelf;
    [[XLTAdManager shareManager] xingletaonetwork_requestAdActivityWithUrl:link link_type:link_type tid:tid item_source:item_source success:^(NSDictionary * _Nonnull adInfo) {
        XLTActivityLinkModel *linkModel = [XLTActivityLinkModel modelWithDictionary:adInfo];
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        self.linkModel = linkModel;
        [self reloadView];

    } failure:^(NSString *errorMsg, NSString * _Nullable authUrl,XLTBaseModel *model) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self reloadView];
        if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
            [[XLTAliManager shareManager] openAliTrandPageWithURLString:authUrl sourceController:self authorized:NO];
        }if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]){
            [[XLTPDDManager shareManager] openPDDPageWithURLString:authUrl sourceController:self close:YES];
        } else {
            // do noting
        }
    }];
}

- (void)letaoShowEmptyView {
    if (self.letaoEmptyCoverView == nil) {
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无数据"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];
    self.scrollView.hidden = YES;
}
- (void)defultColor{
    self.contentView.backgroundColor =self.arcView.backgroundColor = [UIColor colorWithHex:0xFE4F4E];
    self.goActivityBtn.backgroundColor = [UIColor colorWithHex:0xFDEBCE];
    self.storeBtn.backgroundColor = [UIColor colorWithHex:0xFDEBCE];
    NSString *str = @"男装打折，4件5折，限今日抢购\n抢购地址：http://218.6.242.42:9002/secure/RapidBoard.jspa?rapidView=21&projectKey=XKD&view=planning&selectedIssue=XKD-3585";
    self.contentLabel.text = str;
    CGSize size = [str sizeWithFont:[UIFont fontWithName:kSDPFBoldFont size:13] maxSize:CGSizeMake(kScreenWidth - 60, 1000)];
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height + 10);
    }];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
}
- (void)reloadView{
    if (!self.model) {
        [self letaoShowEmptyView];
        return;
    }
    self.scrollView.hidden = NO;
    self.title = self.model.name;
    if (self.model.style) {
        self.scrollView.backgroundColor = self.contentView.backgroundColor = self.arcView.backgroundColor = [UIColor colorWithHexString:[self hexColorStr:self.model.style.bgcolor]];
        [self.headerBgView sd_setImageWithURL:[NSURL URLWithString:self.model.style.bgImage_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat imageHeight = 200;
            if (image) {
                imageHeight = image.size.height / image.size.width * kScreenWidth;
                [self.headerBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(imageHeight);
                }];
               
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateContentSize:imageHeight];
            });
            
        }];
    }
    if ([self.model.button count]) {
        for (XLTActivityBtnModel *btnModel in self.model.button) {
            if (btnModel.type.intValue == 2) {
                [self.goActivityBtn setTitle:btnModel.name forState:UIControlStateNormal];
                self.goActivityBtn.backgroundColor = [UIColor colorWithHexString:[self hexColorStr:btnModel.bgColor]];
                [self.goActivityBtn setTitleColor:[UIColor colorWithHexString:[self hexColorStr:btnModel.color]] forState:UIControlStateNormal];
            }else if (btnModel.type.intValue == 1){
                [self.storeBtn setTitle:btnModel.name forState:UIControlStateNormal];
                self.storeBtn.backgroundColor = [UIColor colorWithHexString:[self hexColorStr:btnModel.bgColor]];
                [self.storeBtn setTitleColor:[UIColor colorWithHexString:[self hexColorStr:btnModel.color]] forState:UIControlStateNormal];
            }
        }
    }
    NSMutableString *content = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",self.model.content]];
    if ([self.model.platform isEqualToString:XLTTaobaoPlatformIndicate] || [self.model.platform isEqualToString:XLTTianmaoPlatformIndicate]) {
        [content appendString:@"\n\n复制口令进【掏宝】抢购："];

    }else{
        [content appendString:@"\n\n抢购地址："];
    }
    
    if (self.linkModel) {
        if ([self.model.platform isEqualToString:XLTTaobaoPlatformIndicate] || [self.model.platform isEqualToString:XLTTianmaoPlatformIndicate]) {
            NSString *tCode = self.linkModel.tCode;
            if([tCode isKindOfClass:[NSString class]] && tCode.length > 0) {
                [content appendString:tCode];
            }
        }else {
            NSString *click_url = self.linkModel.click_url;
            if([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                [content appendString:click_url];
            }
        }
    }
    self.contentLabel.text = content;
    [self.contentLabel sizeToFit];
    CGSize size = [content sizeWithFont:[UIFont fontWithName:kSDPFBoldFont size:13] maxSize:CGSizeMake(kScreenWidth - 80, 1000)];
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height + 30);
    }];
    [self.labelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height + 60);
    }];
    CGFloat contentHeight = 30 + 45 + 20 + 45 + 25 + 15 + size.height + 40 + 60;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(33 + contentHeight);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
//    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
}
- (void)updateContentSize:(CGFloat )imageHeight{
    CGSize size = [self.contentLabel.text sizeWithFont:[UIFont fontWithName:kSDPFBoldFont size:13] maxSize:CGSizeMake(kScreenWidth - 80, 1000)];
    CGFloat contentHeight = imageHeight + 33 + 30 + 45 + 20 + 45 + 25 + 15 + size.height + 40 + 60;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, contentHeight);
}
- (NSString *)hexColorStr:(NSString *)color{
    if (color.length > 6) {
        return [color substringWithRange:NSMakeRange(color.length - 6, 6)];
    }
    return color;
}


- (void)goActivityVC {
    if (![[XLTUserManager shareManager] isLogined]) { // 需要登录
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        NSNumber *has_bind_tb = [XLTUserManager shareManager].curUserInfo.has_bind_tb;
        BOOL isAliSource  = [self.model.platform isKindOfClass:[NSString class]] && ([self.model.platform isEqualToString:XLTTaobaoPlatformIndicate] || [self.model.platform isEqualToString:XLTTianmaoPlatformIndicate]);
        // 需要授权
        if (![has_bind_tb boolValue] && isAliSource) {
            [self xingletaonetwork_requestTaoBaoAuthWithSourceController:self];
        } else {
            if ([self.model.data isKindOfClass:[NSDictionary class]]) {
                [[XLTAdManager shareManager] adJumpWithInfo:self.model.data sourceController:self];
            }
        }
    }
}


- (void)storeAction {
    if (![[XLTUserManager shareManager] isLogined]) { // 需要登录
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        NSNumber *has_bind_tb = [XLTUserManager shareManager].curUserInfo.has_bind_tb;
        BOOL isAliSource  = [self.model.platform isKindOfClass:[NSString class]] && ([self.model.platform isEqualToString:XLTTaobaoPlatformIndicate] || [self.model.platform isEqualToString:XLTTianmaoPlatformIndicate]);

        // 需要授权
        if (![has_bind_tb boolValue] && isAliSource) {
            [self xingletaonetwork_requestTaoBaoAuthWithSourceController:self];
        } else {
            [UIPasteboard generalPasteboard].string = self.contentLabel.text;
            [self showTipMessage:@"复制成功!"];
        }
    }
}

- (void)jumpActionWith:(NSString *)plate url:(NSString *)url{
    if ([plate isEqualToString:XLTTaobaoPlatformIndicate] || [plate isEqualToString:XLTTianmaoPlatformIndicate]) {
       if (![[XLTUserManager shareManager].curUserInfo.has_bind_tb boolValue]) {
            [self xingletaonetwork_requestTaoBaoAuthWithSourceController:self];
        } else {
            [[XLTAliManager shareManager] openAliTrandPageWithURLString:url sourceController:self authorized:YES];
        }
    }else if ([plate isEqualToString:XLTPDDPlatformIndicate]) {
        [[XLTPDDManager shareManager] openPDDPageWithURLString:url sourceController:self close:NO];
    }else if ([plate isEqualToString:XLTJindongPlatformIndicate]) {
        [[XLTJingDongManager shareManager] openKeplerPageWithURL:url sourceController:self];
    }else if ([plate isEqualToString:XLTVPHPlatformIndicate]) {
        [[XLTWPHManager shareManager] openWPHPageWithNativeURLString:nil itemUrl:url sourceController:self];
    }
}
- (void)xingletaonetwork_requestTaoBaoAuthWithSourceController:(XLTBaseViewController *)
sourceController {
    [[XLTAliManager shareManager] xingletaonetwork_requestTaoBaoAuthUrlSuccess:^(NSString * _Nonnull authUrl, NSURLSessionDataTask * _Nonnull task) {
            [[XLTAliManager shareManager] openAliTrandPageWithURLString:authUrl sourceController:sourceController authorized:NO];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
            [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
    }];
}
#pragma mark Lazy
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
        _scrollView.bounces = NO;
        _scrollView.hidden = YES;
//        _scrollView.alwaysBounceHorizontal = NO;
//        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}
- (UIImageView *)headerBgView{
    if (!_headerBgView) {
        _headerBgView = [[UIImageView alloc] init];
        _headerBgView.backgroundColor = [UIColor whiteColor];
    }
    return _headerBgView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
- (UIView *)arcView{
    if (!_arcView) {
        _arcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:_arcView.frame];
        CGFloat rHeight = 33;
        CGFloat offset_w = 20;
        CGRect circleRect = CGRectMake(-offset_w, -rHeight, _arcView.size.width+offset_w*2, rHeight*2);
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];

        [rectPath appendPath:circlePath];

        CAShapeLayer *mask1 = [CAShapeLayer layer];

        mask1.frame = _arcView.bounds;

        mask1.backgroundColor = [UIColor clearColor].CGColor;

        mask1.fillColor = [UIColor blueColor].CGColor;

        mask1.path = rectPath.CGPath;

        mask1.fillRule = kCAFillRuleEvenOdd;

        _arcView.layer.mask = mask1;
    }
    return _arcView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] init];
        _labelBgView.backgroundColor = [UIColor whiteColor];
        _labelBgView.layer.cornerRadius = 6;
    }
    return _labelBgView;
}
- (UIButton *)goActivityBtn{
    if (!_goActivityBtn) {
        _goActivityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goActivityBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:18];
        [_goActivityBtn setTitle:@"前往活动" forState:UIControlStateNormal];
        _goActivityBtn.layer.cornerRadius = 22.5;
        [_goActivityBtn addTarget:self action:@selector(goActivityVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goActivityBtn;
}
- (UIButton *)storeBtn{
    if (!_storeBtn) {
        _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn setTitle:@"复制活动文案" forState:UIControlStateNormal];
        _storeBtn.layer.cornerRadius = 22.5;
        _storeBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:18];
        [_storeBtn addTarget:self action:@selector(storeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeBtn;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.font = [UIFont fontWithName:kSDPFBoldFont size:13];
    }
    return _contentLabel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
