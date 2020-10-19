# AlipaySDK_No_UTDID

 支付宝支付 SDK ，适用于集成了百川 SDK，出现 UTDID 冲突，SDK 已适配 iPhoneX，支持 IPv6_only 网络和 ATS 安全标准，支持手动集成以及 Cocoapods 集成方式，持续更新。

## 安装 CocoaPods

在终端输入

```
sudo gem install cocoapods
```

如果安装成功，会有一个提示

```
Successfully installed cocoaPods
```

## 使用 CocoaPods 安装 SDK

在您项目工程 `.xcodeproj` 文件同目录下创建一个名为 `Podfile` 文件。如果您尚未创建 Xcode 项目，请立即创建一个并将其保存到您的本地计算机。

在当前工程文件 `.xcodeproj` 所在文件夹下，打开 terminal。

- 创建 `Podfile`

```
touch Podfile
```

- 编辑 `Podfile` 内容

```
platform :ios, '8.0' #手机的系统
target 'YourProjectTarget' do #工程名字
  pod “AlipaySDK_No_UTDID” #支付宝支付SDK
end   
```

- 在 `Podfile` 所在的文件夹下输入命令

```
pod install 
//这个可能比较慢，请耐心等待……
end 
```

- 导入成功，启动工程

## 升级新版 SDK

若已经安装了支付宝 iOS 支付 SDK，想要更新到最新版本，在 `Podfile` 文件的目录下使用以下命令

```
pod repo update #用于保证本地支付相关SDK为最新版 pod update   
```

## 使用 CocoaPods 的问题

`pod search` 无法搜索到类库的解决办法（找不到类库）：

- 执行 `pod setup`

- 删除 `~/Library/Caches/CocoaPods` 目录下的 `search_index.json` 文件

```
pod setup 成功后会生成~/Library/Caches/CocoaPods/search_index.json文件
终端输入rm ~/Library/Caches/CocoaPods/search_index.json
删除成功后再执行pod search
```

- 执行 `pod search`

## 使用 SDK

`import <AlipaySDK/AlipaySDK.h>` 后，在 `@implementation AppDelegate` 中以下代码中的 `NSLog` 改为实际业务处理代码。

```
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
```

## Swift 接入 SDK

- 如果项目使用 Swift 为开发语言，需要添加桥接文件，如 `Bridging-Header.h`

- 同时，在项目 `Build Settings` 中设置桥接文件的位置

- 添加成功后，在桥接文件中写入 `#import <AlipaySDK/AlipaySDK.h>`

- 如此，在需要调用 AlipaySDK 的地方，即可直接使用，具体调用方式参照 OC

- 注意，运行时如果发生报错，在桥接文件中，写入 `#import <UIKit/UIKit.h>`

## iOS 调用说明

> 接口名称：AlipaySDK
> 
> 接口描述：提供支付功能。

Alipay 接口主要为商户提供订单支付功能。接口所提供的方法，如下表所示：


| 方法名称 | 方法描述 |
| :-- | :-- |
| +(Alipay *)defaultService; | 获取服务实例。 |
| -(void)payOrder:(NSString *)orderStr fromScheme:(NSString *)schemeStr callback:(CompletionBlock)completionBlock; | 支付并通过回调返回结果。 |
| -(void)processOrderWithPaymentResult:(NSURL*)resultUrl standbyCallback:(CompletionBlock)completionBlock; | 处理支付宝客户端返回的 url（在 app 被杀模式下，通过这个方法获取支付结果）。 |

快捷订单支付 iOS

> 方法名称：pay 方法

> 方法原型：(void)payOrder:(NSString )orderStr fromScheme:(NSString )schemeStr callback:(CompletionBlock)completionBlock;

> 方法功能：提供给商户快捷订单支付功能。


| 参数名称 | 参数描述 |
| :-- | :-- |
| NSString* scheme | 商户程序注册的 URL protocol，供支付完成后回调商户程序使用 |
| (CompletionBlock)completionBlock | 快捷支付开发包回调函数，返回免登、支付结果。本地未安装支付宝客户端，或未成功调用支付宝客户端进行支付的情况下（走 H5 收银台），会通过该 completionBlock 返回支付结果。 |
| NSString* orderString | app 支付请求参数字符串，主要包含商户的订单信息，key=value 形式，以&连接。 |


处理客户端返回 url

> 方法名称：处理客户端方法

> 方法原型：-(void)processOrderWithPaymentResult:(NSURL*)resultUrl standbyCallback:(CompletionBlock)completionBlock;

> 方法功能：设备已安装支付宝客户端情况下，处理支付宝客户端返回的 url。


| 参数名称 | 参数描述 |
| :-- | :-- |
| NSURL *resultUrl | 支付宝客户端回传的 url |
| CompletionBlock completionBlock | 本地安装了支付宝客户端，且成功调用支付宝客户端进行支付的情况下，会通过该 completionBlock 返回支付结果 |


回调接口

在支付过程结束后，会通过 callbackBlock 同步返回支付结果（callbackBlock 是调用支付同步的回调）。支付结果中参数的提取，必须通过 CompletionBlock 获取，禁止开发者私自解析支付结果返回的 URL。

## 参考文档

App 支付 iOS 集成流程详见：[开发文档/App支付/iOS集成流程](https://docs.open.alipay.com/204/105295/)

## 许可 License

支付宝支付 SDK 是在 [MIT 的许可](https://github.com/caosuyang/AlipaySDK/blob/master/LICENSE)下发布的。


