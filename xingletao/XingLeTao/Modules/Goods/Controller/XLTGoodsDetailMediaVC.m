//
//  XLTGoodsDetailMediaVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailMediaVC.h"

#import "SDCycleScrollView.h"
#import "HMSegmentedControl.h"
#import "XLDGoodsDetailVideoView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
#import "UIImage+UIColor.h"

@interface XLTGoodsDetailMediaVC () <JPVideoPlayerDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) IBOutlet SDCycleScrollView *letaoCycleScrollView;
@property (nonatomic, assign) NSInteger letaoCurrentCycleIndex;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) XLDGoodsDetailVideoView *letaoDetailVideoView;
@property (nonatomic, assign) JPVideoPlayerStatus letaoCurrentVideoPlayerStatus;
@property (nonatomic, strong) UILabel *currentSDCycleIndexLabel;
@property (nonatomic, strong) IBOutlet UIButton *saveAlbumBtn;

@end

@implementation XLTGoodsDetailMediaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.letaoCurrentCycleIndex = -1;
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view from its nib.
    self.letaoCycleScrollView.infiniteLoop = NO;
    self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.letaoCycleScrollView.autoScroll = NO;
    self.letaoCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    self.letaoCycleScrollView.imageURLStringsGroup = self.letaoImageArray;
    self.letaoCycleScrollView.delegate = self;
    if (self.letaoVideoArray.count > 0) {
        [self letaoShowVideoBtn];
    }
    self.letaoCycleScrollView.backgroundColor = [UIColor clearColor];
    [self letaoSetupCycleScrollIndicator:self.letaoImageArray];
    [self.letaoDetailVideoView setJp_videoPlayerDelegate:self];
    
    [self letaoSetupSegmentedControl];
    
    [self loadSaveAlbumBtnStyle];
}

- (void)letaoSetupSegmentedControl {
    // 配置`菜单视图`
    _segmentedControl = [[HMSegmentedControl alloc] init];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.selectionIndicatorHeight = 1.0;
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
    _segmentedControl.userDraggable = NO;
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    if (self.letaoVideoArray.count > 0) {
        _segmentedControl.sectionTitles = @[@"视频",@"图片"];
    } else {
        _segmentedControl.sectionTitles = @[@"图片"];
    }
    [_segmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.sectionTitles.count > 1) {
        if (segmentedControl.selectedSegmentIndex == 0) {
            [self letaoVideoBtnAction];
        } else {
            [self letaoImageBtnAction];
        }
    }
}


