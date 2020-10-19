//
//  XLTMyWatermarkViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyWatermarkViewController.h"
#import "XLTMyWatermarkSwitchCell.h"
#import "XLTMyWatermarkCell.h"
#import "XLTMyWatermarkLogic.h"
#import "UIImage+UIColor.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

@interface XLTMyWatermarkViewController () <UITableViewDelegate, UITableViewDataSource, XLTMyWatermarkCellDelegate, XLTMyWatermarkSwitchCellDelegate>
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, assign) BOOL watermarkSwitchOn;
@property (nonatomic, strong, nullable) NSString *watermarkText;

@end

@implementation XLTMyWatermarkViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.watermarkSwitchOn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置专属水印";
    self.view.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
    [self requestMyWatermarkInfo];
}

- (void)requestMyWatermarkInfo {
    [self letaoShowLoading];
    __weak __typeof(self)weakSelf = self;
    [[XLTMyWatermarkLogic shareInstance] requestMyWatermarkInfoSuccess:^(NSDictionary * _Nonnull info) {
        [weakSelf reloadContentViewInfo];
        [weakSelf letaoShowLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf reloadContentViewInfo];
        [weakSelf letaoShowLoading];
    }];
}

- (void)reloadContentViewInfo {
    
    self.watermarkText = [XLTMyWatermarkLogic shareInstance].watermarkText;
    if ([self.watermarkText isKindOfClass:[NSString class]] && self.watermarkText.length > 0) {
        self.watermarkSwitchOn = [XLTMyWatermarkLogic shareInstance].watermarkSwitchOn;
    } else {
        // 没有设置水印，默认打开
        self.watermarkSwitchOn = YES;
    }
    [self loadContentTableView];
    [self loadSureButton];
}


- (void)loadContentTableView {
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _contentTableView.pagingEnabled = YES;
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentTableView.sectionFooterHeight = 0;
    _contentTableView.sectionHeaderHeight = 0;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.estimatedRowHeight = 200;
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedSectionHeaderHeight = 0;
    _contentTableView.estimatedSectionFooterHeight = 0;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
    [self registerTableViewCells];
    
    [self.view addSubview:_contentTableView];
    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-103);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).offset(-103);
        }
    }];

}

- (void)loadSureButton {
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:16];
    [_sureButton setTitle:@"保存" forState:UIControlStateNormal];
    [_sureButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateNormal];
    [_sureButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]] forState:UIControlStateDisabled];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 22.5;
    _sureButton.enabled = self.watermarkText.length > 0;
    _sureButton.hidden = !self.watermarkSwitchOn;
    [self.view addSubview:_sureButton];
    
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-39);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).offset(-39);
        }
        make.height.mas_equalTo(45);
    }];
}

- (void)registerTableViewCells {
    [_contentTableView registerNib:[UINib nibWithNibName:@"XLTMyWatermarkSwitchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyWatermarkSwitchCell"];
    [_contentTableView registerNib:[UINib nibWithNibName:@"XLTMyWatermarkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyWatermarkCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (!self.watermarkSwitchOn) {
            return 0;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTMyWatermarkSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyWatermarkSwitchCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.watermarkSwitch.on = self.watermarkSwitchOn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        XLTMyWatermarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyWatermarkCell" forIndexPath:indexPath];
        cell.watermarkLabel.text = self.watermarkText;
        cell.watermarkTextField.text = self.watermarkText;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)watermarkSwitchCell:(XLTMyWatermarkSwitchCell *)cell switchOn:(BOOL)on {
    if (!on) {
        [self letaoShowLoading];
         __weak __typeof(self)weakSelf = self;
        NSString *watermarkText = self.watermarkText;
        [[XLTMyWatermarkLogic shareInstance] updateMyWatermark:watermarkText enabled:on success:^(NSDictionary * _Nonnull info) {
            if (on) {
                [weakSelf showTipMessage:@"设置成功，快去分享商品图片吧"];
            } else {
                [weakSelf showTipMessage:@"关闭水印成功"];
            }
            weakSelf.watermarkSwitchOn = on;
            [weakSelf.contentTableView reloadData];
            weakSelf.sureButton.enabled = self.watermarkText.length > 0;
            weakSelf.sureButton.hidden = !self.watermarkSwitchOn;
            [weakSelf letaoRemoveLoading];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf.contentTableView reloadData];
            [weakSelf showTipMessage:errorMsg];
            [weakSelf letaoRemoveLoading];
        }];
    } else {
        self.watermarkSwitchOn = on;
        [self.contentTableView reloadData];
        self.sureButton.enabled = self.watermarkText.length > 0;
        self.sureButton.hidden = !self.watermarkSwitchOn;
    }

}


- (void)watermarkCell:(XLTMyWatermarkCell *)cell didChangeWatermarkText:(NSString *)watermarkText {
    self.watermarkText = watermarkText;
    _sureButton.enabled = self.watermarkText.length > 0;
    _sureButton.hidden = !self.watermarkSwitchOn;
}

- (void)sureButtonAction {
    NSString *watermarkText = self.watermarkText;
    BOOL watermarkSwitchOn = self.watermarkSwitchOn;
    if (watermarkSwitchOn) {
        if (watermarkText.length > 10) {
            [self showTipMessage:@"水印文字不能超过10个字!"];
            return;
        }
    }
     __weak __typeof(self)weakSelf = self;
    [[XLTMyWatermarkLogic shareInstance] updateMyWatermark:watermarkText enabled:watermarkSwitchOn success:^(NSDictionary * _Nonnull info) {
        if (watermarkSwitchOn) {
            [weakSelf showTipMessage:@"设置成功，快去分享商品图片吧"];
        } else {
            [weakSelf showTipMessage:@"关闭水印成功"];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showTipMessage:errorMsg];
    }];
    
}


- (void)watermarkCell:(XLTMyWatermarkCell *)cell browserImage:(UIImage *)image {
    if (image) {
        NSArray *imagesArray = [[XLTMyWatermarkLogic shareInstance] addWatermarkForImages:@[image] watermarkText:self.watermarkText];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        KSPhotoBrowser.imageViewBackgroundColor = UIColor.clearColor;
        
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < imagesArray.count; i++) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil image:imagesArray[i]];
            [items addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:self];
    }
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
