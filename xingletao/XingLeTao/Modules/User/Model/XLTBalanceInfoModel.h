//
//  XLTBalanceInfoModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTBalanceInfoModel : XLTBaseModel
@property (nonatomic ,copy) NSString *BlanceId;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *amountTaken;
@property (nonatomic ,copy) NSString *amountAvail;
@property (nonatomic ,copy) NSString *amountMonth;
@property (nonatomic ,copy) NSString *amountComing;
@property (nonatomic ,copy) NSString *orderTotalCount;
@property (nonatomic ,copy) NSString *orderTotalAmount;
@property (nonatomic ,copy) NSString *orderComingCount;
@property (nonatomic ,copy) NSString *orderComingAmount;
@property (nonatomic ,copy) NSString *orderAvailAmount;
@property (nonatomic ,copy) NSString *orderAvailCount;
@property (nonatomic ,copy) NSString *orderFailAmount;
@property (nonatomic ,copy) NSString *orderFailCount;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *estimatedRebateAmount;

//xlt
@property (nonatomic ,copy) NSString *amountTotal; //类型：Number  必有字段  备注：总收益
@property (nonatomic ,copy) NSString *amountFrozen;
@property (nonatomic ,copy) NSString *unsettledAmount;  //类型：String  必有字段  备注：未结算金额
@property (nonatomic ,copy) NSString *withdrawAmount;    //类型：String  必有字段  备注：总提现
@property (nonatomic ,copy) NSString *amountUseable;  //类型：String  必有字段  备注：可提现余额 = 总收益- 总提现
@property (nonatomic ,copy) NSString *withdraw_success_amount;
@property (nonatomic ,copy) NSString *helptext;
@end

NS_ASSUME_NONNULL_END
