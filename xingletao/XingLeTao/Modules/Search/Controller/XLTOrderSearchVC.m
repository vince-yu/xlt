//
//  XLTOrderSearchVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/19.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderSearchVC.h"
#import "UIImage+UIColor.h"
#import "UIColor+Helper.h"
#import "PYSearchViewController.h"
#import "XLTCustomSearchBar.h"
#import "XLTOrderSearchResultVC.h"
#import "HMSegmentedControl.h"

@interface XLTOrderSearchVC () <PYSearchViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) PYSearchViewController *letaoSearchVC;
@property (nonatomic, strong) XLTCustomSearchBar *letaoCustomSearchBar;
@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@end

@implementation XLTOrderSearchVC


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self letaoAddObserverForSearchTextField];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    [self.view addSubview:self.letaoSearchVC.view];
    self.letaoSearchVC.view.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.letaoCustomSearchBar];
    
    if (_letaoShowSegment && [XLTAppPlatformManager shareManager].checkEnable) {
        
        UIView *letaoSegmentedControlBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.letaoCustomSearchBar.frame), self.view.bounds.size.width,  44)];
        letaoSegmentedControlBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:letaoSegmentedControlBgView];
        
        [self.view addSubview:self.letaoSegmentedControl];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat segmentedControlHeight = 0;
    if (_letaoShowSegment && [XLTAppPlatformManager shareManager].checkEnable) {
        segmentedControlHeight = 44;
    }
    self.letaoSearchVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop +segmentedControlHeight, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop -segmentedControlHeight);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }

}

- (HMSegmentedControl *)letaoSegmentedControl {
    if (!_letaoSegmentedControl) {
        _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.letaoCustomSearchBar.frame), self.view.bounds.size.width - 100,  44)];
        _letaoSegmentedControl.backgroundColor = [UIColor whiteColor];
        _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _letaoSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _letaoSegmentedControl.userDraggable = NO;
        _letaoSegmentedControl.selectionIndicatorHeight = 2.0;
        _letaoSegmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
        _letaoSegmentedControl.sectionTitles = @[@"我的订单",@"粉丝订单"];
        _letaoSegmentedControl.type = HMSegmentedControlTypeText;
        _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]};
        _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    }
    return _letaoSegmentedControl;

}




- (PYSearchViewController *)letaoSearchVC {
    if (_letaoSearchVC == nil) {
        _letaoSearchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:nil];
        _letaoSearchVC.delegate = self;
        _letaoSearchVC.hotSearchStyle = PYHotSearchStyleBorderTag;
        _letaoSearchVC.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
        _letaoSearchVC.removeSpaceOnSearchString = NO;
        
        _letaoSearchVC.searchHistoriesCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories-Order.plist"];
    }
    return _letaoSearchVC;
}

- (XLTCustomSearchBar *)letaoCustomSearchBar {
    if (_letaoCustomSearchBar == nil) {
        _letaoCustomSearchBar = [[XLTCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        [_letaoCustomSearchBar.letaoCancelBtn addTarget:self action:@selector(letaoDidClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        _letaoCustomSearchBar.letaoSearchTextFiled.delegate = self;
        _letaoCustomSearchBar.letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索订单编号或商品名称" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];

    }
    return _letaoCustomSearchBar;
}

- (void)letaoDidClickedCancel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)letaoAddObserverForSearchTextField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoSearchTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.letaoCustomSearchBar.letaoSearchTextFiled];
}


- (void)letaoSearchTextFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.letaoCustomSearchBar.letaoSearchTextFiled) {
        // do noting
    }
}

#pragma mark -  PYSearchViewControllerDelegate

- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)letaoSearchText {
}


- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)letaoSearchText {
    self.letaoCustomSearchBar.letaoSearchTextFiled.text = letaoSearchText;
    [self letaoStartSearchWithText:letaoSearchText];
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
        XLTOrderSearchResultVC *reultViewController = [[XLTOrderSearchResultVC alloc] init];
        reultViewController.letaoSearchText = letaoSearchText;
        BOOL isGroupOrder = (self.letaoSegmentedControl.selectedSegmentIndex != 0);
        reultViewController.isGroup = isGroupOrder;
        [self.navigationController pushViewController:reultViewController animated:YES];
        self.letaoSearchVC.searchBar.text = letaoSearchText;
        [self.letaoSearchVC saveSearchCacheAndRefreshView];
    }
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
