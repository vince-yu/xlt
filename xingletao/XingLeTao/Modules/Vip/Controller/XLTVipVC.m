//
//  XLTVipVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipVC.h"
#import "XLTOrderLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTOrderCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTOrderHeaderView.h"
#import "XLTAppPlatformManager.h"
#import "XLTAlertViewController.h"
#import "XLTVipHeaderView.h"
#import "XLTVipGoodsCell.h"
#import "XLTVipLogic.h"
#import "XLTVipLogic.h"
#import "XLTUserManager.h"
#import "XLTMallGoodsDetailVC.h"
#import "XLTUserInfoLogic.h"
#import "XLTVipPictureCell.h"
#import "XLTWKWebViewController.h"
#import "XLTContactMentorVC.h"
#import "XLTUserInvateVC.h"

@interface XLTVipVC ()<XLTVipHeaderViewDelegate, XLTVipPictureCellDelegate>
@property (nonatomic ,copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic ,strong) XLTVipHeaderView *headerView;
@property (nonatomic, strong) UIView *letaoCustomNavView;
@property (nonatomic ,assign) CGFloat headerHeight;
@property (nonatomic ,strong) NSMutableDictionary * pictureCellDisplayInfo;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) UIButton *bottomButton;
@end

@implementation XLTVipVC

- (void)dealloc
{
    self.scrollCallback = nil;
}
- (XLTVipHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XLTVipHeaderView alloc] initWithNib];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth,700);
//        _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _headerView.delegate = self;
       
    }
    return _headerView;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)invateAction{
    XLTUserInvateVC *vc = [[XLTUserInvateVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)letaoSetupRefreshAutoFooter {
}
- (void)letaoShowEmptyView {
//    [super letaoShowEmptyView];
//    self.letaoEmptyCoverView.titleStr = @"您还没有订单记录哦~";
//    self.letaoEmptyCoverView.image = [UIImage imageNamed:@"xingletao_order_empty"];
}
- (LetaoEmptyCoverView *)letaoEmptyCoverView{
    return nil;
}
- (LetaoEmptyCoverView *)letaoErrorView{
    return nil;
}
- (void)letaoSetupCustomNavView {
    self.letaoCustomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
    self.letaoCustomNavView.alpha = 0;
    self.letaoCustomNavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.letaoCustomNavView];
    
    
    UILabel *letaoNavTitleLabel = [[UILabel alloc] init];
    letaoNavTitleLabel.text = @"会员";
    letaoNavTitleLabel.textColor = [UIColor blackColor];
    letaoNavTitleLabel.font = [UIFont letaoMediumBoldFontWithSize:18.0];
    letaoNavTitleLabel.textAlignment = NSTextAlignmentCenter;
    letaoNavTitleLabel.frame = CGRectMake(0, kStatusBarHeight, self.letaoCustomNavView.bounds.size.width, 44);
    [self.letaoCustomNavView addSubview:letaoNavTitleLabel];
    if (self.needBack) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, kStatusBarHeight, 50, 44);
        [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        leftButton.tag = 45564;
        [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.letaoCustomNavView addSubview:leftButton];
    }

    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(self.letaoCustomNavView.bounds.size.width - 44 , kStatusBarHeight, 44, 44);
//    [rightButton setImage:[UIImage imageNamed:@"xingletao_mine_header_setting"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.letaoCustomNavView addSubview:rightButton];
}




- (void)letaoShowLoading{
//    self.loadingViewBgColor = [UIColor clearColor];
//    [super letaoShowLoading];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoTriggerRefresh];
    [self letaohiddenNavigationBar:YES];
    if (!self.letaoCustomNavView.alpha) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      if (@available(iOS 11.0, *)) {
          self.collectionView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
      } else {
          // Fallback on earlier versions
          self.automaticallyAdjustsScrollViewInsets = NO;
      }
    self.view.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    self.collectionView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F5];
    
    
    if (self.needBack) {
        [self.view addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(kStatusBarHeight);
            make.left.mas_equalTo(10);
        }];
    }
    [self buildBottomButton];
    
    [self headerViewLoadLocalCache];
    [self letaoSetupCustomNavView];
}
- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}