- (void)letaoVideoBtnAction {
    if (self.letaoCycleScrollView.imageURLStringsGroup.count > 0) {
        @try {
            UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
            if ([collectionView isKindOfClass:[UICollectionView class]]) {
                [collectionView addSubview:self.letaoDetailVideoView];
                [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }

}

- (void)letaoImageBtnAction {
    NSArray *letaoVideoUrlArray = [self letaoImageArray];
    BOOL haveVideo = (letaoVideoUrlArray.count > 0);
    if (haveVideo && self.letaoCycleScrollView.imageURLStringsGroup.count > 1) {
        @try {
            UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
            if ([collectionView isKindOfClass:[UICollectionView class]]) {
                [collectionView addSubview:self.letaoDetailVideoView];
                [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
 
}

- (void)cycleScrollToItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
    @try {
        UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
        if ([collectionView isKindOfClass:[UICollectionView class]]) {
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)letaoShowVideoBtn {
    if (self.letaoDetailVideoView == nil)  {
        self.letaoDetailVideoView = [[XLDGoodsDetailVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreen_iPhone375Scale(425))];
        self.letaoDetailVideoView.autoresizingMask =UIViewAutoresizingFlexibleHeight;
        [self.letaoDetailVideoView.letaoVideoPlayBtn addTarget:self action:@selector(letaoPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        @try {
            UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
            if ([collectionView isKindOfClass:[UICollectionView class]]) {
                [collectionView addSubview:self.letaoDetailVideoView];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    self.letaoDetailVideoView.letaoVideoPlayBtn.hidden = NO;

    
}



- (void)letaoPlayVideo:(UIButton *)videoPlayButton {
    [self letaoRemoveVideoBtn];
    if (self.letaoVideoUrl) {
        [self.letaoDetailVideoView jp_stopPlay];
        [self.letaoDetailVideoView jp_playVideoWithURL:[NSURL   URLWithString:self.letaoVideoUrl]
                                bufferingIndicator:nil
                                       controlView:nil
                                      progressView:nil
                                     configuration:nil];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.segmentedControl.frame = CGRectMake(0, kStatusBarHeight, 170, 44);
    self.segmentedControl.center = CGPointMake(self.view.center.x, self.segmentedControl.center.y);
    
    self.letaoDetailVideoView.frame = CGRectMake(0, 0, kScreenWidth, self.letaoCycleScrollView.bounds.size.height);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.letaoFristIndex > 0 && self.letaoFristIndex < self.letaoImageArray.count) {
        [self cycleScrollToItemAtIndex:self.letaoFristIndex animated:NO];
        if (_segmentedControl.sectionTitles.count > 1) {
            _segmentedControl.selectedSegmentIndex = 1;
        }
    }
    NSInteger index = self.letaoFristIndex;
    NSArray *letaoVideoUrlArray = self.letaoVideoArray;
    if (self.letaoCycleScrollView.imageURLStringsGroup.count >0) {
        self.currentSDCycleIndexLabel.hidden = (index==0 && letaoVideoUrlArray.count >0);
        NSInteger pageIndex = self.letaoVideoUrl ? index:index+1;
        self.currentSDCycleIndexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)pageIndex,(unsigned long)(self.letaoCycleScrollView.imageURLStringsGroup.count - letaoVideoUrlArray.count)];
    } else {
        self.currentSDCycleIndexLabel.hidden = YES;
    }

}


- (BOOL)shouldAutoReplayForURL:(nonnull NSURL *)videoURL {
    return NO;
}



- (BOOL)shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackgroundForURL:(NSURL *)videoURL {
    return NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (self.letaoVideoUrl != nil && self.letaoFristIndex == 0) {
        [self.letaoDetailVideoView jp_resumePlayWithURL:[NSURL URLWithString:self.letaoVideoUrl]
                                 bufferingIndicator:nil
                                        controlView:nil
                                       progressView:nil
                                      configuration:nil];
          self.letaoDetailVideoView.jp_progressView.tintColor = [UIColor letaomainColorSkinColor];
    }
}

- (IBAction)letaoLeftButtonClicked {
    if (self.letaoVideoUrl) {
        if ([self.delegate respondsToSelector:@selector(letaoVideoVCWillBack:playerStatus:)]) {
            [self.delegate letaoVideoVCWillBack:self playerStatus:self.letaoDetailVideoView.jp_playerStatus];
        }
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didScrollToIndex:(NSInteger)index {
    if (self.letaoCurrentCycleIndex != index) {
        self.letaoCurrentCycleIndex = index;
        NSArray *letaoVideoUrlArray = self.letaoVideoArray;
        BOOL haveVideo = (letaoVideoUrlArray.count > 0);
        if (haveVideo && index == 0) {
            // 播放视频
            if (self.letaoCurrentVideoPlayerStatus == JPVideoPlayerStatusPause) {
                [self.letaoDetailVideoView jp_resume];
            }
        } else {
            if (haveVideo) {
                if (self.letaoCurrentVideoPlayerStatus == JPVideoPlayerStatusPlaying) {
                    [self.letaoDetailVideoView jp_pause];
                }
            }
        }
        
        if ((index==0 && letaoVideoUrlArray.count >0)
            &&  self.segmentedControl.sectionTitles.count > 0) {
            self.segmentedControl.selectedSegmentIndex = 0;
        } else {
            self.segmentedControl.selectedSegmentIndex =  self.segmentedControl.sectionTitles.count -1;
        }
            if (self.letaoCycleScrollView.imageURLStringsGroup.count >0) {
                self.currentSDCycleIndexLabel.hidden = (index==0 && letaoVideoUrlArray.count >0);
                NSInteger pageIndex = self.letaoVideoUrl ? index:index+1;
                self.currentSDCycleIndexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)pageIndex,(unsigned long)(self.letaoCycleScrollView.imageURLStringsGroup.count - letaoVideoUrlArray.count)];
            } else {
                self.currentSDCycleIndexLabel.hidden = YES;
            }
    }
}

- (void)letaoRemoveVideoBtn {
    self.letaoDetailVideoView.letaoVideoPlayBtn.hidden = YES;

}

- (void)playerStatusDidChanged:(JPVideoPlayerStatus)playerStatus {
    if (playerStatus != self.letaoCurrentVideoPlayerStatus) {
        self.letaoCurrentVideoPlayerStatus = playerStatus;
        if (self.letaoCurrentVideoPlayerStatus != JPVideoPlayerStatusStop) {
            [self letaoRemoveVideoBtn];
        } else {
            [self letaoShowVideoBtn];
            if (self.letaoDetailVideoView.jp_viewInterfaceOrientation != JPVideoPlayViewInterfaceOrientationLandscape) {
                 [self.letaoDetailVideoView jp_stopPlay];
            } else {
                [self.letaoDetailVideoView jp_gotoPortraitAnimated:YES completion:^{
                    [self.letaoDetailVideoView jp_stopPlay];
                }];
            }
        }
    }

}

- (void)letaoSetupCycleScrollIndicator:(NSArray *)imageURLStringsGroup {
    
    // 设置
    if (imageURLStringsGroup.count > 1) {
        if (self.currentSDCycleIndexLabel == nil) {
            self.currentSDCycleIndexLabel = [UILabel new];
            [self.view addSubview:self.currentSDCycleIndexLabel];
            self.currentSDCycleIndexLabel.textColor = [UIColor colorWithHex:0xFF333333];
            self.currentSDCycleIndexLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            self.currentSDCycleIndexLabel.textAlignment = NSTextAlignmentCenter;
            self.currentSDCycleIndexLabel.font = [UIFont letaoRegularFontWithSize:10.0];
            self.currentSDCycleIndexLabel.layer.masksToBounds = YES;
            self.currentSDCycleIndexLabel.layer.cornerRadius = 10;
            self.currentSDCycleIndexLabel.adjustsFontSizeToFitWidth = YES;
            [self.currentSDCycleIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@40);
                make.height.height.equalTo(@20);
                make.right.mas_equalTo(self.view.mas_right).offset(-10);
                make.top.mas_equalTo(self.letaoCycleScrollView.mas_bottom).offset(20);
            }];
        }
        NSInteger index = self.letaoFristIndex;
        NSArray *letaoVideoUrlArray = self.letaoVideoArray;
        if (self.letaoCycleScrollView.imageURLStringsGroup.count >0) {
            self.currentSDCycleIndexLabel.hidden = (index==0 && letaoVideoUrlArray.count >0);
            NSInteger pageIndex = self.letaoVideoUrl ? index:index+1;
            self.currentSDCycleIndexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)pageIndex,(unsigned long)(self.letaoCycleScrollView.imageURLStringsGroup.count - letaoVideoUrlArray.count)];
        } else {
            self.currentSDCycleIndexLabel.hidden = YES;
        }
    }
}


- (void)loadSaveAlbumBtnStyle {
    UIImage *bgImage = [UIImage gradientColorImageFromColors: @[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:CGSizeMake(kScreenWidth - 30, 44)];
    [self.saveAlbumBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
}


- (IBAction)saveAlbumAction {
    NSInteger letaoCurrentCycleIndex = self.letaoCurrentCycleIndex;
    NSArray *imageURLStringsGroup = self.letaoCycleScrollView.imageURLStringsGroup;
    if (letaoCurrentCycleIndex == -1) {
        letaoCurrentCycleIndex = self.letaoFristIndex;
    }
    if (letaoCurrentCycleIndex >=0 && letaoCurrentCycleIndex < imageURLStringsGroup.count) {
        BOOL haveVideo = (self.letaoVideoArray.count > 0);
        NSMutableArray *letaoVideoArray = [NSMutableArray array];
        NSMutableArray *letaoImageArray = [NSMutableArray array];
        if (haveVideo && letaoCurrentCycleIndex == 0) {
            if (self.letaoVideoUrl) {
                [letaoVideoArray addObject:self.letaoVideoUrl];
            }
        } else {
             [letaoImageArray addObject:imageURLStringsGroup[letaoCurrentCycleIndex]];
        }
        // 开始下载
         [self letaoShowLoading];
        __weak typeof(self)weakSelf = self;
        [self downloadImages:letaoImageArray videosUrls:letaoVideoArray complete:^(NSArray *videoArray, NSArray *imageArray) {
            [weakSelf letaoRemoveLoading];
            [weakSelf saveAlbumWithVideoArray:videoArray imageArray:imageArray];
        }];
    }
}

- (void)downloadImages:(NSArray *)imageUrls videosUrls:(NSArray *)videosUrls complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    NSInteger totalTaskCount = imageUrls.count + videosUrls.count;
    __block NSInteger downloadTaskCount = 0;
    NSMutableArray *downImageArray = [NSMutableArray array];
    NSMutableArray *downVideosArray = [NSMutableArray array];
    if (totalTaskCount > 0) {
        if (imageUrls.count > 0) {
            [imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *imageUrl = (NSString *)obj;
                if ([imageUrl isKindOfClass:[NSString class]]) {
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (image && !error) {
                                [downImageArray addObject:image];
                            }
                            downloadTaskCount ++;
                            if (downloadTaskCount >= totalTaskCount) {
                                complete(downVideosArray,downImageArray);
                                *stop = YES;
                            }
                        });
                    }];
                } else {
                    downloadTaskCount ++;
                    if (downloadTaskCount >= totalTaskCount) {
                        complete(downVideosArray,downImageArray);
                        *stop = YES;
                    }
                }
            }];
        }

        if (videosUrls.count > 0) {
            [videosUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *videosUrl = (NSString *)obj;
                if ([videosUrl isKindOfClass:[NSString class]]) {
                    [XLTNetworkHelper downloadWithURL:videosUrl fileDir:nil progress:nil success:^(NSString *filePath) {
                        if (filePath) {
                            [downVideosArray addObject:filePath];
                        }
                        downloadTaskCount ++;
                        if (downloadTaskCount >= totalTaskCount) {
                            complete(downVideosArray,downImageArray);
                            *stop = YES;
                        };
                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                        downloadTaskCount ++;
                        if (downloadTaskCount >= totalTaskCount) {
                            complete(downVideosArray,downImageArray);
                            *stop = YES;
                        }
                    }];
                } else {
                    downloadTaskCount ++;
                    if (downloadTaskCount >= totalTaskCount) {
                        complete(downVideosArray,downImageArray);
                        *stop = YES;
                    }
                }
            }];
        }
    } else {
         complete(downVideosArray,downImageArray);
    }
   
}


- (void)saveAlbumWithVideoArray:(NSArray *)videoArray imageArray:(NSArray *)imageArray {
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
