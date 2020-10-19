//
//  XLTStartRecommedViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTStartRecommedViewController.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "TZImagePickerController.h"
#import "XLTStartRecommedTextCell.h"
#import "XLTStartRecommedGoodsCell.h"
#import "XLTStartRecommedMediaCell.h"
#import "XLTStartRecommedFooterCell.h"
#import "XLTRecommedFeedUploadOperation.h"
#import "XLTRecommedFeedLogic.h"
#import "XLTInvetorAlterView.h"
#import "XLTMyRecommendVC.h"
#import "NSArray+Bounds.h"

@interface XLTStartRecommedViewController () <UICollectionViewDelegate, UICollectionViewDataSource,KSPhotoBrowserDelegate, TZImagePickerControllerDelegate, XLTStartRecommedTextCellDelegate, XLTStartRecommedMediaCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) NSMutableArray *selectAssetsList;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, copy) NSString *feedText;

@end

@implementation XLTStartRecommedViewController

- (void)dealloc {
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐商品";
    self.mediaArray = [NSMutableArray arrayWithObject:[NSNull null]];
    [self loadContentTableView];
    self.isTomorrow = @"0";
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 60, 28);
    [sendButton setTitle:@"提交" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:16];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 14.0;
    UIImage *bgNormal = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:sendButton.bounds.size];
    UIImage *bgDisabled = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];;
    [sendButton setBackgroundImage:bgNormal forState:UIControlStateNormal];
    [sendButton setBackgroundImage:bgDisabled forState:UIControlStateDisabled];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
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
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoListRegisterCells];
    [self.view addSubview:_collectionView];
}

- (void)letaoListRegisterCells {
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTStartRecommedTextCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTStartRecommedTextCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTStartRecommedGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTStartRecommedGoodsCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTStartRecommedMediaCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTStartRecommedMediaCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTStartRecommedFooterCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTStartRecommedFooterCell"];
}




#pragma mark -  UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 2) {
        return self.mediaArray.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTStartRecommedGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTStartRecommedGoodsCell" forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:self.goodsInfo];
        return cell;
    } else if (indexPath.section == 1) {
        XLTStartRecommedTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTStartRecommedTextCell" forIndexPath:indexPath];
        [cell updateFeedText:self.feedText];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        XLTStartRecommedMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTStartRecommedMediaCell" forIndexPath:indexPath];
        BOOL isVideo = NO;
        cell.delegate = self;
        [cell updatePhoto:self.mediaArray[indexPath.item] isVideo:isVideo];
        return cell;
    } else {
        XLTStartRecommedFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTStartRecommedFooterCell" forIndexPath:indexPath];
        XLT_WeakSelf;
        cell.showTomorrow = self.showTomorrow;
        cell.selectBlock = ^(NSString * _Nonnull isTomorrow) {
            XLT_StrongSelf;
            self.isTomorrow = isTomorrow;
        };
        return cell;
    }
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.bounds.size.width, 126.0);
    } else if (indexPath.section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, 200.0);
    } else if (indexPath.section == 2) {
        CGFloat space = 25.0;
        CGFloat leftMargin = 15;
        CGFloat itemWidth = floorf((collectionView.bounds.size.width - space*2 - leftMargin*2)/3);
        return CGSizeMake(itemWidth, itemWidth);
    } else {
        return CGSizeMake(collectionView.bounds.size.width, 175.0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return UIEdgeInsetsMake(20, 15, 20, 15);
    }
    return UIEdgeInsetsZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
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


- (void)recommedMediaCell:(XLTStartRecommedMediaCell *)cell clearPhoto:(UIImage *)photo {
    NSUInteger index = [self.mediaArray indexOfObject:photo];
    if (index != NSNotFound) {
        [self.mediaArray by_removeObjectAtIndex:index];
        if (self.mediaArray.count < 9) {
            if (![self.mediaArray containsObject:[NSNull null]]) {
                [self.mediaArray addObject:[NSNull null]];
            }
        }
        if (index  < self.selectAssetsList.count) {
            [self.selectAssetsList by_removeObjectAtIndex:index];
        }
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:1];
        [self.collectionView reloadSections:reloadSet];
        [self adjustRightBarButtonItem];
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
}


- (void)openImagePickerControllers {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVC.selectedAssets = self.selectAssetsList;
    // 在内部显示拍照按钮
    imagePickerVC.allowTakePicture = YES;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingGif = NO;
    imagePickerVC.allowPickingMultipleVideo = NO;
    imagePickerVC.oKButtonTitleColorNormal = [UIColor letaomainColorSkinColor];
    imagePickerVC.oKButtonTitleColorDisabled = [[UIColor letaomainColorSkinColor] colorWithAlphaComponent:0.3];
    imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.mediaArray = photos.mutableCopy;
    if (self.mediaArray.count < 9) {
        [self.mediaArray addObject:[NSNull null]];
    }
    self.selectAssetsList = assets.mutableCopy;
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:2];
    [self.collectionView reloadSections:reloadSet];
    
    [self adjustRightBarButtonItem];
}


