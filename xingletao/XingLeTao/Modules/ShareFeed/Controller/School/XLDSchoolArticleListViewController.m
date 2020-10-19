//
//  XLDSchoolArticleListViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLDSchoolArticleListViewController.h"
#import "XLTSchoolSearchReusableView.h"
#import "XLTSchoolArticleCell.h"
#import "XLTShareFeedLogic.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTArticleDetailViewController.h"
#import "XLTCommonAlertViewController.h"
#import "XLTSchoolFullScreenSJVideoVC.h"

@interface XLDSchoolArticleListViewController () <XLTSchoolArticleCellDelegate>

@end

@implementation XLDSchoolArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.collectionView.mj_footer;
    if ([footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}


- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}


- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTSchoolArticleCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTSchoolArticleCell"];
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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;

}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTSchoolArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTSchoolArticleCell" forIndexPath:indexPath];
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
    cell.delegate = self;
    [cell letaoUpdateCellDataWithInfo:itemInfo];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 114);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)articleCell:(XLTSchoolArticleCell *)cell shareWithInfo:(NSDictionary *)info {
    [self showShareAlertWithInfo:info];
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
