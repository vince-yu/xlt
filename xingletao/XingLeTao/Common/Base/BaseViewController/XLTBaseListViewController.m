//
//  XLTBaseListViewController.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTBaseListViewController.h"
#import "MJRefresh.h"
#import "LetaoEmptyCoverView.h"

@interface XLTBaseListViewController ()

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;
@property (nonatomic, assign) BOOL letaoIsLoadingState;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@end

@implementation XLTBaseListViewController

#define kPageSize 10
#define kTheFirstPageIndex 1

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoPageDataArray = [NSMutableArray array];
        self.contentTableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loadingViewBgColor = self.view.backgroundColor;
    [self loadContentTableView];
    _currentPageIndex =  [self theFirstPageIndex];
    [self requestFristPageData];
}

- (void)loadContentTableView {
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.contentTableViewStyle];
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentTableView.sectionFooterHeight = 0;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.estimatedRowHeight = 0;
    _contentTableView.estimatedSectionHeaderHeight = 0;
    _contentTableView.estimatedSectionFooterHeight = 0;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self registerTableViewCells];
    [self letaoSetupRefreshHeader];
    _contentTableView.mj_header = _letaoRefreshHeader;
    
    [self letaoSetupRefreshAutoFooter];
    _contentTableView.mj_footer = _letaoRefreshAutoFooter;
    // 首次隐藏
    _contentTableView.mj_footer.hidden = YES;
    
    [self.view addSubview:_contentTableView];
}

- (void)registerTableViewCells {
    
}

- (void)letaoSetupRefreshHeader {
    if (_letaoRefreshHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf letaoTriggerRefresh];
        }];
    }
}

- (void)letaoSetupRefreshAutoFooter {
    if (_letaoRefreshAutoFooter == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf letaoTriggerLoadMore];
        }];
        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 5.0;
        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
    }
}
- (void)letaoTriggerRefresh {
    if (_letaoIsLoadingState) {
        return;
    }
    _letaoIsLoadingState = YES;
    [self requestFristPageData];
}

- (void)letaoTriggerLoadMore {
    if(_letaoIsLoadingState) {
        return ;
    }
    _letaoIsLoadingState = YES;
    [self requestNextPageData];
}

- (void)letaoStopRefreshState {
    [_letaoRefreshHeader endRefreshing];
    _letaoIsLoadingState = NO;
}

- (void)letaoStopLoadMoreState {
    [_letaoRefreshAutoFooter endRefreshing];
    _letaoIsLoadingState = NO;
}

- (void)letaoStopLoadMoreStateWithNoMoreData {
    [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    _letaoIsLoadingState = NO;
}



- (NSInteger)pageSize {
    return kPageSize;
}

- (NSInteger)theFirstPageIndex {
    return kTheFirstPageIndex;
}

- (NSInteger)miniPageSizeForMoreData {
    return 1;
}

- (void)requestFristPageData {
    NSInteger requestIndex = [self theFirstPageIndex];
    if (self.letaoPageDataArray.count == 0) {
        [self letaoShowLoading];
        [self letaoRemoveEmptyView];
    }
    [self letaoFetchPageDataForIndex:requestIndex pageSize:self.pageSize];
}

- (void)requestNextPageData {
    NSInteger requestIndex = _currentPageIndex +1;
    [self letaoFetchPageDataForIndex:requestIndex pageSize:self.pageSize];
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize {
    __weak __typeof(self)weakSelf = self;
    [self letaoFetchPageDataForIndex:index pageSize:pageSize success:^(NSArray * _Nullable letaoPageDataArray) {
        [weakSelf receivedDataSuccess:letaoPageDataArray andIndex:index];
    } failed:^(NSError * _Nullable error, NSString * _Nullable tipMessage) {
        [weakSelf receivedDataError:error tipMessage:tipMessage];
    }];
}

// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                        failed:(XLTBaseListRequestFailed)failed{
    
}

- (void)receivedDataError:(NSError * _Nullable)error tipMessage:(NSString * _Nullable)tipMessage {
    [self letaoRemoveMJLoadingsStatus];
    [self letaoRemoveLoading];
    if (self.letaoPageDataArray.count == 0) {
        [self letaoShowErrorView];
    } else {
        [self letaoRemoveErrorView];
    }
    if ([tipMessage isKindOfClass:[NSString class]] && tipMessage.length > 0){
        [self showTipMessage:tipMessage];
    } else {
        [self showTipMessage:NetWork_NotReachable];
    }
}

- (void)receivedDataSuccess:(NSArray *)letaoPageDataArray andIndex:(NSInteger)index {
    if (index == [self theFirstPageIndex]) {
        [self refreshContentTableViewUseData:letaoPageDataArray];
    } else {
        [self addMoreContentTableViewUseData:letaoPageDataArray];
    }
    
    [self letaoRemoveLoading];
    [self letaoRemoveErrorView];
    
    [self letaoStopRefreshState];
    if (self.letaoPageDataArray.count > 0) {
        [self letaoRemoveEmptyView];
        if(letaoPageDataArray.count < [self miniPageSizeForMoreData]) {
            [self letaoStopLoadMoreStateWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.contentTableView.mj_insetT + self.contentTableView.mj_contentH <= self.contentTableView.mj_h) {
                    self.contentTableView.mj_footer.hidden =  (self.letaoPageDataArray.count == 0);
                    [self letaoStopLoadMoreState];
                    [self.letaoRefreshAutoFooter beginRefreshing];
                } else {
                    [self letaoStopLoadMoreState];
                }
            });
        }
    } else {
        [self letaoShowEmptyView];
        [self letaoStopLoadMoreState];
    }
    
    // 没有数据的时候隐藏mj_footer
    self.contentTableView.mj_footer.hidden =  (self.letaoPageDataArray.count == 0);
    
    self.currentPageIndex = index;
}

// 刷新操作，更新UITableView
- (void)refreshContentTableViewUseData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]]) {
        [self.letaoPageDataArray setArray:letaoPageDataArray];
        [_contentTableView reloadData];
    }
}

// 更多操作，更新UITableView
- (void)addMoreContentTableViewUseData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        [self.letaoPageDataArray addObjectsFromArray:letaoPageDataArray];
        [_contentTableView reloadData];
    }
}

// clear letaoPageDataArray and reload contentTableView data
- (void)clearPageData {
    [self.letaoPageDataArray removeAllObjects];
    [_contentTableView reloadData];
    self.contentTableView.mj_footer.hidden = YES;
    self.currentPageIndex = [self theFirstPageIndex];
}


- (void)letaoRemoveMJLoadingsStatus {
    [self letaoStopRefreshState];
    [self letaoStopLoadMoreState];
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
    [self.contentTableView addSubview:self.letaoEmptyCoverView];
}

- (void)letaoRemoveEmptyView {
    [self.letaoEmptyCoverView removeFromSuperview];
}

- (void)letaoShowErrorView {
    if (self.letaoErrorView == nil) {
        __weak typeof(self)weakSelf = self;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xinletao_page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf letaoRemoveErrorView];
                                                                  [weakSelf requestFristPageData];
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 28.f;
        letaoEmptyCoverView.contentViewOffset = - 50;
        
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:14.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        letaoEmptyCoverView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnHeight = 40.f;
        letaoEmptyCoverView.actionBtnHorizontalMargin = 62.f;
        letaoEmptyCoverView.actionBtnCornerRadius = 20.f;
        letaoEmptyCoverView.actionBtnBorderColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnBorderWidth = 0.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.letaoErrorView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoErrorView];
}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
