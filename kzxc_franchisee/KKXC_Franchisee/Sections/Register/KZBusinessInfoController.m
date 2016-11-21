//
//  KZBusinessInfoController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZBusinessInfoController.h"
#import "KZTabBarController.h"
#import "KZAddressManager.h"
#import "KZSchoolManager.h"
#import "GroundMapController.h"
#import "KZCityModel.h"

@interface KZBusinessInfoController ()<UITextFieldDelegate,GroundMapControllerDelegate> {
    
    NSString * _addressName;
    NSString * _longtitude;
    NSString * _latitude;
    
}
@property (weak, nonatomic) IBOutlet UILabel *provinceLab;
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *businessNameTF;
@property (weak, nonatomic) IBOutlet UITextField *businessAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *provinceLineView;
@property (weak, nonatomic) IBOutlet UIView *cityLineView;
@property (nonatomic, strong) UITableView * tableView;

//数据源
@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *cityArr;

//记录选择的model
@property (nonatomic,strong) KZAddressModel *selectProvineModel;
@property (nonatomic,strong) KZAddressModel *selectCityModel;

@end

@implementation KZBusinessInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setNavigation];
    
    [self createUI];
    
    //加载省份地址信息
    [self loadProvinceInfo];
}

- (void)createUI {
    
    //监听键盘弹事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear) name:UIKeyboardWillShowNotification object:nil];
    
    [self setTextfiledValue:_businessNameTF];
    [self setTextfiledValue:_businessAddressTF];
    _selectAddressBtn.layer.borderColor = [UIColor colorWithHexString:@"9cc3eb"].CGColor;
    _selectAddressBtn.layer.borderWidth = 0.5;
    _selectAddressBtn.layer.cornerRadius = 3;
    _selectAddressBtn.clipsToBounds = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"323842"];
    [self.view addSubview:_tableView];
    
}
- (void)keyboardWillAppear{
    [self dismissTable];
}
- (void)dismissTable{
    _tableView.frame = CGRectZero;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableView.tag==10?_provinceArr.count:tableView.tag==20?_cityArr.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"323842"];
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    
    KZAddressModel *model = _tableView.tag==10?_provinceArr[indexPath.row]:_cityArr[indexPath.row];
    cell.textLabel.text = model.areaName;
    
    cell.textLabel.font = kFont13;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)setTextfiledValue:(UITextField *)view {
    
    view.delegate = self;
    [view setValue:[UIColor colorWithHexString:@"5a6d83"] forKeyPath:@"_placeholderLabel.textColor"];
    //设置文字内容显示位置
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.leftView = paddingView;
    view.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissTable];
    if (tableView.tag==10) {
        //选择省
        KZAddressModel *model = _provinceArr[indexPath.row];
        [self loadCityArrWithProvinceModel:model];
        _provinceLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
        _provinceLab.text = model.areaShortName;
        _selectProvineModel = model;
    } else {
        //选择市
        KZAddressModel *model = _cityArr[indexPath.row];
        _cityLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
        _cityLab.text = model.areaShortName;
        _selectCityModel = model;
    }
}
//点击选择省份按
- (IBAction)provinceBtnClick:(id)sender {
    
    [_tableView reloadData];
    _tableView.contentOffset = CGPointZero;
    
    _tableView.tag = 10;//标识选择省份
    
    _tableView.frame = CGRectMake(40, _provinceLineView.origin.y, 115, 200);
    
}
//点击选择市按钮
- (IBAction)cityBtnClick:(id)sender {
    
    if (!_selectProvineModel) {
        [self.hudManager showErrorSVHudWithTitle:@"请先选择省份" hideAfterDelay:1.0];
        return;
    }
    
    [_tableView reloadData];
    _tableView.contentOffset = CGPointZero;
    
    _tableView.tag = 20; //标识选择市
    
    _tableView.frame = CGRectMake(_cityLineView.origin.x, _cityLineView.origin.y, 115, 200);
    
}
//地图选址,需要具体地址和经纬度
- (IBAction)selectBtnClick:(id)sender {
    
    GroundMapController * groupCtl = [[GroundMapController alloc] init];
    
    groupCtl.delegate = self;
    
    [self.navigationController pushViewController:groupCtl animated:YES];
 
    
}
#pragma mark -- 商户信息录入接口
- (IBAction)confirmBtnClick:(id)sender {
    
    if (!_selectProvineModel) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择省份" hideAfterDelay:1.0];
        return;
    }
    if (!_selectCityModel) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择城市" hideAfterDelay:1.0];
        return;
    }
    if (_businessNameTF.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写商户名称" hideAfterDelay:1.0];
        return;
    }
    if (_businessAddressTF.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择商户地址" hideAfterDelay:1.0];
        return;
    }

    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = infoEnteringUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"user_type"] = @"3";
    paramDict[@"province_id"] = _selectProvineModel.idNum;
    paramDict[@"city_id"] = _selectCityModel.idNum;
    paramDict[@"school_id"] = @"";
    paramDict[@"class_id"] = @"";
    paramDict[@"real_name"] = @"";
    paramDict[@"specialities"] = @"";
    paramDict[@"community_name"] = @"";
    paramDict[@"business_name"] = _businessNameTF.text;
    paramDict[@"business_address"] = _businessAddressTF.text;
    paramDict[@"business_lat"] = _latitude;
    paramDict[@"business_lng"] = _longtitude;
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"商户的信息录入%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            [kUserDefault setObject:_selectCityModel.idNum forKey:@"cityInfo"];
            [kUserDefault setBool:YES forKey:@"kHasBuildFranchiseeInfo"];
            
            [self jumpSuccessView];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"信息录入失败" hideAfterDelay:1.0];
    }];
}

