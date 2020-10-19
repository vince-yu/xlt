//
//  XLTStoreViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStoreViewController.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "UIImage+UIColor.h"
#import "XLTStoreFilterView.h"
#import "XLDStoreGoodsCollectionViewCell.h"

@interface XLTStoreViewController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation XLTStoreViewController

- (void)dealloc {
    self.scrollCallback = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)letaoSetupRefreshHeader {
    
}

- (void)letaoSetupFilterView {

}

- (UIViewController *)sourceViewController {
    return self.letaonavigationController;
}


- (NSString *)letaoCurrentPlateIdParameter{
    return nil;
}

- (NSString *)categoryIdParameter{
    return nil;
}

- (NSString *)letaoStoreIdParameter{
    return self.letaoStoreId;
}

- (NSString *)sourceParameter {
    return self.letaoStoreSource;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoconfigTranslucentNavigation];
    [self letaoconfigLeftBarItemWithImage:[UIImage imageNamed:@"xinletao_gooddetail_graybackground_back"] target:self action:@selector(letaoLeftButtonClicked)];
    [self letaoSetupNavigationBarTitleColor:[UIColor colorWithHex:0xFF25282D]];
}

- (void)letaoLeftButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsBottom = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    safeAreaInsetsBottom = safeAreaInsetsBottom;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, kBottomSafeHeight, 0);
}



// CELL
static NSString *const kXLDStoreGoodsCollectionViewCell = @"XLDStoreGoodsCollectionViewCell";
static NSString *const kFilterHeader = @"kFilterHeader";

- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLDStoreGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDStoreGoodsCollectionViewCell];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeader];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLDStoreGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDStoreGoodsCollectionViewCell forIndexPath:indexPath];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeader forIndexPath:indexPath];
    if (self.topFilterView == nil) {
        self.topFilterView = [[NSBundle mainBundle]loadNibNamed:@"XLTStoreFilterView" owner:self options:nil].lastObject;
        self.topFilterView.backgroundColor = [UIColor clearColor];
        self.topFilterView.delegate = self;
        self.topFilterView.frame = CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height);
        self.topFilterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.topFilterView.letaoHiddenFilterBtn = YES;
    }
    [headerView addSubview:self.topFilterView];

    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 44;
    return CGSizeMake(collectionView.bounds.size.width, height);
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
    [self.letaonavigationController pushViewController:goodDetailViewController animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
