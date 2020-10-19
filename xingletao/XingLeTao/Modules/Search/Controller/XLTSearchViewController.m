//
//  XLTSearchViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTSearchViewController.h"
#import "UIImage+UIColor.h"
#import "XLTSearchLogic.h"
#import "UIColor+Helper.h"
#import "PYSearchViewController.h"
#import "XLTCustomSearchBar.h"
#import "XLTQRCodeScanLogic.h"
#import "XLTGoodsSearchReultVC.h"
#import "HMSegmentedControl.h"
#import "XLTStoreSearchReultVC.h"
#import "XLTAdManager.h"

@interface XLTSearchViewController () <PYSearchViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) PYSearchViewController *letaoSearchVC;
@property (nonatomic, strong) NSArray *letaohotKeyWordsArray;
@property (nonatomic, strong) XLTSearchLogic *letaoSearchLogic;
@property (nonatomic, strong) XLTCustomSearchBarTwo *letaoCustomSearchBar;
@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, assign) BOOL letaoShowPlatformSegment;
@property (nonatomic, strong) NSMutableArray *supportGoodsPlatformNameArray;
@property (nonatomic, strong) NSMutableArray *supportGoodsPlatformCodeArray;
@property (nonatomic ,strong) UIImageView *adImageView;
@property (nonatomic ,strong) UIView *adView;
@property (nonatomic ,strong) NSDictionary *adInfo;

//汇报使用
@property (nonatomic ,copy) NSString *searchStrType;
@end