- (void)headerViewLoadLocalCache {
    if (self.headerView.model == nil) {
        XLTVipTaskModel *task = [XLTVipLogic getVipTaskListResponseCache];
        if (task) {
            self.headerView.model = task;
        }
    }
    
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    XLT_WeakSelf;
//    success(@[]);
    [XLTUserInfoLogic xingletaonetwork_requestUserInfoSuccess:^(id  _Nonnull balance) {
        XLT_StrongSelf;
        XLT_WeakSelf;
        [XLTVipLogic getVipRightListWithSuccess:^(id  _Nonnull object) {
            XLT_StrongSelf;
            XLT_WeakSelf;
            [XLTVipLogic getVipTaskListWithSuccess:^(id  _Nonnull object) {
                    XLT_StrongSelf;
                    self.headerView.model = object;
                XLTVipRightsModel *model = [XLTUserManager shareManager].rightModel;
                XLTVipRightItem *curItem = nil;
                for (XLTVipRightItem *item in model.list) {
                    if (item.level.intValue == model.level.intValue) {
                        curItem = item;
                    }
                }
                
                success(curItem.moreimg);
//                if (![XLTAppPlatformManager shareManager].showVipBuy){
//                    success(@[]);
//                }
            //        [self.headerView configWithLevel];
                } failure:^(NSString * _Nonnull errorMsg) {
//                    if (![XLTAppPlatformManager shareManager].showVipBuy){
                        failed(nil,errorMsg);
//                    }
                }];
        } failure:^(NSString * _Nonnull errorMsg) {
            [XLTVipLogic getVipTaskListWithSuccess:^(id  _Nonnull object) {
                    XLT_StrongSelf;
                    self.headerView.model = object;
//                if (![XLTAppPlatformManager shareManager].showVipBuy){
                    success(@[]);
//                }
               
            //        [self.headerView configWithLevel];
                } failure:^(NSString * _Nonnull errorMsg) {
//                    if (![XLTAppPlatformManager shareManager].showVipBuy){
                        failed(nil,errorMsg);
//                    }
                }];
        }];
        
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];
//    if ([XLTAppPlatformManager shareManager].showVipBuy) {
//        [XLTVipLogic getVipGoodsListWithPage:[NSString stringWithFormat:@"%ld",index] row:[NSString stringWithFormat:@"%ld",pageSize] success:^(id  _Nonnull object) {
//            success(object);
//
//        } failure:^(NSString * _Nonnull errorMsg) {
//            failed(nil,errorMsg);
//        }];
//    }
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentSize.height < self.view.height + 80) {
//        return;
//    }
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    if (scrollView.contentOffset.y > 0) {
        [self removeBottomButtonAnimate];
    }
    CGFloat thresholdDistance = kSafeAreaInsetsTop;
    if (scrollView.contentOffset.y >= thresholdDistance) {
        self.letaoCustomNavView.alpha = 1.0;
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    } else {
        if (scrollView.contentOffset.y >= thresholdDistance -kSafeAreaInsetsTop) {
            CGFloat percent = (scrollView.contentOffset.y -( thresholdDistance -kSafeAreaInsetsTop))/kSafeAreaInsetsTop;
            percent = MAX(0, MIN(1, percent));
            self.letaoCustomNavView.alpha = percent;
            if (percent > 0) {
                if (@available(iOS 13.0, *)) {
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
                } else {
                    // Fallback on earlier versions
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                }
            }
            
//            [UIApplication sharedApplication].statusbar
        } else {
            self.letaoCustomNavView.alpha = 0;
            if (@available(iOS 13.0, *)) {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            } else {
                // Fallback on earlier versions
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self showBottomButtonAnimate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self showBottomButtonAnimate];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
     [self showBottomButtonAnimate];
}

// registerTableViewCells should overwrite by sub class
- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTVipGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTVipGoodsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTVipPictureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTVipPictureCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"vipHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"vipFooter"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)pictureCell:(XLTVipPictureCell *)cell imageSizeChanged:(UIImage *)image imageSize:(CGSize)size {
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}


#define kDefaultPictureCellHeight 100

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTVipPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTVipPictureCell" forIndexPath:indexPath];
    cell.delegate = self;
    XLTVipMoreImageModel *imageModel = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    NSString *imageStr = imageModel.icon;
    if (self.pictureCellDisplayInfo == nil) {
        self.pictureCellDisplayInfo = [NSMutableDictionary dictionary];
    }
    if (imageStr) {
        XLTVipPictureCellDisplayModel *displayModel = self.pictureCellDisplayInfo[imageStr];
        if (displayModel == nil) {
            displayModel = [XLTVipPictureCellDisplayModel new];
            displayModel.imageUrl = imageStr;
            displayModel.jumpUrl = imageModel.url;
            displayModel.height = kDefaultPictureCellHeight;
            self.pictureCellDisplayInfo[imageStr] = displayModel;
        }
        cell.picImageView.hidden = NO;
        [cell letaoUpdateCellDataWithInfo:displayModel];
    } else {
        cell.picImageView.hidden = YES;
    }
    return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"vipHeader" forIndexPath:indexPath];
        [headerView addSubview:self.headerView];
//        headerView.height = self.headerHeight;
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(headerView);
        }];
        return headerView;
    }else{
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"vipFooter" forIndexPath:indexPath];
//        [headerView addSubview:self.headerView];
        return view;
    }
    
}
- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (self.headerHeight) {
        return CGSizeMake(kScreenWidth, self.headerHeight);
//    }else{
//        return CGSizeMake(kScreenWidth, 715);
//    }
//    return CGSizeMake(kScreenWidth, 715);

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 10);
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *imageStr = [self.letaoPageDataArray objectAtIndex:indexPath.row];

    XLTVipPictureCellDisplayModel *displayModel = self.pictureCellDisplayInfo[imageStr];
    if (displayModel != nil) {
        return CGSizeMake(kScreenWidth, displayModel.height);
    } else {
        return CGSizeMake(kScreenWidth, kDefaultPictureCellHeight);
    }
}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)headerHeight{
    CGFloat height = self.headerView.height;
    height = height < self.view.height + kTopHeight ? self.view.height + kTopHeight : height;
    return height;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.letaoPageDataArray.count) {
        XLTVipMoreImageModel *imageModel = [self.letaoPageDataArray objectAtIndex:indexPath.row];
        if ([imageModel isKindOfClass:[XLTVipMoreImageModel class]]) {
            NSString *url = imageModel.url;
            if ([url isKindOfClass:[NSString class]] && url.length) {
                [self pushToTaskVC:url];

            }
        }
    }
}

