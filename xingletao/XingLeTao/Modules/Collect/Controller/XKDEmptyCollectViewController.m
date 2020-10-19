//
//  XKDEmptyCollectViewController.m
//  XingKouDai
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XKDEmptyCollectViewController.h"
#import "XKDGoodDetailLogic.h"
#import "XKDEmptyView.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XKDEmptyCollectCell.h"
#import "XKDHomeCategoryItemCell.h"
#import "XKDGoodDetailViewController.h"
#import "MJRefreshNormalHeader.h"

@interface XKDEmptyCollectViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, XKDEmptyCollectCellDelegate>
@property (nonatomic, strong) XKDGoodDetailLogic *detailLogic;
@property (nonatomic, strong) XKDEmptyView *retryView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshAutoNormalFooter;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshNormalHeader;

@end

@implementation XKDEmptyCollectViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self loadContentCollectionView];
    [self requestGuessYouLikeGoodsData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self xkd_hiddenNavigationBar:YES];
}

- (void)loadContentCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self initRefreshAutoNormalFooter];
    [_refreshAutoNormalFooter endRefreshingWithNoMoreData];
    _collectionView.mj_footer = _refreshAutoNormalFooter;
    _collectionView.mj_footer.hidden = YES;
    
    [self initRefreshNormalHeader];
    _collectionView.mj_header = _refreshNormalHeader;
    
    [self registerCells];
    [self.view addSubview:_collectionView];
}

- (void)initRefreshAutoNormalFooter {
    if (_refreshAutoNormalFooter == nil) {
        _refreshAutoNormalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        }];
    }
}



- (void)initRefreshNormalHeader {
    if (_refreshNormalHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _refreshNormalHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf triggerRefresh];
        }];
    }
}


- (void)triggerRefresh {
    // tell parent
}

- (void)requestGuessYouLikeGoodsData {
    [self showLoadingView];
    if (self.detailLogic == nil) {
        self.detailLogic = [[XKDGoodDetailLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    [self.detailLogic guessYouLikeGoodsDataSuccess:^(NSArray * _Nonnull goodsArray) {
        weakSelf.dataArray = goodsArray;
        [weakSelf removeLoadingView];
        [weakSelf.collectionView reloadData];
         
        weakSelf.refreshAutoNormalFooter.hidden = (goodsArray.count == 0);
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing
        [weakSelf showTipMessage:errorMsg];
        [weakSelf removeLoadingView];
    }];
}

- (void)showLoadingView {
//    self.loadingViewBgColor = [UIColor whiteColor];
//    [super showLoadingView];
}

- (void)showRetryView {
    if (self.retryView == nil) {
        __weak typeof(self)weakSelf = self;
        XKDEmptyView *emptyView = [XKDEmptyView emptyActionViewWithImageStr:@"page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf removeRetryView];
                                                                  [weakSelf requestGuessYouLikeGoodsData];
                                                              }];
        emptyView.emptyViewIsCompleteCoverSuperView = YES;
        emptyView.subViewMargin = 28.f;
        emptyView.contentViewOffset = - 50;
        
        emptyView.titleLabFont = [UIFont systemFontOfSize:14.f];
        emptyView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        emptyView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        emptyView.actionBtnTitleColor = [UIColor xkd_mainColorSkinColor];
        emptyView.actionBtnHeight = 40.f;
        emptyView.actionBtnHorizontalMargin = 62.f;
        emptyView.actionBtnCornerRadius = 2.f;
        emptyView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
        emptyView.actionBtnBorderWidth = 0.5;
        emptyView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.retryView = emptyView;
    }
    [self.view addSubview:self.retryView];
}

- (void)removeRetryView {
    [self.retryView removeFromSuperview];
}

#pragma mark - collectionView

- (void)registerCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XKDHomeCategoryItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XKDHomeCategoryItemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XKDEmptyCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XKDEmptyCollectCell"];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XKDEmptyCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKDEmptyCollectCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else {
        XKDHomeCategoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKDHomeCategoryItemCell" forIndexPath:indexPath];
        [cell updateCellData:self.dataArray[indexPath.row]];
        return cell;
    }

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         return CGSizeMake(collectionView.bounds.size.width, 209);
    } else {
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat height = kScreen_iPhone375Scale(340) - offset;
        return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
    }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(0, 10, 15, 10);
    }
   
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.dataArray[indexPath.row];
    NSString *goodsId = itemInfo[@"_id"];
    NSString *storeId = itemInfo[@"seller_shop_id"];
    XKDGoodDetailViewController *goodDetailViewController = [[XKDGoodDetailViewController alloc] init];
    goodDetailViewController.goodsId = goodsId;
    goodDetailViewController.storeId = storeId;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];

}

- (void)emptyCollectCell:(XKDEmptyCollectCell *)cell goHomeAction:(id)sender {
    self.tabBarController.selectedIndex = 0;
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
