//
//  XLTInvaterRecommendView.m
//  XingLeTao
//
//  Created by SNQU on 2020/5/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTInvaterRecommendView.h"
#import "XLTUserInfoLogic.h"
#import "NSArray+Bounds.h"

@interface XLTInvaterRecommendView ()
@property (weak, nonatomic) IBOutlet UILabel *refreshLable;
@property (weak, nonatomic) IBOutlet UIImageView *refreshImageView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@property (weak, nonatomic) IBOutlet UIView *recommonedView;
@property (nonatomic, copy) NSArray *codeArray;
@end

@implementation XLTInvaterRecommendView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTInvaterRecommendView" owner:nil options:nil] lastObject];
    if (self) {
        self.layer.cornerRadius = 5;
        [self refreshAction:nil];
    }
    return self;
}
- (IBAction)refreshAction:(id)sender {
    [self updateRefreshConfig:YES];
    [self performSelector:@selector(requestCodeArray) withObject:nil afterDelay:1];
    
}
- (void)requestCodeArray{
    XLT_WeakSelf;
    [XLTUserInfoLogic getInviterCodeArraySuccess:^(id  _Nonnull info) {
        XLT_StrongSelf;
        [self updateRefreshConfig:NO];
        [self reloadInvaterCode:info];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self updateRefreshConfig:NO];
    }];
}
- (void)updateRefreshConfig:(BOOL )refresh{
    self.refreshBtn.enabled = !refresh;
    self.recommonedView.hidden = refresh;
    if (refresh) {
        self.refreshImageView.image = [UIImage imageNamed:@"xlt_refreshing"];
        self.refreshLable.textColor = [UIColor colorWithHex:0x9C9C9C];
    }else{
        self.refreshImageView.image = [UIImage imageNamed:@"xlt_refresh"];
        self.refreshLable.textColor = [UIColor colorWithHex:0x25282D];
    }
    
}
- (void)reloadInvaterCode:(NSArray *)array{
    if (array.count) {
        self.codeArray = array;
    }
    if (!self.codeArray.count) {
        return;
    }
    for (UIView *view in self.recommonedView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat btnWidth = 65;//(kScreenWidth - 80 - self.codeArray.count);
    CGFloat btnHeight = 30;
    NSInteger row = 4.0;
    CGFloat space = (kScreenWidth - 80 - btnWidth * row) / (row - 1);
    
    NSInteger section = (NSInteger)ceil(self.codeArray.count / 4.0);
    for (NSInteger j = 0 ; j < section ; j ++) {
        for (NSInteger i = 0 ; i < row ; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *code = [self.codeArray by_ObjectAtIndex:j * row + i];
            [btn setTitle:code forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
            [btn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
            btn.tag = 3000 + i + j * row;
            btn.layer.cornerRadius = 3;
            btn.layer.borderColor = [UIColor colorWithHex:0xE6E6E7].CGColor;
            btn.layer.borderWidth = 1;
            [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.recommonedView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo((btnWidth + space) * i);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnHeight);
                make.top.mas_equalTo((btnHeight + 10) * j);
            }];
        }
    }
    
}
- (void)selectAction:(UIButton *)btn{
    NSString *code = btn.titleLabel.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCode:)]) {
        [self.delegate selectCode:code];
    }
}
@end
