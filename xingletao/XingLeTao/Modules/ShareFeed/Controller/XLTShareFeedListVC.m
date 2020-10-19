//
//  XLTShareFeedListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareFeedListVC.h"
#import "XLTShareFeedLogic.h"

#import "XLTFullScreenVideoVC.h"
#import "XLTShareFeedMediaDownloadVC.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
#import "MBProgressHUD+TipView.h"
#import "XLTUserManager.h"
#import "XLTGoodsDetailLogic.h"
#import "XLTAliManager.h"
#import "XLTGoodsEarnShareImageView.h"
#import "XLTHomePageLogic.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTGoodsDetailVC.h"
#import "KSSDImageManager.h"
#import "XLTPDDManager.h"
#import "XLTMyWatermarkLogic.h"
#import "UIView+PYSearchExtension.h"

@interface XLTShareFeedListVC () 
@property (nonatomic, strong) NSMutableDictionary *unFoldIndexDictionary;
@property (nonatomic, strong) XLTGoodsDetailLogic *letaoGoodsDetailLogic;
@property (nonatomic, strong) NSArray *tagTitleArray;
@property (nonatomic, strong) NSArray *tagViewArray;

@end

@implementation XLTShareFeedListVC


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLoginSuccessNotification) name:kXLTNotifiLoginSuccess object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLogoutSuccessNotification) name:kXLTNotifiLogoutSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(supportGoodsPlatformValueNotification) name:@"kSupportGoodsPlatformValueNotification" object:nil];

    }
    return self;
}

- (void)letaoLoginSuccessNotification {
    [self requestFristPageData];
}

- (void)letaoLogoutSuccessNotification {
    [self requestFristPageData];
}

- (void)supportGoodsPlatformValueNotification {
    if (!self.viewLoaded) {
        return;
    }
    [self requestFristPageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.estimatedRowHeight = 200;
    self.contentTableView.estimatedSectionHeaderHeight = 0;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.unFoldIndexDictionary == nil) {
        self.unFoldIndexDictionary = [NSMutableDictionary dictionary];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.contentTableView setContentOffset:CGPointZero animated:YES];
    }];
    
    if ([self.tagArray isKindOfClass:[NSArray class]] && self.tagArray.count > 0) {
        NSMutableArray *tagTitleArray = [NSMutableArray array];

        [self.tagArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *title = obj[@"title"];
                if ([title isKindOfClass:[NSString class]]) {
                    [tagTitleArray addObject:title];
                } else {
                    [tagTitleArray addObject:@""];
                }
            } else {
                [tagTitleArray addObject:@""];
            }
        }];
        self.tagTitleArray = tagTitleArray;
        if (self.tagTitleArray.count > 0) {
            [self buildTagMenus];
            [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(44);
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    // Fallback on earlier versions
                    make.bottom.equalTo(self.view);
                }
            }];
        }
    }
}

- (void)buildTagMenus {
    CGFloat space = 10;
    CGFloat leftMargin = 32;
    CGFloat rightMargin = 32;
    __block CGFloat start_x = leftMargin;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    NSMutableArray *tagViewArray = [NSMutableArray array];
    [self.tagTitleArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *tagLabel = [self tagLabelWithTitle:obj];
        tagLabel.tag = idx;
        [self adjustTagLabel:tagLabel forSelectedStyle:(idx == 0)];
        [tagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        tagLabel.py_x = start_x;
        tagLabel.py_y = ceilf((48- tagLabel.py_height)/2);
        [scrollView addSubview:tagLabel];
        [tagViewArray addObject:tagLabel];
        start_x += (tagLabel.py_width + space);
    }];
    self.tagViewArray = tagViewArray;
    scrollView.contentSize = CGSizeMake(start_x + rightMargin, 48);
}

- (UILabel *)tagLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:13];
    label.text = title;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 24;
    label.py_height = 28;
    label.layer.cornerRadius = label.py_height/2;
    return label;
}

