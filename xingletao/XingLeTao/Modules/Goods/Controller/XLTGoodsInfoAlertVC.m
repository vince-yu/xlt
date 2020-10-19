//
//  XLTGoodsInfoAlertVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsInfoAlertVC.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+Helper.h"
#import "XLTGoodsDetailVC.h"
#import "XLTPopTaskViewManager.h"

@interface XLTGoodsInfoAlertVC ()

@end

@implementation XLTGoodsInfoAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.letaoearnLabel.layer.masksToBounds = YES;
    self.letaoearnLabel.layer.cornerRadius = 2.0;
    self.letaoearnLabel.layer.borderColor = self.letaoearnLabel.textColor.CGColor;
    self.letaoearnLabel.layer.borderWidth = 1.0;

    self.letaoBgView.backgroundColor = [UIColor whiteColor];
    self.letaoBgView.layer.masksToBounds = YES;
    self.letaoBgView.layer.cornerRadius = 10.0;
    
    
    self.letaoCancelBtn.layer.masksToBounds = YES;
    self.letaoCancelBtn.layer.cornerRadius = 18;
    self.letaoCancelBtn.layer.borderColor =  [UIColor colorWithHex:0xFFE3E3E6].CGColor;
    self.letaoCancelBtn.layer.borderWidth = 1.0;
    
    self.letaoOkBtn.layer.masksToBounds = YES;
    self.letaoOkBtn.layer.cornerRadius = 18;
    
    [self letaoUpdateCellDataWithInfo:self.letaoItemDictionary];
}



- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    NSNumber *earnAmount = nil;
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;

    
    NSString *letaosourceLabeltring = nil;
    NSString *letaoStoreNameLabelString = nil;
    NSNumber *paidNumber = nil;
    NSString *letaoGoodsTitleLabelString = nil;
    
    NSNumber *postageState = nil;

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        postageState = itemInfo[@"item_delivery_postage"];

        price = itemInfo[@"item_price"];
        letaosourceLabeltring = [XLTGoodsDisplayHelp letaoSourceTextForType:itemInfo[@"item_source"]];
        paidNumber = itemInfo[@"item_sell_count"];

        NSDictionary *seller = itemInfo[@"seller"];
        if ([seller isKindOfClass:[NSDictionary class]]) {
            letaoStoreNameLabelString = seller[@"seller_shop_name"];
        }
        letaoGoodsTitleLabelString = itemInfo[@"title"];
        if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
            letaoGoodsTitleLabelString = itemInfo[@"item_title"];
        }
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
    }
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    
    
    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:self.letaoearnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice originalPricePrefixText:@" ￥" letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[[NSDate dateTomorrow] timeIntervalSince1970]];
    self.letaoearnLabel.text = [NSString stringWithFormat:@" %@ ",self.letaoearnLabel.text];
    self.letaopricePrefixLabel.text = [NSString stringWithFormat:@" %@ ",self.letaopricePrefixLabel.text];
    
    
    NSString *picUrlString = itemInfo[@"pict_url"];
    if (![picUrlString isKindOfClass:[NSString class]]) {
        picUrlString = itemInfo[@"item_image"];
    }
    if ([picUrlString isKindOfClass:[NSString class]]) {
        [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[picUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    } else {
        [self.letaogoodsImageView setImage:kPlaceholderSmallImage];
    }
    
    NSString *couponAmountText = [NSString stringWithFormat:@" %@元券 ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    
    self.letaoCouponSpace.hidden = self.letaocouponAmountButton.hidden;
    
}

- (IBAction)letaoCancelBtnClicked:(id)sender {
    [self letaoDismissVCWithGoodsId:nil item_source:nil item_id:nil];
}

- (IBAction)letaoGoBtnClicked:(id)sender {
    NSString *letaoGoodsId = nil;
    NSString *item_source = nil;
    NSString *item_id = nil;
    if ([self.letaoItemDictionary isKindOfClass:[NSDictionary class]]) {
        letaoGoodsId = self.letaoItemDictionary[@"goods_id"];
        item_source = self.letaoItemDictionary[@"item_source"];
        item_id = self.letaoItemDictionary[@"item_id"];
        
        //汇报
        NSMutableDictionary *dic = @{}.mutableCopy;
        dic[@"good_id"] = [SDRepoManager repoResultValue:letaoGoodsId];
        dic[@"good_name"] = [SDRepoManager repoResultValue:self.letaoItemDictionary[@"item_title"]];
        NSString *paste_content = [UIPasteboard generalPasteboard].string;
        dic[@"xlt_item_search_keyword"] = [SDRepoManager repoResultValue:paste_content];
        dic[@"xlt_item_source"] = [SDRepoManager repoResultValue:item_source];
        dic[@"position_number"] = @1;
        dic[@"key_word_type"] = @"null";
        dic[@"search_way"] = @"复制链接解析搜索";
        dic[@"xlt_item_firstcate_title"] = @"null";
        dic[@"xlt_item_thirdcate_title"] = @"null";
        dic[@"xlt_item_secondcate_title"] = @"null";
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_SEARCHRESULT_CLICK properties:dic];
    }
    [self letaoDismissVCWithGoodsId:letaoGoodsId item_source:item_source item_id:item_id];
    
    
}



- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
                               itemInfo:(NSDictionary * _Nullable)itemInfo {
    
    self.letaoItemDictionary = itemInfo;
    self.view.hidden = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sourceViewController.definesPresentationContext = YES;
    self.letaoItemDictionary = itemInfo;
    [sourceViewController presentViewController:self animated:NO completion:^{
        self.view.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        self.letaoBgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
             self.letaoBgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)letaoDismissVCWithGoodsId:(NSString * _Nullable)letaoGoodsId item_source:(NSString * _Nullable)item_source item_id:(NSString * _Nullable)item_id {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.letaoBgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                if (letaoGoodsId) {
                    UIViewController *p = self.presentingViewController;
                    [self dismissViewControllerAnimated:NO completion:^{
                        XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
                         goodDetailViewController.letaoPassDetailInfo = self.letaoItemDictionary;
                        goodDetailViewController.letaoGoodsSource = item_source;
                        goodDetailViewController.letaoGoodsId = letaoGoodsId;
                        goodDetailViewController.letaoGoodsItemId = item_id;
                        if ([p isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *navigationController = (UINavigationController *)p;
                            [navigationController pushViewController:goodDetailViewController animated:YES];

                        } else {
                            [p.navigationController pushViewController:goodDetailViewController animated:YES];
                        }
                    }];
                    [[XLTPopTaskViewManager shareManager] removePopedView:self];
                } else {
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [[XLTPopTaskViewManager shareManager] removePopedView:self];
                }
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
