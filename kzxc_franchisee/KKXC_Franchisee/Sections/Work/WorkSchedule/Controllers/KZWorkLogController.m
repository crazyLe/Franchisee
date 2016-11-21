//
//  KZWorkLogController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkLogController.h"
#import "KZWorkCommitSucceedController.h"
#import "WorkLogCell.h"

@interface KZWorkLogController ()<UITableViewDelegate,UITableViewDataSource,WorkLogCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *imageDataArray;
    NSString *remarksContent;
    BOOL firstImageStatus;
    BOOL secondImageStatus;
    BOOL thirdImageStatus;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation KZWorkLogController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"工作日志";
    
    [self loadLocalData];
    
    _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.rowHeight = 490;
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_table];
    
    [_table mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
        make.left.mas_equalTo(@0);
    }];
}


- (void)loadLocalData {
    remarksContent = @"请在此输入当天工作情况,请勿在0点左右提交，以免发生数据传输错误";
    imageDataArray = [NSMutableArray arrayWithArray:@[[NSNull null],[NSNull null],[NSNull null]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"WorkLogCell";
    
    WorkLogCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkLogCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commitContent.text = remarksContent;
    
    [cell.commitFirstButton setBackgroundImage:[UIImage imageNamed:@"workschedule_addphoto"] forState:UIControlStateNormal];
    
    if (![imageDataArray[0] isKindOfClass:[NSNull class]]) {
        [cell.commitFirstButton setBackgroundImage:imageDataArray[0] forState:UIControlStateNormal];
        UIButton *del = [self creatImageDelButtonWithTag:201];
        [cell.commitFirstButton addSubview:del];
    }
    [cell.commitSecondButton setBackgroundImage:[UIImage imageNamed:@"workschedule_addphoto"] forState:UIControlStateNormal];
    if (![imageDataArray[1] isKindOfClass:[NSNull class]]) {
        [cell.commitSecondButton setBackgroundImage:imageDataArray[1] forState:UIControlStateNormal];
        UIButton *del = [self creatImageDelButtonWithTag:202];
        [cell.commitSecondButton addSubview:del];
    }
    [cell.commitThirdButton setBackgroundImage:[UIImage imageNamed:@"workschedule_addphoto"] forState:UIControlStateNormal];
    if (![imageDataArray[2] isKindOfClass:[NSNull class]]) {
        [cell.commitThirdButton setBackgroundImage:imageDataArray[2] forState:UIControlStateNormal];
        UIButton *del = [self creatImageDelButtonWithTag:203];
        [cell.commitThirdButton addSubview:del];
    }
    
    if (_state == 1) {
        [cell.submit setTitle:@"提前完成" forState:UIControlStateNormal];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (UIButton *)creatImageDelButtonWithTag:(NSInteger)tag {
    UIButton *delButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 60, 20, 20)];
    delButton.tag = tag;
    [delButton setBackgroundImage:[UIImage imageNamed:@"icon_work_delete_nomal"] forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(deleteCurrentButton:) forControlEvents:UIControlEventTouchUpInside];
    return delButton;
}

- (void)deleteCurrentButton:(UIButton *)sender {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"确定删除该图片吗?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             nil;
                                                         }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger tag = sender.tag;
        if (201 == tag) {
            imageDataArray[0] = [NSNull null];
        } else if (202 == tag) {
            imageDataArray[1] = [NSNull null];
        } else if (203 == tag) {
            imageDataArray[2] = [NSNull null];
        }
        [_table reloadData];
    }];
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:sureAction];
    
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)presentImagePickerController:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //从相册选取
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        //拍照
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    firstImageStatus = NO;
    secondImageStatus = NO;
    thirdImageStatus = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if (firstImageStatus) {
        firstImageStatus = !firstImageStatus;
        imageDataArray[0] = image ;
    }
    if (secondImageStatus) {
        secondImageStatus = !secondImageStatus;
        imageDataArray[1] = image ;
    }
    if (thirdImageStatus) {
        thirdImageStatus = !thirdImageStatus;
        imageDataArray[2] = image ;
    }
    
    [_table reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendRemarksContent:(NSString *)content {
    remarksContent = content;
//    [_table reloadData];
}

- (void)addPhoto:(UIButton *)button andTag:(int)tag {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"选择照片"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             nil;
                                                         }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (tag == 101) {
            firstImageStatus = YES;
        } else if (tag == 102) {
            secondImageStatus = YES;
        } else if (tag == 103) {
            thirdImageStatus = YES;
        }
        [self presentImagePickerController:0];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (tag == 101) {
            firstImageStatus = YES;
        } else if (tag == 102) {
            secondImageStatus = YES;
        } else if (tag == 103) {
            thirdImageStatus = YES;
        }
        [self presentImagePickerController:1];
    }];
    
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:photoAction];
    [alertCtl addAction:cameraAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)postMessage {
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中..." hideAfterDelay:10.0];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"task_id"] = _taskId;
    param[@"content"] = remarksContent;
    param[@"state"] = @(_state);

    NSMutableArray *postImageArray = [NSMutableArray array];
    
    for (int i = 0 ; i < 3; i++) {
        if ([imageDataArray[i] isKindOfClass:[NSNull class]]) {
            postImageArray[i] = @"";
        } else {
            postImageArray[i] = UIImageJPEGRepresentation(imageDataArray[i], 0.5);
        }
    }
    
    [KZNetworkEngine uploadMultipleImageWithUrl:workScheduleAddUrl param:param imgParaNameArr:@[@"image_one",@"image_two",@"image_three"] imgDataArr:postImageArray successBlock:^(id jsonObj) {
        
        [self.hudManager dismissSVHud];
        int code = [jsonObj[@"code"] intValue];
        
        if (1 == code) {
            KZWorkCommitSucceedController *succeed = [[KZWorkCommitSucceedController alloc]init];
            if (0 == _state) {
                succeed.flag = @"nomal";
            } else {
                succeed.flag = @"tiqian";
            }
            [self.navigationController pushViewController:succeed animated:YES];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

- (void)gotoCommitResultController {
    
    if ([remarksContent isEqualToString:@"请在此输入当天工作情况,请勿在0点左右提交，以免发生数据传输错误"]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入内容" hideAfterDelay:1.0];
        return;
    }
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"是否确认提交?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             nil;
                                                         }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postMessage];
    }];
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:sureAction];
    
    [self presentViewController:alertCtl animated:YES completion:nil];
}

@end
