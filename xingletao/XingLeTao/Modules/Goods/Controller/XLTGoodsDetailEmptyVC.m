//
//  XLTGoodsDetailEmptyVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailEmptyVC.h"
#import "XLTGoodsDetailLogic.h"
#import "LetaoEmptyCoverView.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTGoodsDetailEmptyCollectionViewCell.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"

@interface XLTGoodsDetailEmptyVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) XLTGoodsDetailLogic *letaoGoodsDetailLogic;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *letaoPageDataArray;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;

@end

@implementation XLTGoodsDetailEmptyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品未找到";
    [self letaoSetupContentCollectionView];
    [self requestGuessYouLikeGoodsData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}


- (void)letaoSetupContentCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoSetupRefreshAutoFooter];
    [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
    _collectionView.mj_footer.hidden = YES;
    [self letaoListRegisterCells];
    [self.view addSubview:_collectionView];
}

- (void)letaoSetupRefreshAutoFooter {
    if (_letaoRefreshAutoFooter == nil) {
        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        }];
        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 5.0;
        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
    }
}

- (void)requestGuessYouLikeGoodsData {
    [self letaoShowLoading];
    if (self.letaoGoodsDetailLogic == nil) {
        self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoGoodsDetailLogic xingletaonetwork_requestYouLikeGoodsDataSuccess:^(NSArray * _Nonnull goodsArray) {
        weakSelf.letaoPageDataArray = goodsArray;
        [weakSelf letaoRemoveLoading];
        [weakSelf.collectionView reloadData];
         
        weakSelf.letaoRefreshAutoFooter.hidden = (goodsArray.count == 0);
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
    }];
}

- (void)letaoShowLoading {
//    self.loadingViewBgColor = [UIColor whiteColor];
//    [super letaoShowLoading];
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
                                                                  [weakSelf requestGuessYouLikeGoodsData];
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
        //        letaoEmptyCoverView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
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

#pragma mark - collectionView

- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTGoodsDetailEmptyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTGoodsDetailEmptyCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTHomeCategoryGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTHomeCategoryGoodsCollectionViewCell"];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.letaoPageDataArray.count;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTGoodsDetailEmptyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTGoodsDetailEmptyCollectionViewCell" forIndexPath:indexPath];
        cell.letaoGuessLabel.hidden = (self.letaoPageDataArray.count == 0);
        return cell;
    } else {
        XLTHomeCategoryGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTHomeCategoryGoodsCollectionViewCell" forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:self.letaoPageDataArray[indexPath.row]];
        return cell;
    }

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         return CGSizeMake(collectionView.bounds.size.width, 257);
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
    if (section == 1) {
        return 10;
    }
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
    NSString *letaoGoodsId = itemInfo[@"_id"];
    NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
    XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
    goodDetailViewController.letaoPassDetailInfo = itemInfo;
    goodDetailViewController.letaoGoodsId = letaoGoodsId;
    goodDetailViewController.letaoStoreId = letaoStoreId;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.letaoGoodsSource = item_source;
    NSString *letaoGoodsItemId = itemInfo[@"item_id"];
    goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];

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
