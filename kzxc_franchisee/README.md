# 康庄学车-加盟商端
康庄学车加盟端，是以校园招生加盟商为中心，微官网、在线报名和推广素材库等功能帮助加盟商更好地开展招生业务，同时帮助加盟商统计招生数据及信息，方便其向公司总部对接招生信息，简化业务流程  

[AppStore](https://itunes.apple.com/cn/app/kang-zhuang-jia-meng-duan/id1144838124?mt=8)

## 项目目录结构说明

> AppDelegate(app入口相关)     
> Sections(各模块、模块内部再按MVC划分）  
> Utils(常用的工具类） 
> Macro(相关宏定义)
> General(项目中通用的 可复用的组件)  
> Resources(plist、配置、html等资源文件)
> DataBase(数据库管理相关)  
> Vender(第三方库文件、非pod管理)  
> Network(网络相关)  
> pod(pod第三方库）

## 规范说明

## 图片资源管理命名
### 图片文件尽量放asset中管理，文件夹尽量用英文命名最差使用拼音，图片文件命名采用type_location_identifier_state规则，只需要@2x和@3x图片,缩略前缀type常用参考如下:
* icon
* btn
* bg
* line
* logo
* pic
* img

### 常用state主要如下：
* normal
* highlighted
* selected
* disabled

当只有一种状态时 state 不写

示例：icon_common_rightArrow、 icon_tab_work_normal、icon_tab_work_selected



## 约定
### git 协作工作流程   
#### clone 并切换分支（只需做一次）
1. clone代码 git clone [url]  
2. 切换到dev分支 git checkout dev
3. 同步远程代码到最新状态 git pull --rebase  
  
#### 具体工作流程 （循环操作执行）
1. 修改编辑代码完成后 增加修改到暂存去 git add [dir] [file] [.]
2. 提交修改到本地仓库并填写对应简洁清晰的日志 git commit -m [message]
3. 将本地仓库相关修改推送同步到远程 git push [remote] [branch] (默认dev跟远程dev已经建立了映射关系 只需 git push即可），推送到远程之前 最好先 git pull --rebase 一次  

#### 冲突解决
如果是 git pull --rebase 时出现的冲突解决步骤如下：  
1. 找到有冲突的文件，处理冲突的代码 保留最终需要的部分，然后保存退出文件  
2. 添加刚修改的冲突文件到暂存区 git add [dir] [file] [.]  
3. 继续之前的 rebase操作： git rebase --continue  
4. 推送到远程 git push

如果是 git pull 时出现的冲突解决步骤如下
1. 找到有冲突的文件，处理冲突的代码 保留最终需要的部分，然后保存退出文件  
2. 添加刚修改的冲突文件到暂存区 git add [dir] [file] [.]  
3. 提交修改到本地仓库并填写对应简洁清晰的日志 git commit -m [message]
4. 推送到远程 git push 

### 功能模块工作流 （分步、减小颗粒度、避免冲突、便于管理恢复等）
1. 创建合适的文件目录结构，在对应目录下创建对应页面相关文件  然后提交第一次 ‘添加xxxx’ 推送到远程
2. 对对应页面进行页面布局，布局完成后 提交第二次 ‘实现xxx页面布局’ 推送到远程
3. 处理业务逻辑（网络请求、数据对接、页面跳转等），第三次提交 ‘完成xxx页面功能逻辑’ 推送到远程
4. 辅助处理联调遇到的问题 第四次提交 ‘解决xxxx’ （可选、根据实际情况）  