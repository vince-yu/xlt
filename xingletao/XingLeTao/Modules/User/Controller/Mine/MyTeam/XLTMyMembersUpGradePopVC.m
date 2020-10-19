//
//  XLTMyMembersUpGradePopVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/25.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyMembersUpGradePopVC.h"
#import "XLTMyMembersUpGradeExplainCell.h"
#import "XLTMyMembersUpGradeCell.h"
#import "XLTMyMembersUpGradeTitleCell.h"

@interface XLTMyMembersUpGradePopVC () <UITableViewDelegate, UITableViewDataSource, XLTMyMembersUpGradeTitleCellDelegate>
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentTableViewHeight;
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;


@end

@implementation XLTMyMembersUpGradePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.estimatedRowHeight = 100;
    self.contentTableView.estimatedSectionHeaderHeight = 0;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.layer.masksToBounds = YES;
    self.contentTableView.layer.cornerRadius = 8.0;
    [self registerTableViewCells];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat height = ceilf(self.contentTableView.contentSize.height);
        self.contentTableViewHeight.constant = height;
    });
}


- (void)registerTableViewCells {
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTMyMembersUpGradeTitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyMembersUpGradeTitleCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTMyMembersUpGradeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyMembersUpGradeCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTMyMembersUpGradeExplainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyMembersUpGradeExplainCell"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.upGradeProgressArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTMyMembersUpGradeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyMembersUpGradeTitleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.upGradeTitleLabel.text = self.upGradeTitleText;
        cell.delegate = self;
        return cell;
    } else  if (indexPath.section == 1) {
        XLTMyMembersUpGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyMembersUpGradeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        XLTVipTaskRulesModel *model =[self.upGradeProgressArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[XLTVipTaskRulesModel class]]) {
            cell.model = model;
        }
        return cell;
    } else {
        XLTMyMembersUpGradeExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyMembersUpGradeExplainCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.upGradeExplainLabel.text = nil;
        if ([self.upGradeExplainText isKindOfClass:[NSString class]] && self.upGradeExplainText.length > 0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];        //设置行间距
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.upGradeExplainText];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.upGradeExplainText length])];
            cell.upGradeExplainLabel.attributedText = attributedString;
        } else {
            cell.upGradeExplainLabel.attributedText = nil;
        }

        return cell;
    }
}


- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
              upGradeExplainText:(NSString * _Nullable)upGradeExplainText
                upGradeTitleText:(NSString * _Nullable)upGradeTitleText
             upGradeProgressInfo:(NSArray * _Nullable)upGradeProgressInfo {
    self.upGradeExplainText = [upGradeExplainText isKindOfClass:[NSString class]] ? upGradeExplainText : nil;
    self.upGradeTitleText = [upGradeTitleText isKindOfClass:[NSString class]] ? upGradeTitleText : nil;;
    self.upGradeProgressArray = [upGradeProgressInfo isKindOfClass:[NSArray class]] ? upGradeProgressInfo : nil;;

    self.view.hidden = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sourceViewController.definesPresentationContext = YES;
    [sourceViewController presentViewController:self animated:NO completion:^{
        self.view.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        self.contentTableView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
             self.contentTableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)myMembersUpGradeCloseAction {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentTableView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
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
