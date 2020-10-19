//
//  XLTOrderListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderListVC.h"
#import "XLTOrderLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTOrderCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTOrderHeaderView.h"
#import "XLTAppPlatformManager.h"
#import "XLTAlertViewController.h"
#import "NSArray+Bounds.h"
#import "XLTCarcdOrderCell.h"
#import "XLTWKWebViewController.h"

@interface XLTOrderListVC ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) XLTOrderLogic *orderLogic;
@end

@implementation XLTOrderListVC
- (void)dealloc
{
    self.scrollCallback = nil;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
}

- (void)letaoShowEmptyView {
    [super letaoShowEmptyView];
    self.letaoEmptyCoverView.titleStr = @"您还没有订单记录哦~";
    self.letaoEmptyCoverView.image = [UIImage imageNamed:@"xingletao_order_empty"];
    self.letaoEmptyCoverView.contentViewOffset = 35;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.orderLogic == nil) {
        self.orderLogic = [[XLTOrderLogic alloc] init];
    }
    if (self.isGroup) {
        [self.orderLogic xingletaonetwork_requestGroupOrdersWithIndex:index pageSize:pageSize yearMonth:self.letaoYearMonthText source:self.letaoOrderSource status:self.status letaoSearchText:self.letaoSearchText retrieveOrderId:self.retrieveOrderId success:^(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task) {
            success(orderArray);
        } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
            failed(nil,errorMsg);
        }];
    }else{
        [self.orderLogic xingletaonetwork_requestOrdersWithIndex:index pageSize:pageSize yearMonth:self.letaoYearMonthText source:self.letaoOrderSource status:self.status letaoSearchText:self.letaoSearchText retrieveOrderId:self.retrieveOrderId success:^(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task) {
            success(orderArray);
        } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
            failed(nil,errorMsg);
        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

// registerTableViewCells should overwrite by sub class
- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTOrderCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTOrderCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCarcdOrderCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTCarcdOrderCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTOrderHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTOrderHeaderView"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;

}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTOrderListModel *itemInfo = self.letaoPageDataArray[indexPath.row];
    if (itemInfo.creditCardOrderInfo) {
        XLTCarcdOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTCarcdOrderCell" forIndexPath:indexPath];
        cell.model = itemInfo;
        return cell;
    }else{
        XLTOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTOrderCollectionViewCell" forIndexPath:indexPath];
        __weak typeof(self)weakSelf = self;
    //    cell.letaoCellCoverButtonClicked = ^(NSDictionary *cellInfo){
    //        [weakSelf selectCellAtIndexPath:indexPath];
    //    };
        cell.operateButtonClicked = ^(NSDictionary *cellInfo,BOOL canRebate){
            [weakSelf letaoShareBtnClickedAtIndexPath:indexPath canRebate:canRebate];
        };
        
        [cell letaoUpdateCellWithData:itemInfo];
        return cell;
    }
    

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    XLTOrderHeaderView *headerReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XLTOrderHeaderView" forIndexPath:indexPath];
    headerReusableView.backgroundColor = self.view.backgroundColor;
    XLT_WeakSelf;
    headerReusableView.otherBlock = ^{
        XLT_StrongSelf;
        [self pushOtherVC];
    };
    if (self.letaoYearMonthText != nil) {
        NSArray *array = [self.letaoYearMonthText componentsSeparatedByString:@"-"];
        headerReusableView.letaoDateLabel.text = [NSString stringWithFormat:@"— %@年%@月%@订单 —",array.firstObject,array.lastObject,self.title];

    } else {
        headerReusableView.letaoDateLabel.text = nil;
    }
   
    return headerReusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.letaoYearMonthText != nil) {
        return CGSizeMake(collectionView.bounds.size.width, 60);
    } else {
        return CGSizeMake(collectionView.bounds.size.width, 35);
    }
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLTOrderListModel *itemInfo = self.letaoPageDataArray[indexPath.row];
    if (itemInfo.creditCardOrderInfo) {
        return CGSizeMake(collectionView.bounds.size.width - 20, 160);
    }else{
        return CGSizeMake(collectionView.bounds.size.width - 20, 135);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self selectCellAtIndexPath:indexPath];
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath  {
    XLTOrderListModel *itemInfo = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.row];
    //事件汇报
    if ([itemInfo isKindOfClass:[XLTOrderListModel class]]) {
        NSMutableDictionary *properties = @{}.mutableCopy;
        properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo.orderId];
        properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo.item_title];
        properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo.item_source];
        properties[@"xlt_item_firstcate_title"] = @"null";
        properties[@"xlt_item_thirdcate_title"] = @"null";
        properties[@"xlt_item_secondcate_title"] = @"null";
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GROUP_ORDER properties:properties];
    }
    
    
    // type字段吧，int类型，1 为饿了么
    BOOL isElmSource = ([itemInfo.type isKindOfClass:[NSNumber class]] && [itemInfo.type integerValue] == 1);
    if (isElmSource) {
        // do noting
    } else {
        NSString *letaoGoodsId = itemInfo.goods_id;
        NSString *letaoStoreId = itemInfo.seller_shop_id;
        
        XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
        goodDetailViewController.letaoGoodsId = letaoGoodsId;
        goodDetailViewController.letaoStoreId = letaoStoreId;
        NSString *item_source = itemInfo.item_source;
        goodDetailViewController.letaoGoodsSource = item_source;
        NSString *letaoGoodsItemId = itemInfo.item_id;
        goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if (!nav) {
            nav = self.letaonavigationController;
        }
        [nav pushViewController:goodDetailViewController animated:YES];
    }
}