@implementation XLTSearchViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置分平台搜索
        
        NSArray *supportGoodsPlatformArray = [[XLTAppPlatformManager shareManager] supportGoodsPlatformArrayForSearch];
        _supportGoodsPlatformNameArray = [NSMutableArray array];
        _supportGoodsPlatformCodeArray = [NSMutableArray array];
        [supportGoodsPlatformArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull platformInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([platformInfo isKindOfClass:[NSDictionary class]]) {
                NSString *name = platformInfo[@"name"];
                NSString *code = platformInfo[@"code"];
                if (name && code) {
                    [_supportGoodsPlatformNameArray addObject:name];
                    [_supportGoodsPlatformCodeArray addObject:code];
                }
            }
        }];
        _letaoShowPlatformSegment = (_supportGoodsPlatformCodeArray.count == _supportGoodsPlatformNameArray.count && _supportGoodsPlatformNameArray.count > 0) ;
        [self letaoAddObserverForSearchTextField];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.adView];
    [self.adView addSubview:self.adImageView];
    [self.view addSubview:self.letaoSearchVC.view];
    self.letaoSearchVC.view.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    [self.view addSubview:self.letaoCustomSearchBar];
    if (_letaoShowPlatformSegment) {
        [self.view addSubview:self.letaoSegmentedControl];
    }
    if ([self.letaoPasteboardSearchText isKindOfClass:[NSString class]]
        && self.letaoPasteboardSearchText.length > 0) {
        [self letaoSaveSearchTextAndRefreshView:self.letaoPasteboardSearchText];
        self.letaoCustomSearchBar.letaoSearchTextFiled.text = self.letaoPasteboardSearchText;
    } else if ([self.letaoSearchText isKindOfClass:[NSString class]]
        && self.letaoSearchText.length > 0) {
        [self letaoSaveSearchTextAndRefreshView:self.letaoSearchText];
        self.letaoCustomSearchBar.letaoSearchTextFiled.text = self.letaoSearchText;
    }
    [self requstAd];
}
- (UIImageView *)adImageView{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.frame = CGRectMake(15,15, kScreenWidth - 30, 100);
        _adImageView.hidden = YES;
        _adImageView.layer.cornerRadius = 7;
        _adImageView.clipsToBounds = YES;
        _adImageView.userInteractionEnabled = YES;
        [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClick)]];
    }
    return _adImageView;
}
- (UIView *)adView{
    if (!_adView) {
        _adView = [[UIView alloc] init];
        _adView.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
        _adView.frame = CGRectMake(0, self.letaoSegmentedControl.height + self.letaoSegmentedControl.y, kScreenWidth, 100);
    }
    return _adView;
}
- (void)requstAd{
    __weak typeof(self)weakSelf = self;
    [[XLTAdManager shareManager] xingletaonetwork_requestAdListWithPosition:@"20001" success:^(NSArray * _Nonnull adArray) {
        [weakSelf updateAdInfo:adArray.firstObject];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf updateAdInfo:nil];
    }];
}
- (void)adClick{
    [[XLTAdManager shareManager] adJumpWithInfo:self.adInfo sourceController:self];
    if ([self.adInfo isKindOfClass:[NSDictionary class]]) {
        NSString *adId = self.adInfo[@"_id"];
        [[XLTAdManager shareManager] repoAdClickWitdAdId:adId];
        
        // 汇报事件
//        NSMutableDictionary *properties = @{}.mutableCopy;
//        properties[@"xlt_item_id"] = self.adInfo[@"_id"];
//        properties[@"xlt_item_title"] = self.adInfo[@"title"];
//        properties[@"xlt_item_ad_platform"] = self.adInfo[@"platform"];
//        properties[@"xlt_item_ad_position"] = self.adInfo[@"show_position"];
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_COURSE properties:nil];
    }
}
- (void)updateAdInfo:(NSDictionary * _Nullable)adInfo{
    self.adInfo = adInfo;
    if ([adInfo isKindOfClass:[NSDictionary class]] && [adInfo objectForKey:@"image"]) {
            
            XLT_WeakSelf;
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:[adInfo objectForKey:@"image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                XLT_StrongSelf;
                if (image) {
                    CGFloat bili = image.size.width / image.size.height;
                    CGFloat imageHeight = (kScreenWidth - 30) / bili;
                    
                    XLT_WeakSelf;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        XLT_StrongSelf;
                        self.adImageView.height = imageHeight;
                        self.adView.height = imageHeight + 15;
                        CGFloat segmentedControlHeight = 0;
                            if (self.letaoShowPlatformSegment) {
                                segmentedControlHeight = 44;
                            }
                        
                    });
                }
            }];
            self.adImageView.hidden = NO;
        }else{
            self.adImageView.hidden = YES;
            CGFloat segmentedControlHeight = 0;
            if (_letaoShowPlatformSegment) {
                segmentedControlHeight = 44;
            }
            self.letaoSearchVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop +segmentedControlHeight, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop -segmentedControlHeight);
        }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat segmentedControlHeight = 0;
    if (_letaoShowPlatformSegment) {
        segmentedControlHeight = 44;
    }
    if (!self.adImageView.hidden) {
        segmentedControlHeight = segmentedControlHeight + self.adImageView.height + 15;
    }
    self.letaoSearchVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop +segmentedControlHeight, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop -segmentedControlHeight);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (self.letaohotKeyWordsArray.count <= 0) {
        [self xingletaonetwork_requestHotKeyWordsData];
    }
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    if ([self.popParameters isKindOfClass:[NSDictionary class]]) {
        NSString *nearestTextFiledText = self.popParameters[@"kNearestTextFiledText"];
        if ([nearestTextFiledText isKindOfClass:[NSString class]]) {
            self.letaoCustomSearchBar.letaoSearchTextFiled.text = nearestTextFiledText;;
        }
    }
    self.popParameters = nil;
}


