//
//  XLTMallMakeOrderVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallMakeOrderVC.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTAddressLogic.h"
#import "XLTAddAddressVC.h"
#import "XLTMallOrderLogic.h"
#import "WXApi.h"

@interface XLTMallMakeOrderVC () <XLTAddAddressVCDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *letaoGoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoAddressLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *lettaoSKULabel;
@property (nonatomic, weak) IBOutlet UILabel *lettaoGoodsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel *lettaoGoodsAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *lettaoFooterAmountLabel;


@property (nonatomic, weak) IBOutlet UIButton *lettaoAliPickButton;
@property (nonatomic, weak) IBOutlet UIButton *lettaoWXinPickButton;

@property (nonatomic, weak) IBOutlet UILabel *lettaoMemberTipLabel;
@property (nonatomic, strong) NSMutableArray *letaoAddressTaskArray;

@property (nonatomic, strong) NSDictionary *province;
@property (nonatomic, strong) NSDictionary *city;
@property (nonatomic, strong) NSDictionary *county;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sketch;

@end

@implementation XLTMallMakeOrderVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedAliPayNotification:) name:@"XLTReceviedAliPayNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWxinRespNotification:) name:@"kWxinAuthRespNotificationName" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.letaoAddressTaskArray = [NSMutableArray array];
    self.title = @"确认订单";
    
    self.lettaoMemberTipLabel.layer.masksToBounds = YES;
    self.lettaoMemberTipLabel.layer.cornerRadius = 2.0;
    self.lettaoAliPickButton.selected = YES;
    self.lettaoWXinPickButton.selected = NO;
    
    [self letaoUpdateGoodsDataWithInfo:self.goodsInfo];
    
    [self requestAddressInfo];

}

- (void)addAddressVC:(XLTAddAddressVC *)vc
     name:(NSString *)name
              phone:(NSString *)phone
      province_name:(NSString *)province_name
        province_id:(NSString *)province_id
city_name:(NSString *)city_name
          city_code:(NSString *)city_code
        county_name:(NSString *)county_name
        county_code:(NSString *)county_code
              sketch:(NSString *)sketch {
    
    self.name = name;
    self.phone = phone;
    self.sketch = sketch;
    if (province_name && province_id
        && city_name && city_code
        && county_name && county_code) {
        self.province = @{
            @"name": province_name,
            @"id": province_id
        };
                      
        self.city = @{
            @"province": province_name,
            @"name": city_name,
            @"id": city_code
        };
                      
        self.county = @{
            @"city": city_name,
            @"name": county_name,
            @"id": county_code
        };
    }
       
    
    [self cancelAddressInfo];
    [self setupAddressWithName:name phone:phone province_name:province_name city_name:city_name county_name:county_name sketch:sketch];
}

- (void)requestAddressInfo {
    __weak typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [XLTAddressLogic fetchAddressInfoSuccess:^(XLTBaseModel * _Nonnull model, NSURLSessionDataTask * _Nonnull task) {
        if ([weakSelf.letaoAddressTaskArray containsObject:task]) {
             [weakSelf.letaoAddressTaskArray removeObject:task];
            NSDictionary *info = model.data;
            NSString *name = info[@"name"];
            NSString *phone = info[@"phone"];
            NSString *full_addr = info[@"full_addr"];
            self.name = name;
            self.phone = phone;
            self.sketch = info[@"sketch"];
            
            NSString *province_name = info[@"province_name"];
            NSString *province_id = info[@"province_origin_code"];
            
            NSString *city_name = info[@"city_name"];
            NSString *city_code = info[@"city_origin_code"];
            
            NSString *county_name = info[@"county_name"];
            NSString *county_code = info[@"county_origin_code"];
            if (province_name && province_id
                && city_name && city_code
                && county_name && county_code) {
                self.province = @{
                    @"name": province_name,
                    @"id": province_id
                };
                
                self.city = @{
                    @"province": province_name,
                    @"name": city_name,
                    @"id": city_code
                };
                
                self.county = @{
                    @"city": city_name,
                    @"name": county_name,
                    @"id": county_code
                };
            }
            
            [self setupAddressWithName:name phone:phone full_addr:full_addr];
        }
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        if ([weakSelf.letaoAddressTaskArray containsObject:task]) {
            [weakSelf.letaoAddressTaskArray removeObject:task];
        }
    }];
    sessionTask ? [self.letaoAddressTaskArray  addObject:sessionTask] : nil ;
}

