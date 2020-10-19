//
//  XLTCategoryListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCategoryListVC.h"
#import "UIImage+UIColor.h"
#import "XLTCategoryLogic.h"
#import "XLTCategorysView.h"
#import "LetaoEmptyCoverView.h"
#import <AVFoundation/AVFoundation.h>
#import "XLTQRCodeScanViewController.h"
#import "XLTCategoryFilterListVC.h"
#import "XLTSearchViewController.h"

@interface XLTCategoryListVC ()
@property (nonatomic, strong) UIView *letaoTopHeader;
@property (nonatomic, strong) NSArray *letaoCategoryDataArray;
@property (nonatomic, strong) XLTCategoryLogic *letaoCategoryLogic;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic, strong) XLTCategorysView *letaoCategorysView;

@property (nonatomic, copy) NSString *needPickCategoryId;
@property (nonatomic, copy) NSNumber *needPickCategoryLevel;
@end

@implementation XLTCategoryListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(supportGoodsPlatformValueNotification) name:@"kSupportGoodsPlatformValueNotification" object:nil];
    }
    return self;
}

- (void)supportGoodsPlatformValueNotification {
    if (!self.viewLoaded) {
        return;
    }
    [self xingletaonetwork_requestCategoryData];
}

- (void)needPickCategory:(NSString *)categoryId categoryLevel:(NSNumber *)categoryLevel {
    self.needPickCategoryId = categoryId;
    self.needPickCategoryLevel = categoryLevel;
    
    [self scrollCategoryToNeedPosition];
}

- (void)scrollCategoryToNeedPosition {
    if (self.letaoCategoryDataArray.count > 0
        && self.needPickCategoryId
        && self.needPickCategoryLevel) {
        NSString *needPickCategoryId = self.needPickCategoryId;
        NSNumber *needPickCategoryLevel = self.needPickCategoryLevel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.letaoCategorysView needPickCategory:needPickCategoryId categoryLevel:needPickCategoryLevel];
        });
        self.needPickCategoryId = nil;
        self.needPickCategoryLevel = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildTopHeader];
    [self xingletaonetwork_requestCategoryData];
}

- (void)xingletaonetwork_requestCategoryData {
    if (self.letaoCategoryLogic == nil) {
        self.letaoCategoryLogic = [[XLTCategoryLogic alloc] init];
    }
    if (self.letaoCategoryDataArray.count == 0) {
        [self letaoShowLoading];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoCategoryLogic xingletaonetwork_requestAllCategoryDataSuccess:^(NSArray * _Nonnull categoryArray) {
        [weakSelf letaoRemoveLoading];
        [weakSelf letaoSetupCategorysViewWithArray:categoryArray];
        [weakSelf scrollCategoryToNeedPosition];
    } failure:^(NSString * _Nonnull errorMsg) {
        if (weakSelf.letaoCategoryDataArray.count == 0) {
            [weakSelf letaoRemoveLoading];
            [weakSelf letaoShowErrorView];
        }
    }];
}

- (void)letaoSetupCategorysViewWithArray:(NSArray *)categoryArray {
    if (self.letaoCategorysView) {
        [self.letaoCategorysView removeFromSuperview];
        self.letaoCategorysView = nil;
    }
     __weak typeof(self)weakSelf = self;
     XLTCategorysView *categorysView = [[XLTCategorysView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.letaoTopHeader.frame), self.view.bounds.size.width, self.view.bounds.size.height -CGRectGetMaxY(self.letaoTopHeader.frame)) withCategorysArray:categoryArray withSelectIndex:^(NSInteger left, NSInteger right,XLTCategoryModel* info) {
         [weakSelf letaoSelectedCategor:info leftIndex:left];
     }];
    categorysView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    categorysView.letaoIsRecordLastScrollPosition = NO;
    categorysView.letaoIsRecordLastScrollAnimated = YES;
    [self.view addSubview:categorysView];
    if (categoryArray.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            categorysView.letaoNeedToScorllerIndex = 0;
        });
    }
    self.letaoCategorysView = categorysView;
    self.letaoCategoryDataArray = categoryArray;
}

