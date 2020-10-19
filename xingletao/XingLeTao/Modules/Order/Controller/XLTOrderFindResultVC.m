//
//  XLTOrderFindResultVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderFindResultVC.h"
#import "XLTOrderFindCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTOrderLogic.h"
#import "XLTOrderFindEmptyVC.h"
#import "XLTOrderListModel.h"
#import "XLTOrderFindSuccessVC.h"

@interface XLTOrderFindResultVC ()
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) XLTOrderLogic *orderLogic;

@end

@implementation XLTOrderFindResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回订单";
    [self letaoSetupBottomView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-70);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).offset(-103);
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}

- (void)letaoSetupBottomView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@70);
        if (@available(iOS 11.0, *)) {
            make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.left.right.bottom.equalTo(@0);
        }

    }];
    self.footerView = footerView;
    
    UIButton *findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findButton.backgroundColor = [UIColor letaomainColorSkinColor];
    [findButton setTitle:@"确认找回" forState:UIControlStateNormal];
    [findButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    findButton.titleLabel.font = [UIFont letaoRegularFontWithSize:15];
    findButton.layer.masksToBounds = YES;
    findButton.layer.cornerRadius = 22;
    [findButton addTarget:self action:@selector(letaoFindButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:findButton];
    
    [findButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@44);
        make.top.mas_equalTo(13);
    }];
    self.footerView.hidden = YES;
}

- (void)letaoFindButtonClicked {
    NSMutableArray *ids = [NSMutableArray array];
    [self.letaoPageDataArray enumerateObjectsUsingBlock:^(XLTOrderListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[XLTOrderListModel class]]) {
            if (obj.orderId) {
                [ids addObject:obj.orderId];
            }
        }
    }];
    __weak typeof(self)weakSelf = self;
    [self.orderLogic findOrders:ids success:^(NSDictionary * _Nonnull info, NSURLSessionTask * _Nonnull task) {
        [weakSelf letaoFindOrdersSuccessed];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoFindOrdersFailed];
    }];
}

- (void)letaoFindOrdersSuccessed {
    XLTOrderFindSuccessVC *vc = [[XLTOrderFindSuccessVC alloc] initWithNibName:@"XLTOrderFindSuccessVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)letaoFindOrdersFailed {
    
}

- (void)letaoShowEmptyView {

    XLTOrderFindEmptyVC *seeksResultEmptyViewController = [[XLTOrderFindEmptyVC alloc] init];
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    [viewControllers removeObject:self];
    [viewControllers addObject:seeksResultEmptyViewController];
    [self.navigationController setViewControllers:viewControllers animated:NO];
}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor whiteColor];
    [super letaoShowLoading];
}

- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTOrderFindCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTOrderFindCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;

}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTOrderFindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTOrderFindCollectionViewCell" forIndexPath:indexPath];
    XLTOrderListModel *orderListModel = self.letaoPageDataArray[indexPath.row];
    [cell letaoUpdateCellWithData:orderListModel];
    return cell;

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - 20, 157);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XLTOrderListModel *itemInfo = self.letaoPageDataArray[indexPath.row];
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
        NSString *letaoGoodsItemId = itemInfo.item_id;
        goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
        goodDetailViewController.letaoGoodsSource = item_source;
        [self.navigationController pushViewController:goodDetailViewController animated:YES];
    }
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.orderLogic == nil) {
        self.orderLogic = [[XLTOrderLogic alloc] init];
    }
    __weak __typeof(self)weakSelf = self;
    if (self.isGroup) {
        [self.orderLogic xingletaonetwork_requestGroupOrdersWithIndex:index pageSize:pageSize yearMonth:nil source:nil status:nil letaoSearchText:nil retrieveOrderId:self.letaoSearchText success:^(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task) {
            success(orderArray);
            weakSelf.footerView.hidden =  !(weakSelf.letaoPageDataArray.count > 0);
        } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
            failed(nil,errorMsg);
        }];
    }else{
        [self.orderLogic xingletaonetwork_requestOrdersWithIndex:index pageSize:pageSize yearMonth:nil source:nil status:nil letaoSearchText:nil retrieveOrderId:self.letaoSearchText success:^(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task) {
            success(orderArray);
            weakSelf.footerView.hidden =  !(weakSelf.letaoPageDataArray.count > 0);
        } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
            failed(nil,errorMsg);
        }];
    }
    
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
