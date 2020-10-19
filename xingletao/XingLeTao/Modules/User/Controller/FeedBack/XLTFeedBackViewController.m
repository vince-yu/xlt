//
//  XLTFeedBackViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackViewController.h"
#import "XLTFeedBackInputPhoneCell.h"
#import "XLTFeedBackMediaCell.h"
#import "XLTFeedBackMediaFooter.h"
#import "XLTFeedBackMediaHeader.h"
#import "XLTFeedBackTextViewCell.h"
#import "XLTFeedBackListCell.h"
#import "TZImagePickerController.h"
#import "UIImage+UIColor.h"
#import "TZImageUploadOperation.h"
#import "XLTLogManager.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "XLTSchoolFullScreenSJVideoVC.h"
#import "XLTFeedBackLogic.h"
#import "XLTBGCollectionViewFlowLayout.h"

@interface XLTFeedBackViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, XLTFeedBackTextViewCellDelegate,KSPhotoBrowserDelegate, XLTFeedBackMediaCellDelegate, XLTBGCollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) NSMutableArray *selectAssetsList;
@property (nonatomic, strong) UIButton *feedBackButton;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, copy) NSString *feedBackText;

@end

@implementation XLTFeedBackViewController
#define kFeedBackButtonHeight 44.0
#define kFeedBackButtonBottom 22.0
#define kFeedBackButtonTop 12.0

- (void)dealloc {
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要反馈";
    self.mediaArray = [NSMutableArray arrayWithObject:[NSNull null]];
    [self loadContentTableView];
    [self loadFeedBackButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"xlt_mine_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    XLTBGCollectionViewFlowLayout *flowLayout = [[XLTBGCollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)loadContentTableView {
    UICollectionViewFlowLayout *flowLayout = [self collectionViewLayout];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    CGRect rect = CGRectMake(15, 0, self.view.bounds.size.width -30, self.view.bounds.size.height - safeAreaInsetsBottom - (kFeedBackButtonHeight + kFeedBackButtonBottom + kFeedBackButtonTop));
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoListRegisterCells];
    [self.view addSubview:_collectionView];
}

- (void)letaoListRegisterCells {
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackInputPhoneCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTFeedBackInputPhoneCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackTextViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTFeedBackTextViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackMediaCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTFeedBackMediaCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackMediaHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTFeedBackMediaHeader"];
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackMediaFooter" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XLTFeedBackMediaFooter"];

}

- (void)loadFeedBackButton {
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    UIButton *feedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [feedBackButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateNormal];
    [feedBackButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]] forState:UIControlStateDisabled];

    [feedBackButton setTitle:@"提交" forState:UIControlStateNormal];
    feedBackButton.titleLabel.font = [UIFont letaoRegularFontWithSize:15];
    [feedBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedBackButton addTarget:self action:@selector(feedBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    feedBackButton.layer.masksToBounds =  YES;
    feedBackButton.layer.cornerRadius = kFeedBackButtonHeight/2.0;
    [self.view addSubview:feedBackButton];
    [feedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(kFeedBackButtonTop);
        make.height.equalTo(@kFeedBackButtonHeight);
    }];
    feedBackButton.enabled = NO;
    self.feedBackButton = feedBackButton;
}



