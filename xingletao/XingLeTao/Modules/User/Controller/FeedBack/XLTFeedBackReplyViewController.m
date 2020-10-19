//
//  XLTFeedBackReplyViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackReplyViewController.h"
#import "XLTFeedBackMediaCell.h"
#import "XLTFeedBackMediaFooter.h"
#import "XLTFeedBackMediaHeader.h"
#import "XLTFeedBackReplyTextViewCell.h"
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
#import "XLTFeedBackReplyMediaHeader.h"
#import "NSString+Size.h"
#import "XLTFeedBackReplyPhoneCell.h"

@interface XLTFeedBackReplyViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate,KSPhotoBrowserDelegate, XLTFeedBackMediaCellDelegate, XLTBGCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSString *phoneText;
@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, strong) NSArray *enclosureArray;
@property (nonatomic, copy) NSString *reply_contentText;
@property (nonatomic, copy) NSString *wxinText;

@end

@implementation XLTFeedBackReplyViewController
#define kFeedBackButtonHeight 50.0
#define kFeedBackButtonBottom 0
#define kFeedBackButtonTop 12.0
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的反馈";

    [self loadContentTableView];
    self.collectionView.hidden = YES;
    [self requestFeedBackDetail];
}

- (void)requestFeedBackDetail {
    [self letaoShowLoading];
    __weak __typeof(self)weakSelf = self;
    [XLTFeedBackLogic requestFeedBackDetailWitdhId:self.feedId success:^(NSDictionary * _Nonnull info, NSURLSessionDataTask * _Nonnull task) {
        [weakSelf letaoRemoveLoading];
        [weakSelf reloadDataWithFeedBackDetail:info];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
    }];
    
    
    [XLTFeedBackLogic requestCustomerServiceSuccess:^(NSDictionary * _Nonnull info, NSURLSessionDataTask * _Nonnull task) {
        [weakSelf realodloadCustomerServiceInfo:info];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {

    }];
    
    
}

- (void)reloadDataWithFeedBackDetail:(NSDictionary *)info {
    NSString *phoneText = [info[@"phone"] isKindOfClass:[NSString class]] ?  info[@"phone"] : @"";
    NSString *contentText = [info[@"content"] isKindOfClass:[NSString class]] ?  info[@"content"] : @"";
    NSString *reply_contentText = [info[@"reply_content"] isKindOfClass:[NSString class]] ?  info[@"reply_content"] : @"";
    NSArray *enclosureArray = [info[@"enclosure"] isKindOfClass:[NSArray class]] ?  info[@"enclosure"] : @[];

    self.phoneText = phoneText;
    self.contentText = contentText;
    self.reply_contentText = reply_contentText;
    self.enclosureArray = enclosureArray;
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
}

- (void)realodloadCustomerServiceInfo:(NSDictionary *)info {
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    UIView *serviceBgView = [UIView new];
    serviceBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:serviceBgView];
    
    [serviceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(kFeedBackButtonTop);
        make.height.equalTo(@kFeedBackButtonHeight);
    }];
    
    
    UIButton *feedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedBackButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateNormal];

    [feedBackButton setTitle:@"复制" forState:UIControlStateNormal];
    feedBackButton.titleLabel.font = [UIFont letaoRegularFontWithSize:15];
    [feedBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedBackButton addTarget:self action:@selector(wxinCopyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [serviceBgView addSubview:feedBackButton];
    [feedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.right.top.equalTo(@0);
        make.height.mas_equalTo(serviceBgView.mas_height);
    }];
    
    
    NSString *preText = @"还有其他疑问，请联系官方微信客服\n";
    NSString *wxinText = [NSString stringWithFormat:@"%@",info[@"wx"]];
    self.wxinText = wxinText;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",preText,wxinText]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, preText.length)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(preText.length, attributedString.length - preText.length)];

    UILabel *textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.attributedText = attributedString;
    [serviceBgView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(feedBackButton.mas_left);
        make.top.equalTo(@0);
        make.left.equalTo(@15);
        make.height.mas_equalTo(serviceBgView.mas_height);
    }];
      
}

- (void)wxinCopyButtonAction {
     [UIPasteboard generalPasteboard].string = self.wxinText;
    [self showTipMessage:@"复制成功!"];
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
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackReplyTextViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTFeedBackReplyTextViewCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackMediaCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTFeedBackMediaCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackReplyPhoneCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTFeedBackReplyPhoneCell"];

    
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTFeedBackReplyMediaHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTFeedBackReplyMediaHeader"];

}


