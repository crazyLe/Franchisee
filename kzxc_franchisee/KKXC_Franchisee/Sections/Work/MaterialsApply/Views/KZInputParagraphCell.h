//
//  KZInputParagraphCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <SZTextView.h>
#import <UIKit/UIKit.h>

@class KZInputParagraphCell;

@protocol KZInputParagraphCellDelegate <NSObject>

- (void)KZInputParagraphCell:(KZInputParagraphCell *)cell textDidChanged:(SZTextView *)textView;

@end

@interface KZInputParagraphCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftLbl;

@property (nonatomic,strong)SZTextView *textView;

@property (nonatomic,assign) id <KZInputParagraphCellDelegate> delegate;

@end
