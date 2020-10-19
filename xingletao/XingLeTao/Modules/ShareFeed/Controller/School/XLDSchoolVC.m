//
//  XLDSchoolVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLDSchoolVC.h"
#import "XLTSchoolCategoryCell.h"
#import "XLTSchoolSearchReusableView.h"
#import "XLTSchoolArticleCell.h"
#import "XLTShareFeedLogic.h"
#import "XLTArticleSearchVC.h"
#import "XLDSchoolArticleListViewController.h"
#import "XLTArticleDetailViewController.h"
#import "XLTCommonAlertViewController.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTSchoolFullScreenSJVideoVC.h"

@interface XLDSchoolVC () <XLTSchoolSearchReusableViewDelegate,XLTSchoolArticleCellDelegate>
@property (nonatomic, strong) NSArray *hotCateSArray;
@end

@implementation XLDSchoolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.collectionView.mj_footer;
    if ([footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
}


- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}


- (void)letaoShowEmptyView {
    if (self.hotCateSArray.count == 0 && self.letaoPageDataArray.count == 0) {
        [super letaoShowEmptyView];
    }
}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)letaoShowErrorView {
    if (self.hotCateSArray.count == 0 && self.letaoPageDataArray.count == 0) {
        [super letaoShowErrorView];
    }
}

- (void)requestHotCate {
    __weak typeof(self)weakSelf = self;
    [XLTShareFeedLogic requestSchoolHotCateWithCategory:self.letaoChannelId success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        [weakSelf receivedHotCateSuccess:feedArray];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {

    }];

}

- (void)receivedHotCateSuccess:(NSArray *)hotCateSArray {
    self.hotCateSArray =  hotCateSArray;
    [self.collectionView reloadData];
    
    [self letaoRemoveLoading];
    [self letaoRemoveErrorView];
    if (self.hotCateSArray.count > 0 || self.letaoPageDataArray.count > 0) {
        [self letaoRemoveEmptyView];
    }

}

- (void)requestFristPageData {
    [self requestHotCate];
    [super requestFristPageData];
}

- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTSchoolCategoryCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTSchoolCategoryCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTSchoolArticleCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTSchoolArticleCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTSchoolSearchReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTSchoolSearchReusableView"];
}

// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                            failed:(XLTBaseListRequestFailed)failed {
    [XLTShareFeedLogic requestSchoolArticleListDataForIndex:index pageSize:pageSize channelId:self.letaoChannelId success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        success(feedArray);
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        failed(nil,errorMsg);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 ) {
       return self.hotCateSArray.count;
    } else if (section == 1){
       return self.letaoPageDataArray.count;
    } else {
        return 0;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTSchoolCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTSchoolCategoryCell" forIndexPath:indexPath];
        NSDictionary *itemInfo = self.hotCateSArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    } else {
        XLTSchoolArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTSchoolArticleCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    }

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGSizeMake(floorf((collectionView.bounds.size.width -20)/3), 70);
    } else {
        return CGSizeMake(collectionView.bounds.size.width, 114);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0 && self.hotCateSArray.count > 0) {
        return UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
             XLTSchoolSearchReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTSchoolSearchReusableView" forIndexPath:indexPath];
            headerView.delegate = self;
            return headerView;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(collectionView.bounds.size.width, 44);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *itemInfo = self.hotCateSArray[indexPath.row];
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *letaoChannelId = itemInfo[@"_id"];
            NSString *name = itemInfo[@"name"];
            XLDSchoolArticleListViewController *articleListViewController = [[XLDSchoolArticleListViewController alloc] init];
            articleListViewController.letaoChannelId = letaoChannelId;
            if ([name isKindOfClass:[NSString class]]) {
                articleListViewController.title = name;
            }
            [self.navigationController pushViewController:articleListViewController animated:YES];
        }

        
    } else if (indexPath.section == 1) {
        [self articleSelectedAtIndexPath:indexPath];
    }
}

- (void)letaoStartSearchWithText:(NSString *)letaoSearchText {
    XLTArticleSearchVC *articleSearchVC = [[XLTArticleSearchVC alloc] init];
    [self.navigationController pushViewController:articleSearchVC animated:NO];
}

