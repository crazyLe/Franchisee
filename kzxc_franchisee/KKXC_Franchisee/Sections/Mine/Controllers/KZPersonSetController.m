//
//  KZPersonSetController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZPersonSetController.h"
#import "PersonSetCell.h"
#import "PersonModel.h"
#import "KZAddressManager.h"
#import "KZAddressModel.h"
#import "KZAddressModel.h"

@interface KZPersonSetController ()

{
    NSString *province_id;
    NSString *city_id;
}
@property(strong,nonatomic)NSMutableArray *keyArr;
@property(strong,nonatomic)NSMutableArray *valueArr;

@property(strong,nonatomic)NSMutableArray *ageArray;

@property(strong,nonatomic)ZHPickView *sexpickview;
@property(strong,nonatomic)ZHPickView *agepickview;
@property(strong,nonatomic)ZHPickView *areapickview;

@end

@implementation KZPersonSetController

- (NSMutableArray *)keyArr
{
    if (!_keyArr) {
        _keyArr = [NSMutableArray arrayWithObjects:@"姓名",@"头像",@"性别",@"年龄",@"手机号",@"地区",@"地址", nil];
    }
    return _keyArr;
}

- (NSMutableArray *)valueArr
{
    if (!_valueArr) {
        _valueArr = [NSMutableArray arrayWithObjects:@"",@"placeHeader",@"",@"",@"",@"",@"", nil];
    }
    return _valueArr;
}

- (NSMutableArray *)ageArray
{
    if (!_ageArray) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 18; i < 61; i++) {
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _ageArray = temp;
    }
    return _ageArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人设置";
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(15, 65, kScreenWidth - 30, 44)];
    add.titleLabel.font = Font18;
    add.layer.cornerRadius = 5;
    [add setTitle:@"保 存" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add setBackgroundColor:[UIColor colorWithHexString:@"#1D8FE1"]];
    [add addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:add];

    _table.tableFooterView = foot;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerNib:[UINib nibWithNibName:@"PersonSetCell" bundle:nil] forCellReuseIdentifier:@"PersonSetCell"];
    
    [self getPersonData];
}