-  (void)setupAddressWithName:(NSString *)name
                        phone:(NSString *)phone
                    full_addr:(NSString *)full_addr {
    if ([name isKindOfClass:[NSString class]]
        && [phone isKindOfClass:[NSString class]]
        && [full_addr isKindOfClass:[NSString class]]) {
        NSString *title = [NSString stringWithFormat:@"%@   %@",name,phone];
        self.letaoNameLabel.textColor = [UIColor colorWithHex:0xFF131413];
        self.letaoNameLabel.text = title;
        self.letaoNameLabel.numberOfLines = 1;
        self.letaoAddressLabel.text = full_addr;
    }
}
-  (void)setupAddressWithName:(NSString *)name
                                             phone:(NSString *)phone
                                     province_name:(NSString *)province_name
                                         city_name:(NSString *)city_name
                                       county_name:(NSString *)county_name
                                            sketch:(NSString *)sketch {
    NSString *full_addr =  [NSString stringWithFormat:@"%@%@%@%@",province_name,city_name,county_name,sketch];
    [self setupAddressWithName:name phone:phone full_addr:full_addr];
}

- (void)cancelAddressInfo {
    @synchronized (self) {
        [self.letaoAddressTaskArray enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.letaoAddressTaskArray removeAllObjects];
    }
}





- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}




- (void)letaoUpdateGoodsDataWithInfo:(id _Nullable )itemInfo {
    NSNumber *price = nil;
    NSNumber *spec = nil;
    NSString *title = nil;
    NSString *imageUrl = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        price = ([itemInfo[@"price"] isKindOfClass:[NSString class]] || [itemInfo[@"price"] isKindOfClass:[NSNumber class]]) ? itemInfo[@"price"] : nil;
        spec = [itemInfo[@"spec"] isKindOfClass:[NSNumber class]] ? itemInfo[@"spec"] : nil;
        title = [itemInfo[@"title"] isKindOfClass:[NSString class]] ? itemInfo[@"title"] : nil;
        spec = [itemInfo[@"spec"] isKindOfClass:[NSString class]] ? itemInfo[@"spec"] : @"";
        
        NSArray *banner = itemInfo[@"banner"];
        if ([banner isKindOfClass:[NSArray class]]) {
            NSString * fristiImageUrl = banner.firstObject;
            if ([fristiImageUrl isKindOfClass:[NSString class]]) {
                imageUrl = fristiImageUrl;
            }
        }
    }
    [self.letaoGoodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kPlaceholderSmallImage];
    
    self.letaoGoodsTitleLabel.text = title;
    self.lettaoSKULabel.text = [NSString stringWithFormat:@"规格：%@",spec];
    self.letaoPriceLabel.text = [NSString stringWithFormat:@"￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:price]];
    self.lettaoGoodsAmountLabel.text = self.letaoPriceLabel.text;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：￥%@ ",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:price]]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoRegularFontWithSize:14.0] range:NSMakeRange(0, 3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF31302E] range:NSMakeRange(0, 3)];

    [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:20.0] range:NSMakeRange(3, attributedString.length -3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor letaomainColorSkinColor] range:NSMakeRange(3, attributedString.length -3)];
    self.lettaoFooterAmountLabel.text = nil;
    self.lettaoFooterAmountLabel.attributedText = attributedString;

}