- (CGFloat)heightForFeedBackReplyMediaHeader {
    
    CGFloat contentTextHeight = [self.contentText sizeWithFont:[UIFont letaoRegularFontWithSize:13.0] maxSize:CGSizeMake(_collectionView.bounds.size.width - 20, CGFLOAT_MAX)].height;
    return ceilf(contentTextHeight + 60) + 11;
}

- (CGFloat)heightForFeedBackReplyPhoneCell {
    return 73.0;
}

- (CGFloat)heightForFeedBackReplyTextViewCell {
    CGFloat textWidth = _collectionView.bounds.size.width - 20;
    CGFloat contentTextHeight = [self.reply_contentText sizeWithFont:[UIFont letaoRegularFontWithSize:13.0] maxSize:CGSizeMake(textWidth, CGFLOAT_MAX)].height;
    CGFloat heightForFeedBackReplyText = MAX(ceilf(contentTextHeight + 60), 193.0) + 20;
    return heightForFeedBackReplyText;
}


#pragma mark -  UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.enclosureArray.count;
    } else if (section == 2) {
        return (self.phoneText.length > 0) ? 1 : 0;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTFeedBackReplyTextViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTFeedBackReplyTextViewCell" forIndexPath:indexPath];
        [cell updateReplyText:self.reply_contentText];
        return cell;
    } else if (indexPath.section == 1) {
        XLTFeedBackMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTFeedBackMediaCell" forIndexPath:indexPath];
        BOOL isVideo = NO;
        NSString *url = self.enclosureArray[indexPath.item];
        if ([url isKindOfClass:[NSString class]]) {
            isVideo = ([url hasSuffix:@"mp4"] || [url hasSuffix:@"mov"]);
            [cell updatePhotoUrl:url isVideo:isVideo];
        }

        
        return cell;
    } else {
        XLTFeedBackReplyPhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTFeedBackReplyPhoneCell" forIndexPath:indexPath];
        cell.phoneTextField.text = self.phoneText;
        return cell;
    }

}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.bounds.size.width, [self heightForFeedBackReplyTextViewCell]);
    } else if (indexPath.section == 1) {
        CGFloat space = 10.0;
        CGFloat leftMargin = 13;
        CGFloat itemWidth = floorf((collectionView.bounds.size.width - space*3 - leftMargin*2)/4);
        return CGSizeMake(itemWidth, itemWidth);
    } else {
        return CGSizeMake(collectionView.bounds.size.width, [self heightForFeedBackReplyPhoneCell]);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return UIEdgeInsetsMake(10, 13.0, 20, 13.0);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, [self heightForFeedBackReplyMediaHeader]);
    }
   return CGSizeZero;
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     XLTFeedBackReplyMediaHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTFeedBackReplyMediaHeader" forIndexPath:indexPath];
     [headerView updateFeedText:self.contentText];
      return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.item < self.enclosureArray.count) {
            BOOL isVideo = NO;
            NSString *url = self.enclosureArray[indexPath.item];
            if ([url isKindOfClass:[NSString class]]) {
                isVideo = ([url hasSuffix:@"mp4"] || [url hasSuffix:@"mov"]);
            }
            if (isVideo) {
                [self playVideoWithUrl:url];
            } else {
                NSMutableArray *photoArray = [NSMutableArray array];
                [self.enclosureArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        if (!([obj hasSuffix:@"mp4"] || [obj hasSuffix:@"mov"])) {
                            [photoArray addObject:obj];
                        }
                    }

                }];
                NSUInteger index = [photoArray indexOfObject:url];
                if (index == NSNotFound) {
                    index = 0;
                }
                [self browseImages:photoArray atIndex:index];
            }
        }
    }
}

- (void)playVideoWithUrl:(NSString *)url {
    XLTSchoolFullScreenSJVideoVC *videoVC = [[XLTSchoolFullScreenSJVideoVC alloc] init];
    videoVC.letaoVideoUrl = url;
    [self.navigationController pushViewController:videoVC animated:YES];
}


- (void)feedBackMediaCell:(XLTFeedBackMediaCell *)cell clearPhoto:(UIImage *)photo {

   
}

- (void)browseImages:(NSArray *)imagesArray
             atIndex:(NSUInteger)index {
     [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
     KSPhotoBrowser.imageViewBackgroundColor = UIColor.clearColor;
     
     NSMutableArray *items = @[].mutableCopy;
     for (int i = 0; i < imagesArray.count; i++) {
         KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil imageUrl:imagesArray[i]];
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
