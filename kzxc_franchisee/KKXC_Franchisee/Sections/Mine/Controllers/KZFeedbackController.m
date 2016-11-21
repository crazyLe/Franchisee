//
//  KZFeedbackController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZFeedbackController.h"
#import "LimitInput.h"
#import "KZFeedbackSuccessController.h"

@interface KZFeedbackController ()<UITextViewDelegate>
{
    NSMutableAttributedString * _attString;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *limitLab;
@property (weak, nonatomic) IBOutlet UIButton *submintBtn;
@property (nonatomic, strong) UILabel * placeLab;

@end

@implementation KZFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"意见反馈";
    
    [self createUI];
    
    
    
    
}
- (void)createUI {
    
    [_textView setValue:@499 forKey:@"LimitInput"];
    _textView.delegate = self;
    
    
    _placeLab = [[UILabel alloc] init];
    _placeLab.font = [UIFont systemFontOfSize:15];
    _placeLab.textColor = [UIColor colorWithHexString:@"999999"];
    _placeLab.enabled = NO;
    _placeLab.numberOfLines = 0;
    [_textView addSubview:_placeLab];
    [_placeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.width.offset(kScreenWidth - 30);
    }];
    
    if (_textView.text.length == 0) {
        
        _placeLab.text = @"请详细描述您的问题或建议，我们将及时跟进解决!";
        
        _attString = [NSMutableAttributedString attributeStringWithText:@"  可输入" attributes:@[Font12,[UIColor colorWithHexString:@"999999"]]];
        [_attString appendText:@"0" withAttributesArr:@[Font12,[UIColor colorWithHexString:@"666666"]]];
        [_attString appendText:@"/500个字符" withAttributesArr:@[Font12,[UIColor colorWithHexString:@"999999"]]];
        
        _limitLab.attributedText = _attString;
    }
    
    
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _placeLab.text = @"请详细描述您的问题或建议，我们将及时跟进解决!";
        _limitLab.attributedText = _attString;
        
    }else {
        _placeLab.text = @"";
        
        NSMutableAttributedString * attString = [NSMutableAttributedString attributeStringWithText:@"  可输入" attributes:@[Font12,[UIColor colorWithHexString:@"999999"]]];
        [attString appendText:[NSString stringWithFormat:@"%lu",(unsigned long)_textView.text.length] withAttributesArr:@[Font12,[UIColor colorWithHexString:@"666666"]]];
        [attString appendText:@"/500个字符" withAttributesArr:@[Font12,[UIColor colorWithHexString:@"999999"]]];
        
        _limitLab.attributedText = attString;
    }
  
    
}
#pragma mark -- 意见反馈的接口
- (IBAction)commit:(id)sender {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = opinionFeedbackUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"content"] = _textView.text;
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"意见反馈%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            KZFeedbackSuccessController * successCtl = [[KZFeedbackSuccessController alloc] init];
            [self.navigationController pushViewController:successCtl animated:YES];
            
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
                
    } failedBlock:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"提交失败" hideAfterDelay:1.0];
    }];
    
}



@end
