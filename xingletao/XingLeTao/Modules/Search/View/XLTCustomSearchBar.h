//
//  XLTCustomSearchBar.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTCustomSearchBar : UIView
@property (nonatomic, strong) UIButton *letaoCancelBtn;
@property (nonatomic, strong) UITextField *letaoSearchTextFiled;
@end


@interface XLTCustomSearchBarTwo : UIView
@property (nonatomic, strong) UIButton *letaoSearchBtn;
@property (nonatomic, strong) UITextField *letaoSearchTextFiled;
@property (nonatomic, strong) UIButton *letaoLeftBtn;
@end

NS_ASSUME_NONNULL_END