- (void)xingletaonetwork_requestHotKeyWordsData {
    if (self.letaoSearchLogic == nil) {
        self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
    }
     __weak typeof(self)weakSelf = self;
    [self.letaoSearchLogic xingletaonetwork_xingletaonetwork_requestHotKeyWordsDataDataSuccess:^(NSArray * _Nonnull hotKeyWordsArray) {
        [weakSelf letaoReloadHotKeyWords:hotKeyWordsArray];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}


- (void)xingletaonetwork_requestSearchSuggestionData:(NSString *)inputText {
    if (self.letaoSearchLogic == nil) {
        self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
    }
    [self.letaoSearchLogic letaoCancelSearchSuggestionTask];
     __weak typeof(self)weakSelf = self;
    [self.letaoSearchLogic xingletaonetwork_xingletaonetwork_requestSearchSuggestionDataWithInputText:inputText success:^(NSArray * _Nonnull suggestionArray) {
        [weakSelf letaoReloadSuggestionData:suggestionArray];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)letaoReloadHotKeyWords:(NSArray *)hotKeyWordsArray {
    self.letaohotKeyWordsArray = hotKeyWordsArray;

    NSMutableDictionary *colorInfo = [NSMutableDictionary dictionary];
    NSMutableArray *hotSearches = [NSMutableArray array];
    [hotKeyWordsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *hotKeyWords = @"";
        if ([obj isKindOfClass:[NSDictionary class]]
            && [obj[@"key"] isKindOfClass:[NSString class]]) {
            hotKeyWords = obj[@"key"];
            NSMutableDictionary *keyColorInfo = [NSMutableDictionary dictionary];
            NSString *font_color = obj[@"font_color"];
            NSString *back_color = obj[@"back_color"];
            if ([font_color isKindOfClass:[NSString class]]) {
                UIColor *fontColor = [UIColor colorWithHexString:[font_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                keyColorInfo[@"font_color"] = fontColor;
            }
            
            if ([back_color isKindOfClass:[NSString class]]) {
                UIColor *backColor = [UIColor colorWithHexString:[back_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                keyColorInfo[@"back_color"] = backColor;
            }
            if (keyColorInfo.count) {
                colorInfo[hotKeyWords] = keyColorInfo;
            }
        }
        [hotSearches addObject:hotKeyWords];
    }];
    self.letaoSearchVC.hotSearches = hotSearches;
    
    [self.letaoSearchVC.hotSearchTags enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.text) {
            NSDictionary *keyColorInfo = colorInfo[obj.text];
            UIColor *fontColor = keyColorInfo[@"font_color"];
            UIColor *backColor = keyColorInfo[@"back_color"];
            if ([fontColor isKindOfClass:[UIColor class]]) {
                obj.textColor = fontColor;
            }
            
            if ([backColor isKindOfClass:[UIColor class]]) {
                obj.backgroundColor = backColor;
            }
        }
    }];
}

- (void)letaoReloadSuggestionData:(NSArray *)suggestionArray {
    NSMutableArray *searchSuggestions = [NSMutableArray array];
    [suggestionArray  enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]
                       && [obj[@"key"] isKindOfClass:[NSString class]]) {
            [searchSuggestions addObject:obj[@"key"]];
        }
    }];
    self.letaoSearchVC.searchSuggestions = searchSuggestions;
}

- (PYSearchViewController *)letaoSearchVC {
    if (_letaoSearchVC == nil) {
        _letaoSearchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:[[XLTAppPlatformManager shareManager] platformText:@"搜索商品标题 领优惠券拿返现"]];
        _letaoSearchVC.delegate = self;
        _letaoSearchVC.removeSpaceOnSearchString = NO;
        _letaoSearchVC.hotSearchStyle = PYHotSearchStyleBorderTag;
        _letaoSearchVC.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
    }
    return _letaoSearchVC;
}

- (XLTCustomSearchBarTwo *)letaoCustomSearchBar {
    if (_letaoCustomSearchBar == nil) {
        _letaoCustomSearchBar = [[XLTCustomSearchBarTwo alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        [_letaoCustomSearchBar.letaoLeftBtn addTarget:self action:@selector(letaoDidClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        [_letaoCustomSearchBar.letaoSearchBtn addTarget:self action:@selector(letaoDidClickedSearch) forControlEvents:UIControlEventTouchUpInside];

        _letaoCustomSearchBar.letaoSearchTextFiled.delegate = self;
    }
    return _letaoCustomSearchBar;
}



- (HMSegmentedControl *)letaoSegmentedControl {
    if (!_letaoSegmentedControl) {
        _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.letaoCustomSearchBar.frame), self.view.bounds.size.width - 20,  44)];
        _letaoSegmentedControl.backgroundColor = [UIColor whiteColor];
        _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _letaoSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _letaoSegmentedControl.selectionIndicatorHeight = 2.0;
        _letaoSegmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
        _letaoSegmentedControl.sectionTitles = self.supportGoodsPlatformNameArray;
        _letaoSegmentedControl.type = HMSegmentedControlTypeText;
        _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]};
        _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
        
        if (self.item_source) {
           NSUInteger index =  [self.supportGoodsPlatformCodeArray indexOfObject:self.item_source];
            if (index != NSNotFound && index < self.supportGoodsPlatformNameArray.count) {
                _letaoSegmentedControl.selectedSegmentIndex = index;
            }
        }
    }
    return _letaoSegmentedControl;
    
}


