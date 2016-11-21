//
//  WorkLogCell.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkLogCellDelegate <NSObject>

@optional
//跳转界面
- (void)gotoCommitResultController;
//添加图片
- (void)addPhoto:(UIButton *)button andTag:(int)tag;
//添加日志内容
- (void)sendRemarksContent:(NSString *)content;

@end

@interface WorkLogCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *commitContent;
@property (weak, nonatomic) IBOutlet UIButton *commitFirstButton;
@property (weak, nonatomic) IBOutlet UIButton *commitSecondButton;
@property (weak, nonatomic) IBOutlet UIButton *commitThirdButton;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@property (weak, nonatomic) id <WorkLogCellDelegate> delegate;

@end
