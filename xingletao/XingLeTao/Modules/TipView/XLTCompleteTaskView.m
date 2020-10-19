//
//  XLTCompleteTaskView.m
//  XingLeTao
//
//  Created by SNQU on 2020/3/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCompleteTaskView.h"
#import "XLTWKWebViewController.h"
#import "XLTUserManager.h"
#import "AppDelegate.h"
#import "XLTPopTaskViewManager.h"


@interface XLTCompleteTaskView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *taskBtn;
@property (weak, nonatomic) IBOutlet UIImageView *btnBgImageView;
@end

@implementation XLTCompleteTaskView
+ (void)showTaskCompleteTitle:(NSString *)title gold:(NSUInteger )number {
    XLTCompleteTaskView *view = [[XLTCompleteTaskView alloc] initWithNib];
    if ([title isKindOfClass:[NSString class]]) {
        view.titleLabel.text = title;
    }else if ([title isKindOfClass:[NSAttributedString class]]){
        view.titleLabel.attributedText = (NSAttributedString *)title;
    }
    view.numberLabel.text = [NSString stringWithFormat:@"+%lu",number];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"获得 %lu 星币",number]];
    [attrStr addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:25], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF80A]} range:NSMakeRange(3, 1)];
    view.describeLabel.attributedText = attrStr;
    [view show];
}
- (instancetype)initWithNib {
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTCompleteTaskView" owner:nil options:nil] lastObject];
    if (self) {
        self.showTime = 3;
        self.bgView.layer.cornerRadius = 15;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addGestureRecognizer:tap];
        
        self.btnBgImageView.layer.cornerRadius = 15;
        self.btnBgImageView.clipsToBounds = YES;
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFAE01],[UIColor colorWithHex:0xFF6E02]] gradientType:1 imgSize:CGSizeMake(80, 30)];
        [self.btnBgImageView setImage:bgImage];
        [self.taskBtn setEnabled:NO];
        //            self.memberLabelBg.image = bgImage;
        
    }
    return self;
}
- (void)tapAction{
    [self pushToTaskVC];
    [self dissMiss];

    // 清除 rootViewController 的presentedViewController
    [[XLTPopTaskViewManager shareManager] clearPopedViews];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            if (appDelegate.window.rootViewController.presentedViewController != nil) {
                [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                }];
            }
        }
    }
}
- (void)pushToTaskVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTUserTaskH5Url;
    web.fullScreen = YES;
    web.title = @"任务中心";
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:web animated:YES];
}
- (void)setTipImage:(UIImage *)tipImage{
    [self.iconImageView setImage:tipImage];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)show{
    if (self.superview) {
        return;
    }
    XLT_WeakSelf
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 1;
        [self dissMissAfterDelay:self.showTime];
    } completion:^(BOOL finished) {

    }];
}
- (void)dissMissAfterDelay:(NSTimeInterval )time{
    XLT_WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XLT_StrongSelf;
        [self dissMiss];
    });
}
- (void)dissMiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self removeFromSuperview];
    }];
}

@end