- (void)letaoSelectedCategor:(XLTCategoryModel *)item leftIndex:(NSInteger)left {
    XLTCategoryFilterListVC *listViewController = [[XLTCategoryFilterListVC alloc] init];
    listViewController.nonePlateList = YES;
    listViewController.categoryId = item.letaoCategoryId;
    listViewController.plateName = item.letaoCategoryName;
    listViewController.categoryLevel = item.letaoLevel;
    if (left >=0 && left < self.letaoCategoryDataArray.count) {
        XLTCategoryModel *leftCategoryModel = self.letaoCategoryDataArray[left];
        listViewController.parentCategoryId = leftCategoryModel.letaoCategoryId;
        listViewController.parentCategoryName = leftCategoryModel.letaoCategoryName;
    }
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)buildTopHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSafeAreaInsetsTop)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:headerView];
    self.letaoTopHeader = headerView;
    
    UIButton *qrcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrcodeButton setImage:[UIImage imageNamed:@"xinletao_home_qrcode_gray"] forState:UIControlStateNormal];
    qrcodeButton.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
    [qrcodeButton addTarget:self action:@selector(qrcodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:qrcodeButton];
    
    UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qrcodeButton.frame), qrcodeButton.frame.origin.y +7, headerView.bounds.size.width - 15 -CGRectGetMaxX(qrcodeButton.frame), 30)];
    letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[XLTAppPlatformManager shareManager] platformText:@"搜索商品标题 领优惠券拿返现"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
    letaoSearchTextFiled.backgroundColor = [UIColor colorWithHex:0xFFF5F6F7];
    letaoSearchTextFiled.layer.masksToBounds = YES;
    letaoSearchTextFiled.layer.cornerRadius = 15;
    [headerView addSubview:letaoSearchTextFiled];
    
    UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 3, 13, 13)];
    searchIconImageView.image = [UIImage imageNamed:@"xinletao_home_search_image"];
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+13+5, 20)];
    [leftPaddingView addSubview:searchIconImageView];
    leftPaddingView.backgroundColor = [UIColor clearColor];
    letaoSearchTextFiled.leftView = leftPaddingView;
    letaoSearchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *searchBarOverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBarOverButton.backgroundColor = [UIColor clearColor];
    searchBarOverButton.frame = letaoSearchTextFiled.bounds;
    searchBarOverButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [searchBarOverButton addTarget:self action:@selector(letaoSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [letaoSearchTextFiled addSubview:searchBarOverButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bounds.size.height - 0.5, headerView.bounds.size.width, 0.5)];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    line.backgroundColor = [UIColor colorWithHex:0xFFEBEBED];
    [headerView addSubview:line];
    [headerView addSubview:line];
}



- (void)letaoShowEmptyView {
    if (self.letaoEmptyCoverView == nil) {
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无数据"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];
}

- (void)letaoRemoveEmptyView {
    [self.letaoEmptyCoverView removeFromSuperview];
}

- (void)letaoShowErrorView {
    if (self.letaoErrorView == nil) {
        __weak typeof(self)weakSelf = self;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xinletao_page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf letaoRemoveErrorView];
                                                                  [weakSelf xingletaonetwork_requestCategoryData];
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 28.f;
        letaoEmptyCoverView.contentViewOffset = - 50;
        
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:14.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        letaoEmptyCoverView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnHeight = 40.f;
        letaoEmptyCoverView.actionBtnHorizontalMargin = 62.f;
        letaoEmptyCoverView.actionBtnCornerRadius = 20.f;
        //        letaoEmptyCoverView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
        letaoEmptyCoverView.actionBtnBorderColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnBorderWidth = 0.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.letaoErrorView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoErrorView];
}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}

- (void)letaoSearchButtonClicked:(id)sender {
    XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:NO];
}



- (void)qrcodeBtnClicked:(id)sender {
    XLTQRCodeScanViewController *loginViewController = [[XLTQRCodeScanViewController alloc] init];
    [self letaoPushScanVC:loginViewController];
}

#pragma mark - QRCodeScan

- (void)letaoPushScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.navigationController pushViewController:scanVC animated:YES];
                            });
                            NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        } else {
                            NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        }
                    }];
                    break;
                }
                case AVAuthorizationStatusAuthorized: {
                    [self.navigationController pushViewController:scanVC animated:YES];
                    break;
                }
                case AVAuthorizationStatusDenied: {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - 星乐桃] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertC addAction:alertA];
                    [self presentViewController:alertC animated:YES completion:nil];
                    break;
                }
                case AVAuthorizationStatusRestricted: {
                    NSLog(@"因为系统原因, 无法访问相册");
                    break;
                }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation XLTCategoryPushListVC
- (void)buildTopHeader {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品分类";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:NO];
    [self letaoSetupNavigationWhiteBar];
}
@end
