//
//  XLTCategoryLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/6.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCategoryLogic.h"


@implementation XLTCategoryModel



@end

@implementation XLTCategoryLogic
- (void)xingletaonetwork_requestAllCategoryDataSuccess:(void(^)(NSArray *categoryArray))success
                            failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"1" forKey:@"all"];
    [XLTNetworkHelper GET:kCategorysUrl parameters:parameters responseCache:^(id responseCache) {
        if ([responseCache isKindOfClass:[NSDictionary class]]) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseCache];
            if ([model.data isKindOfClass:[NSArray class]]) {
                NSArray *categoryModelArray = [self letaoBuildFirstLevelArray:model.data];
                success(categoryModelArray);
            }
        }
    } success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *categoryModelArray = [self letaoBuildFirstLevelArray:model.data];
                success(categoryModelArray);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}

- (NSArray *)letaoBuildFirstLevelArray:(NSArray *)categoryArray {
//    level1
    NSMutableArray *firstLevelArray = [NSMutableArray array];
    @try {
        [categoryArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"level"] integerValue] == 1
                && [obj[@"status"] integerValue] == 1) {
                XLTCategoryModel *item = [[XLTCategoryModel alloc] init];
                item.letaoCategoryId = obj[@"_id"];
                item.letaoCategoryName = obj[@"name"];
                item.letaoCategoryIcon = obj[@"icon"];
                item.letaoLevel = obj[@"level"];
                [firstLevelArray addObject:item];
                [self letaoBuildSecondLevelArray:categoryArray withTopCategory:item];
                [item.letaoChildCategoryArray enumerateObjectsUsingBlock:^(XLTCategoryModel *  _Nonnull categoryItem, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self letaoBuildThirdLevelArray:categoryArray withTopCategory:categoryItem];
                }];
            }
            
        }];
    } @catch (NSException *exception) {
        firstLevelArray = [NSMutableArray array];
    } @finally {
    }
    return firstLevelArray;
}

- (void)letaoBuildSecondLevelArray:(NSArray *)categoryArray withTopCategory:(XLTCategoryModel *)topCategoryItem {
//    level2
    NSMutableArray *secondLevelArray = [NSMutableArray array];
    @try {
        [categoryArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"level"] integerValue] == 2
                && [obj[@"status"] integerValue] == 1) {
                NSString *pid = obj[@"pid"];
                if ([pid isEqualToString:topCategoryItem.letaoCategoryId]) {
                    XLTCategoryModel *item = [[XLTCategoryModel alloc] init];
                    item.letaoCategoryId = obj[@"_id"];
                    item.letaoCategoryName = obj[@"name"];
                    item.letaoCategoryIcon = obj[@"icon"];
                    item.letaoLevel = obj[@"level"];
                    [secondLevelArray addObject:item];
                }
            }
            
        }];
    } @catch (NSException *exception) {
        secondLevelArray = [NSMutableArray array];
    } @finally {
    }
    topCategoryItem.letaoChildCategoryArray = secondLevelArray;
}


- (void)letaoBuildThirdLevelArray:(NSArray *)categoryArray withTopCategory:(XLTCategoryModel *)topCategoryItem {
//    level3
    NSMutableArray *thirdLevelArray = [NSMutableArray array];
    @try {
        [categoryArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"level"] integerValue] == 3
                && [obj[@"status"] integerValue] == 1) {
                NSString *pid = obj[@"pid"];
                if ([pid isEqualToString:topCategoryItem.letaoCategoryId]) {
                    XLTCategoryModel *item = [[XLTCategoryModel alloc] init];
                    item.letaoCategoryId = obj[@"_id"];
                    item.letaoCategoryName = obj[@"name"];
                    item.letaoCategoryIcon = obj[@"icon"];
                    item.letaoLevel = obj[@"level"];
                    [thirdLevelArray addObject:item];
                }

            }
            
        }];
    } @catch (NSException *exception) {
        thirdLevelArray = [NSMutableArray array];
    } @finally {
    }
    topCategoryItem.letaoChildCategoryArray = thirdLevelArray;
}

@end