- (void)pushToTaskVC:(NSString *)url{
    if ([url isKindOfClass:[NSString class]] && url.length >0) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
          NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
          [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              if (obj.name) {
                  queryParameters[obj.name] = obj.value;
              }
          }];
          NSString *needLogin = queryParameters[@"needLogin"];
          BOOL isNeedLogin = (([needLogin isKindOfClass:[NSString class]] || [needLogin isKindOfClass:[NSNumber class]]) && [needLogin boolValue]);
          if (isNeedLogin
              && ![[XLTUserManager shareManager] isLogined]) {
              [[XLTUserManager shareManager] displayLoginViewController];
          } else {
              XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
              web.jump_URL = url;
              web.title = @"星乐桃";
              [self.navigationController pushViewController:web animated:YES];
          }
    }
}

#pragma mark HeaderView Delegate
- (void)scrollVipRight:(NSInteger)level headerHeight:(CGFloat)height{
    XLTVipRightItem *levelitem = nil;
    for (XLTVipRightItem *item in [XLTUserManager shareManager].rightModel.list) {
        if (level == 0) {
            if (item.level.intValue==[XLTUserManager shareManager].curUserInfo.level.intValue) {
                levelitem = item;
            }
        }else{
            if (item.level.intValue==[XLTUserManager shareManager].curUserInfo.level.intValue + 1) {
                levelitem = item;
            }
        }
        
    }
    self.letaoPageDataArray = [NSMutableArray arrayWithArray:levelitem.moreimg];
    [self.collectionView reloadData];
}
- (void)upScrollAction{
    XLTContactMentorVC *vc = [[XLTContactMentorVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)buildBottomButton {
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:16];
    bottomButton.layer.masksToBounds = YES;
    bottomButton.layer.cornerRadius = 22.5;
    UIImage *bgNormal = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAD01],[UIColor colorWithHex:0xFFFF6D01]] gradientType:1 imgSize:CGSizeMake(280, 45)];
    [bottomButton setBackgroundImage:bgNormal forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(invateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    self.bottomButton = bottomButton;
    
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(280);
    }];
}



- (void)showBottomButtonAnimate {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeBottomButtonAnimate {
    CGFloat tx = 0;
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    CGFloat ty = safeAreaInsetsBottom + self.bottomButton.bounds.size.height + 15;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomButton.transform = CGAffineTransformMakeTranslation(tx, ty);
    } completion:^(BOOL finished) {
    }];
}

@end
