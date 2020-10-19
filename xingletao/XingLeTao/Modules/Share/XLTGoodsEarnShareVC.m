//
//  XLTGoodsEarnShareVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsEarnShareVC.h"
#import "XLTPickImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+UIColor.h"
#import "XLTGoodsDisplayHelp.h"
#import <Photos/Photos.h>
#import "XLTShareManager.h"
#import "XLTUserTaskManager.h"
#import "XLTMyWatermarkLogic.h"

@interface XLTGoodsEarnShareVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *eranLabel;
@property (nonatomic, weak) IBOutlet UIImageView *eranBgImageView;
@property (nonatomic, weak) IBOutlet UILabel *pickImageLabel;
@property (nonatomic, weak) IBOutlet UIButton *saveAlbumButton;
@property (nonatomic, weak) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic, weak) IBOutlet UITextView *shareTextView;
@property (nonatomic, weak) IBOutlet UIButton *tklCopyButton;
@property (nonatomic, weak) IBOutlet UIButton *shareTextCopyButton;
@property (nonatomic, weak) IBOutlet UIView *bottomShareView;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableDictionary *pickedImageDictionary;
@property (nonatomic, strong) NSString *eranText;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *shareTextViewHeight;

@property (nonatomic ,strong) NSDictionary *needRepoTaskInfo;
@end

@implementation XLTGoodsEarnShareVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if ([self.needRepoTaskInfo isKindOfClass:[NSDictionary class]] && self.needRepoTaskInfo.count > 0) {
        [[XLTUserTaskManager shareManager] letaoRepoShareTaskInfo:self.needRepoTaskInfo];
        self.needRepoTaskInfo = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"创建分享";
    if (self.shareImageArray == nil) {
        self.shareImageArray = [NSMutableArray array];
    }
    
    if (self.pickedImageDictionary == nil) {
        self.pickedImageDictionary = [NSMutableDictionary dictionary];
    }
    
    if (self.sharePosterImage) {
        if (self.shareImageArray.count > 0) {
            [self.shareImageArray insertObject:self.sharePosterImage atIndex:0];
        } else {
            [self.shareImageArray addObject:self.sharePosterImage];
        }
        [self pickImageIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }
    [self pickedImageDictionaryChanged];
    
    [self updateShareTextLabelAttributedText];
    [self updateEarnTextLabelAttributedText];
    
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"XLTPickImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTPickImageCollectionViewCell"];
    [self cornerRadiusForButton:self.saveAlbumButton];
    [self cornerRadiusForButton:self.tklCopyButton];
    [self cornerRadiusForButton:self.shareTextCopyButton];
    
    self.eranBgImageView.image = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:CGSizeMake(kScreenWidth, 70)];
    
    self.tklCopyButton.hidden = !self.isAliSource;
    
    self.shareTextView.delegate = self;
    
    // 获取任务参数
    [self fetchUpperVCShareTaskInfoIfNeed];
    //
   
}

/**
*  获取上层视图的SharetaskInfo参数，for navgation
*/
- (void)fetchUpperVCShareTaskInfoIfNeed {
    if (self.taskInfo == nil) {
        NSMutableDictionary *taskInfo = [NSMutableDictionary dictionary];
        [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof XLTBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XLTBaseViewController class]]
                && [obj.taskInfo isKindOfClass:[NSDictionary class]]) {
                [taskInfo addEntriesFromDictionary:obj.taskInfo];
                *stop = YES;
            } else if ([obj isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabBarController = (UITabBarController *)obj;
                XLTBaseViewController *baseVC = tabBarController.viewControllers.firstObject;
                if ([baseVC isKindOfClass:[XLTBaseViewController class]]
                    && [baseVC.taskInfo isKindOfClass:[NSDictionary class]]) {
                        [taskInfo addEntriesFromDictionary:baseVC.taskInfo];
                        *stop = YES;
                }
            }
        }];
        // 是否是分享任务
        if (taskInfo.count > 0) {
            // 开始任务
            NSString *taskId = taskInfo[@"id"];
            // 分享商品任务
            if ([taskId isKindOfClass:[NSString class]] && [taskId isEqualToString:@"EverydayTaskThree"]) {
                NSNumber *type = taskInfo[@"type"];
                if ([type isKindOfClass:[NSString class]] || [type isKindOfClass:[NSNumber class]]) {
                    if ([type integerValue] == 2) {
                        // type: 2分享
                        self.taskInfo = taskInfo;
                    }
                }
            }

        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect shareTextViewRect  = [self.shareTextView.superview convertRect:self.shareTextView.frame toView:self.view];
    CGFloat height = ceilf ((self.bottomShareView.frame.origin.y - 20 -12 - shareTextViewRect.origin.y));
    self.shareTextViewHeight.constant = MAX(150.0, height);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""] && range.length > 0) {
         return YES;
     } else {
         if (textView.text.length - range.length + text.length > 600) {
             [self showTipMessage:@"文案不能超过600字"];
             return NO;
         }
     }
    return YES;
}


- (void)setGoodsInfo:(NSDictionary *)goodsInfo {
    _goodsInfo = goodsInfo.copy;
    [self updateTextData:goodsInfo];
    
}


