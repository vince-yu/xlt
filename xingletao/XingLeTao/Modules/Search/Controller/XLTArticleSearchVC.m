//
//  XLTOrderSearchVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/19.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTArticleSearchVC.h"
#import "UIImage+UIColor.h"
#import "UIColor+Helper.h"
#import "PYSearchViewController.h"
#import "XLTCustomSearchBar.h"
#import "XLTArticleSearchResultVC.h"

@interface XLTArticleSearchVC () <PYSearchViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) PYSearchViewController *letaoSearchVC;
@property (nonatomic, strong) XLTCustomSearchBar *letaoCustomSearchBar;

@end

@implementation XLTArticleSearchVC


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
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.letaoSearchVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
    
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





- (PYSearchViewController *)letaoSearchVC {
    if (_letaoSearchVC == nil) {
        _letaoSearchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:nil];
        _letaoSearchVC.delegate = self;
        _letaoSearchVC.hotSearchStyle = PYHotSearchStyleBorderTag;
        _letaoSearchVC.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
        _letaoSearchVC.removeSpaceOnSearchString = NO;
        
        _letaoSearchVC.searchHistoriesCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories-Article.plist"];
    }
    return _letaoSearchVC;
}

- (XLTCustomSearchBar *)letaoCustomSearchBar {
    if (_letaoCustomSearchBar == nil) {
        _letaoCustomSearchBar = [[XLTCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        [_letaoCustomSearchBar.letaoCancelBtn addTarget:self action:@selector(letaoDidClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        _letaoCustomSearchBar.letaoSearchTextFiled.delegate = self;
        _letaoCustomSearchBar.letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
        _letaoCustomSearchBar.letaoSearchTextFiled.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
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
        XLTArticleSearchResultVC *reultViewController = [[XLTArticleSearchResultVC alloc] init];
        reultViewController.letaoSearchText = letaoSearchText;
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
