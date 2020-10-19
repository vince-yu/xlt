//
//  XLTVideoListModel.h
//  XingLeTao
//
//  Created by SNQU on 2020/4/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

@interface XLTVideoCategaryModel : XLTBaseModel
@property (nonatomic ,copy) NSString *cid;
@property (nonatomic ,copy) NSString *title;
@end

@interface XLTVideoListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *videoId;
@property (nonatomic ,copy) NSString *activity_type;
@property (nonatomic ,copy) NSString *dy_trill_id;
@property (nonatomic ,copy) NSString *dy_video_like_count;
@property (nonatomic ,copy) NSString *dy_video_share_count;
@property (nonatomic ,copy) NSString *dy_video_title;
@property (nonatomic ,copy) NSString *dy_video_url;
@property (nonatomic ,copy) NSString *dynamic_image;
@property (nonatomic ,copy) NSString *first_frame;
@property (nonatomic ,copy) NSString *fqcat;
@property (nonatomic ,copy) NSString *general_index;
@property (nonatomic ,copy) NSString *goods_id;
@property (nonatomic ,copy) NSString *item_desc;
@property (nonatomic ,copy) NSString *item_id;
@property (nonatomic ,copy) NSString *item_pic;
@property (nonatomic ,copy) NSString *item_pic_copy;
@property (nonatomic ,copy) NSString *item_price;
@property (nonatomic ,copy) NSString *item_min_price;
@property (nonatomic ,copy) NSString *item_sale;
@property (nonatomic ,copy) NSString *item_sale2;
@property (nonatomic ,copy) NSString *item_short_title;
@property (nonatomic ,copy) NSString *item_sell_count;
@property (nonatomic ,copy) NSString *item_source;
@property (nonatomic ,copy) NSString *item_title;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *seller_id;
@property (nonatomic ,copy) NSString *seller_name;
@property (nonatomic ,copy) NSString *shop_id;
@property (nonatomic ,copy) NSString *shop_name;
@property (nonatomic ,copy) NSString *stock;
@property (nonatomic ,copy) NSString *today_sale;
@property (nonatomic ,copy) NSString *utime;
@property (nonatomic ,copy) NSString *yesterday_sale;
@property (nonatomic ,copy) NSDictionary *goods_info;
@end