- (IBAction)lettaoAliPickButtonClicked:(id)sender {
    self.lettaoAliPickButton.selected = !self.lettaoAliPickButton.selected;
    self.lettaoWXinPickButton.selected = !self.lettaoAliPickButton.selected;
}

- (IBAction)lettaoWXinPickButtonClicked:(id)sender {
    self.lettaoWXinPickButton.selected = !self.lettaoWXinPickButton.selected;
    self.lettaoAliPickButton.selected = !self.lettaoWXinPickButton.selected;
}

- (IBAction)lettaoSureButtonClicked:(id)sender {
    if (self.letaoNameLabel.text.length < 1
        || self.letaoAddressLabel.text.length <1) {
        [self showTipMessage:@"请先输入地址"];
        return;
    }
    NSString *goodsId = self.goodsInfo[@"_id"];
    NSString *payType = nil;
    BOOL isWXinPick = NO;
    if (self.lettaoWXinPickButton.selected) {
        payType = @"wechat";
        isWXinPick = YES;
    } else {
        payType = @"alipay";
    }
    if (isWXinPick) {
        if(![WXApi isWXAppInstalled]) {
            [self showTipMessage:@"您还未安装微信"];
            return;
        }
    }
     __weak typeof(self)weakSelf = self;
    [self letaoShowLoading];
    [XLTMallOrderLogic genOrderWithGoodsId:goodsId payType:payType success:^(XLTBaseModel * _Nonnull model, NSURLSessionDataTask * _Nonnull task) {
        if (isWXinPick) {
            [self startWXinPayWithOrderInfo:model.data];
        } else {
            [self startAliPayWithOrderInfo:model.data];
        }
        [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
         [weakSelf letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}

- (void)startAliPayWithOrderInfo:(NSDictionary *)orderInfo {
    if ([orderInfo isKindOfClass:[NSDictionary class]]) {
        NSString *payWithorderString = orderInfo[@"orderInfo"];
        if ([payWithorderString isKindOfClass:[NSString class]]) {
//            [[XLTAliPayManager shareManager] payWithorderString:payWithorderString];

        }
    }

}

- (void)startWXinPayWithOrderInfo:(NSDictionary *)orderInfo {
    if ([orderInfo isKindOfClass:[NSDictionary class]]) {
        @try {
            NSString *partnerId = orderInfo[@"partnerid"];
            NSString *prepayId = orderInfo[@"prepayid"];
            NSString *package = orderInfo[@"package"];
            NSString *noncestr = orderInfo[@"noncestr"];
            UInt32 timeStamp = (UInt32)[orderInfo[@"timestamp"] longLongValue];
            NSString *sign = orderInfo[@"sign"];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = partnerId;
            request.prepayId= prepayId;
            request.package = package;
            request.nonceStr= noncestr;
            request.timeStamp = timeStamp;
            request.sign = sign;
            [WXApi sendReq:request completion:nil];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }

    }

}

- (void)receviedAliPayNotification:(NSNotification *)notification {
    [self showTipMessage:@"支付成功"];
    [self didPayFinished];
}

- (void)receiveWxinRespNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)notification.object;
        switch (response.errCode) {
            case WXSuccess:
                [self showTipMessage:@"支付成功"];
                [self didPayFinished];
                break;
            case WXErrCodeUserCancel:
                [self showTipMessage:@"已取消支付"];
                break;
            default:
                [self showTipMessage:@"支付失败"];
                break;
        }
    }
}

- (void)didPayFinished {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)addressButtonClicked:(id)sender {
    XLTAddAddressVC *addressVC = [[XLTAddAddressVC alloc] init];
    addressVC.delegate = self;
    addressVC.province = self.province;
    addressVC.city = self.city;
    addressVC.county = self.county;
    addressVC.name = self.name;
    addressVC.phone = self.phone;
    addressVC.sketch = self.sketch;
    [self.navigationController pushViewController:addressVC animated:YES];
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
