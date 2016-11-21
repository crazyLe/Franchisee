//
//  KZApplyCommitController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "MMPickerView.h"
#import "LLDatePicker.h"
#import "KZMaterialModel.h"
#import "KZAddMaterialModel.h"
#import "KZOneCenterBtnCell.h"
#import "KZInputParagraphCell.h"
#import "KZAddMaterialCell.h"
#import "KZApplyCommitCell.h"
#import "KZApplyCommitController.h"
#import "KZMaterialListController.h"

@interface KZApplyCommitController () <UITableViewDelegate,UITableViewDataSource,KZAddMaterialCellDelegate,KZOneCenterBtnCellDelegate,KZInputParagraphCellDelegate,KZApplyCommitCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) KZAddMaterialModel *model;

@end

@implementation KZApplyCommitController
{
    NSUInteger numOfSection;
}

- (id)init
{
    if (self = [super init]) {
        numOfSection = 3;
        _model = [[KZAddMaterialModel alloc] init];
    }
    return self;
}

- (void)setMaterialModelArr:(NSArray *)materialModelArr{
    if (_materialModelArr != materialModelArr) {
        _materialModelArr = materialModelArr;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setUI];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:@"申请提交" textColor:nil];
    [self setRightText:@"清单" textColor:kBlueThemeColor ImgPath:nil action:@selector(clickRightBtn:)];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    [self registerNibWithClassNameArr:@[@"KZApplyCommitCell",@"KZAddMaterialCell",@"KZInputParagraphCell",@"KZOneCenterBtnCell"] cellIdentifier:nil table:_tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        //第一个区
        return 3;
    }
    else if (section==numOfSection-1) {
        //最后一个区
        return 3;
    }
    else {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //第一区
        return [@[@(96),@(54),@(54)][indexPath.row] floatValue];
    }
    else if (indexPath.section==numOfSection-1) {
        //最后一区
        return [@[@(70),@(100),@(75)][indexPath.row] floatValue];
    } else {
        return 54;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    else if (section!=numOfSection-1) {
        return 32;
    }
    else
    {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((section!=0)&&(section!=numOfSection-1)) {
        //最后一个区
        UIView *view = [UIView new];
        view.tag = section;
        
        UILabel *titleLbl = [UILabel new];
        [view addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.right.bottom.offset(0);
        }];
        titleLbl.text = [NSString stringWithFormat:@"物料明细(%ld)",section];
        titleLbl.tag = 1002;
        
        if (section != 1) {
            //添加删除按钮
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:deleteBtn];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(15);
                make.top.bottom.offset(0);
                make.width.offset(70);
            }];
            [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:kBlueThemeColor forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = kFont14;
        }
        
        return view;
    } else {
        return [UIView new];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //第一区
        KZApplyCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZApplyCommitCell"];
        
        if (indexPath.row<=2) {
            NSArray *lblTextArr = @[@"申请原因",@"期望交付日期",@"收件地址"];
            NSArray *TFPlaceHolderArr = @[@"请输入申请原因",@"请选择",@"请输入"];
            cell.leftLbl.text = lblTextArr[indexPath.row];
            cell.rightTF.placeholder = TFPlaceHolderArr[indexPath.row];
            cell.accessoryImgView.hidden = indexPath.row != 1;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.rightTF.text = indexPath.row==0?_model.content:indexPath.row==1?_model.formaterDate:_model.address;
            cell.rightTF.userInteractionEnabled = indexPath.row==0||indexPath.row==2;
            cell.rightTF.keyboardType = UIKeyboardTypeDefault;
        }
        return cell;
    }
    else if (indexPath.section==numOfSection-1){
        //最后一区
        switch (indexPath.row) {
            case 0:
            {
                KZAddMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZAddMaterialCell"];
                cell.delegate = self;
                return cell;
            }
                break;
            case 1:
            {
                KZInputParagraphCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZInputParagraphCell"];
                cell.delegate = self;
                return cell;
            }
                break;
            case 2:
            {
                KZOneCenterBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZOneCenterBtnCell"];
                cell.delegate = self;
                return cell;
            }
                break;
                
            default:
                break;
        }
    } else {
        //材料明细
        KZApplyCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZApplyCommitCell"];
        cell.delegate = self;
        cell.indexPath = indexPath;
        NSArray *titleArr = @[@"物料名称",@"申请数量"];
        NSArray *placeHolderArr = @[@"请选择",@"请输入申请数量"];
        cell.leftLbl.text = titleArr[indexPath.row];
        cell.rightTF.placeholder = placeHolderArr[indexPath.row];
        cell.accessoryImgView.hidden = indexPath.row != 0;
        KZMaterialItemModel *model = _model.itemArr[indexPath.section-1];
        cell.rightTF.text = indexPath.row==0?model.name:model.num;
        cell.rightTF.userInteractionEnabled = indexPath.row==1;
        cell.rightTF.keyboardType = indexPath.row==1?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row==1) {
        //期望交付日期
        [self.view endEditing:YES];
        [LLDatePicker showWithDate:nil minimumDate:nil maximumDate:nil datePickerMode:UIDatePickerModeDateAndTime delegate:self object:nil];
    } else if(indexPath.section != numOfSection-1 && indexPath.section != 0 && indexPath.row == 0)
    {
        //材料明细
        [self.view endEditing:YES];
        NSMutableArray *arr = [NSMutableArray array];
        for (KZMaterialModel *model in _materialModelArr) {
            if (!isEmptyStr(model.title)) {
                [arr addObject:model.title];
            }
        }
        
        if (isEmptyArr(arr)) {
            return;
        }
        
        KZMaterialItemModel *model = _model.itemArr[indexPath.section-1];
        
        WeakObj(self)
        
        [MMPickerView showPickerViewInView:self.view withStrings:arr withOptions:
         @{MMbackgroundColor: [UIColor whiteColor],
           MMtextColor: [UIColor blackColor],
           MMtoolbarColor: [UIColor whiteColor],
           MMbuttonColor: [UIColor blueColor],
           MMfont: [UIFont systemFontOfSize:18],
           MMvalueY: @3,
           MMselectedObject:isEmptyStr(model.name)?arr[0]:model.name,
           }
                                completion:^(NSString *selectedString) {
                                    model.name = selectedString;
                                    [selfWeak.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                                    for (KZMaterialModel *tModel in _materialModelArr) {
                                        if ([tModel.title isEqualToString:selectedString]) {
                                            model.item_id = tModel.idNum;
                                            break;
                                        }
                                    }
                                }];
    } else {
        //最后一区
        
    }
}

