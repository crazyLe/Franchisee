//
//  KZDelResonView.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

//#define tablerect CGRectMake(45, (kScreenHeight - 330)/2,kScreenWidth - 90 , 330)
#define tablerect CGRectMake((kScreenWidth - 290)/2, (kScreenHeight - 330)/2,290 , 330)

#import "KZDelResonView.h"
#import "KZDelCell.h"

@implementation KZDelResonView

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = self.backgroundColor =  [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5];
        
        UITableView *optiontable = [[UITableView alloc]initWithFrame:tablerect style:UITableViewStylePlain];
        optiontable.dataSource = self;
        optiontable.delegate = self;
        optiontable.scrollEnabled = NO;
        _table = optiontable;
        
        [optiontable registerNib:[UINib nibWithNibName:@"KZDelCell" bundle:nil] forCellReuseIdentifier:@"KZDelCell"];
        
        [self addSubview: optiontable];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZDelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZDelCell"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cancleBlock = ^(){
        [self hide];
    };
    
    cell.sureBlock = ^(NSString *reson){
        [self hide];
        NSLog(@"----delete ---- %@",reson);
    };
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 330;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}


@end