- (void)adjustTagLabel:(UILabel *)label forSelectedStyle:(BOOL)selected {
    if (selected) {
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor letaomainColorSkinColor];
    } else {
        label.textColor = [UIColor colorWithHex:0xFF25282D];
        label.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
    }
}

- (void)tagDidCLick:(UITapGestureRecognizer *)gr {
    UILabel *label = (UILabel *)gr.view;
    NSUInteger idx = label.tag;
    if (idx < self.tagArray.count) {
        NSDictionary *tagInfo = self.tagArray[idx];
        if ([tagInfo isKindOfClass:[NSDictionary class]]) {
            NSString *currentTag = tagInfo[@"_id"];
            if (self.currentTag != currentTag) {
                self.currentTag = currentTag;
                
                [self.tagViewArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self adjustTagLabel:obj forSelectedStyle:(obj == label)];
                }];
                
                [self requestFristPageData];
            }
        }
    }
}


- (void)letaoShowLoading {
    [self letaoShowClearBgLoading];
}


- (void)letaoShowClearBgLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (NSString * _Nullable)letaoChannelIdParameters {
    if(self.currentTag) {
        return self.currentTag;
    } else {
        return self.letaoChannelId;
    }
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    __weak typeof(self)weakSelf = self;
    [XLTShareFeedLogic xingletaonetwork_requestShareFeedDataForIndex:index pageSize:pageSize channelId:[self letaoChannelIdParameters] success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        [weakSelf.unFoldIndexDictionary removeAllObjects];
        success(feedArray);
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        failed(nil,errorMsg);
    }];
}



- (void)openAliTrandPageWithURLString:(NSString *)url
                        authorization:(BOOL)authorization {
    [[XLTAliManager shareManager] openAliTrandPageWithURLString:url sourceController:self authorized:authorization];
}


- (UIImage *)letaoConvertViewToImage:(UIView *)view size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// CELL
- (void)registerTableViewCells {
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedTopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedTopCell"];
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedTextCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedMediaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedMediaCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedGoodsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedGoodsCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedGoodsStepCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedGoodsStepCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedEmptyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedEmptyCell"];

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView shareCellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView shareCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![self isValidCellForRowAtIndexPath:indexPath]) {
        XLTShareFeedEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedEmptyCell" forIndexPath:indexPath];
        NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == (numberOfRows - 1)) {
            cell.contentMediaViewHeight.constant = 10;
        } else {
            cell.contentMediaViewHeight.constant = 1;
        }
        return cell;
    } else if (indexPath.row == 0) {
        XLTShareFeedTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedTopCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell letaoUpdateCellDataWithInfo:self.letaoPageDataArray[indexPath.section]];
        return cell;
        
    } else if (indexPath.row == 1) {
        XLTShareFeedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedTextCell" forIndexPath:indexPath];
        cell.delegate = self;
        BOOL fold = ![self isUnFoldIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:self.letaoPageDataArray[indexPath.section] fold:fold];
        return cell;
    } else if (indexPath.row == 2) {
        XLTShareFeedMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedMediaCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        [cell letaoUpdateCellDataWithInfo:info];
        
        return cell;
    } else if (indexPath.row == 3) {
        XLTShareFeedGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedGoodsCell" forIndexPath:indexPath];
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *goodBase = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            goodBase = info[@"goodBase"];
        }
        [cell letaoUpdateCellGoodsInfo:goodBase otherDataInfo:info];
        return cell;
    } else {
        XLTShareFeedGoodsStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedGoodsStepCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *goodBase = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            goodBase = info[@"goodBase"];
        }
        [cell letaoUpdateCellDataWithInfo:goodBase];
        return cell;
    }
}

