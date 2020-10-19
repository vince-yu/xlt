//
//  XLTGoodsDetailSukPopVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailSukPopVC.h"
#import "XLTGoodsDetailSukTableViewCell.h"
#import "XLTGoodsDetailSukSingleCell.h"

@interface XLTGoodsDetailSukPopVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@end

@implementation XLTGoodsDetailSukPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.letaoCloseBtn.layer.masksToBounds = YES;
    self.letaoCloseBtn.layer.cornerRadius = 23.0;
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.estimatedRowHeight = 44;
    self.contentTableView.estimatedSectionHeaderHeight = 0;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTGoodsDetailSukTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTGoodsDetailSukTableViewCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTGoodsDetailSukSingleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTGoodsDetailSukSingleCell"];

    self.letaoTitleTextLabel.text = self.letaoTitleText;
    if (self.letaoPageDataArray.count <= 1) {
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)setLetaoDataInfo:(NSDictionary *)itemInfo {
    _letaoDataInfo = itemInfo;
    if (self.letaoPageDataArray == nil) {
        self.letaoPageDataArray = [NSMutableArray array];
    }
    if (_letaoIsSafeguardCell) {
        if (self.letaoIsSingleCellType) {
            NSArray *protection = (NSArray *)itemInfo;
            NSMutableArray *titleArray = [NSMutableArray array];
            if ([protection isKindOfClass:[NSArray class]]) {
                [protection enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *value = obj[@"title"];
                        if ([value isKindOfClass:[NSString class]]) {
                            [titleArray addObject:value];
                        }
                    }
                }];
            }
            if (titleArray.count) {
                NSString *joinedTitle = [titleArray componentsJoinedByString:@"，"];
                if (joinedTitle) {
                    [self.letaoPageDataArray addObject:joinedTitle];
                }
            }
        } else {
            NSArray *protection = (NSArray *)itemInfo;
            if ([protection isKindOfClass:[NSArray class]]) {
                [protection enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *value = obj[@"title"];
                        NSString *desc = obj[@"desc"];
                        if ([value isKindOfClass:[NSString class]]
                            && [desc isKindOfClass:[NSString class]]) {
                            [self.letaoPageDataArray addObject:[NSString stringWithFormat:@"%@-%@",value,desc]];
                        }
                    }
                }];
            }
        }

    } else {
        NSArray *argument = (NSArray *)itemInfo;
        if ([argument isKindOfClass:[NSArray class]]) {
            NSDictionary *argumentInfo = argument.firstObject;
            if ([argumentInfo isKindOfClass:[NSDictionary class]]) {
                [argumentInfo.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *value = argumentInfo[obj];
                    if (![value  isKindOfClass:[NSString class]]) {
                        value = @"";
                    }
                    [self.letaoPageDataArray addObject:[NSString stringWithFormat:@"%@-%@",obj,value]];
                }];
            }
        }

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(self.letaoIsSingleCellType) {
        XLTGoodsDetailSukSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTGoodsDetailSukSingleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *contentText = self.letaoPageDataArray[indexPath.row];
        cell.sukLabel.text = contentText;
        return cell;
    } else {
        XLTGoodsDetailSukTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTGoodsDetailSukTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *contentText = self.letaoPageDataArray[indexPath.row];
        NSArray *contentArray = [contentText componentsSeparatedByString:@"-"];
        
        cell.sukTitleLabel.text = contentArray.firstObject;
        cell.sukLabel.text = contentArray.lastObject;
        return cell;
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

- (IBAction)letaoCloseBtnClicked:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.letaoBgView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
          self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
