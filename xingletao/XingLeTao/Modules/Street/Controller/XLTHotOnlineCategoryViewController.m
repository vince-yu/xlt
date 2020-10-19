//
//  XLTHotOnlineCategoryViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHotOnlineCategoryViewController.h"
#import "XLTHotOnlinenGoodsCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLDStreetLogic.h"

@interface XLTHotOnlineCategoryViewController ()

@end

@implementation XLTHotOnlineCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    [XLDStreetLogic xingletaonetwork_requestRedGoodsListWithIndex:index pageSize:pageSize sourece:nil sign:nil categoryId:self.letaoChannelId postage:nil t:nil startPrice:nil endPrice:nil success:^(id  _Nonnull goodArray, NSURLSessionDataTask * _Nonnull task) {
        success(goodArray);
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
        failed(nil,errorMsg);
    }];

  
}


// CELL
static NSString *const kXLTHotOnlinenGoodsCell = @"XLTHotOnlinenGoodsCell";
- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHotOnlinenGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHotOnlinenGoodsCell];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTHotOnlinenGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHotOnlinenGoodsCell forIndexPath:indexPath];
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
    [cell letaoUpdateCellDataWithInfo:itemInfo];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 157);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
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
    goodDetailViewController.letaoParentPlateId = self.letaoParentPlateId;
    goodDetailViewController.letaoCurrentPlateId = @"500001";
    goodDetailViewController.letaoIsCustomPlate = YES;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.letaoGoodsSource = item_source;
    NSString *letaoGoodsItemId = itemInfo[@"item_id"];
    goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];
    // 汇报事件
    [SDRepoManager xltrepo_trackPlatleGoodsSelected:itemInfo
                                          xlt_item_firstplatle_id:self.letaoParentPlateId
                                       xlt_item_firstplatle_title:@"红人街"
                                         xlt_item_secondplatle_id:nil
                                      xlt_item_secondplatle_title:@"网红爆款"
                             xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
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