- (void)recommedTextCell:(XLTStartRecommedTextCell *)cell textDidChanged:(NSString *)text {
    self.feedText = text;
    [self adjustRightBarButtonItem];
}

- (void)adjustRightBarButtonItem {
    NSMutableArray *mediaArray = self.mediaArray.mutableCopy;
    [self.mediaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([obj isKindOfClass:[UIImage class]] || [obj isKindOfClass:[NSString class]])) {
            [mediaArray removeObject:obj];
        }
    }];
    self.navigationItem.rightBarButtonItem.enabled = (self.feedText.length > 9 && mediaArray.count > 1);
}

- (void)sendButtonAction {
    NSString *feedText = self.feedText;
    [self letaoShowLoading];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    __weak __typeof(self)weakSelf = self;
    NSMutableArray *uploadFileInfoArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.selectAssetsList.count; i++) {
        PHAsset *asset = self.selectAssetsList[i];
        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
        XLTRecommedFeedUploadOperation *operation = [[XLTRecommedFeedUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
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
            NSArray *fileUrlArray = [uploadFileInfoArray copy];
            [weakSelf hasUploadSuccess:fileUrlArray feedText:feedText];
        });
    }];
    [self.operationQueue addOperation:logOp];
}

- (void)hasUploadFailed {
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
    [self showTipMessage:@"上传图片失败，请重试"];
    [self letaoRemoveLoading];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)hasUploadSuccess:(NSArray *)fileUrlArray feedText:(NSString *)feedText {
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
    // 发生数据
    if ([self.goodsInfo isKindOfClass:[NSDictionary class]]) {
        NSString *itemId = self.goodsInfo[@"item_id"];
        NSString *itemSource = self.goodsInfo[@"item_source"];
        NSString *goodsId = self.goodsInfo[@"_id"];
        __weak __typeof(self)weakSelf = self;
        [XLTRecommedFeedLogic recommendGoods:goodsId itemSource:itemSource itemId:itemId imageUrls:fileUrlArray contentText:feedText tomorrow:self.isTomorrow success:^(NSDictionary * _Nonnull stateInfo) {
            [weakSelf recommendGoodsSuccess:stateInfo];
            [weakSelf letaoRemoveLoading];
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showTipMessage:errorMsg];
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    } else {
        [self letaoRemoveLoading];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)recommendGoodsSuccess:(NSDictionary *)info {
    __weak typeof(self)weakSelf = self;
    [XLTInvetorAlterView showNamalAlterWithTitle:@"推荐成功" content:nil image:[UIImage imageNamed:@"xingletao_mine_suceessed"] leftBtnText:@"关闭" rightBtnText:@"查看推荐" leftBlock:^{
        [weakSelf closePageView];
        
    } rightBlock:^{
        // 查看推荐
        [weakSelf pushMyRecommendVC];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kXLTFeedRecommendGoodsSuccess" object:nil];
}

- (void)pushMyRecommendVC {
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    [viewControllers removeObject:self];
    if(![viewControllers.lastObject isKindOfClass:[XLTMyRecommendVC class]]) {
        XLTMyRecommendVC *myRecommendVC = [[XLTMyRecommendVC alloc] init];
        [viewControllers addObject:myRecommendVC];
    }
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)closePageView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kGoodsRecommedSuccessNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@interface XLTReRecommedViewController ()

@end

@implementation XLTReRecommedViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showTomorrow = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.imageUrlArray isKindOfClass:[NSArray class]]) {
        self.mediaArray = [NSMutableArray arrayWithArray:self.imageUrlArray];
        if (self.mediaArray.count < 9) {
            if (![self.mediaArray containsObject:[NSNull null]]) {
                [self.mediaArray addObject:[NSNull null]];
            }
        }
    }
    self.feedText = self.recommedText;
    [self adjustRightBarButtonItem];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return [self collectionView:collectionView recommedMediaCelForItemAtIndexPath:indexPath];
    } else {
        return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView recommedMediaCelForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLTStartRecommedMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTStartRecommedMediaCell" forIndexPath:indexPath];
    BOOL isVideo = NO;
    cell.delegate = self;
    NSString *image = self.mediaArray[indexPath.item];
    if ([image isKindOfClass:[NSString class]]) {
        [cell updatePhotoUrl:image isVideo:isVideo];
    } else {
        [cell updatePhoto:(UIImage *)image isVideo:isVideo];
    }
    return cell;
}


- (void)openImagePickerControllers {
    NSMutableArray *mediaArray = self.mediaArray.mutableCopy;
    [self.mediaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIImage class]]) {
            [mediaArray removeObject:obj];
        }
    }];
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX(0, 9-mediaArray.count) delegate:self];
    imagePickerVC.selectedAssets = self.selectAssetsList;
    // 在内部显示拍照按钮
    imagePickerVC.allowTakePicture = YES;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingGif = NO;
    imagePickerVC.allowPickingMultipleVideo = NO;
    imagePickerVC.oKButtonTitleColorNormal = [UIColor letaomainColorSkinColor];
    imagePickerVC.oKButtonTitleColorDisabled = [[UIColor letaomainColorSkinColor] colorWithAlphaComponent:0.3];
    imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    NSMutableArray *mediaArray = self.mediaArray.mutableCopy;
    [self.mediaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            [mediaArray removeObject:obj];
        }
    }];
    [mediaArray addObjectsFromArray:photos];
    self.mediaArray = mediaArray;
    if (self.mediaArray.count < 9) {
        [self.mediaArray addObject:[NSNull null]];
    }
    self.selectAssetsList = assets.mutableCopy;
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:2];
    [self.collectionView reloadSections:reloadSet];
    [self adjustRightBarButtonItem];
}

