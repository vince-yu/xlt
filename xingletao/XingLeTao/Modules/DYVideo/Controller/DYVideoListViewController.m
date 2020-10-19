//
//  DYVideoListViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYVideoListViewController.h"
#import "XLTVideoLogic.h"
#import "XLTVideoListCell.h"
#import "NSArray+Bounds.h"
#import "DYVideoViewController.h"
#import "XLTVideoListLayout.h"

@interface DYVideoListViewController ()<XLTVideoListLayoutDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation DYVideoListViewController

- (void)dealloc
{
    self.scrollCallback = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self letaoTriggerRefresh];
    [self letaohiddenNavigationBar:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0x17151C];;
    self.collectionView.backgroundColor = [UIColor colorWithHex:0x17151C];;
    self.collectionView.backgroundView = nil;
    
    __weak DYVideoListViewController *weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
//    self.collectionView.
}

- (UICollectionViewLayout *)collectionViewLayout {
    XLTVideoListLayout *flowLayout = [[XLTVideoListLayout alloc] init];
    flowLayout.delegate = self;
//    flowLayout.sectionHeadersPinToVisibleBounds = NO;
////    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    XLT_WeakSelf;
    if (self.letaoPageDataArray.count == 0) {
        [self letaoShowLoading];
    }
//
    [XLTVideoLogic getVideoListWithCid:self.cid page:[NSString stringWithFormat:@"%ld",index] row:[NSString stringWithFormat:@"%ld",pageSize] success:^(id object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        success(object);
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        failed(nil,errorMsg);
        [self letaoRemoveLoading];
        [self letaoShowEmptyView];
    }];
    
    
    
}

// registerTableViewCells should overwrite by sub class
- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTVideoListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTVideoListCell"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTVipPictureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTVipPictureCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.letaoPageDataArray.count;
    return count;
}


#define kDefaultPictureCellHeight 100
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTVideoListCell" forIndexPath:indexPath];
    cell.listModel = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 10);
}

////item大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat itemWith = (kScreenWidth - 30) / 2.0;
//    CGFloat picHeight = itemWith * 460/345.0;
//    if (indexPath.row == 0) {
//    
//        return CGSizeMake(itemWith, picHeight);
//    }else{
//        return CGSizeMake(itemWith, picHeight + 105);
//    }
//    
//}
////
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DYVideoViewController *vc = [[DYVideoViewController alloc] init];
    vc.letaoChannelId = self.cid;
    vc.pageVideoArray = [self.letaoPageDataArray modelToJSONObject];
    vc.currentPageIndex = self.currentPageIndex;
    if (indexPath.row < vc.pageVideoArray.count) {
        vc.startVideoInfo = vc.pageVideoArray[indexPath.row];
    }
    [self.xlt_navigationController pushViewController:vc animated:YES];
}
#pragma mark  - <LMHWaterFallLayoutDeleaget>
- (CGFloat)waterFallLayout:(XLTVideoListLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth{
    CGFloat itemWith = (kScreenWidth - 30) / 2.0;
    CGFloat picHeight = itemWith * 460/345.0;
    if (indexPath == 0) {
        return picHeight;
    }else{
        return picHeight + 115;
    }
}

- (CGFloat)rowMarginInWaterFallLayout:(XLTVideoListLayout *)waterFallLayout{
    
    return 10;
    
}

- (NSUInteger)columnCountInWaterFallLayout:(XLTVideoListLayout *)waterFallLayout{
    
    return 2;
    
}
- (CGFloat)waterFallLayout:(UICollectionViewLayout *)waterFallLayout withForItemAtIndexPath:(NSUInteger)indexPath{
    CGFloat itemWith = (kScreenWidth - 30) / 2.0;
    return itemWith;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
    [self.backToTopButton setImage:[UIImage imageNamed:@"xlt_video_toTop"] forState:UIControlStateNormal];

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
//    NSString *title = nil;
//    NSString *sourceStr = nil;
//    switch (self.status.intValue) {
//        case 0:
//            title = @"全部";
//        break;
//        case 1:
//            title = @"即将到账";
//        break;
//        case 2:
//            title = @"已到账";
//        break;
//        case 10:
//            title = @"已失效";
//        break;
//        default:
//            title = @"全部";
//            break;
//    }
//    NSString *sourceText=  [[XLTAppPlatformManager shareManager] letaoSourceTextForType:self.letaoOrderSource];
//    if ([sourceText isKindOfClass:[NSString class]] && sourceText.length > 0) {
//        // do notiig
//    } else {
//         sourceText = @"全部";
//    }
//    NSString *eventText = (self.isGroup ? XLT_EVENT_GROUP_ORDER : XLT_EVENT_USER_ORDER);
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
//    properties[@"xlt_item_title"] = title;
//    properties[@"xlt_item_source_title"] = sourceStr;
//    [SDRepoManager xltrepo_trackEvent:eventText properties:properties];
}

- (void)listDidDisappear {
}
@end
