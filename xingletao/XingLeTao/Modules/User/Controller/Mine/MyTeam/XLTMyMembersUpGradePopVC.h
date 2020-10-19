//
//  XLTMyMembersUpGradePopVC.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/25.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyMembersUpGradePopVC : XLTBaseViewController
@property (nonatomic, copy) NSString *upGradeExplainText;
@property (nonatomic, copy) NSString *upGradeTitleText;
@property (nonatomic, copy) NSArray *upGradeProgressArray;

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
              upGradeExplainText:(NSString * _Nullable)upGradeExplainText
                upGradeTitleText:(NSString * _Nullable)upGradeTitleText
             upGradeProgressInfo:(NSArray * _Nullable)upGradeProgressInfo;
@end

NS_ASSUME_NONNULL_END