- (BOOL)isValidCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *info = self.letaoPageDataArray[indexPath.section];
    if (indexPath.row == 0) {
        return YES;
    } else if (indexPath.row == 1) {
        NSString *content = nil;
        if ([info isKindOfClass:[NSDictionary class]] && [info[@"content"] isKindOfClass:[NSString class]]) {
            content = info[@"content"];
        }
        return content.length > 0;
    } else if (indexPath.row == 2) {
        NSArray *images = nil;
        NSArray *videos = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            if ([info[@"images"] isKindOfClass:[NSArray class]]) {
                images = info[@"images"];
            }
            if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
                videos = info[@"videos"];
            }
        }
        NSMutableArray *mediaArray = [NSMutableArray array];
        if (videos.count) {
            [mediaArray addObjectsFromArray:videos];
        }
        if (images.count) {
            [mediaArray addObjectsFromArray:images];
        }
        return mediaArray.count > 0;
    } else if (indexPath.row == 3 || indexPath.row == 4) {
        NSDictionary *goodBase = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            goodBase = info[@"goodBase"];
        }
        return ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0);
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.letaoPageDataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        return 5;
    } else {
        return 4;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *itemInfo = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
             itemInfo = info[@"goodBase"];
         }

        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
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

    }
}



- (void)startFetchResourceWithInfo:(NSDictionary *)info share:(BOOL)share {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    NSDictionary *goodBase = nil;
    NSString *item_source =nil;
    NSString *letaoGoodsId =nil;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([NSStringFromClass([self class]) isEqualToString:@"XLTFeedRecommedRankingListVC"]) {
            goodBase = info[@"goods_info"];
        } else {
            goodBase = info[@"goodBase"];
        }
    }
    if (share) {
        NSString *content = nil;
        if ([info[@"content"] isKindOfClass:[NSString class]]) {
            content = info[@"content"];
        } else {
            content = info[@"share_content"];
        }
        if (content && content.length > 0) {
            [UIPasteboard generalPasteboard].string = content;
            [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:content];
            [MBProgressHUD letaoshowTipMessageInWindow:@"分享文案已复制到剪贴板" hideAfterDelay:0.5];
        }
    }
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
        goodBase = nil;
    }
    if ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0) {
        // 需要授权,需要生成海报
        item_source = goodBase[@"item_source"];
        letaoGoodsId = goodBase[@"_id"];
        BOOL letaoIsAliSource = ([item_source isKindOfClass:[NSString class]]
                                     && ([item_source isEqualToString:XLTTaobaoPlatformIndicate] || [item_source isEqualToString:XLTTianmaoPlatformIndicate]));
        __weak typeof(self)weakSelf = self;
        if ([XLTAppPlatformManager shareManager].isLimitModel) {
        } else {
            if (self.letaoGoodsDetailLogic == nil) {
                self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
            }
            if (letaoIsAliSource) {
                [self letaoShowClearBgLoading];
                [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:letaoGoodsId itemSource:item_source isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                    [weakSelf letaoRemoveLoading];
                    NSDictionary *itemInfo = model.data;
                    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
                        if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
                            NSString *auth_url = itemInfo[@"auth_url"];
                            if ([auth_url isKindOfClass:[NSString class]]) {
                                [weakSelf openAliTrandPageWithURLString:auth_url authorization:NO];
                            }
                        } else {
                            NSString *tbk_pwd = itemInfo[@"code"];
                            if ([tbk_pwd isKindOfClass:[NSString class]]) {
                                [self completeShareAuthCheckWithGoodsInfo:goodBase itemInfo:info share:share tbk_pwd:tbk_pwd jd_pwd:nil];
                            } else {
                                [self showTipMessage:Data_Error];
                            }
                        }
                    }
           
                   
                } failure:^(NSString * _Nonnull errorMsg) {
                    [weakSelf letaoRemoveLoading];
                    [weakSelf showTipMessage:errorMsg];
                }];
            } else {
                [self letaoShowClearBgLoading];
                [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:letaoGoodsId itemSource:item_source isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                    [weakSelf letaoRemoveLoading];
                    if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                        NSString *auth_url = model.data[@"auth_url"];
                        if ([auth_url isKindOfClass:[NSString class]]) {
                            [weakSelf letaoOpenPddWithUrlString:auth_url];
                        }
                    }else {
                        NSDictionary *itemInfo = model.data;
                        NSString *click_url = itemInfo[@"click_url"];
                        NSString *item_url = itemInfo[@"item_url"];
                        if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                            [weakSelf completeShareAuthCheckWithGoodsInfo:goodBase itemInfo:info share:share tbk_pwd:nil jd_pwd:click_url];
                        } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                            [weakSelf completeShareAuthCheckWithGoodsInfo:goodBase itemInfo:info share:share tbk_pwd:nil jd_pwd:item_url];
                        }
                    }
                    

                 } failure:^(NSString * _Nonnull errorMsg) {
                     [weakSelf letaoRemoveLoading];
                     [weakSelf showTipMessage:errorMsg];
                 }];
            }
        }
    } else {
        // 不需要授权，不需要生成海报
        [self completeShareAuthCheckWithGoodsInfo:nil itemInfo:info share:share tbk_pwd:nil jd_pwd:nil];
    }
}