#pragma mark -  UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.mediaArray.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTFeedBackTextViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTFeedBackTextViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        XLTFeedBackMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTFeedBackMediaCell" forIndexPath:indexPath];
        BOOL isVideo = NO;
        if (indexPath.item < self.selectAssetsList.count) {
            PHAsset *asset = self.selectAssetsList[indexPath.item];
            isVideo = (asset.mediaType == PHAssetMediaTypeVideo);
        }
        cell.delegate = self;
        [cell updatePhoto:self.mediaArray[indexPath.item] isVideo:isVideo];
        return cell;
    } else {
        XLTFeedBackInputPhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTFeedBackInputPhoneCell" forIndexPath:indexPath];
        return cell;
    }

}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.bounds.size.width, 208.0);
    } else if (indexPath.section == 1) {
        CGFloat space = 5.0;
        CGFloat leftMargin = 10;
        CGFloat itemWidth = floorf((collectionView.bounds.size.width - space*4 - leftMargin*2)/5);
        return CGSizeMake(itemWidth, itemWidth);
    } else {
        return CGSizeMake(collectionView.bounds.size.width, 85.0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return UIEdgeInsetsMake(0, 10.0, 0, 10.0);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, 44.0);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, 59.0);
    }
   return CGSizeZero;
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (kind == UICollectionElementKindSectionHeader) {
         XLTFeedBackMediaHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTFeedBackMediaHeader" forIndexPath:indexPath];
         return headerView;
     } else {
         XLTFeedBackMediaFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XLTFeedBackMediaFooter" forIndexPath:indexPath];
         footerView.mediaCountLabel.text = [NSString stringWithFormat:@"%ld/6",(long)self.selectAssetsList.count];
         return footerView;
     }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.item < self.mediaArray.count) {
            UIImage *info = self.mediaArray[indexPath.item];
            if ([info isKindOfClass:[UIImage class]]) {
                if (indexPath.item < self.selectAssetsList.count) {
                    PHAsset *asset = self.selectAssetsList[indexPath.item];
                    BOOL isVideo = (asset.mediaType == PHAssetMediaTypeVideo);
                    if (isVideo) {
                        [self playVideoWithPHAsset:asset];
                    } else {
                        NSMutableArray *photoArray = [NSMutableArray array];
                        [self.selectAssetsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if(idx < self.mediaArray.count) {
                                if ((((PHAsset *)obj).mediaType == PHAssetMediaTypeImage)) {
                                    UIImage *photo = self.mediaArray[idx];
                                    [photoArray addObject:photo];
                                }
                            }
                        }];
                        NSUInteger index = [photoArray indexOfObject:info];
                        if (index == NSNotFound) {
                            index = 0;
                        }
                        [self browseImages:photoArray atIndex:index];
                    }
                }

            } else {
                [self openImagePickerControllers];
            }
        }
    }
}

- (void)feedBackMediaCell:(XLTFeedBackMediaCell *)cell clearPhoto:(UIImage *)photo {
    NSUInteger index = [self.mediaArray indexOfObject:photo];
    if (index != NSNotFound) {
        [self.mediaArray removeObjectAtIndex:index];
        if (self.mediaArray.count < 6) {
            if (![self.mediaArray containsObject:[NSNull null]]) {
                [self.mediaArray addObject:[NSNull null]];
            }
        }
        if (index  < self.selectAssetsList.count) {
            [self.selectAssetsList removeObjectAtIndex:index];
        }
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:1];
        [self.collectionView reloadSections:reloadSet];
    }
   
}

- (void)browseImages:(NSArray *)imagesArray
             atIndex:(NSUInteger)index {
     [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
     KSPhotoBrowser.imageViewBackgroundColor = UIColor.clearColor;
     
     NSMutableArray *items = @[].mutableCopy;
     for (int i = 0; i < imagesArray.count; i++) {
         KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil image:imagesArray[i]];
         [items addObject:item];
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

// MARK: - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
//    NSLog(@"selected index: %ld", index);
}


- (void)playVideoWithPHAsset:(PHAsset *)asset  {
    [self letaoShowLoading];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(asset.mediaType == PHAssetMediaTypeVideo) {
            [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf playVideoWithUrl:outputPath];
                    [weakSelf letaoRemoveLoading];
                });
            } failure:^(NSString *errorMessage, NSError *error) {
                [weakSelf showTipMessage:@"获取视频失败"];
                [weakSelf letaoRemoveLoading];
            }];
        }
        
    });
}

- (void)playVideoWithUrl:(NSString *)url {
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[XLTSchoolFullScreenSJVideoVC class]]) {
        XLTSchoolFullScreenSJVideoVC *videoVC = [[XLTSchoolFullScreenSJVideoVC alloc] init];
        videoVC.letaoVideoUrl = url;
        videoVC.isfileURLPath = YES;
        [self.navigationController pushViewController:videoVC animated:YES];
    }
}


