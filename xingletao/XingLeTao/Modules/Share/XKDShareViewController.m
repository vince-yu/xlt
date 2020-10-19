//
//  XTLShareViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/12.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XTLShareViewController.h"
#import "XKDShareManager.h"
#import "XKDURLConstant.h"
#import "XKDBaseModel.h"
#import "XKDQRCodeShareViewController.h"

@interface XTLShareViewController ()

@end

@implementation XTLShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSString *)goodsId {
    if ([self.detailModel.data isKindOfClass:[NSDictionary class]]
        && [self.detailModel.data[@"_id"] isKindOfClass:[NSString class]]) {
        return self.detailModel.data[@"_id"];
    }
    return @"";
}

- (NSString *)goodsTitle {
    if ([self.detailModel.data isKindOfClass:[NSDictionary class]]
        && [self.detailModel.data[@"item_title"] isKindOfClass:[NSString class]]) {
        return self.detailModel.data[@"item_title"];
    }
    return @"";
}

- (NSString *)goodsImageUrl {
    if ([self.detailModel.data isKindOfClass:[NSDictionary class]]
        && [self.detailModel.data[@"item_image"] isKindOfClass:[NSString class]]) {
        NSString *goodsImageUrl = [self.detailModel.data[@"item_image"] picUrl];
         NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:goodsImageUrl];
        NSString *httpScheme = @"http";
        if ([urlComponents.scheme isEqualToString:httpScheme]) {
           return [@"https" stringByAppendingString: [goodsImageUrl substringWithRange:NSMakeRange(httpScheme.length, goodsImageUrl.length - httpScheme.length)]];
        } else {
            return goodsImageUrl;
        }
        return [self.detailModel.data[@"item_image"] picUrl];
    }
    return @"";
}

- (NSString *)baseUrl {
    return [[XKDAppPlatformManager shareManager] baseH5SeverUrl];
}

- (IBAction)shareWeixin {
    if (![[XKDShareManager shareManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [self showTipMessage:@"你还未安装微信"];
    } else {
        //    域名/item/商品id.html
        NSString *goodUrl = [NSString stringWithFormat:@"%@item/%@.html",[self baseUrl],[self goodsId]];
        NSString *title = [self goodsTitle];
        NSString *content = @"我发现了一个不错的商品，巨划算，快来看看吧！";
        NSString *imgeUrl = [self goodsImageUrl];
        __weak typeof(self)weakSelf = self;
        [[XKDShareManager shareManager] shareWebPage:goodUrl title:title describe:content thumbURL:imgeUrl platformType:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
                if (error) {
                [weakSelf dismiss];
            } else {
                [weakSelf dismiss];
            }
        }];
    }
}

- (IBAction)shareQQ {
    if (![[XKDShareManager shareManager] isInstall:UMSocialPlatformType_QQ]) {
        [self showTipMessage:@"你还未安装QQ"];
    } else {
        //    域名/item/商品id.html
        NSString *goodUrl = [NSString stringWithFormat:@"%@item/%@.html",[self baseUrl],[self goodsId]];
        NSString *title = [self goodsTitle];
        NSString *content = @"我发现了一个不错的商品，巨划算，快来看看吧！";
        NSString *imgeUrl = [self goodsImageUrl];
        __weak typeof(self)weakSelf = self;
        [[XKDShareManager shareManager] shareWebPage:goodUrl title:title describe:content thumbURL:imgeUrl platformType:UMSocialPlatformType_QQ completion:^(id result, NSError *error) {
            if (error) {
                [weakSelf dismiss];
            } else {
                [weakSelf dismiss];
            }
        }];
    }
}

- (IBAction)shareWeibo {
    if (![[XKDShareManager shareManager] isInstall:UMSocialPlatformType_Sina]) {
        [self showTipMessage:@"你还未安装微博"];
    } else {
        //    域名/item/商品id.html
        NSString *goodUrl = [NSString stringWithFormat:@"%@item/%@.html",[self baseUrl],[self goodsId]];
        NSString *title = [self goodsTitle];
        NSString *content = @"我发现了一个不错的商品，巨划算，快来看看吧！";
        NSString *imgeUrl = [self goodsImageUrl];
        __weak typeof(self)weakSelf = self;
        [[XKDShareManager shareManager] shareWebPage:goodUrl title:[content stringByAppendingString:title] describe:@"" thumbURL:imgeUrl platformType:UMSocialPlatformType_Sina completion:^(id result, NSError *error) {
            if (error) {
                [weakSelf dismiss];
            } else {
                [weakSelf dismiss];
            }
        }];
    }
}

- (IBAction)qrcodeAction {
    UIViewController *p = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        XKDQRCodeShareViewController *viewController = [[XKDQRCodeShareViewController alloc] initWithNibName:@"XKDQRCodeShareViewController" bundle:[NSBundle mainBundle]];
           viewController.detailModel = self.detailModel;
           viewController.view.hidden = YES;
           p.definesPresentationContext = YES;
           viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
           [p presentViewController:viewController animated:NO completion:^{
               viewController.view.hidden = NO;
               viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
               viewController.bgView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
               [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                   viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                   viewController.bgView.transform=CGAffineTransformMakeTranslation(0, 0);
               } completion:^(BOOL finished) {
               }];
           }];
    }];
}


- (IBAction)invite {
    NSString *goodUrl = [NSString stringWithFormat:@"%@item/%@.html",[self baseUrl],[self goodsId]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = goodUrl;
    [[XKDAppPlatformManager shareManager] saveGoodsPasteboardValue:goodUrl];
    [self showTipMessage:@"复制邀请链接成功!"];
}

- (IBAction)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.bgView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
          self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
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
