//
//  XLTUserGoodsRecommendVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserGoodsRecommendVC.h"
#import "XLTHomePageLogic.h"
#import "XLTUserGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTUserInfoLogic.h"

@interface XLTUserGoodsRecommendVC ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) XLTHomePageLogic *logic;

@end

@implementation XLTUserGoodsRecommendVC
- (void)dealloc {
    self.scrollCallback = nil;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)letaoSetupRefreshHeader {
//}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}


- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.logic == nil) {
        self.logic = [[XLTHomePageLogic alloc] init];
    }
    [XLTUserInfoLogic xingletaonetwork_requestUserRecommendGoodsDataForIndex:index pageSize:pageSize goodsSource:nil sort:nil success:^(NSArray *goodsArray, NSURLSessionDataTask *task) {
        success(goodsArray);
    } failure:^(NSString *errorMsg, NSURLSessionDataTask *task) {
        failed(nil,errorMsg);
    }];
}

// CELL
static NSString *const kXLTUserGoodsCollectionViewCell = @"XLTUserGoodsCollectionViewCell";

- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTUserGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTUserGoodsCollectionViewCell];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTUserGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTUserGoodsCollectionViewCell forIndexPath:indexPath];
    __weak typeof(self)weakSelf = self;
    cell.letaoCellCoverButtonClicked = ^{
        [weakSelf selectCellAtIndexPath:indexPath];
    };
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
    [cell letaoUpdateCellDataWithInfo:itemInfo];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
    // 因为间距不是等比放大，调整一个修正量offset
    CGFloat height = kScreen_iPhone375Scale(340) - offset;
    return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
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

    [self.letaonavigationController pushViewController:goodDetailViewController animated:YES];
    // 汇报事件
    [SDRepoManager xltrepo_trackGoodsSelectedWithInfo:itemInfo xlt_item_place:[NSString stringWithFormat:@"%ld",(long)indexPath.row] xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
    //汇报
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    dic[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    dic[@"xlt_item_place"] = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    dic[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    dic[@"xlt_item_firstcate_title"] = @"null";
    dic[@"xlt_item_thirdcate_title"] = @"null";
    dic[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_CATEGORY properties:dic];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
    NSLog(@"listDidAppear");
}

- (void)listDidDisappear {
    NSLog(@"listDidDisappear");
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