- (UINavigationController *)cureentLetaoNavigationController {
    UINavigationController *nav = self.letaonavigationController;
    if (!nav) {
        nav = self.navigationController;
    }
    return nav;
}

- (void)letaoShareBtnClickedAtIndexPath:(NSIndexPath *)indexPath canRebate:(BOOL)canRebate  {
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
    if (canRebate) {
        [self rebatWithOrderInfo:itemInfo];
    } else {
        if ([XLTAppPlatformManager shareManager].isOrderShareTipSwitchOff) {
             [self shareWithOrderInfo:itemInfo];
        } else {
            XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
                   alertViewController.displayNotShowButton = YES;
            [alertViewController letaoPresentWithSourceVC:[self cureentLetaoNavigationController] title:@"分享规则" message:@"1、下单成功后，分享给一位新用户\n\n2、新用户需在截止时间内，下载星乐桃APP注册登录，输入订单分享码即分享成功，同时该新用户也可以获得购买任一商品得相同比例返利的优惠\n\n3、每单仅仅只需要邀请一个新用户即可获得高返" sureButtonText:@"知道了" cancelButtonText:nil];
            __weak typeof(self)weakSelf = self;
            alertViewController.letaoalertViewAction = ^(NSInteger clickIndex,BOOL noneShow) {
                if (noneShow) {
                    [[XLTAppPlatformManager shareManager] orderShareTipSwitchOff:YES];
                }
                [weakSelf shareWithOrderInfo:itemInfo];
            };
        }
    }
}

- (void)rebatWithOrderInfo:(NSDictionary *)itemInfo {
    NSMutableDictionary *letaoOrderDictionary = itemInfo.mutableCopy;
    if (letaoOrderDictionary) {
        NSInteger index = [self.letaoPageDataArray indexOfObject:itemInfo];
        if (index != NSNotFound) {
            [self.letaoPageDataArray replaceObjectAtIndex:index withObject:letaoOrderDictionary];
             NSString *orderId = letaoOrderDictionary[@"_id"];
            __weak typeof(self)weakSelf = self;
            [self.orderLogic rebatWithOrderId:orderId success:^(NSDictionary * _Nonnull info, NSURLSessionTask * _Nonnull task) {
                [weakSelf showTipMessage:@"领取成功"];
                letaoOrderDictionary[@"can_rebate"] = @0;
                [weakSelf.collectionView reloadData];
            } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
                [weakSelf showTipMessage:@"errorMsg"];
            }];
        }
       
    }
}

- (void)pushOtherVC{
    XLTWKWebViewController *vc = [[XLTWKWebViewController alloc] init];
    vc.jump_URL = [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202010ordertip"];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:vc animated:YES];
}
- (void)repoOrderShareWithOrderInfo:(NSDictionary *)itemInfo {
    NSString *share_type = itemInfo[@"share_type"];
    NSString *orderId = itemInfo[@"_id"];
    NSString *goods_id = itemInfo[@"item_id"];
    NSString *item_source = itemInfo[@"item_source"];
    [[XLTRepoDataManager shareManager] repoOrderSharActionOrderId:orderId activity:share_type goodId:goods_id item_source:item_source];
}

- (void)shareWithOrderInfo:(NSDictionary *)itemInfo {
    /*
    [self repoOrderShareWithOrderInfo:itemInfo];
    XLTOrderShareVC *viewController = [[XLTOrderShareVC alloc] initWithNibName:@"XLTOrderShareVC" bundle:[NSBundle mainBundle]];
    viewController.letaoOrderDictionary = itemInfo;
    viewController.view.hidden = YES;
    self.definesPresentationContext = YES;
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[self cureentLetaoNavigationController] presentViewController:viewController animated:NO completion:^{
        viewController.view.hidden = NO;
        viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        viewController.bgView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            viewController.bgView.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
        }];
    }];*/
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
    // 汇报事件
    NSString *title = nil;
    NSString *sourceStr = nil;
    switch (self.status.intValue) {
        case 0:
            title = @"全部";
        break;
        case 1:
            title = @"即将到账";
        break;
        case 2:
            title = @"已到账";
        break;
        case 10:
            title = @"已失效";
        break;
        default:
            title = @"全部";
            break;
    }
    NSString *sourceText=  [[XLTAppPlatformManager shareManager] letaoSourceTextForType:self.letaoOrderSource];
    if ([sourceText isKindOfClass:[NSString class]] && sourceText.length > 0) {
        // do notiig
    } else {
         sourceText = @"全部";
    }
//    NSString *eventText = (self.isGroup ? XLT_EVENT_GROUP_ORDER : XLT_EVENT_USER_ORDER);
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
//    properties[@"xlt_item_title"] = title;
//    properties[@"xlt_item_source_title"] = sourceStr;
//    [SDRepoManager xltrepo_trackEvent:eventText properties:properties];
}

- (void)listDidDisappear {
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