- (void)completeShareAuthCheckWithGoodsInfo:(NSDictionary * _Nullable)goodsInfo itemInfo:(NSDictionary *)itemInfo share:(BOOL)share tbk_pwd:(NSString * _Nullable)tbk_pwd jd_pwd: (NSString * _Nullable)jd_pwd  {
    if (goodsInfo) {
        __weak typeof(self)weakSelf = self;
        [self downBillResource:goodsInfo tbk_pwd:tbk_pwd jd_pwd:jd_pwd complete:^(UIImage *billImage) {
            [weakSelf downLoadShareResource:itemInfo complete:^(NSArray *videoArray, NSArray *imageArray) {
                
                if (videoArray.count + imageArray.count > 0 || billImage) {
                    NSMutableArray *shareImageArray = [NSMutableArray array];
                    if ([imageArray isKindOfClass:[NSArray class]]) {
                        [shareImageArray addObjectsFromArray:imageArray];;
                    }
                    if (share) {
                        [weakSelf showActivityViewControllerWithVideoArray:videoArray imageArray:shareImageArray gooodsImage:billImage];

                    } else {
                        [weakSelf saveAlbumWithVideoArray:videoArray addWatermarkIfNeedForImages:shareImageArray gooodsImage:billImage];
                    }
                } else {
                    [weakSelf showTipMessage:@"下载失败"];
                }
            }];
        }];
    } else {
         __weak typeof(self)weakSelf = self;
        [self downLoadShareResource:itemInfo complete:^(NSArray *videoArray, NSArray *imageArray) {
            if (videoArray.count + imageArray.count > 0) {
                if (share) {
                    [weakSelf showActivityViewControllerWithVideoArray:videoArray imageArray:imageArray gooodsImage:nil];

                } else {
                    [self saveAlbumWithVideoArray:videoArray addWatermarkIfNeedForImages:imageArray gooodsImage:nil];
                }
                } else {
                [weakSelf showTipMessage:@"下载失败"];
            }
        }];
    }
}


- (void)downBillResource:(NSDictionary *)info tbk_pwd:(NSString * _Nullable)tbk_pwd  jd_pwd: (NSString * _Nullable)jd_pwd complete:(void(^)(UIImage *billImage))complete {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.label.text = @"海报生成中...";
    hud.label.textColor = [UIColor colorWithHex:0xFF333333];
    hud.label.font = [UIFont letaoLightFontWithSize:12.0];
    XLTGoodsEarnShareImageView *earnShareImageView = [[NSBundle mainBundle] loadNibNamed:@"XLTGoodsEarnShareImageView" owner:self options:nil].lastObject;
    NSMutableArray *imageURLStringsGroup = @[].mutableCopy;
    [earnShareImageView updateGoodsData:info imageURLStringsGroup:imageURLStringsGroup tkl:tbk_pwd jdkl:jd_pwd complete:^(BOOL success, NSMutableArray * _Nonnull imageArray) {
        [hud hideAnimated:NO];
        UIImage *billImage = [self letaoConvertViewToImage:earnShareImageView size:CGSizeMake(kScreenWidth, kScreen_iPhone375Scale(610))];
        complete(billImage);
    }];
    earnShareImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreen_iPhone375Scale(610));

    [earnShareImageView setNeedsLayout];
    [earnShareImageView layoutIfNeeded];
}

