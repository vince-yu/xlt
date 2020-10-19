//
//  XLTVipRightsModel.h
//  XingLeTao
//
//  Created by SNQU on 2020/2/4.
//  Copyright © 2020 snqu. All rights reserved.
//

/*
 {
     "data": - {                //类型：Object  必有字段  备注：无
         "list": - [                //类型：Array  必有字段  备注：无
              - {                //类型：Object  必有字段  备注：无
                 "_id":"5e38f10f02dce61b58002f53",                //类型：String  必有字段  备注：无
                 "level":3,                //类型：Number  必有字段  备注：等级 对比data.level可判定当前权益
                 "icon":"//",                //类型：String  必有字段  备注：无
                 "rights": - [                //类型：Array  必有字段  备注：无
                      - {                //类型：Object  必有字段  备注：无
                         "title":"主标题",                //类型：String  必有字段  备注：主标题
                         "icon":"//",                //类型：String  必有字段  备注：权益图标
                         "subtitle":"副标题"                //类型：String  必有字段  备注：副标题
                     }
                 ],
                 "moreimg": - [                //类型：Array  必有字段  备注：更多图标
                     "//"                //类型：String  必有字段  备注：无
                 ],
                 "itime":1580790031,                //类型：Number  必有字段  备注：无
                 "utime":1580794744,                //类型：Number  必有字段  备注：无
                 "level_name":"超级会员"                //类型：String  必有字段  备注：等级名称
             }
         ],
         "level":3                //类型：Number  必有字段  备注：无
     },
     "message":"success",                //类型：String  必有字段  备注：无
     "code":0                //类型：Number  必有字段  备注：无
 }
 */

#import <Foundation/Foundation.h>
#import "XLTBaseModel.h"

//NS_ASSUME_NONNULL_BEGIN

@interface XLTVipMoreImageModel : XLTBaseModel
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *url;
@end

@interface XLTVipRightItemDetail : XLTBaseModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *subtitle;

@end

@interface XLTVipRightItem : XLTBaseModel
@property (nonatomic ,copy) NSString *_id;
@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSArray *rights;
@property (nonatomic ,copy) NSArray *moreimg;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *utime;
@property (nonatomic ,copy) NSString *level_name;

@end

@interface XLTVipRightsModel : XLTBaseModel
@property (nonatomic ,strong) NSArray *list;
@property (nonatomic ,copy) NSString *level;
@end

//NS_ASSUME_NONNULL_END