- (void)articleSelectedAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSNumber *share_wechat_open = itemInfo[@"share_wechat_open"];
            if ([share_wechat_open isKindOfClass:[NSNumber class]] && [share_wechat_open integerValue] ==1) {
                [self showShareAlertWithInfo:itemInfo];
            } else {
                NSNumber *type = itemInfo[@"type"];
                NSString *url = itemInfo[@"jump_url"];
                NSString *title = itemInfo[@"title"];
                if ([type isKindOfClass:[NSNumber class]] && [type integerValue] == 3
                    && [url isKindOfClass:[NSString class]]) {
                    XLTSchoolFullScreenSJVideoVC *videoVC = [[XLTSchoolFullScreenSJVideoVC alloc] init];
                    videoVC.letaoVideoUrl = url;
                    videoVC.letaoVideoTitle = title;
                    [self.navigationController pushViewController:videoVC animated:YES];
                } else {
                  
                    XLTArticleDetailViewController *detailViewController = [[XLTArticleDetailViewController alloc] init];
                    detailViewController.jump_URL = url;
                    detailViewController.title = title;
                    detailViewController.articleInfo = itemInfo;
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
                


            }
        }

    }
}


- (void)showShareAlertWithInfo:(NSDictionary *)info {
    if (!XLTAppPlatformManager.shareManager.checkEnable) {
        [self openShareVCWithInfo:info];
        return;
    }
    XLTCommonAlertViewController *alertViewController = [[XLTCommonAlertViewController alloc] init];
    [alertViewController letaoPresentWithSourceVC:self.navigationController title:@"分享到微信才能收听" message:@"分享文章到微信，打开即可直接收听" cancelButtonText:@"取消" sureButtonText:@"分享到微信"];
    alertViewController.letaoalertViewAction = ^(NSInteger clickIndex) {
        if (clickIndex == 1) {
            [self openShareVCWithInfo:info];
        }
    };
}

- (void)openShareVCWithInfo:(NSDictionary *) info {
    
    NSString *title = nil;
    NSString *content = nil;
    NSString *url = nil;
    NSString *cover_image = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        title = info[@"title"];
        url = info[@"jump_url"];
        if ([info[@"cover_image"] isKindOfClass:[NSString class]]) {
            cover_image = info[@"cover_image"];
        }
    }
     __weak typeof(self)weakSelf = self;
    if (cover_image) {
        [self letaoShowLoading];
        [self downloadImage:cover_image complete:^(UIImage * _Nullable image) {
            [weakSelf letaoRemoveLoading];
            [weakSelf startShareWithTitle:title content:content image:image url:url];
        }];
    } else {
         [self startShareWithTitle:title content:content image:nil url:url];
    }
    
}

- (void)startShareWithTitle:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url {
    if (title || content || url || image) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSMutableArray *textArray = [NSMutableArray array];
        if (title) {
            [textArray addObject:title];
        }
        if (content) {
            [textArray addObject:content];
        }
        if ([textArray count] > 0) {
            [items addObject:[NSString stringWithFormat:@"%@",[textArray componentsJoinedByString:@""]]];
        }
        if (url) {
            NSURL *shareUrl = [NSURL URLWithString:url];
            if (shareUrl) {
                [items addObject:shareUrl];
            }
        }
        if (image) {
            [items addObject:image];
        }
        if (items) {
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[XLTGoodsDisplayHelp processSizeForShareActivityItems:items goodsImage:nil] applicationActivities:nil];
            [self.navigationController presentViewController:activityVC animated:TRUE completion:nil];
        }
    }
}


- (void)downloadImage:(NSString *)imageUrl complete:(void(^)(UIImage * _Nullable image))complete {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image && !error) {
                complete(image);;
            } else {
               complete(nil);
            }
        });
    }];
}

- (void)articleCell:(XLTSchoolArticleCell *)cell shareWithInfo:(NSDictionary *)info {
    [self showShareAlertWithInfo:info];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
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