- (void)downLoadShareResource:(NSDictionary *)info complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    NSArray *images = nil;
    NSArray *videos = nil;
    NSString *content = nil;
    NSString *itemId = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([info[@"images"] isKindOfClass:[NSArray class]]) {
            images = info[@"images"];
        }
        if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
            videos = info[@"videos"];
        }
        if ([info[@"content"] isKindOfClass:[NSString class]]) {
            content = info[@"content"];
        }
        itemId = info[@"_id"];
        
    }
    NSMutableArray *mediaArray = [NSMutableArray array];
    if (videos.count) {
        [mediaArray addObjectsFromArray:videos];
    }
    if (images.count) {
        [mediaArray addObjectsFromArray:images];
    }
    if (mediaArray.count > 0) {
        XLTShareFeedMediaDownloadVC *mediaDownloadVC = [[XLTShareFeedMediaDownloadVC alloc] init];
        [mediaDownloadVC letaoPresentWithSourceVC:self.navigationController downloadMediaWithItemInfo:info complete:^(NSArray * _Nonnull videoArray, NSArray * _Nonnull imageArray) {
            complete(videoArray,imageArray);
        }];
    } else {
        complete(@[],@[]);
    }
    [XLTShareFeedLogic repoClickWithId:itemId];
}

- (void)cell:(UITableViewCell *)cell shareBtnClicked:(id)sender {

    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    if (indexPath) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *goodBase = nil;
        if ([NSStringFromClass([self class]) isEqualToString:@"XLTFeedRecommedRankingListVC"]) {
            goodBase = info[@"goods_info"];
        } else {
            goodBase = info[@"goodBase"];
        }

//        NSString *item_source = goodBase[@"item_source"];
//        BOOL isWPHSource = ([goodBase isKindOfClass:[NSDictionary class]] && [item_source isKindOfClass:[NSString class]] && [item_source isEqualToString:XLTVPHPlatformIndicate]);
//        if (!isWPHSource && ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0) && ![self isCouponValidForGoodsInfo:goodBase]) {
//            [self showTipMessage:@"宝贝已抢完"];
//        } else {
//        }
        [self startFetchResourceWithInfo:info share:YES];
    }
    
    
}

