//
//  KZInterface.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#ifndef KZInterface_h
#define KZInterface_h

#ifdef DEBUG
//测试
#define HOST_ADD @"http://192.168.5.216:8000/franchisee"
#define WAP_HOST_ADD @"http://192.168.5.216:81/index.php/wap"
#else
//正式
#define HOST_ADD @"https://www.kangzhuangxueche.com:8000/franchisee"
#define WAP_HOST_ADD @"https://www.kangzhuangxueche.com/index.php/wap"
#endif

//工作首页
#define kWorkInterface HOST_ADD@"/work"

//work文章链接
#define kWorkArticleInterface WAP_HOST_ADD@"/article/show"

//work如何赚钱
#define kWorkHowEarnMoney WAP_HOST_ADD@"/franchisee/money"

//申请详情wap链接
#define kApplyDetailWapInterface WAP_HOST_ADD@"/franchisee/applyInfo?app=1&token=%@&order_id=%@"

//获取验证码
#define getValidateCodeUrl HOST_ADD@"/user/send-code"
//注册
#define registerUrl HOST_ADD@"/user/register"
//登录
#define loginUrl HOST_ADD@"/user/login"
//找回密码
#define findPswUrl HOST_ADD@"/user/find-password"
//提成申请
#define percentageApplyUrl HOST_ADD@"/work/apply-list"
//基本信息录入
#define infoEnteringUrl HOST_ADD@"/member/info-add"
//意向列表
#define intentionListUrl HOST_ADD@"/customer"
//意向删除
#define deleteIntentionUrl HOST_ADD@"/customer/del"
//意向备注
#define getIntentionRemarksUrl HOST_ADD"/customer/remark"
//新增意向备注
#define addIntentionRemarkUrl  HOST_ADD@"/customer/remark-add"
//删除意向备注
#define deleteIntentionRemarkUrl HOST_ADD@"/customer/remark-del"
//意见反馈
#define opinionFeedbackUrl HOST_ADD@"/feedback"


//获取银行列表
#define kGetBanksUrl HOST_ADD@"/information/get-banks"

//银行卡绑定信息
#define kBankBindInfoUrl HOST_ADD@"/member/bank"

//绑定银行卡
#define kBindBankCardUrl HOST_ADD@"/member/bank-bind"

//开发环境
#define weiguanwangWebMainUrl WAP_HOST_ADD@"/card/show/%@?app=1&uid=%@&cityId=%d"
#define weiguanwangWebEditUrl WAP_HOST_ADD@"/card/show/%@?app=1&uid=%@&time=%@&sign=%@"

//分享微官网地址
#define kWeiGuanWangShareUrl WAP_HOST_ADD@"/card/show/%@?cityId=%d"

//工作安排
#define workScheduleUrl             HOST_ADD@"/work/task-list"
//工作安排详情
#define workScheduleDetailsUrl      HOST_ADD@"/work/task-info"
//工作安排日志新增
#define workScheduleAddUrl          HOST_ADD@"/work/task-log-add"
//活动宣传
#define workActivityUrl HOST_ADD@"/activity"

//业务培训
#define kBusinessTrainInterface HOST_ADD@"/news/training"

//检查版本
#define kCheckVersionInterface  HOST_ADD@"/check-version"

//地区统一接口
#define kGetAddressInfoInterface HOST_ADD@"/information/get-address"

//学校统一接口
#define kGetSchoolInfoInterface HOST_ADD@"/information/get-school"

//个人设置数据获取
#define getPersonSetDataUrl     HOST_ADD@"/member/info"

//个人资料编辑
#define editPersonDataUrk       HOST_ADD@"/member/update"

//修改密码
#define modeifyPassword HOST_ADD@"/member/edit-password"

//修改手机号
#define modeityPhone    HOST_ADD@"/member/edit-phone"

//物料申请(首页)
#define kMaterialApplyInterface HOST_ADD@"/items"

//物料申请(新增)
#define kAddMaterialInterface HOST_ADD@"/items/add"

//我的物料申请列表
#define kMyMaterialListInterface HOST_ADD@"/items/mine"

//申请撤回
#define kApplyUndoInterface HOST_ADD@"/items/mine-del"

//消息拉取
#define kPullMessageInterface HOST_ADD@"/message"

#endif /* KZInterface_h */