- (void)openImagePickerControllers {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];
    imagePickerVC.selectedAssets = self.selectAssetsList;
    // 在内部显示拍照按钮
    imagePickerVC.allowTakePicture = YES;
    imagePickerVC.allowPickingVideo = YES;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingGif = NO;
    imagePickerVC.allowPickingMultipleVideo = YES;
    imagePickerVC.oKButtonTitleColorNormal = [UIColor letaomainColorSkinColor];
    imagePickerVC.oKButtonTitleColorDisabled = [[UIColor letaomainColorSkinColor] colorWithAlphaComponent:0.3];
    imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.mediaArray = photos.mutableCopy;
    if (self.mediaArray.count < 6) {
        [self.mediaArray addObject:[NSNull null]];
    }
    self.selectAssetsList = assets.mutableCopy;
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:1];
    [self.collectionView reloadSections:reloadSet];
}


- (void)feedBackTextViewCell:(XLTFeedBackTextViewCell *)cell textDidChanged:(NSString *)text {
    self.feedBackButton.enabled = text.length > 2;
    self.feedBackText = text;
}

- (void)feedBackButtonAction {
    
    NSString *content = self.feedBackText;
    NSString *phone = nil;
    XLTFeedBackInputPhoneCell *cell = (XLTFeedBackInputPhoneCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
    if ([cell isKindOfClass:[XLTFeedBackInputPhoneCell class]]) {
        if (cell.phoneTextField.text) {
            phone = cell.phoneTextField.text;
        }
    }
    if ([phone isKindOfClass:[NSString class]] && phone.length > 0) {
        if (![self verifyPhoneNumber:phone]) {
            [self showTipMessage:@"手机号格式有误，请重新填写"];
            return;
        }
    }
    
    [self letaoShowLoading];

    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    __weak __typeof(self)weakSelf = self;
    NSMutableArray *uploadFileInfoArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.selectAssetsList.count; i++) {
        PHAsset *asset = self.selectAssetsList[i];
        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
            NSLog(@"图片获取&上传完成");
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            NSLog(@"获取原图进度 %f", progress);
        }];
        
        operation.uploadBlock = ^(NSDictionary * _Nonnull adInfo, BOOL success) {
            if (success && adInfo) {
                NSString *fileUrl = adInfo[@"file"];
                if (fileUrl) {
                    [uploadFileInfoArray addObject:fileUrl];
                }
            } else {
                [weakSelf hasUploadFailed];
            }
        };
        [self.operationQueue addOperation:operation];
    }
    

    NSBlockOperation *logOp = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XLTLogManager sharedInstance] uploadLogWithInputText:nil success:^(NSDictionary * _Nonnull info) {
                 [weakSelf letaoRemoveLoading];
                  if (info) {
                      NSString *log_url = info[@"file"];
                      NSArray *enclosure = [uploadFileInfoArray copy];
                      [XLTFeedBackLogic feedBackWithPhone:phone log_url:log_url content:content enclosure:enclosure success:^(NSDictionary *info,NSURLSessionDataTask * task) {
                          [weakSelf letaoRemoveLoading];
                          [weakSelf showTipMessage:@"提交成功"];
                          [weakSelf popBackAndRefresh];
                      } failure:^(NSString *errorMsg,NSURLSessionDataTask * task) {
                          [weakSelf showTipMessage:errorMsg];
                      }];
                      
                  }
             } failure:^(NSString * _Nonnull errorMsg) {
                 [weakSelf hasUploadFailed];
             }];
            
        });
    }];
    [self.operationQueue addOperation:logOp];
}

- (void)hasUploadFailed {
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
    [self showTipMessage:@"上传文件失败，请重试"];
    [self letaoRemoveLoading];
}


- (void)popBackAndRefresh {
    [self letaoPopViewControllerWithParameters:@{@"triggerRefresh":@""} animated:YES];
}

- (BOOL)verifyPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber && [phoneNumber isKindOfClass:[NSString class]]) {
        NSString *regex = @"1[3456789]\\d{9}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        // 字符串判断，然后BOOL值
        BOOL result = [predicate evaluateWithObject:phoneNumber];
        return result;
    } else {
        return NO;
    }
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [UIColor whiteColor];
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