- (void)cell:(XLTShareFeedGoodsStepCell *)cell copyBtnClicked:(id)sender {
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    if (indexPath && indexPath.section < self.letaoPageDataArray.count) {
          NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.section];
          NSDictionary *goodBase = nil;
        if ([NSStringFromClass([self class]) isEqualToString:@"XLTFeedRecommedRankingListVC"]) {
            goodBase = itemInfo[@"goods_info"];
        } else {
            goodBase = itemInfo[@"goodBase"];
        }
//          NSString *item_source = goodBase[@"item_source"];
//          BOOL isWPHSource = ([goodBase isKindOfClass:[NSDictionary class]] && [item_source isKindOfClass:[NSString class]] && [item_source isEqualToString:XLTVPHPlatformIndicate]);
//          if (!isWPHSource && ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0) && ![self isCouponValidForGoodsInfo:goodBase]) {
//              [self showTipMessage:@"宝贝已抢完"];
//              return;
//          }
          if ([goodBase isKindOfClass: [NSDictionary class]]) {
              NSString *letaoGoodsId = goodBase[@"_id"];
              NSString *source = goodBase[@"item_source"];
              if (self.letaoGoodsDetailLogic == nil) {
                  self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
              }
              [self letaoShowClearBgLoading];
               __weak typeof(self)weakSelf = self;
              BOOL letaoIsAliSource = ([source isKindOfClass:[NSString class]]
                                           && ([source isEqualToString:XLTTaobaoPlatformIndicate] || [source isEqualToString:XLTTianmaoPlatformIndicate]));
              if (letaoIsAliSource) {
                  [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:letaoGoodsId itemSource:source isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                      [weakSelf letaoRemoveLoading];
                      NSDictionary *data = model.data;
                      if ([data isKindOfClass:[NSDictionary class]]) {
                          if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
                              NSString *auth_url = data[@"auth_url"];
                              if ([auth_url isKindOfClass:[NSString class]]) {
                                  [weakSelf letaoOpenAliTrandWithURLString:auth_url authorization:NO];
                              }
                          } else {
                              if (isAliCommandTextOnly) {
                                  NSString *share_text = data[@"share_code"];
                                  [self letaoCopyPasteboardText:share_text];
                              }

                          }
                      }
                  } failure:^(NSString * _Nonnull errorMsg) {
                     [weakSelf letaoRemoveLoading];
                      [weakSelf showTipMessage:errorMsg];
                  }];
              } else {
                  [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:letaoGoodsId itemSource:source isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                      [weakSelf letaoRemoveLoading];
                      NSDictionary *data = model.data;
                      if ([data isKindOfClass:[NSDictionary class]]) {
                          if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                              NSString *auth_url = model.data[@"auth_url"];
                              if ([auth_url isKindOfClass:[NSString class]]) {
                                  [weakSelf letaoOpenPddWithUrlString:auth_url];
                              }
                          }else if (isAliCommandTextOnly) {
                              NSString *share_text = data[@"share_code"];
                              [self letaoCopyPasteboardText:share_text];
                          }
                      }
                  } failure:^(NSString * _Nonnull errorMsg) {
                      [weakSelf letaoRemoveLoading];
                      [weakSelf showTipMessage:errorMsg];
                  }];
              }
          }
      }
}

- (void)letaoOpenAliTrandWithURLString:(NSString *)url
                        authorization:(BOOL)authorization {
    [[XLTAliManager shareManager] openAliTrandPageWithURLString:url sourceController:self authorized:authorization];
}
- (void)letaoOpenPddWithUrlString:(NSString *)url{
    [[XLTPDDManager shareManager] openPDDPageWithURLString:url sourceController:self close:NO];
}
- (void)letaoCopyPasteboardText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]]
        && text.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [self showTipMessage:@"复制成功!"];
    } else {
        [self showTipMessage:@"口令找不到了，复制失败!"];
    }
}




- (BOOL)isCouponValidForGoodsInfo:(NSDictionary *)itemInfo {
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
    }
    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    return isCouponValid;
}


