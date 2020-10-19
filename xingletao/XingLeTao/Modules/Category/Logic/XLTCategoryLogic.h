//
//  XLTCategoryModel.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/6.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"


NS_ASSUME_NONNULL_BEGIN

@interface XLTCategoryModel : NSObject
@property(copy,nonatomic) NSString * letaoCategoryIcon;
@property(copy,nonatomic) NSString * letaoCategoryName;
@property(copy,nonatomic) NSString * letaoCategoryId;
/**
 *  下一级菜单
 */
@property(strong,nonatomic) NSArray * letaoChildCategoryArray;
@property(assign,nonatomic) NSNumber * letaoLevel;

// 位置信息
@property(assign,nonatomic) float letaoTopOffset;

@end

@interface XLTCategoryLogic : XLTNetBaseLogic

- (void)xingletaonetwork_requestAllCategoryDataSuccess:(void(^)(NSArray *categoryArray))success
                            failure:(void(^)(NSString *errorMsg))failure;
@end




NS_ASSUME_NONNULL_END
