//
//  XLTContactMentorVC.m
//  XingLeTao
//
//  Created by vince on 2020/2/14.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTContactMentorVC.h"
#import "XLTUserManager.h"

@interface XLTContactMentorVC ()
@property (nonatomic ,strong) UIScrollView *contentView;
@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIImageView *codeImageView;
@property (nonatomic ,strong) UILabel *describeLabel;
@property (nonatomic ,strong) UIButton *sureBtn;

@property (nonatomic ,strong) UIButton *saveQRBtn;

@property (nonatomic ,strong) UIImageView *titleBgView;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIImageView *avatorImageView;
@property (nonatomic ,strong) UILabel *metorLabel;
@property (nonatomic ,strong) UILabel *tipLabel;
@end

@implementation XLTContactMentorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    NSString *metor = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;
    if (metor.length) {
        self.metorLabel.text = [NSString stringWithFormat:@"导师微信：%@",metor];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
}
- (void)initSubView{
    self.title = @"联系导师";
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view);
    }];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.codeImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.metorLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.titleBgView];
    [self.contentView addSubview:self.saveQRBtn];
    
    CGSize size = [self.titleLabel.text sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(kScreenWidth - 30, 500)];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenWidth - 30);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(size.height + 5);
    }];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(35);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(125);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.codeImageView);
    }];
    
    [self.saveQRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(130);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saveQRBtn.mas_bottom).offset(34);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(38);
        make.right.mas_equalTo(-38);
    }];
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(105);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBgView.mas_bottom).offset(15);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.metorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorImageView.mas_bottom).offset(14);
        make.centerX.equalTo(self.codeImageView);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.metorLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.codeImageView);
    }];
    
    [self.contentView addSubview:self.sureBtn];
    if (kScreenHeight <= 667) {
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(50).priorityLow();
            make.bottom.equalTo(self.contentView).offset(-50);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(45);
        }];
    }else{
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-50);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(45);
        }];
    }
    
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xDEDEDE];
    }
    return _lineView;
}
- (UIImageView *)titleBgView{
    if (!_titleBgView) {
        _titleBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_mentor_bg"]];
        
    }
    return _titleBgView;
}
- (UIImageView *)avatorImageView{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.cornerRadius = 30;
        _avatorImageView.clipsToBounds = YES;
        [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:[XLTUserManager shareManager].curUserInfo.tutor_inviter_avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    }
    return _avatorImageView;;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _contentView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHex:0x25282D];
        _titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"添加导师，一对一教学，升级，订单，返利，所有问题一并解决，星乐桃导师助你站在风口，拥抱财富。";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)codeImageView{
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xlt_metor_code"]];
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
        press.minimumPressDuration = 1;
        _codeImageView.userInteractionEnabled = YES;
        [_codeImageView addGestureRecognizer:press];
    }
    return _codeImageView;
}
- (UILabel *)metorLabel{
    if (!_metorLabel) {
        _metorLabel = [[UILabel alloc] init];
        _metorLabel.textColor = [UIColor colorWithHex:0x25282D];
        _metorLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _metorLabel.text = [NSString stringWithFormat:@"导师微信：--"];
    }
    return _metorLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor colorWithHex:0xAEAEAE];
        _tipLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _tipLabel.text = @"请勿重复添加";
    }
    return _tipLabel;
}
- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.text = @"扫码添加星乐桃官方公众号";
        _describeLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _describeLabel.textColor = [UIColor colorWithHex:0xAEAEAE];
    }
    return _describeLabel;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"复制去微信加好友" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(updateWXAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
        _sureBtn.layer.cornerRadius = 22.5;
    }
    return _sureBtn;
}
- (UIButton *)saveQRBtn{
    if (!_saveQRBtn) {
        _saveQRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveQRBtn setTitle:@"保存二维码" forState:UIControlStateNormal];
        [_saveQRBtn setTitleColor:[UIColor colorWithHex:0x26282E] forState:UIControlStateNormal];
        [_saveQRBtn addTarget:self action:@selector(saveQRAction) forControlEvents:UIControlEventTouchUpInside];
        _saveQRBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:14];
        _saveQRBtn.layer.cornerRadius = 8;
        _saveQRBtn.layer.borderWidth = 0.5;
        _saveQRBtn.layer.borderColor = [UIColor colorWithHex:0xE8E6E6].CGColor;
    }
    return _saveQRBtn;
}
- (void)handlePress:(UIGestureRecognizer *)gester{
    if (gester.state == UIGestureRecognizerStateBegan) {
        [self saveQRAction];
    }else{
        
    }
}
- (void)saveQRAction{
    UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)updateWXAction{
    NSString *mentor = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;
    if (mentor.length) {
        [UIPasteboard generalPasteboard].string = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
    }
    
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存失败" ;
    }else{
        msg = @"图片已保存到相册" ;
    }
    [self showTipMessage:msg];
}
@end
