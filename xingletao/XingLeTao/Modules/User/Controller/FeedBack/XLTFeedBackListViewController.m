//
//  XLTFeedBackListViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackListViewController.h"
#import "XLTFeedBackListCell.h"
#import "XLTFeedBackLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTFeedBackViewController.h"
#import "XLTFeedBackReplyViewController.h"

@interface XLTFeedBackListViewController ()

@end

@implementation XLTFeedBackListViewController


#define kFeedBackButtonHeight 44.0
#define kFeedBackButtonBottom 22.0
#define kFeedBackButtonTop 12.0
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问题反馈";
    self.view.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    self.contentTableView.backgroundColor = [UIColor letaolightgreyBgSkinColor];

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    self.contentTableView.frame = CGRectMake(15, 0, self.view.bounds.size.width -30, self.view.bounds.size.height - safeAreaInsetsBottom - (kFeedBackButtonHeight + kFeedBackButtonBottom + kFeedBackButtonTop));
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.estimatedRowHeight = 100;
    self.contentTableView.estimatedSectionHeaderHeight = 0;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    [self loadContentTableViewHeader];
    [self loadFeedBackButton];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
        if ([self.popParameters isKindOfClass:[NSDictionary class]]) {
        NSString *triggerRefresh = self.popParameters[@"triggerRefresh"];
        if ([triggerRefresh isKindOfClass:[NSString class]]) {
            [self letaoTriggerRefresh];
        }
    }
    self.popParameters = nil;
}

- (void)letaoShowEmptyView {
    [super letaoShowEmptyView];
    self.letaoEmptyCoverView.titleStr = @"您还没有反馈记录哦～";
    self.letaoEmptyCoverView.image = [UIImage imageNamed:@"xingletao_order_empty"];
//    self.letaoEmptyCoverView.contentViewOffset = - 80;
}


// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells {
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTFeedBackListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTFeedBackListCell"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.letaoPageDataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTFeedBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTFeedBackListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateDataInfo:self.letaoPageDataArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.letaoPageDataArray[indexPath.section];
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *feedId = info[@"_id"];
        XLTFeedBackReplyViewController *detailViewController = [[XLTFeedBackReplyViewController alloc] init];
        detailViewController.feedId = feedId;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                            failed:(XLTBaseListRequestFailed)failed {
    [XLTFeedBackLogic requestFeedBackListDataForIndex:index pageSize:pageSize success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        success(feedArray);
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
         failed(nil,errorMsg);
    }];
}


- (void)loadContentTableViewHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentTableView.bounds.size.width, 50)];
    header.backgroundColor = [UIColor clearColor];
    self.contentTableView.tableHeaderView = header;
    
    UIView *line = [UIView new];
    line.layer.cornerRadius = 1.0;
    line.layer.masksToBounds = YES;
    UIColor *textColor = [UIColor colorWithHex:0xFF25282D];
    line.backgroundColor = textColor;
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.mas_equalTo(header);
        make.height.equalTo(@15);
        make.width.equalTo(@3);
    }];
    
    
    UILabel *label = [UILabel new];
    [header addSubview:label];
    label.text = @"反馈记录";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont letaoMediumBoldFontWithSize:15];
    label.textColor = textColor;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(3);
        make.centerY.mas_equalTo(header);
    }];
    
}


- (void)loadFeedBackButton {
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    UIButton *feedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    feedBackButton.backgroundColor = [UIColor letaomainColorSkinColor];
    [feedBackButton setTitle:@" 我要反馈" forState:UIControlStateNormal];
    [feedBackButton setImage:[UIImage imageNamed:@"feedback_edit"] forState:UIControlStateNormal];
    feedBackButton.titleLabel.font = [UIFont letaoRegularFontWithSize:15];
    [feedBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedBackButton addTarget:self action:@selector(feedBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    feedBackButton.layer.masksToBounds =  YES;
    feedBackButton.layer.cornerRadius = kFeedBackButtonHeight/2.0;
    [self.view addSubview:feedBackButton];
    [feedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.mas_equalTo(self.contentTableView.mas_bottom).offset(kFeedBackButtonTop);
        make.height.equalTo(@kFeedBackButtonHeight);
    }];
}

- (void)feedBackButtonAction {
    XLTFeedBackViewController *feedBackViewController = [[XLTFeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedBackViewController animated:YES];
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
