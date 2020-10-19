//
//  XLTTeacherShareListVC.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareListForMeVC.h"
#import "XLTTeacherShareListCell.h"
#import "XLTTeacherShareLogic.h"
#import "XLTTeacherShareListModel.h"
#import "NSArray+Bounds.h"
#import "MJRefresh.h"
#import "XLTTeacherShareHeaderView.h"
#import "XLTTeachShareWebVC.h"

@interface XLTTeacherShareListForMeVC ()
@property (nonatomic ,strong) XLTTeacherShareHeaderView *headerView;
@end

@implementation XLTTeacherShareListForMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导师分享";
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(10);
    }];
    self.contentTableView.showsVerticalScrollIndicator = NO;
    
}
- (XLTTeacherShareHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XLTTeacherShareHeaderView alloc] initWithNib];
    }
    return _headerView;
}
- (void)dealloc{
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
    [[XLTRepoDataManager shareManager] umeng_repoEvent:@"tutor_share_view" params:nil];
}
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTTeacherShareListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTTeacherShareListCell"];
}

- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                        failed:(XLTBaseListRequestFailed)failed{
    [XLTTeacherShareLogic getTutorShareListWithIndex:[NSString stringWithFormat:@"%ld",(long)index] page:[NSString stringWithFormat:@"%ld",(long)pageSize] success:^(id  _Nonnull object) {
        success(object);
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];
}
- (NSInteger)miniPageSizeForMoreData {
    return self.pageSize;
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTTeacherShareListModel *orderListModel = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.section];
    if (orderListModel.url) {
        XLTTeachShareWebVC *vc = [[XLTTeachShareWebVC alloc] init];
//        vc.jump_URL = orderListModel.url;
        vc.jump_URL = @"https://www.youku.com/";
        vc.showCloseBtn = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [[XLTRepoDataManager shareManager] umeng_repoEvent:@"tutor_share_detail" params:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTTeacherShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTTeacherShareListCell" forIndexPath:indexPath];
    XLTTeacherShareListModel *orderListModel = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.section];
    orderListModel.type = XLTTeacherShareCellTypeNomal;
    cell.model = orderListModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return self.letaoPageDataArray.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 120;
    }
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.headerView;
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    
    return view;
}

@end