/*
- (void)cell:(XLTShareFeedTopCell *)cell shareBtnClicked:(id)sender {
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    if (indexPath) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSArray *images = nil;
        NSArray *videos = nil;
        NSString *content = nil;
        NSString *itemId = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            if ([info[@"images"] isKindOfClass:[NSArray class]]) {
                images = info[@"images"];
            }
            if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
                videos = info[@"videos"];
            }
            if ([info[@"content"] isKindOfClass:[NSString class]]) {
                content = info[@"content"];
            }
            itemId = info[@"_id"];
            
        }
        CGFloat afterDelayTime = 0.5;
        if (content) {
            [UIPasteboard generalPasteboard].string = content;
            [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:content];

            [MBProgressHUD letaoshowTipMessageInWindow:@"文案已复制" hideAfterDelay:afterDelayTime];
        } else {
            afterDelayTime = 0;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *mediaArray = [NSMutableArray array];
            if (videos.count) {
                [mediaArray addObjectsFromArray:videos];
            }
            if (images.count) {
                [mediaArray addObjectsFromArray:images];
            }
            if (mediaArray.count > 0) {
                XLTShareFeedMediaDownloadVC *mediaDownloadVC = [[XLTShareFeedMediaDownloadVC alloc] init];
                __weak typeof(self)weakSelf = self;
                [mediaDownloadVC letaoPresentWithSourceVC:self.navigationController downloadMediaWithItemInfo:info complete:^(NSArray * _Nonnull videoArray, NSArray * _Nonnull imageArray) {
                    if (videoArray.count + imageArray.count > 0) {
                        [self showActivityViewControllerWithVideoArray:videoArray.firstObject imageArray:imageArray];
                    } else {
                        [weakSelf showTipMessage:@"下载失败"];
                    }
                }];
            }
        });
        
        
        [XLTShareFeedLogic repoClickWithId:itemId];
    }
}*/



- (void)cell:(UITableViewCell *)cell downloadBtnClicked:(id)sender {
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    if (indexPath) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *goodBase = nil;
        if ([NSStringFromClass([self class]) isEqualToString:@"XLTFeedRecommedRankingListVC"]) {
            goodBase = info[@"goods_info"];
        } else {
            goodBase = info[@"goodBase"];
        }
//        NSString *item_source = goodBase[@"item_source"];
//        BOOL isWPHSource = ([goodBase isKindOfClass:[NSDictionary class]] && [item_source isKindOfClass:[NSString class]] && [item_source isEqualToString:XLTVPHPlatformIndicate]);
//        if (!isWPHSource && ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0) && ![self isCouponValidForGoodsInfo:goodBase]) {
//            [self showTipMessage:@"宝贝已抢完"];
//        } else {
//            [self startFetchResourceWithInfo:info share:NO];
//        }
        [self startFetchResourceWithInfo:info share:NO];
    }
  

}


- (void)cell:(XLTShareFeedTextCell *)cell fold:(BOOL)fold {
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    if (indexPath) {
        NSString *section = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        if (fold) {
            [self.unFoldIndexDictionary removeObjectForKey:section];;
        } else {
            [self.unFoldIndexDictionary setObject:@"1" forKey:section];
        }
        [self.contentTableView reloadData];
    }

}


- (BOOL)isUnFoldIndexPath:(NSIndexPath *)indexPath {
    NSString *section = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    return ([self.unFoldIndexDictionary objectForKey:section] != nil);
}

- (void)cell:(XLTShareFeedMediaCell *)cell playVideos:(NSString *)url {
    XLTFullScreenVideoVC *videoViewController = [[XLTFullScreenVideoVC alloc] initWithNibName:@"XLTFullScreenVideoVC" bundle:[NSBundle mainBundle]];
    videoViewController.letaoVideoUrl = url;
    [self.navigationController pushViewController:videoViewController animated:YES];
}


- (void)cell:(XLTShareFeedMediaCell *)cell
  sourceView:(UIButton *)sourceView
showImagesArray:(NSArray *)imagesArray
     atIndex:(NSUInteger)index
 {
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    KSPhotoBrowser.imageViewBackgroundColor = UIColor.clearColor;
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < imagesArray.count; i++) {
        NSString *imageUrl = imagesArray[i];
        if ([imageUrl isKindOfClass:[NSString class]]) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:sourceView.imageView imageUrl:[NSURL URLWithString:[imageUrl letaoConvertToHttpsUrl]]];
             [items addObject:item];
        }
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
}

// MARK: - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
//    NSLog(@"selected index: %ld", index);
}

