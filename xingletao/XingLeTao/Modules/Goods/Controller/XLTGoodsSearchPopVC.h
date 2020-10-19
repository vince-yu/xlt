//
//  XLTGoodsSearchPopVC.h
//  
//
//  Created by chenhg on 2019/12/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsSearchPopVC : XLTBaseViewController
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *goodsLabel;
@property (nonatomic, copy, nullable) void(^popViewControllerSearchAction)(NSString *searchText);
- (void)presentWithSourceViewController:(UIViewController *)sourceViewController
                             searchText:(NSString * _Nullable)searchText;

@end

NS_ASSUME_NONNULL_END