- (void)getPersonData {
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中" hideAfterDelay:10.0];
    [KZNetworkEngine postWithUrl:getPersonSetDataUrl paraDic:nil successBlock:^(id jsonObj) {
        [self.hudManager dismissSVHud];
        int code = [jsonObj[@"code"] intValue];
        if (1 == code) {
            NSDictionary *dict = jsonObj[@"data"];
            PersonModel *model = [PersonModel mj_objectWithKeyValues:dict];
            NSString *sexStr = ([model.userSex intValue] == 0)?@"女":@"男";
            NSString *areaStr =[self areaStringWithPid:model.provinceId andCityId:model.cityId];
            province_id = model.provinceId;
            city_id = model.cityId;
            self.valueArr = [NSMutableArray arrayWithObjects:model.userName,model.userFace,sexStr,model.userAge,model.userTel,areaStr,model.address, nil];
            
            [_table reloadData];
        }
    } failedBlock:^(NSError *error) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return self.keyArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSInteger row = indexPath.row;
    PersonSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonSetCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.key.text = _keyArr[row];

    if (0 == row || 6 == row) {
        cell.value.enabled = YES;
        cell.value.delegate = self;
        cell.value.tag = row;
    }
    
    if (1 == row) {

        UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 10, 45, 45)];
        head.layer.masksToBounds = YES;
        head.layer.cornerRadius = 22.5;
        if ([self.valueArr[row] isKindOfClass:[UIImage class]]) {
            head.image = self.valueArr[row];
        } else {
            [head sd_setImageWithURL:self.valueArr[row] placeholderImage:[UIImage imageNamed:@"placeHeader"]];
        }
        [cell addSubview:head];
    } else {
        cell.value.text = self.valueArr[row];
    }
    return cell;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
     [self pickviewHiden];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger tag = textField.tag;
    NSString *valueStr = textField.text;
    switch (tag) {
        case 0: {
            self.valueArr[0] = valueStr;
        }
            break;
//        case 4: {
//            self.valueArr[4] = valueStr;
//        }
//            break;
        case 6: {
            self.valueArr[6] = valueStr;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (1 == row) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
        [actionSheet showInView:self.view];
    }
    if (2 == row) {
        _sexpickview = [[ZHPickView alloc]initPickviewWithArray:@[@"男",@"女"] isHaveNavControler:NO];
        [_sexpickview  setPickViewColor:[UIColor whiteColor]];
        _sexpickview.delegate = self;
        _sexpickview.tag = 102;
        [_sexpickview show];
    }
    if (3 == row) {
        
        _agepickview = [[ZHPickView alloc]initPickviewWithArray:self.ageArray isHaveNavControler:NO];
        [_agepickview  setPickViewColor:[UIColor whiteColor]];
        _agepickview.delegate = self;
        _agepickview.tag = 103;
        [_agepickview show];
    }
    if (5 == row) {
        NSArray *ass = [KZAddressManager getNestedProvinceModelArr];
    
//        NSArray *parray = [KZProvinceModel mj_keyValuesArrayWithObjectArray:ass];
        
        _areapickview = [[ZHPickView alloc]initPickviewWithArray:ass isHaveNavControler:NO];
        [_areapickview  setPickViewColor:[UIColor whiteColor]];
        _areapickview.delegate = self;
        _areapickview.tag = 105;
        [_areapickview show];
    }
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSInteger tag = pickView.tag;
    
    if (102 == tag) {
        self.valueArr[2] = resultString;
        [_table reloadData];
    }
    if (103 == tag) {
        self.valueArr[3] = resultString;
        [_table reloadData];
    }
    if (105 == tag) {
        NSArray *strArray = [resultString componentsSeparatedByString:@"-"];
        self.valueArr[5] = [NSString stringWithFormat:@"%@ %@",strArray[0],strArray[1]];
        province_id = strArray[2];
        city_id = strArray[3];
        [_table reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //从相册选取
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    if (buttonIndex == 1) {
        //拍照
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
   
    _valueArr[1] = image;
    [_table reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)areaStringWithPid:(NSString *)pid andCityId:(NSString *)cid {
    KZAddressModel *pmodel = [KZAddressManager getAddressModelWithType:KZAddressTypeProvince idNum:pid];
    KZAddressModel *cmodel = [KZAddressManager getAddressModelWithType:KZAddressTypeCity idNum:cid];
    return [NSString stringWithFormat:@"%@%@",pmodel.areaName,cmodel.areaName];
}

- (void)sendClick {

    NSString *user_name = self.valueArr[0];
    NSString *user_sex = self.valueArr[2];
    NSString *user_age = self.valueArr[3];
    NSString *user_tel = self.valueArr[4];
    NSString *address = self.valueArr[6];
    
    if (0 == user_name.length) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入用户昵称" hideAfterDelay:1.0];
        return;
    }
    
    if (0 == [user_age intValue]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入年龄" hideAfterDelay:1.0];
        return;
    }
    
    if (![ValidateHelper validateMobile:user_tel]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入正确手机号" hideAfterDelay:1.0];
        return;
    }

    user_sex = [user_sex isEqualToString:@"男"]?@"1":@"0";

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_name"] = user_name;
    param[@"user_sex"] = user_sex;
    param[@"user_age"] = user_age;
    param[@"user_tel"] = user_tel;
    param[@"province_id"] = province_id;
    param[@"city_id"] = city_id;
    param[@"address"] = address;

    NSData *data;
    NSString *headName;
    if ([self.valueArr[1] isKindOfClass:[UIImage class]]) {
        data = UIImageJPEGRepresentation(self.valueArr[1], 0.5);
        headName = @"user_face";
    }else{
        data =  [@"" dataUsingEncoding:NSUTF8StringEncoding];
        headName = @"";
    }
    
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中" hideAfterDelay:10.0];
    
    [KZNetworkEngine uploadSingleImageWithUrl:editPersonDataUrk param:param imgParaName:headName imgData:data successBlock:^(id jsonObj) {
    
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        if (1 == code) {

            msg = (msg.length == 0)?@"修改成功":msg;
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            msg = (msg.length == 0)?@"修改失败请重试":msg;
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}
- (void)pickviewHiden {
    if (_sexpickview) {
        [_sexpickview remove];
    }
    if (_agepickview) {
        [_agepickview remove];
    }
    if (_areapickview) {
        [_areapickview remove];
    }
}
@end
