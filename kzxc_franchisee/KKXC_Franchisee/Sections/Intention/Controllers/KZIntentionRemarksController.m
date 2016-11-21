//
//  KZIntentionRemarksController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZIntentionRemarksController.h"
#import "RemarksCell.h"
#import "RemarksModel.h"
#import "NSString+Size.h"

@interface KZIntentionRemarksController ()
{
    NSMutableArray *remarksArray;
}
@end

@implementation KZIntentionRemarksController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"备注";
    
    [self loadData];
    
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 15, 40)];
    [head addSubview:title];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"学员 %@ 的信息概要",_name]];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0,[NSString stringWithFormat:@"学员 %@ 的信息概要",_name].length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1d8fe1"] range:NSMakeRange(2,_name.length+2)];
    
    title.attributedText = attrStr;
    _remarksTable.tableHeaderView = head;
    
    [_remarksTable registerNib:[UINib nibWithNibName:@"RemarksCell" bundle:nil] forCellReuseIdentifier:@"RemarksCell"];
    _remarksTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadData {
    
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中" hideAfterDelay:20.0];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customer_id"] = _customerId;
    
    [KZNetworkEngine postWithUrl:getIntentionRemarksUrl paraDic:param successBlock:^(id jsonObj) {
        [self.hudManager dismissSVHud];
        int code = [jsonObj[@"code"] intValue];
        if (1 == code) {
            NSDictionary *dict = jsonObj[@"data"];
            remarksArray = [RemarksModel mj_objectArrayWithKeyValuesArray:dict];
            [_remarksTable reloadData];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView  {
        textView.text = @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return remarksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarksCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = remarksArray[indexPath.row];
    
    if (indexPath.row == (remarksArray.count - 1)) {
        cell.circleView.backgroundColor = [UIColor colorWithHexString:@"#1d8fe1"];
        cell.remarksContent.textColor = [UIColor colorWithHexString:@"#1d8fe1"];
        
        [cell.statusLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(25);
            make.width.offset(1);
            make.top.offset(0);
            make.left.offset(25);
        }];
        
    } else {
        cell.circleView.backgroundColor = [UIColor colorWithHexString:@"#C8C8C8"];
        cell.remarksContent.textColor = [UIColor colorWithHexString:@"#666666"];
        [cell.statusLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset([self tableView:tableView heightForRowAtIndexPath:indexPath]);
            make.left.offset(25);
            make.width.offset(1);
        }];
    }

    
    cell.deleteBlock = ^(RemarksCell *cell){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteRemark:cell.model.remarkId];
        }];
        [alert addAction:sureAction];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:cancleAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    };
    
    return cell;
}

- (void)deleteRemark:(NSString *)remarkId {
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中" hideAfterDelay:10.0];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"remark_id"] = remarkId;
    [KZNetworkEngine postWithUrl:deleteIntentionRemarkUrl paraDic:param successBlock:^(id jsonObj) {
        [self.hudManager dismissSVHud];
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        if (1 == code) {
            msg = (msg.length == 0)?@"删除成功":msg;
            [self loadData];
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
        } else {
            msg = (msg.length == 0)?@"删除失败，请重试":msg;
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [self cgfloatWithModel:remarksArray[indexPath.row]];
    
    return height;
}

//通过模型计算出cell高度
- (CGFloat)cgfloatWithModel:(RemarksModel *)model {
    
    CGSize size = [NSString string:model.content sizeWithFont:Font13 maxSize:CGSizeMake(kScreenWidth - 85, CGFLOAT_MAX)];
    
    CGFloat height = 20 + size.height + 10 + 15 + 20;
    
    return height;
}

- (IBAction)commitRemarks:(UIButton *)sender {
    
    NSString *content = self.addremarksTextView.text;
    
    if (0 == content.length || [content isEqualToString:@"新增备注"]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入备注" hideAfterDelay:1.0];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customer_id"] = _customerId;
    param[@"content"] = content;
    
    [KZNetworkEngine postWithUrl:addIntentionRemarkUrl paraDic:param successBlock:^(id jsonObj) {
        
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        
        if (1 == code) {
            msg = (msg.length == 0)?@"添加成功":msg;
            self.addremarksTextView.text = @"新增备注";
            [self loadData];
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:2.0 animaton:YES];
        } else {
            msg = (msg.length == 0)?@"添加失败":msg;
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:2.0];
        }
        
    } failedBlock:^(NSError *error) {
        
    }];
}

    


@end