- (void)letaoDidClickedCancel {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)letaoDidClickedSearch {
    NSString *letaoSearchText = [self.letaoCustomSearchBar.letaoSearchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.searchStrType = @"个人搜索词";
    [self letaoStartSearchWithText:letaoSearchText];
}

- (void)letaoAddObserverForSearchTextField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoSearchTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.letaoCustomSearchBar.letaoSearchTextFiled];
}


- (void)letaoSearchTextFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.letaoCustomSearchBar.letaoSearchTextFiled) {
        NSString *text = [self.letaoCustomSearchBar.letaoSearchTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length) {
            [self xingletaonetwork_requestSearchSuggestionData:text];
        } else {
            self.letaoSearchVC.searchSuggestions = nil;
        }
    }
}

#pragma mark -  PYSearchViewControllerDelegate

- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    if (index < self.letaohotKeyWordsArray.count) {
        NSDictionary *info = self.letaohotKeyWordsArray[index];
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSString *hotId = info[@"_id"];
            if (self.letaoSearchLogic == nil) {
                self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
            }
            [self.letaoSearchLogic letaoRepoKeyWordsClickedWithId:hotId success:^(NSArray * _Nonnull goodsArray) {
            } failure:^(NSString * _Nonnull errorMsg) {
            }];
        }
    }
    //热词；历史词；个人搜索词；null
    self.searchStrType = @"热词";
    self.letaoCustomSearchBar.letaoSearchTextFiled.text = searchText;
    [self letaoStartSearchWithText:searchText];
}


- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    self.letaoCustomSearchBar.letaoSearchTextFiled.text = searchText;
    self.searchStrType = @"历史词";
    [self letaoStartSearchWithText:searchText];
    
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {
    NSString *letaoSearchText = searchViewController.searchSuggestions[indexPath.row];
    self.letaoCustomSearchBar.letaoSearchTextFiled.text = letaoSearchText;
    [self letaoStartSearchWithText:letaoSearchText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *letaoSearchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self letaoStartSearchWithText:letaoSearchText];
    return YES;
}

- (void)letaoStartSearchWithText:(NSString *)letaoSearchText {
    [self.view endEditing:YES];
    if (letaoSearchText.length) {
        NSString *item_source = nil;
        if (self.letaoSegmentedControl.selectedSegmentIndex < self.supportGoodsPlatformCodeArray.count) {
            item_source = self.supportGoodsPlatformCodeArray[self.letaoSegmentedControl.selectedSegmentIndex];
        }
        XLTGoodsSearchReultVC *reultViewController = [[XLTGoodsSearchReultVC alloc] init];
        reultViewController.pasteboardSearchText = self.letaoPasteboardSearchText;
        reultViewController.letaoSearchText = letaoSearchText;
        reultViewController.item_source = item_source;
        reultViewController.searchType = self.searchStrType;
        [self.navigationController pushViewController:reultViewController animated:YES];
        [self letaoSaveSearchTextAndRefreshView:letaoSearchText];
        
        [[XLTRepoDataManager shareManager] repoSearchActionWithKeyword:letaoSearchText];

        // 汇报事件
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        properties[@"xlt_item_search_keyword"] = letaoSearchText;
        properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:item_source];
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_SEARCH properties:properties];
    }
}

- (void)letaoSaveSearchTextAndRefreshView:(NSString *)searchText {
    self.letaoSearchVC.searchBar.text = searchText;
    [self.letaoSearchVC saveSearchCacheAndRefreshView];
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