#pragma mark - LLDatePickerDelegate

- (void)LLDatePicker:(LLDatePicker *)view datePickerValueChanged:(UIDatePicker *)datePicker
{
    _model.date = [NSString stringWithFormat:@"%lld",[KZDateManager timestampsWithDate:datePicker.date]];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)LLDatePicker:(LLDatePicker *)view clickDoneBtn:(UIButton *)doneBtn
{
    [self LLDatePicker:view datePickerValueChanged:view.datePicker];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    //清单
    KZMaterialListController *materialListVC = [[KZMaterialListController alloc] init];
    [self.navigationController pushViewController:materialListVC animated:YES];
}

//点击删除按钮
- (void)clickDeleteBtn:(UIButton *)deleteBtn
{
    UIView *view = deleteBtn.superview;
    
    numOfSection--;
    [_tableView reloadData];
    
    //删除model中对应物料项
    [_model deleteItemWithIndex:view.tag-1];
}

#pragma mark - KZAddMaterialCellDelegate

//增加物料明细 、增加一个区
- (void)KZAddMaterialCell:(KZAddMaterialCell *)cell clickAddBtn:(UIButton *)addBtn
{
    //插入Section,并增加区数
    ++numOfSection;
    [_tableView reloadData];
    
    //增加model中物料项
    [_model addItem];
}

#pragma mark - KZOneCenterBtnCellDelegate

- (void)KZOneCenterBtnCell:(KZOneCenterBtnCell *)cell clickBtn:(UIButton *)btn
{
    [self commitRequest];
}

#pragma mark -  Delegate

- (void)KZInputParagraphCell:(KZInputParagraphCell *)cell textDidChanged:(SZTextView *)textView;
{
    _model.remark = textView.text;
}

#pragma mark - KZApplyCommitCellDelegate

- (void)KZApplyCommitCell:(KZApplyCommitCell *)cell textFieldEditChanged:(UITextField *)textField
{
    if (cell.indexPath.section==0) {
        switch (cell.indexPath.row) {
            case 0:
            {
                //申请原因
                _model.content = textField.text;
            }
                break;
            case 1:
            {
                //期望交付日期
            }
                break;
            case 2:
            {
                //收件地址
                _model.address = textField.text;
            }
                break;
                
            default:
                break;
        }
    } else {
        if (cell.indexPath.row==1) {
            //申请数量
            KZMaterialItemModel *item = _model.itemArr[cell.indexPath.section-1];
            item.num = textField.text;
        }
    }
}

#pragma mrak - Network

- (void)commitRequest{
    NSString *promptStr;
    if (isEmptyStr(_model.content)) {
        promptStr = @"请输入申请原因";
    } else if(isEmptyStr(_model.date)){
        promptStr = @"请选择交付日期";
    } else if (isEmptyStr(_model.address)){
        promptStr = @"请输入地址";
    } else {
        KZMaterialItemModel *itemModel = _model.itemArr[0];
        if (isEmptyStr(itemModel.name)) {
            promptStr = @"请选择物料名称";
        } else if (isEmptyStr(itemModel.num))
        {
            promptStr = @"请输入申请数量";
        }
    }
    
    if (promptStr) {
        [[ProgressHUD sharedInstance] showSuccessSVHudWithTitle:promptStr hideAfterDelay:kHudDismissTime animaton:YES];
        return;
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_model.content forKey:@"content"];
    [paraDic setObject:_model.date forKey:@"date"];
    [paraDic setObject:_model.address forKey:@"address"];
    if (!isEmptyStr(_model.remark)) {
        [paraDic setObject:_model.remark forKey:@"remark"];
    }
    [paraDic setObject:_model.items forKey:@"items"];
    [KZNetworkEngine postWithUrl:kAddMaterialInterface paraDic:paraDic successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            //新增成功
            [[ProgressHUD sharedInstance] showSuccessSVHudWithTitle:@"您的物料申请已提交成功，工作人员将在1个工作日内审核，请留意系统信息。" hideAfterDelay:kHudDismissTime animaton:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[ProgressHUD sharedInstance] showErrorSVHudWithTitle:@"新增失败,请稍后重试" hideAfterDelay:kHudDismissTime];
        }
    } failedBlock:^(NSError *error) {
        [[ProgressHUD sharedInstance] showErrorSVHudWithTitle:@"新增失败,请稍后重试" hideAfterDelay:kHudDismissTime];
    }];
}

@end
