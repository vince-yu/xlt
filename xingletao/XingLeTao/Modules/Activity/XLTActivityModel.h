//
//  XLTActivityModel.h
//  XingLeTao
//
//  Created by SNQU on 2020/4/24.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

@interface XLTActivityStyleModel : XLTBaseModel
@property (nonatomic ,copy) NSString *bgcolor;
@property (nonatomic ,copy) NSString *bgImage;
@property (nonatomic ,copy) NSString * bgImage_url;
@end

@interface XLTActivityBtnModel : XLTBaseModel
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *color;
@property (nonatomic ,copy) NSString *bgColor;

@end


@interface XLTActivityModel : XLTBaseModel
@property (nonatomic ,copy) NSString *acId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *acCode;
@property (nonatomic ,copy) NSString *platform;
@property (nonatomic ,copy) NSString *link;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,strong) XLTActivityStyleModel *style;
@property (nonatomic ,copy) NSArray *button;

@property (nonatomic ,copy) NSArray *link_type;
@property (nonatomic ,copy) NSString *link_url;
@property (nonatomic ,copy) NSString *tid;
@property (nonatomic ,copy) NSNumber *open_third_app;
@property (nonatomic ,strong) NSNumber *direct_protocal;
@property (nonatomic ,strong) NSNumber *direct;

@end

@interface XLTActivityLinkModel : XLTBaseModel
@property (nonatomic ,copy) NSString *click_url;
@property (nonatomic ,copy) NSString *item_url;
@property (nonatomic ,copy) NSString *position_id;
@property (nonatomic ,copy) NSString *tCode;

@end