- (void)jumpSuccessView {
    //注册成功
    UIView * successView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    successView.backgroundColor = [UIColor colorWithHexString:@"323842"];
    [self.view addSubview:successView];
    
    UIImageView * successImgView = [[UIImageView alloc] init];
    successImgView.image = [UIImage imageNamed:@"iconfont-login-64chenggong"];
    [successView addSubview:successImgView];
    [successImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.offset(200);
        make.width.height.offset(70);
    }];
    
    UILabel * stateLab = [[UILabel alloc] init];
    stateLab.text = @"恭喜您,注册成功!";
    stateLab.font = [UIFont systemFontOfSize:20];
    stateLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    [successView addSubview:stateLab];
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(successImgView.mas_bottom).offset(30);
    }];
    
    UILabel * jumpLab = [[UILabel alloc] init];
    jumpLab.font = [UIFont systemFontOfSize:15];
    jumpLab.text = @"自动跳转中...";
    jumpLab.textColor = [UIColor colorWithHexString:@"5a6d83"];
    [successView addSubview:jumpLab];
    [jumpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(stateLab.mas_bottom).offset(15);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        KZTabBarController *tabBarCtl = [[KZTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtl;
        
    });
}

- (void)setNavigation {
    [self setTitleText:@"基本信息 (2/2)" textColor:[UIColor colorWithHexString:@"9cc3eb"]];
    [self setLeftText:@"" textColor:nil ImgPath:nil action:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    [self dismissTable];
}

#pragma mark - 读本地数据库

//加载省信息
- (void)loadProvinceInfo{
    _provinceArr = [KZAddressManager getAddressModelArrWithType:KZAddressTypeProvince parentId:nil];
}
//加载省城市信息
- (void)loadCityArrWithProvinceModel:(KZAddressModel *)model{
    _cityArr = [KZAddressManager getAddressModelArrWithType:KZAddressTypeCity parentId:model.idNum];
}

-(void)getCityModel:(KZCityModel *)city andWeizhi:(CLLocationCoordinate2D)loc
{
    _addressName = city.name;
    
    //self.address = city.name;
    
    _latitude = [NSString stringWithFormat:@"%f",loc.latitude];
    
    _longtitude = [NSString stringWithFormat:@"%f",loc.longitude];
    
    _businessAddressTF.text = _addressName;
    
}
@end
