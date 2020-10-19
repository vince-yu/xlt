//
//  XLTOrderSearchResultVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/19.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTArticleSearchResultVC.h"
#import "XLTCustomSearchBar.h"
#import "LetaoEmptyCoverView.h"
#import "XLTShareFeedLogic.h"


@interface XLTArticleSearchResultVC () <UITextFieldDelegate>
@property (nonatomic, strong) XLTCustomSearchBar *letaoCustomSearchBar;

@end

@implementation XLTArticleSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.letaoCustomSearchBar];
}

- (void)letaoShowEmptyView {
    [super letaoShowEmptyView];
    self.letaoEmptyCoverView.titleStr = @"暂无搜索结果～";
    self.letaoEmptyCoverView.image = [UIImage imageNamed:@"xingletao_order_search_empty"];
}

- (XLTCustomSearchBar *)letaoCustomSearchBar {
    if (_letaoCustomSearchBar == nil) {
        _letaoCustomSearchBar = [[XLTCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        [_letaoCustomSearchBar.letaoCancelBtn addTarget:self action:@selector(letaoDidClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        _letaoCustomSearchBar.letaoSearchTextFiled.delegate = self;
        _letaoCustomSearchBar.letaoSearchTextFiled.text = self.letaoSearchText;
    }
    return _letaoCustomSearchBar;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
}

- (void)letaoDidClickedCancel {
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    if (array.count > 2) {
        [array removeObject:self];
        [array removeLastObject];
        [self.navigationController setViewControllers:array animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;   
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.navigationController popViewControllerAnimated:NO];
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self letaohiddenNavigationBar:YES];

}


- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                            failed:(XLTBaseListRequestFailed)failed {
    [XLTShareFeedLogic requestSchoolArticleSearchDataForIndex:index pageSize:pageSize searchText:self.letaoSearchText success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        success(feedArray);
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
         failed(nil,errorMsg);
    }];
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
