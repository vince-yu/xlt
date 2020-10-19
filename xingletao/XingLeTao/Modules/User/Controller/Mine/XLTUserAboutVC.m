//
//  XLTUserAboutVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserAboutVC.h"
#import "XLTSettingTableViewCell.h"
#import "XLTWKWebViewController.h"
#import "XLTCancelAccountVC.h"
#import "XLTCancelAccountFifthStepVC.h"

@interface XLTUserAboutVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *contentView;
@property (nonatomic ,strong) NSArray *dataDic;
@property (nonatomic ,strong) UIImageView *logoImageView;
@property (nonatomic ,strong) UILabel *versionLabel;
@end

@implementation XLTUserAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}
- (void)initSubView{
    self.title = @"关于星乐桃";
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.contentView];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(15);
        make.height.mas_equalTo(14);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(50);
        make.height.mas_equalTo(150);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];

    
}
#pragma mark Lazy
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.cornerRadius = 15;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.image = [UIImage imageNamed:@"xingletao_mine_icon"];
    }
    return _logoImageView;
}
- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.text = [NSString stringWithFormat:@"V%@",[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    }
    return _versionLabel;
}
- (NSArray *)dataDic{
    if (!_dataDic) {
        _dataDic = @[
                    @{
                        @"name" : @"版本更新",
                     @"value":@"有新版",
                     @"type":[NSNumber numberWithInt:0],
                    },
                    @{
                     @"name" : @"隐私协议",
                     @"type":[NSNumber numberWithInt:1],
                    },
                    @{
                     @"name" : @"账号注销",
                     @"type":[NSNumber numberWithInt:2],
                    }
        ];
    }
    return _dataDic;
}
- (UITableView *)contentView{
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        [_contentView registerNib: [UINib nibWithNibName:@"XLTSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTSettingTableViewCell"];
        _contentView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentView.separatorColor = [UIColor colorWithHex:0xededed];
        _contentView.backgroundView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    }
    return _contentView;
}
#pragma mark Action
- (void)pushToAppstroe{
    NSString *urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id/%@?mt=8",@"1488064629"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
- (void)pushToProtool {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTPrivacyProtocal;
    web.title = @"星乐桃平台隐私政策协议";
    [self.navigationController pushViewController:web animated:YES];
}

- (void)pushCancelAccountVC {
//    XLTCancelAccountFifthStepVC *vc = [[XLTCancelAccountFifthStepVC alloc] initWithNibName:@"XLTCancelAccountFifthStepVC" bundle:[NSBundle mainBundle]];
    XLTCancelAccountVC *vc = [[XLTCancelAccountVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self pushToAppstroe];
        }
            break;
        case 1:
        {
            [self pushToProtool];
        }
            break;
        case 2:{
            [self pushCancelAccountVC];
        }
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTSettingTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.moreIcon.hidden = NO;
    cell.valueLabel.hidden = YES;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataDic.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

@end