- (void)showActivityViewControllerWithVideoArray:(NSArray *)videoArray imageArray:(NSArray *)imageArray gooodsImage:(UIImage *)gooodsImage {
    NSMutableArray *activityItems = [NSMutableArray array];
    if (videoArray.count > 0) {
        NSString *videoPath = videoArray.firstObject;
        if ([videoPath isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:videoPath];
            [activityItems addObject:url];
        }
    }
    if (activityItems.count == 0) {
        [activityItems addObjectsFromArray:imageArray];
    }
   
    if (activityItems.count > 0) {
        if (activityItems.count >9) {
            [activityItems removeObjectsInRange:NSMakeRange(9, activityItems.count-9)];
        }
        [self letaoShowLoading];
        __weak __typeof(self)weakSelf = self;
        [[XLTMyWatermarkLogic shareInstance] addWatermarkIfNeedForImages:activityItems completion:^(NSArray * _Nonnull watermarkImages) {
            [weakSelf showActivityViewController:watermarkImages gooodsImage:gooodsImage];
            [weakSelf letaoRemoveLoading];
        }];

    } else {
        [self showTipMessage:@"没有分享素材"];
    }
}

- (void)showActivityViewController:(NSArray *)watermarkImages gooodsImage:(UIImage *)gooodsImage {
    NSMutableArray *activityItems = watermarkImages.mutableCopy;
    if (gooodsImage) {
        if (activityItems.count > 0) {
            [activityItems insertObject:gooodsImage atIndex:0];
        } else {
            [activityItems addObject:gooodsImage];
        }
    }
    if (activityItems.count >9) {
        [activityItems removeObjectsInRange:NSMakeRange(9, activityItems.count-9)];
    }
    NSArray *shareItems = [XLTGoodsDisplayHelp processSizeForShareActivityItems:activityItems goodsImage:gooodsImage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:shareItems applicationActivities:nil];
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
}



- (void)saveAlbumWithVideoArray:(NSArray *)videoArray addWatermarkIfNeedForImages:(NSArray *)imageArray gooodsImage:(UIImage *)gooodsImage {
    [self letaoShowLoading];
    __weak __typeof(self)weakSelf = self;
    [[XLTMyWatermarkLogic shareInstance] addWatermarkIfNeedForImages:imageArray completion:^(NSArray * _Nonnull watermarkImages) {
        [weakSelf saveAlbumWithVideoArray:videoArray imageArray:watermarkImages gooodsImage:gooodsImage];
        [weakSelf letaoRemoveLoading];
    }];

}


- (void)saveAlbumWithVideoArray:(NSArray *)videoArray imageArray:(NSArray *)watermarkImages gooodsImage:(UIImage *)gooodsImage {
    NSMutableArray *imageArray = watermarkImages.mutableCopy;
    if (gooodsImage) {
        if (imageArray.count > 0) {
            [imageArray insertObject:gooodsImage atIndex:0];
        } else {
            [imageArray addObject:gooodsImage];
        }
    }
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                 [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     UIImage *photo = obj;
                     if ([photo isKindOfClass:[UIImage class]]) {
                         UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                     }

                 }];
                
                [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *videoPath = obj;
                    if ([videoPath isKindOfClass:[NSString class]]) {
                        NSURL *url = [NSURL URLWithString:videoPath];
                        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
                        if (compatible) {
                            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                        }
                    }

                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self showTipMessage:@"已保存到本地相册"];
                });
                
            } else { // 用户第一次拒绝了访问相机权限
    // do thing
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册

        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *photo = obj;
            if ([photo isKindOfClass:[UIImage class]]) {
                UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            }

        }];
        [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *videoPath = obj;
            if ([videoPath isKindOfClass:[NSString class]]) {
                NSURL *url = [NSURL URLWithString:videoPath];
                BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
                if (compatible) {
                    UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }
            }

        }];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self showTipMessage:@"已保存到本地相册"];
        });
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
        if (app_Name == nil) {
            app_Name = [infoDict objectForKey:@"CFBundleName"];
        }
        
        NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    } else if (status == PHAuthorizationStatusRestricted) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
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