- (void)recommedMediaCell:(XLTStartRecommedMediaCell *)cell clearPhoto:(UIImage *)photo {
    NSUInteger index = [self.mediaArray indexOfObject:photo];
    if (index != NSNotFound) {
        if ([cell.itemPhoto isKindOfClass:[UIImage class]]) {
            NSMutableArray *imageArray = [NSMutableArray array];
            [self.mediaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIImage class]]) {
                    [imageArray addObject:obj];
                }
            }];
            NSUInteger assetsIndex = [imageArray indexOfObject:photo];
            if (assetsIndex != NSNotFound && assetsIndex < self.selectAssetsList.count) {
                [self.selectAssetsList removeObjectAtIndex:index];
            }
        }
        
        [self.mediaArray removeObjectAtIndex:index];
  
        
        if (self.mediaArray.count < 9) {
            if (![self.mediaArray containsObject:[NSNull null]]) {
                [self.mediaArray addObject:[NSNull null]];
            }
        }
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:1];
        [self.collectionView reloadSections:reloadSet];
        [self adjustRightBarButtonItem];
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.item < self.mediaArray.count) {
            UIImage *info = self.mediaArray[indexPath.item];
            if ([info isKindOfClass:[UIImage class]] || [info isKindOfClass:[NSString class]]) {
                [self browseImages:self.mediaArray atIndex:indexPath.item];
            } else {
                [self openImagePickerControllers];
            }
        }
    }
}

- (void)browseImages:(NSArray *)imagesArray
             atIndex:(NSUInteger)index {
     [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
     KSPhotoBrowser.imageViewBackgroundColor = UIColor.clearColor;
     
     NSMutableArray *items = @[].mutableCopy;
     for (int i = 0; i < imagesArray.count; i++) {
         UIImage *image = imagesArray[i];
         if ([image isKindOfClass:[UIImage class]]) {
             KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil image:imagesArray[i]];
             [items addObject:item];
         } else if ([image isKindOfClass:[NSString class]]) {
             NSString *imageUrl = (NSString *)image;
             KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil imageUrl:[NSURL URLWithString:[imageUrl letaoConvertToHttpsUrl]]];
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



- (void)sendButtonAction {
    NSString *feedText = self.feedText;
    [self letaoShowLoading];
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    __weak __typeof(self)weakSelf = self;
    NSMutableArray *uploadFileInfoArray = [NSMutableArray array];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    [self.mediaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [imageArray addObject:obj];
        }
    }];
    
    [self.mediaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            NSUInteger assetsIndex = [imageArray indexOfObject:obj];
            if (assetsIndex != NSNotFound && assetsIndex < self.selectAssetsList.count) {
                PHAsset *asset = self.selectAssetsList[assetsIndex];
                // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
                XLTRecommedFeedUploadOperation *operation = [[XLTRecommedFeedUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
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
        } else if ([obj isKindOfClass:[NSString class]]) {
            NSString *fileUrl = self.passUploadiImageInfo[obj];
            if (fileUrl) {
                [uploadFileInfoArray addObject:fileUrl];
            }
        }
    }];
    

    NSBlockOperation *logOp = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *fileUrlArray = [uploadFileInfoArray copy];
            [weakSelf hasUploadSuccess:fileUrlArray feedText:feedText];
        });
    }];
    [self.operationQueue addOperation:logOp];
}



@end
