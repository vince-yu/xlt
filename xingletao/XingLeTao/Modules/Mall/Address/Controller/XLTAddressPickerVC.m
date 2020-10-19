//
//  XLTAddressPickerVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAddressPickerVC.h"
#import "HMSegmentedControl.h"
#import "XLTScrolledPageView.h"
#import "XLTAddressPickerCityListVC.h"

@interface XLTAddressPickerVC () <XLTAddressPickerCityListVCDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) XLTAddressPickerCityListVC *provinceVC;
@property (nonatomic, strong) XLTAddressPickerCityListVC *cityVC;
@property (nonatomic, strong) XLTAddressPickerCityListVC *countyVC;

@end

@implementation XLTAddressPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildSegmentedControl];
    [self loadProvince:self.province city:self.city county:self.county];
}

- (void)buildSegmentedControl {
    // 配置`菜单视图`
    CGFloat segmentedControlWidth = self.contentBgView.bounds.size.width - 30;
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(ceilf((self.contentBgView.bounds.size.width - segmentedControlWidth)/2), 0, segmentedControlWidth, 44)];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.selectionIndicatorHeight = 1.0;
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF333333]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    _segmentedControl.sectionTitles = [self segmentedControlSectionTitles];
    [_segmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentBgView addSubview:_segmentedControl];
    
}


- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self loadProvincePage];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        [self loadCityPage];

    } else {
          [self loadCountyPage];
    }
    _segmentedControl.sectionTitles = [self segmentedControlSectionTitles];
}

- (void)loadProvincePage{
    if (self.provinceVC == nil) {
        self.provinceVC = [[XLTAddressPickerCityListVC alloc] init];
        self.provinceVC.pickerType = XLTAddressPickerProvinceType;
        self.provinceVC.delegate = self;
    }
    self.provinceVC.provinceCode = self.province[@"id"];
    [self addChildViewController:self.provinceVC];
    [self.provinceVC didMoveToParentViewController:self];
    [self.contentBgView addSubview:self.provinceVC.view];
    self.provinceVC.view.frame = CGRectMake(0, 44, self.contentBgView.bounds.size.width, self.contentBgView.height - 44);
    self.provinceVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)loadCityPage{
    if (self.cityVC == nil) {
        self.cityVC = [[XLTAddressPickerCityListVC alloc] init];
        self.cityVC.delegate = self;
        self.cityVC.pickerType = XLTAddressPickerCityType;
    }
    self.cityVC.provinceCode = self.province[@"id"];
    self.cityVC.cityCode = self.city[@"id"];
    [self addChildViewController:self.cityVC];
    [self.cityVC didMoveToParentViewController:self];
    [self.contentBgView addSubview:self.cityVC.view];
    self.cityVC.view.frame = CGRectMake(0, 44, self.contentBgView.bounds.size.width, self.contentBgView.height - 44);
    self.cityVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)loadCountyPage{
    if (self.countyVC == nil) {
        self.countyVC = [[XLTAddressPickerCityListVC alloc] init];
        self.countyVC.delegate = self;
        self.countyVC.pickerType = XLTAddressPickerCountyType;
    }
    self.countyVC.provinceCode = self.province[@"id"];
    self.countyVC.cityCode = self.city[@"id"];
    self.countyVC.countyCode = self.county[@"id"];
    [self addChildViewController:self.countyVC];
    [self.countyVC didMoveToParentViewController:self];
    [self.contentBgView addSubview:self.countyVC.view];
    self.countyVC.view.frame = CGRectMake(0, 44, self.contentBgView.bounds.size.width, self.contentBgView.height - 44);
    self.countyVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (NSArray *)segmentedControlSectionTitles {
    NSMutableArray *sectionTitles = [NSMutableArray array];
    if (self.province) {
        [sectionTitles addObject:self.province[@"name"]];
        if (self.city) {
            [sectionTitles addObject:self.city[@"name"]];
            if (self.county) {
                [sectionTitles addObject:self.county[@"name"]];
            } else {
                [sectionTitles addObject:@"请选择"];
            }
        } else {
            [sectionTitles addObject:@"请选择"];
        }

    } else {
        [sectionTitles addObject:@"请选择"];
    }
    return sectionTitles;

}

- (void)loadProvince:(NSDictionary * _Nullable)province
                city:(NSDictionary * _Nullable)city
              county:(NSDictionary * _Nullable)county {
    NSArray *segmentedControlSectionTitles = [self segmentedControlSectionTitles];
    _segmentedControl.sectionTitles = segmentedControlSectionTitles;
    if (segmentedControlSectionTitles.count > 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.segmentedControl.selectedSegmentIndex = segmentedControlSectionTitles.count -1;
        });

    }
    [self loadProvincePage];
    if (self.city != nil) {
        [self loadCityPage];
    }
    if (self.county != nil) {
        [self loadCountyPage];
    }
}

- (void)pickerCityListVC:(XLTAddressPickerCityListVC *)vc
          pickedProvince:(NSDictionary * _Nullable)province
                    city:(NSDictionary * _Nullable)city
                  county:(NSDictionary * _Nullable)county {
    self.province = province;
    self.city = city;
    self.county = county;
    if (vc.pickerType == XLTAddressPickerProvinceType) {
        @try {
            if (![self.provinceVC.provinceCode isEqualToString:self.province[@"id"]]) {
                [self removeCityPage];
                [self removeCountyPage];
            }
            [self loadCityPage];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } else if (vc.pickerType == XLTAddressPickerCityType) {
         @try {
             if (![self.cityVC.cityCode isEqualToString:self.city[@"id"]]) {
                 [self removeCountyPage];
             }
             [self loadCountyPage];
         } @catch (NSException *exception) {
             
         } @finally {
             
         }
    } else {
         if (province && city && county) {
            if ([self.delegate respondsToSelector:@selector(addressPickerVC:pickedProvince:city:county:)]) {
                [self.delegate addressPickerVC:self pickedProvince:province city:city county:county];
            }
            [self letaoCloseBtnClicked:nil];
        }
    }
    NSArray *segmentedControlSectionTitles = [self segmentedControlSectionTitles];
    _segmentedControl.sectionTitles = segmentedControlSectionTitles;
    if (segmentedControlSectionTitles.count > 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.segmentedControl.selectedSegmentIndex = segmentedControlSectionTitles.count -1;
        });
    }

}


- (void)removeCityPage {
    for (UIViewController *vc in self.childViewControllers) {
        // 推荐保留
        if(vc == self.cityVC) {
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
        }
    }
    [self.cityVC.view removeFromSuperview];
    self.cityVC = nil;
}

- (void)removeCountyPage {
    for (UIViewController *vc in self.childViewControllers) {
        // 推荐保留
        if(vc == self.countyVC) {
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
        }
    }
    [self.countyVC.view removeFromSuperview];
    self.countyVC = nil;
}



- (IBAction)letaoCloseBtnClicked:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.letaoBgView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
          self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
    [self dismissViewControllerAnimated:NO completion:nil];
    }];
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