- (void)updateTextData:(id _Nullable )itemInfo {
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;

    NSNumber *earnAmount = nil;
    BOOL isEarnAmountValid = NO;
    NSString *letaoGoodsTitleLabelString = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        originalPrice = itemInfo[@"item_min_price"];
        price = itemInfo[@"item_price"];
        letaoGoodsTitleLabelString = itemInfo[@"item_title"];
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
            if ([earnAmount isKindOfClass:[NSNumber class]] && [earnAmount integerValue] > 0) {
                isEarnAmountValid = YES;
            }
        }
    }
    self.eranText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
    
}

- (void)cornerRadiusForButton:(UIButton *)button {
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15.0;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    
}

- (void)updateShareTextLabelAttributedText {
    NSString *shareText = self.shareText;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;//段与段之间的间距
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:shareText];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName :paragraphStyle,
                                      NSFontAttributeName:[UIFont letaoRegularFontWithSize:13.0]
    } range:NSMakeRange(0, attributedString.length)];
    

    self.shareTextView.attributedText = attributedString;
}

- (void)updateEarnTextLabelAttributedText {
    NSString *eranText = [NSString stringWithFormat:@"分享赚:￥%@",self.eranText];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:eranText];

    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16.0]
    } range:NSMakeRange(0, 5)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:25.0]
       } range:NSMakeRange(5, attributedString.length - 5)];
    

    self.eranLabel.attributedText = attributedString;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}

#pragma mark -  UICollectionView


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLTPickImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTPickImageCollectionViewCell" forIndexPath:indexPath];
    NSString *imageUrl = [self.shareImageArray objectAtIndex:indexPath.row];
    if ([imageUrl isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:imageUrl];
        [cell.contentImageView sd_setImageWithURL:url];
    } else if ([imageUrl isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)imageUrl;
        [cell.contentImageView setImage:image];
    } else {
        [cell.contentImageView setImage:nil];
    }
    if ([self isPickImageIndexPath:indexPath]) {
        cell.coverView.hidden = NO;
        cell.pickImageView.image = [UIImage imageNamed:@"xinletao_edit_selected_icon"];
    } else {
        cell.coverView.hidden = YES;
        cell.pickImageView.image = [UIImage imageNamed:@"xinletao_edit_unselected_icon"];
    }
    cell.qrcodeLabel.hidden = (indexPath.row != 0);
    return cell;
}

- (BOOL)isPickImageIndexPath:(NSIndexPath *)indexPath {
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return ([self.pickedImageDictionary objectForKey:row] != nil);
}

- (void)pickImageIndexPath:(NSIndexPath *)indexPath {
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.pickedImageDictionary setObject:@"1" forKey:row];
}

- (void)unPickImageIndexPath:(NSIndexPath *)indexPath {
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.pickedImageDictionary removeObjectForKey:row];
}


#define kPickImageCellTopMargin 19.0
#define kPickImageCellLeftMargin 15.0
#define kPickImageCellRightMargin kPickImageCellLeftMargin
#define kPickImageCellBottomMargin kPickImageCellTopMargin
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = floorf(collectionView.bounds.size.height - (kPickImageCellTopMargin + kPickImageCellBottomMargin));
    return CGSizeMake(height, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kPickImageCellTopMargin, kPickImageCellLeftMargin, kPickImageCellBottomMargin, kPickImageCellLeftMargin);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isPickImageIndexPath:indexPath]) {
        if (self.pickedImageDictionary.count > 1) {
            [self unPickImageIndexPath:indexPath];
        } else {
            [self showTipMessage:@"至少选择一张图片"];
        }
    } else {
        [self pickImageIndexPath:indexPath];
    }
    [self pickedImageDictionaryChanged];
    [self.imageCollectionView reloadData];
}


- (void)pickedImageDictionaryChanged {
    NSString *countString = [NSString stringWithFormat:@"%ld",(long)self.pickedImageDictionary.count];
    NSString *suffixString = [NSString stringWithFormat:@"(已选%@张)",countString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[@"选择图片" stringByAppendingString:suffixString]];
    [attributedString addAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]
             } range:NSMakeRange(0, attributedString.length)];
     [attributedString addAttributes:@{ NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16.0]
     } range:NSMakeRange(0, 4)];
    [attributedString addAttributes:@{ NSFontAttributeName:[UIFont letaoRegularFontWithSize:13.0]
        } range:NSMakeRange(4, suffixString.length)];
    [attributedString addAttributes:@{ NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]
          } range:NSMakeRange(attributedString.length - 2 - countString.length, countString.length)];
    self.pickImageLabel.attributedText = attributedString;
}

- (IBAction)tklCopyAction:(id)sender {
    if ([self.shareCode isKindOfClass:[NSString class]]
        && self.shareCode.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.shareCode;
        [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.shareCode];
         [self showTipMessage:@"复制淘口令成功!"];;
    }
}

- (IBAction)shareTextCopyAction:(id)sender {
    if ([self.shareTextView.text isKindOfClass:[NSString class]]
        && self.shareTextView.text.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.shareTextView.text;
        [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.shareTextView.text];
         [self showTipMessage:@"复制分享文案成功!"];
    }
}


