//
//  XLTGoodsDetailVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsDetailVC : XLTBaseViewController
@property (nonatomic, copy) NSDictionary *letaoPassDetailInfo;
@property (nonatomic, copy) NSString *letaoGoodsId;
@property (nonatomic, copy) NSString *letaoGoodsSource;
@property (nonatomic, copy) NSString *letaoGoodsItemId;
@property (nonatomic, copy) NSString *letaoStoreId;
@property (nonatomic, copy) NSString *letaoParentPlateId;
@property (nonatomic, copy) NSString *letaoCurrentPlateId;
@property (nonatomic, assign) BOOL letaoIsCustomPlate;
@end

NS_ASSUME_NONNULL_END
