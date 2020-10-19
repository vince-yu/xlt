//
//  SndoADDataManger.h
//  SndoADSDK
//
//  Created by vince on 2020/7/21.
//  Copyright © 2020 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  广告展示失败类型枚举（主要看中文描述 T_T）
 */
typedef enum _SndoMobleErrorReason
{
    SndoMobleErrorReasonNoneImage = 0, // 广告图片加载失败
    
    SndoMobleErrorReasonParameterError, //参数错误
    
    SndoMobleErrorReasonNetWorkeError,  //网络或其它异常
    
    SndoMobleErrorReasonUnkonw //未知错误 看描述
    
}SndoMobleErrorReason;

#define IOS6M [[UIDevice currentDevice].systemVersion floatValue] > 6.0
#define IOS8M [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
#define IOS9M [[UIDevice currentDevice].systemVersion floatValue] >= 9.0
#define iPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define kSDStatusBarHeight  ((![[UIApplication sharedApplication] isStatusBarHidden] ) ? [[UIApplication sharedApplication] statusBarFrame].size.height : (iPhoneX_All?44.f:20.f))

#define TestServerURL @"http://cpro.sndo.com/api/app"
#define ServerURL @"https://cpro.sndo.com/api/app"

NS_ASSUME_NONNULL_BEGIN

@interface SndoADDataManger : NSObject
+ (SndoADDataManger *)sharedManager;
- (id )configAdRequest;
@end

NS_ASSUME_NONNULL_END
