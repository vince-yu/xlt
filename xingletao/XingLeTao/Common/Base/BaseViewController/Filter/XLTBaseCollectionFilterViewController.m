//
//  XLTBaseCollectionFilterViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionFilterViewController.h"
#import "XLTRightFilterViewController.h"

@interface XLTBaseCollectionFilterViewController () 


@end

@implementation XLTBaseCollectionFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self letaoSetupFilterView];
}

- (void)letaoSetupFilterView {
    if (_topFilterView == nil) {
        _topFilterView = [[NSBundle mainBundle]loadNibNamed:@"XLTTopFilterView" owner:self options:nil].lastObject;
        
    }
    _topFilterView.delegate = self;
    _topFilterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44.0);
    _topFilterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_topFilterView];
}

- (void)letaoFilterView:(XLTTopFilterView *)topFilterView letaoStartFilter:(UIButton *)letaoShowFilterBtn {
    XLTRightFilterViewController *filterViewController = [[XLTRightFilterViewController alloc] initWithNibName:@"XLTRightFilterViewController" bundle:[NSBundle mainBundle]];
    filterViewController.letaoPageDataArray = self.letaoFilterArray;
    filterViewController.delegate = self;
    filterViewController.view.hidden = YES;
    [self sourceViewController].definesPresentationContext = YES;
    filterViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[self sourceViewController] presentViewController:filterViewController animated:NO completion:^{
        filterViewController.view.hidden = NO;
        filterViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        filterViewController.contentBgView.transform = CGAffineTransformMakeTranslation(kScreenWidth -98, 0);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            filterViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        filterViewController.contentBgView.transform=CGAffineTransformMakeTranslation(0, 0);
              } completion:^(BOOL finished) {
                  
              }];
    }];
}

- (UIViewController *)sourceViewController {
    return self.navigationController;
}

- (void)letaoFilterView:(XLTTopFilterView *)topFilterView didSelectedSortType:(XLTTopFilterSortType)type {
    if (self.letaoSortValueType != type) {
        self.letaoSortValueType = type;
        [self requestFilterPageData];
    }
}



- (void)letaoFilterVC:(XLTRightFilterViewController *)filterViewController didChangeFilterData:(NSArray *)letaoFilterArray {
    // set filterInfo
    self.letaoFilterArray = letaoFilterArray;
    [self requestFilterPageData];
}

- (void)requestFilterPageData {
    [self requestFristPageData];
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