- (IBAction)saveAlbumAction:(id)sender {
    NSMutableArray *activityItems = [NSMutableArray array];
       [[self.pickedImageDictionary allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([obj isKindOfClass:[NSString class]]
               && [obj integerValue] >= 0
               && [obj integerValue] < self.shareImageArray.count) {
               [activityItems addObject:self.shareImageArray[[obj integerValue]]];
           }
       }];
    if (activityItems.count == 0) {
        [self showTipMessage:@"请选择图片"];
        return;
    }
    [self letaoShowLoading];
    UIImage *gooodsImage = nil;
    if (self.shareImageArray.firstObject == activityItems.firstObject) {
        gooodsImage = self.shareImageArray.firstObject;
        [activityItems removeObject:gooodsImage];
    }
    __weak __typeof(self)weakSelf = self;
    [[XLTMyWatermarkLogic shareInstance] addWatermarkIfNeedForImages:activityItems completion:^(NSArray * _Nonnull watermarkImages) {
        [weakSelf saveAlbumWithImageArray:watermarkImages gooodsImage:gooodsImage];
        [weakSelf letaoRemoveLoading];
    }];
}

- (void)saveAlbumWithImageArray:(NSArray *)watermarkImages gooodsImage:(UIImage *)gooodsImage {
    NSMutableArray *activityItems = watermarkImages.mutableCopy;
    if (gooodsImage) {
        if (activityItems.count > 0) {
            [activityItems insertObject:gooodsImage atIndex:0];
        } else {
            [activityItems addObject:gooodsImage];
        }
    }
    
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                 [activityItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     UIImage *photo = obj;
                     if ([photo isKindOfClass:[UIImage class]]) {
                         UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                     }

                 }];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self showTipMessage:@"图片已保存到本地相册"];
                });
                
            } else { // 用户第一次拒绝了访问相机权限
    // do thing
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
        [activityItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *photo = obj;
            if ([photo isKindOfClass:[UIImage class]]) {
                UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            }

        }];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self showTipMessage:@"图片已保存到本地相册"];
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


- (IBAction)shareWechatSession {
     [self showActivityViewControllerWithfWatermarkIfNeed];
}

- (IBAction)shareWechatTimeLine {
     [self showActivityViewControllerWithfWatermarkIfNeed];
}

- (IBAction)shareQQ {
    [self showActivityViewControllerWithfWatermarkIfNeed];
}

- (IBAction)shareWeibo {
    [self showActivityViewControllerWithfWatermarkIfNeed];
}

- (void)showActivityViewControllerWithfWatermarkIfNeed {
    NSMutableArray *activityItems = [NSMutableArray array];
    [[self.pickedImageDictionary allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]
            && [obj integerValue] >= 0
            && [obj integerValue] < self.shareImageArray.count) {
            [activityItems addObject:self.shareImageArray[[obj integerValue]]];
        }
    }];
    if (activityItems.count > 0) {
        if (activityItems.count >9) {
            [activityItems removeObjectsInRange:NSMakeRange(9, activityItems.count-9)];
        }
        UIImage *gooodsImage = self.shareImageArray.firstObject;
        if ([activityItems containsObject:gooodsImage]) {
            [activityItems removeObject:gooodsImage];
        } else {
            gooodsImage = nil;
        }
        [self letaoShowLoading];
        __weak typeof(self)weakSelf = self;
        [[XLTMyWatermarkLogic shareInstance] addWatermarkIfNeedForImages:activityItems completion:^(NSArray * _Nonnull watermarkImages) {
            [weakSelf showActivityViewController:watermarkImages gooodsImage:gooodsImage];
            [weakSelf letaoRemoveLoading];
        }];
    } else {
        [self showTipMessage:@"请选择图片"];
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
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[XLTGoodsDisplayHelp processSizeForShareActivityItems:activityItems goodsImage:gooodsImage] applicationActivities:nil];
    NSDictionary *taskInfo = self.taskInfo;
    __weak typeof(self)weakSelf = self;
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
        // 微信分享汇报
        BOOL isWeiboType = [@"com.sina.weibo.ShareExtension" isEqualToString:activityType];
        if ([activityType isKindOfClass:[NSString class]] && ([@"com.tencent.xin.sharetimeline" isEqualToString:activityType] || [@"com.tencent.mqq.ShareExtension" isEqualToString:activityType] || isWeiboType)) {
            if ([taskInfo isKindOfClass:[NSDictionary class]] && taskInfo.count > 0) {
                if (completed || isWeiboType) {
                    UIApplicationState state = [UIApplication sharedApplication].applicationState;
                    if (state == UIApplicationStateActive) {
                        [[XLTUserTaskManager shareManager] letaoRepoShareTaskInfo:taskInfo];
                    } else {
                        weakSelf.needRepoTaskInfo = taskInfo;
                    }
                }
            }
        }
    };
    [self presentViewController:activityVC animated:TRUE completion:nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareTextView.text;
    [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.shareTextView.text];
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
