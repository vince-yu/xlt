//
//  SDConstants.h
//  SndoDataSDK
//
//  Created by 向作为 on 2018/8/9.
//  Copyright © 2015-2020 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>


#pragma mark - typedef
/**
 * @abstract
 * Debug 模式，用于检验数据导入是否正确。该模式下，事件会逐条实时发送到 SndoData，并根据返回值检查
 * 数据导入是否正确。
 *
 * @discussion
 * Debug 模式的具体使用方式，请参考:
 *  http://www.sndodata.cn/manual/debug_mode.html
 *
 * Debug模式有三种选项:
 *   SndoDataDebugOff - 关闭 DEBUG 模式
 *   SndoDataDebugOnly - 打开 DEBUG 模式，但该模式下发送的数据仅用于调试，不进行数据导入
 *   SndoDataDebugAndTrack - 打开 DEBUG 模式，并将数据导入到 SndoData 中
 */
typedef NS_ENUM(NSInteger, SndoDataDebugMode) {
    SndoDataDebugOff,
    SndoDataDebugOnly,
    SndoDataDebugAndTrack,
};

/**
 * @abstract
 * TrackTimer 接口的时间单位。调用该接口时，传入时间单位，可以设置 event_duration 属性的时间单位。
 *
 * @discuss
 * 时间单位有以下选项：
 *   SndoDataTimeUnitMilliseconds - 毫秒
 *   SndoDataTimeUnitSeconds - 秒
 *   SndoDataTimeUnitMinutes - 分钟
 *   SndoDataTimeUnitHours - 小时
 */
typedef NS_ENUM(NSInteger, SndoDataTimeUnit) {
    SndoDataTimeUnitMilliseconds,
    SndoDataTimeUnitSeconds,
    SndoDataTimeUnitMinutes,
    SndoDataTimeUnitHours
};


/**
 * @abstract
 * AutoTrack 中的事件类型
 *
 * @discussion
 *   SndoDataEventTypeAppStart - $AppStart
 *   SndoDataEventTypeAppEnd - $AppEnd
 *   SndoDataEventTypeAppClick - $AppClick
 *   SndoDataEventTypeAppViewScreen - $AppViewScreen
 */
typedef NS_OPTIONS(NSInteger, SndoDataAutoTrackEventType) {
    SndoDataEventTypeNone      = 0,
    SndoDataEventTypeAppStart      = 1 << 0,
    SndoDataEventTypeAppEnd        = 1 << 1,
    SndoDataEventTypeAppClick      = 1 << 2,
    SndoDataEventTypeAppViewScreen = 1 << 3,
};

/**
 * @abstract
 * 网络类型
 *
 * @discussion
 *   SndoDataNetworkTypeNONE - NULL
 *   SndoDataNetworkType2G - 2G
 *   SndoDataNetworkType3G - 3G
 *   SndoDataNetworkType4G - 4G
 *   SndoDataNetworkTypeWIFI - WIFI
 *   SndoDataNetworkTypeALL - ALL
 */
typedef NS_OPTIONS(NSInteger, SndoDataNetworkType) {
    SndoDataNetworkTypeNONE      = 0,
    SndoDataNetworkType2G       = 1 << 0,
    SndoDataNetworkType3G       = 1 << 1,
    SndoDataNetworkType4G       = 1 << 2,
    SndoDataNetworkTypeWIFI     = 1 << 3,
    SndoDataNetworkTypeALL      = 0xFF,
};
