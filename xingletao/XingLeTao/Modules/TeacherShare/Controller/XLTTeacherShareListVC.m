//
//  XLTTeacherShareListVC.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareListVC.h"
#import "XLTTeacherShareListCell.h"
#import "XLTTeacherShareLogic.h"
#import "XLTCustomSheetVC.h"
#import "NSArray+Bounds.h"
#import "MJRefresh.h"
#import "XLTCustomOnlyTitleAlterView.h"
#import "XLTTeachShareWebVC.h"
#import "XLTRepoDataManager.h"

@interface XLTTeacherShareListVC ()<XLTTeacherShareListCellDelegate>
@property (nonatomic ,strong) UIButton *createBtn;
@end

@implementation XLTTeacherShareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTableView.frame = CGRectMake(0, 0, kScreenWidth, self.view.height);
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
    self.contentTableView.showsVerticalScrollIndicator = NO;
    if (!self.status) {
        [self.view addSubview:self.createBtn];
        [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
            make.width.mas_equalTo(62);
            make.height.mas_equalTo(62);
        }];
    }
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
}
- (UIButton *)createBtn{
    if (!_createBtn) {
        _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createBtn setImage:[UIImage imageNamed:@"xlt_ts_add"] forState:UIControlStateNormal];
        [_createBtn addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
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
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                        failed:(XLTBaseListRequestFailed)failed{
    [XLTTeacherShareLogic getTutorShareListFromMineWithStatus:self.status index:[NSString stringWithFormat:@"%ld",(long)index] page:[NSString stringWithFormat:@"%ld",(long)pageSize] success:^(id  _Nonnull object) {
        if (self.status.intValue == 2) {
            [self updateCellStatus:object index:index pageSize:pageSize];
        }
        success(object);
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];
}
- (void)updateCellStatus:(NSArray *)array index:(NSInteger )index pageSize:(NSInteger )pageSize{
    if (!array.count) {
        return;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLTTeacherShareListModel *model = obj;
        
        if (!model.is_top.boolValue) {
            [tempArray addObject:model];
            model.indexType = XLTTeacherShareIndexTypeNomal;
        }
        
    }];
    NSInteger count = array.count;
    NSInteger tempCount = tempArray.count;
    if (index == 1) {
        XLTTeacherShareListModel *lastmodel = tempArray.lastObject;
        XLTTeacherShareListModel *firstModel = tempArray.firstObject;
        if (count < pageSize) {
            if (tempCount == 1) {
                firstModel.indexType = XLTTeacherShareIndexTypeNone;
            }else{
                firstModel.indexType = XLTTeacherShareIndexTypeFirst;
                lastmodel.indexType = XLTTeacherShareIndexTypeLast;
            }
        }else{
            firstModel.indexType = XLTTeacherShareIndexTypeFirst;
        }
    }else{
        if (count < pageSize) {
            XLTTeacherShareListModel *lastmodel = tempArray.lastObject;
            lastmodel.indexType = XLTTeacherShareIndexTypeLast;
        }
    }
}
- (NSInteger)miniPageSizeForMoreData {
    return self.pageSize;
}
- (NSInteger)pageSize {
    return 20;
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTTeacherShareListModel *orderListModel = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.section];
    if (orderListModel.url) {
        XLTTeachShareWebVC *vc = [[XLTTeachShareWebVC alloc] init];
        vc.jump_URL = orderListModel.url;
        vc.showCloseBtn = YES;
        [self.letaoNav pushViewController:vc animated:YES];
    }
    [[XLTRepoDataManager shareManager] umeng_repoEvent:@"tutor_share_detail" params:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTTeacherShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTTeacherShareListCell" forIndexPath:indexPath];
    XLTTeacherShareListModel *orderListModel = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.section];
    orderListModel.type = self.type;
    cell.model = orderListModel;
    cell.delegate = self;
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
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
    return [UIView new];
}
#pragma mark XLTTeacherShareListCellDelegate
- (void)setShowWithModel:(XLTTeacherShareListModel *_Nullable)listModel{
    [self showSheetView:listModel];
}
- (void)setTopWithModel:(XLTTeacherShareListModel * _Nullable)listModel{
    [self showSheetView:listModel];
}
- (void)moveWithModel:(XLTTeacherShareListModel * _Nullable)listModel isUp:(BOOL )up{
    [self moveActionWithModel:listModel isUp:up];
}
#pragma mark Action
- (void)createAction:(NSString *)listID{
    XLTTeachShareWebVC *vc = [[XLTTeachShareWebVC alloc] init];
    if ([listID isKindOfClass:[NSString class]] && listID.length) {
        
        vc.jump_URL = [NSString stringWithFormat:@"%@%@?share_id=%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202009tutor/index.html",listID];
    }else{
        vc.jump_URL = [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202009tutor/index.html"];
    }
    
    vc.fullScreen = YES;
//    vc.containerVC = self;
    [self.letaoNav pushViewController:vc animated:YES];
    
    [[XLTRepoDataManager shareManager] umeng_repoEvent:@"tutor_share_create" params:nil];
}
- (void)showSheetView:(XLTTeacherShareListModel *)model{
    XLTCustomSheetVC *vc = [[XLTCustomSheetVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.navigationController.definesPresentationContext = YES;
    if (model.type == XLTTeacherShareCellTypeMeAll) {
        if (model.status.intValue == 2) {
            vc.titleStr = @"取消展示";
            vc.sureBtnTitle = @"删除";
        }else{
            vc.titleStr = @"展示";
            vc.sureBtnTitle = @"删除";
        }
    }else if (model.type == XLTTeacherShareCellTypeMeShow) {
        if (model.is_top.boolValue == 1) {
            vc.sureBtnTitle = @"取消置顶";
            
        }else{
            vc.sureBtnTitle = @"置顶";
            
        }
        vc.titleStr = @"取消展示";
    }
    vc.eidtStr = @"编辑";
    vc.canEdit = YES;
    XLT_WeakSelf;
    vc.sureBlock = ^{
        XLT_StrongSelf
        [self showAlterView:model index:1];
    };
    vc.titleBlock = ^{
        XLT_StrongSelf
        [self showAlterView:model index:2];
    };
    vc.editBlock = ^{
        XLT_StrongSelf
        [self createAction:model.idField];
    };
    [self.letaoNav presentViewController:vc animated:YES completion:^{
//        vc.bgView.hidden = NO;
        
    }];
}
- (void)showAlterView:(XLTTeacherShareListModel *)model index:(NSInteger )index{
    XLT_WeakSelf;
    NSString *title = nil;
    if ((model.type == XLTTeacherShareCellTypeMeAll)) {
        if (index == 1) {
            if (model.status.intValue == 2) {
                title = [NSString stringWithFormat:@"是否取消展示\n%@",model.title];
            }else{
                title = [NSString stringWithFormat:@"是否展示\n%@",model.title];
            }
        }else{
            title = [NSString stringWithFormat:@"是否删除\n%@",model.title];
        }
        
    }else if (model.type == XLTTeacherShareCellTypeMeShow) {
        if (index == 1) {
            title = [NSString stringWithFormat:@"是否取消展示\n%@",model.title];
        }else{
            if (model.is_top.boolValue == 1) {
                title = [NSString stringWithFormat:@"取消置顶\n%@",model.title];
            }else{
                title = [NSString stringWithFormat:@"置顶\n%@",model.title];
            }
        }
        
    }
    [XLTCustomOnlyTitleAlterView showNamalAlterWithTitle:title content:@"" leftBlock:^{
        } rightBlock:^{
            XLT_StrongSelf
            if (model.type == XLTTeacherShareCellTypeMeAll) {
                if (index == 1) {
                    [self setShowActionWithModel:model delete:NO];
                }else{
                    [self setShowActionWithModel:model delete:YES];
                }
                
            }else if (model.type == XLTTeacherShareCellTypeMeShow){
                if (index == 1) {
                    
                    [self setShowActionWithModel:model delete:NO];
                }else{
                    [self setTopActionWithModel:model];
                }
                
            }
        }];
}
- (void)setTopActionWithModel:(XLTTeacherShareListModel *)model{
    NSNumber *type = [NSNumber numberWithInt:!model.is_top.boolValue];
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTTeacherShareLogic setTeacherShareTopWith:model.idField status:type success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        if (type.boolValue == 1) {
            [self showTipMessage:@"置顶成功"];
        }else{
            [self showTipMessage:@"取消置顶成功"];
        }
        [self letaoTriggerRefresh];
        
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
- (void)setShowActionWithModel:(XLTTeacherShareListModel *)model delete:(BOOL )delete{
    NSNumber *type = model.status.intValue == 2 ? @1 : @2;
    if (delete) {
        type = @-1;
    }
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTTeacherShareLogic setTeacherShareShowWith:model.idField status:type success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        if (type.intValue == 2) {
            [self showTipMessage:@"展示成功"];
        }else if (type.intValue == 1){
            [self showTipMessage:@"取消展示成功"];
        }else if (type.intValue == -1){
            [self showTipMessage:@"删除成功"];
        }
        [self.containVC allRefresh];
        
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
- (void)moveActionWithModel:(XLTTeacherShareListModel *)model isUp:(BOOL )up{
    NSNumber *type = up ? @1 : @2;
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTTeacherShareLogic moveTeacherShareSortWith:model.idField status:type success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        if (type.intValue == 1) {
            [self showTipMessage:@"上移成功"];
        }else{
            [self showTipMessage:@"下移成功"];
        }
        [self letaoTriggerRefresh];
        
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
@end
