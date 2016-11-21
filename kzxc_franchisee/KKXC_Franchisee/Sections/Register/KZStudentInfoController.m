//
//  KZStudentInfoController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAddressManager.h"
#import "KZSchoolManager.h"
#import "KZStudentInfoController.h"
#import "KZTabBarController.h"

@interface KZStudentInfoController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary * _dict;
}
@property (weak, nonatomic) IBOutlet UILabel *provinceLab;
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *schoolTF;
@property (weak, nonatomic) IBOutlet UITextField *gradeTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *subjectTF;
@property (weak, nonatomic) IBOutlet UIButton *gradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIView *provinceLineView;
@property (weak, nonatomic) IBOutlet UIView *cityLineView;
@property (weak, nonatomic) IBOutlet UIView *gradeLineView;



//数据源
@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *cityArr;
@property (nonatomic,strong) NSArray *schoolArr;

//记录选择的model
@property (nonatomic,strong) KZAddressModel *selectProvineModel;
@property (nonatomic,strong) KZAddressModel *selectCityModel;
@property (nonatomic,strong) KZSchoolModel *selectSchoolModel;

@end

@implementation KZStudentInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setNavigation];
    
    [self createUI];
    
    //加载省份地址信息
    [self loadProvinceInfo];
}
- (void)createUI {
    //监听键盘弹事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear) name:UIKeyboardWillShowNotification object:nil];
    
    [self setTextfiledValue:_schoolTF];
    [self setTextfiledValue:_gradeTF];
    [self setTextfiledValue:_nameTF];
    [self setTextfiledValue:_subjectTF];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"323842"];
    [self.view addSubview:_tableView];
    
}

- (void)keyboardWillAppear{
    [self dismissTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableView.tag==10?_provinceArr.count:tableView.tag==20?_cityArr.count:tableView.tag==30?_schoolArr.count:tableView.tag==40?kClasses.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"323842"];
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    
    if (_tableView.tag==30) {
        KZSchoolModel *model = _schoolArr[indexPath.row];
        cell.textLabel.text = model.schoolName;
    } else if (_tableView.tag == 40) {
        
        NSDictionary *dict = kClasses[indexPath.row];
        cell.textLabel.text = dict[@"short_name"];
    }
    else {
        KZAddressModel *model = _tableView.tag==10?_provinceArr[indexPath.row]:_cityArr[indexPath.row];
        cell.textLabel.text = model.areaName;
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissTable];
    if (tableView.tag==10) {
        //选择省
        KZAddressModel *model = _provinceArr[indexPath.row];
        [self loadCityArrWithProvinceModel:model];
        _provinceLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
        _provinceLab.text = model.areaShortName;
        _selectProvineModel = model;
    } else if(tableView.tag==20){
        //选择市
        KZAddressModel *model = _cityArr[indexPath.row];
        _cityLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
        _cityLab.text = model.areaShortName;
        _selectCityModel = model;
    } else if (tableView.tag == 30){
        //选择学校
        KZSchoolModel *model = _schoolArr[indexPath.row];
        _schoolTF.text =  model.schoolName;
        _selectSchoolModel = model;
    } else {
        
        _dict = kClasses[indexPath.row];
        _gradeTF.text = _dict[@"short_name"];
        
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
- (void)setNavigation {
    
    [self setTitleText:@"基本信息 (2/2)" textColor:[UIColor colorWithHexString:@"9cc3eb"]];

    [self setLeftText:@"" textColor:nil ImgPath:nil action:nil];
    
}
//判断填写学校之前省市是否选择过
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _schoolTF) {
        if (!_selectCityModel) {
            [self.hudManager showErrorSVHudWithTitle:@"请先选择城市" hideAfterDelay:1.0];
            [_schoolTF resignFirstResponder];
            return;
        }
    }
}
//学校输入改变
- (IBAction)schoolTFTextEditChanged:(id)sender {
    
    //模糊搜索
    UITextField *textField = sender;
    [self loadSchoolWithAreaId:_selectCityModel.idNum key:textField.text];
    
    [_tableView reloadData];
    _tableView.contentOffset = CGPointZero;
    
    _tableView.tag = 30;//标识选择学校
    
    _tableView.frame = CGRectMake(40, CGRectGetMaxY(textField.frame), 115, 200);
}


//点击选择省份按钮
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
- (IBAction)gradeBtnClick:(id)sender {
    
    [_tableView reloadData];
    _tableView.contentOffset = CGPointZero;
    
    _tableView.tag = 40; //标志选择年级
    
    _tableView.frame = CGRectMake(_gradeLineView.origin.x, _gradeLineView.origin.y, 115, 200);
    
    
}




#pragma mark -- 学生信息录入接口
- (IBAction)confirmBtnClick:(id)sender {
    

    if (!_selectProvineModel) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择省份" hideAfterDelay:1.0];
        return;
    }
    if (!_selectCityModel) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择城市" hideAfterDelay:1.0];
        return;
    }
    if (!_selectSchoolModel) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写你所在的学校" hideAfterDelay:1.0];
        return;
    }
    if (_gradeTF.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择你的年级" hideAfterDelay:1.0];
        return;
    }
    if (_nameTF.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写你的姓名" hideAfterDelay:1.0];
        return;
    }
    if (_subjectTF.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写你的专业" hideAfterDelay:1.0];
        return;
    }
    
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = infoEnteringUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"user_type"] = @"1";
    paramDict[@"province_id"] = _selectProvineModel.idNum;
    paramDict[@"city_id"] = _selectCityModel.idNum;
    paramDict[@"school_id"] = _selectSchoolModel.idNum;
    paramDict[@"class_id"] = _dict[@"id"];
    paramDict[@"real_name"] = _nameTF.text;
    paramDict[@"specialities"] = _subjectTF.text;
    paramDict[@"community_name"] = @"";
    paramDict[@"business_name"] = @"";
    paramDict[@"business_address"] = @"";
    paramDict[@"business_lat"] = @"";
    paramDict[@"business_lng"] = @"";
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"学生的信息录入%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString *msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            
            [kUserDefault setObject:_selectCityModel.idNum forKey:@"cityInfo"];
            [kUserDefault setBool:YES forKey:@"kHasBuildFranchiseeInfo"];
            
            [self jumpSuccessView];
        } else {
            [  self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [self dismissTable];
}

- (void)dismissTable{
    _tableView.frame = CGRectZero;
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

//加载学校信息
- (void)loadSchoolWithAreaId:(NSString *)areaId key:(NSString *)key{
    _schoolArr = [KZSchoolManager getSchollModelArrWithAreaId:areaId withKey:key];
}

@end
