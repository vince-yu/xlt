//
//  XLTAddressPickerCityListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAddressPickerCityListVC.h"
#import "XLTAddressPickerCityCell.h"

@interface XLTAddressPickerCityListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSDictionary *cityDictionary;
@property (nonatomic, strong) NSDictionary *countyDictionary;

@property (nonatomic, strong) NSArray *pickDataArray;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, assign) NSInteger currentPickRow;

@end

@implementation XLTAddressPickerCityListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDataFromFile];
    [self setupCurrentPickRow];
    [self loadContentTableView];
    [self scrollTocurrentPickRow];
}
- (void)setupCurrentPickRow {
    self.currentPickRow = -1;
    NSString *codeString = nil;
    if (self.pickerType == XLTAddressPickerProvinceType) {
        if (self.provinceCode) {
            codeString = self.provinceCode;
        }
    } else if (self.pickerType == XLTAddressPickerCityType) {
        if (self.cityCode) {
             codeString = self.cityCode;
        }
    } else {
        if (self.countyCode) {
             codeString = self.countyCode;
        }
    }
    if ([codeString isKindOfClass:[NSString class]]) {
        [self.pickDataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *info = obj;
            if ([info isKindOfClass:[NSDictionary class]]) {
                NSString *code = info[@"id"];
                if ([code isKindOfClass:[NSString class]] && [code isEqualToString:codeString]) {
                    self.currentPickRow = idx;
                    *stop = YES;
                }
            }
        }];
    }
}


- (void)scrollTocurrentPickRow {
    if (self.currentPickRow >= 0 && self.currentPickRow < self.pickDataArray.count) {
        [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPickRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)loadContentTableView {
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentTableView.sectionFooterHeight = 0;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.estimatedRowHeight = 0;
    _contentTableView.estimatedSectionHeaderHeight = 0;
    _contentTableView.estimatedSectionFooterHeight = 0;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self registerTableViewCells];
    
    [self.view addSubview:_contentTableView];
}

- (void)registerTableViewCells {
    [_contentTableView registerNib:[UINib nibWithNibName:@"XLTAddressPickerCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTAddressPickerCityCell"];
}


- (id)dictionaryWithJsonData:(NSData *)jsonData {
    NSError * err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)loadDataFromFile {
    
    NSData *provinceData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"]];
    NSArray *provinceArray =  [self dictionaryWithJsonData:provinceData];
    self.provinceArray = provinceArray;
    
    NSData *cityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"]];
    self.cityDictionary =  [self dictionaryWithJsonData:cityData];
    
    NSData *countyData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"county" ofType:@"json"]];
    self.countyDictionary = [self dictionaryWithJsonData:countyData];
    
    if (self.pickerType == XLTAddressPickerProvinceType) {
        self.pickDataArray = self.provinceArray;
    } else if (self.pickerType == XLTAddressPickerCityType) {
        if (self.provinceCode) {
            self.pickDataArray = [self.cityDictionary objectForKey:self.provinceCode];
        }
    } else {
        if (self.cityCode) {
             self.pickDataArray = [self.countyDictionary objectForKey:self.cityCode];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pickDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLTAddressPickerCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTAddressPickerCityCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *info = self.pickDataArray[indexPath.row];
    cell.letaoCityLabel.text = info[@"name"];
    if (indexPath.row == _currentPickRow) {
        cell.letaoCityLabel.textColor = [UIColor letaomainColorSkinColor];
    } else {
        cell.letaoCityLabel.textColor = [UIColor colorWithHex:0xFF131413];
    }
    cell.letaoForkImageView.hidden = (indexPath.row != _currentPickRow);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _currentPickRow = indexPath.row;
    
    if (self.pickerType == XLTAddressPickerProvinceType) {
        // 读取省份
        NSDictionary *province = [self.pickDataArray objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(pickerCityListVC:pickedProvince:city:county:)]) {
            [self.delegate pickerCityListVC:self pickedProvince:province city:nil county:nil];
        }
        
       
    } else {
        if (self.pickerType == XLTAddressPickerCityType) {
            // 读取区域
            __block NSDictionary *province = nil;
            [self.provinceArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"id"] isEqualToString:self.provinceCode]) {
                    province = obj;
                    *stop = YES;
                }
            }];
            NSDictionary *city = [self.pickDataArray objectAtIndex:indexPath.row];
            
            if ([self.delegate respondsToSelector:@selector(pickerCityListVC:pickedProvince:city:county:)]) {
                   [self.delegate pickerCityListVC:self pickedProvince:[province copy] city:city county:nil];
               }
            
        } else {
            // 读取省
            __block NSDictionary *province = nil;
            [self.provinceArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"id"] isEqualToString:self.provinceCode]) {
                    province = obj;
                    *stop = YES;
                }
            }];
            
            
            // 读取city
            NSArray *cityArray = [self.cityDictionary objectForKey:self.provinceCode];
            __block NSDictionary *city = nil;
            [cityArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"id"] isEqualToString:self.cityCode]) {
                    city = obj;
                    *stop = YES;
                }
            }];
            
            NSDictionary *county = [self.pickDataArray objectAtIndex:indexPath.row];

            
            if ([self.delegate respondsToSelector:@selector(pickerCityListVC:pickedProvince:city:county:)]) {
                [self.delegate pickerCityListVC:self pickedProvince:[province copy] city:[city copy] county:county];
            }
        }
    }
    [self.contentTableView reloadData];
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
