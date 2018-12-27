# xxzhushou_base_framework 叉叉助手基本框架
[README备用链接](https://www.zybuluo.com/cndy1860/note/1369690)
---

## 框架说明
目前手游脚本的实现主要是在多级界面之间不断的跳转，并在其间穿插各状态判定和逻辑操作，流程模式大致可以归结为：界面-->>事件-->>界面-->>事件...本项目即是依据此模型构建的一个的基本框架。
目前流行的框架基本上采用了在每个界面上锚定控件位置，然后在每个控件上加上一个简单的事件（多为tap点击操作），添加一个任务只需要依次列出界面和对应要点击的控件，这样的好处是逻辑简单，对于只需要在各级界面跳转和简单点击的游戏，当然是一个不错的选择，但是对于在各级界面跳转间有复杂情况的游戏来适用性并不高，此框架即是为能适应复杂跳转情况而构建。
本项目以实况足球手游为示例演示开发一个完整的`task`。

### 框架特性
- 基于界面隔离的低耦合度流程执行系统
- 框架界面判定与任务逻辑分离
- 框架代码与任务代码分离
- 可自适应跳过流程片，以应对一些不确定是否出现的流程或者弹窗
- 能稳定适应高延迟范围的界面（如某些需联网界面依赖网络延迟）跳转
- 提供基本的数据字典(4K+单词)，可用于生成规则的随机ID
- 完善的错误处理机制，可通常重启脚本和应用恢复部分可控的错误
- 提供基本OCR
- 检测应用崩溃，可通过重启应用续接未完成的任务

### 实况足球（示例游戏）界面跳转的一些特点
 - 界面跳转完成时间受网络影响严重，由很多界面绑定后台数据导致，完成时间在几十毫秒至几十秒的巨大区间
 - 弹出部分子界面直接覆盖在原来的界面上的一小块区域，比如提示能量不足、球员合约不足
 - 界面跳转间不稳定，以从界面A跳转到界面B为例
    * 可能是保持A界面直到界面B（常规情况）
    * 可能是直接出现过度动画直到界面B
    * 可能是直接出现一个不相关的界面N，保持界面N直到界面B，但是这个界面N有可能正好是其他流程片对应的界面
    * 可能出现通知界面T（一个或者多个通知界面），或者报错界面E（合同不足、能量不足），均需要复杂的事件处理函数
    * A至B之间为是长事件，比如实况开场界面和半场休息界面之间夹杂着半场球赛和对应的多个事件处理，长达数分钟
    * 界面B可能不会到来，需要直接跳过
 - 游戏不稳定，有可能会出现错误的流程，比如48级联赛结束无规律弹出错误的升级提示界面、成就完成界面

## 设计原则
- 分离框架和任务代码，开发尽量只在xxxTask.lua中进行
- 尽量分离界面判定和逻辑代码
- 尽量降低流程片间的耦合度，但在处理后续可能出现多个不确定界面的情况下会在局部违反此规则（catchPage机制）
- 尽量不使用延时来确保上一歩操作的完成（比如点击下一歩按钮）
- 在不关键的流程片降低扫描频率，节省资源

## 模块说明
- main：程序入口
- task模块：以流程片为单位执行任务流程的具体细节。具体的任务由开发者在task_list文件夹中的具体任务文件中定义
- page模块：界面特征值库和相关的判定方法
- func/projectFunc：通用函数/项目专用函数，均为全局定义
- dict模块：数据字典，提供了一个4K+的单词库，以及多种取词方法，可用于生成规则的随机ID
- global：全局变量和常量
- config：配置表`CFG`，为全局定义
- init：初始相关变量和用户设置
- orc：文字识别
- zui：第三方UI库-Zui，可自行选择更换

## 框架流程执行

一个完整的脚本任务`task`由一系列流程`processes`组成，而流程又由多个流程片`process`组成，每一个流程片由流程片初始界面`page`和一个事件函数`actionFunc`组成。  `runTask`方法首先会从`taskList`中提取对应的`processes`，然后以`process`为单位具体执行。程序首先会等待流程片初始界面`page`的到来，但并不关心之前的任何流程，然后开始执行流程片的具体的逻辑操作函数`actionFunc`，执行完成后释放流程片控制权，同时不关心后续流程。
###`process`执行流程图
注:GFM可能不支持流程图，如不支持可自行COPY代码在其他工具上查看
```flow
st=>start: 循环执行流程片
setSkipStatus=>operation: 根据justFirstRun和justBreakingRun
设置各流程片的初始skip属性
setSkipTime=>operation: 设置进入skip检测的等待时间
execProcess=>operation: 遍历执行流程片
isSkipProcess=>condition: 是否需要跳过的流程片
checkCurretPage=>operation: 循环检测当前界面
isProcessPage=>condition: 是否为当前流程片对应的界面
actionFunc=>operation: 执行流程片事件函数actionFunc
waitFunc=>operation: 执行流程片等待事件函数waitFunc
checkTimeout=>operation: timeout检测
isSkip=>condition: 是否发生了skip
e=>end: 完成当前流程片流程
st->setSkipStatus->setSkipTime->execProcess->isSkipProcess
isSkipProcess(no,left)->checkCurretPage
isSkipProcess(yes)->execProcess
checkCurretPage->isProcessPage
isProcessPage(no,left)->waitFunc
isProcessPage(yes)->actionFunc->execProcess
waitFunc->checkTimeout->isSkip
isSkip(yes)->isSkipProcess
isSkip(no)->checkCurretPage
```
## 核心机制说明
### **skip**机制：通过设置`skipStatus`属性来控制是否跳过流程片
根据是否为首次运行，是否为断点任务，当前界面是否存在可跳过的情况来设置`skipStatus`。
在脚本运行期间，如果流程中某一个流程片界面没有出现，或者因为用户主动点击了一下歩而跳过了某一个流程片，那么在循环等待的过程中，如果等待时间超过`CFG.WAIT_CHECK_SKIP`，流程函数将尝试判定是否可以执行跳过流程片的处理。判定原则是：当前的界面`CURRENT_PAGE`符合当前流程片之后的某个流程片的界面`PROCESS_PAGE`，那么就判定从`CURRENT_PAGE`至`PROCESS_PAGE`(不包括`PROCESS_PAGE`本身)为可跳过界面，设置`skipStatus`属性为true，并直接跳转到`PROCESS_PAGE`继续执行流程。
通过skip机制，可以让脚本可以从流程中的任何一个界面开始任务，主要解决以下问题:

 - 自动重启应用或者脚本后，脚本能够自动续接任务
 - 当用户不小心手动点击了下一步按钮，跳过了某个流程，能够自动判定并继续
 - 当用户从非主界面开始游戏，也能自动判定并继续
 - 某个流程只是概率性出现，未出现时可以使用此机制跳过（如果只是极低概率出现推荐用catchPage跳过）
 
### **catchPage**机制：处理界面跳转可能出现多个不确定界面的情况
比如流程为`{A,B,C,D,E,F,G}`，以界面A跳转至界面B为例：

 - 跳转的过程中，可能出现其他无关界面E，但是E出现在后续流程中，这就有可能直接触发了skip机制，导致skip掉了B、C、D三个界面的流程。要处理这种情况，那么便可使用:
```
if catchPage(PAGE_B) == PAGE_B then nextAction end
```
这样在捕获到界面B以前，将会忽略掉其他所有的界面，避免造成干扰

 - 跳转的过程中，可能先出现了游戏弹出的数个通知，每则通知需要点击关闭按钮才能继续，而通知关闭以后，还可能出现多个其他提示，比如能量不足，合同不足，依次完成这所有的操作后，才能顺利跳转到B。处理示例：

```
while
    catchPage({PAGE_B, PAGE_NOTICE}, {points_contract, points_energy})
    if PAGE_B then break    --出口
    if PAGE_NOTICE then closeNotice()
    if PAGE_points_contract then chargeContract()
    if PAGE_points_energy then chargeEnergy()
end
nextAction
```
你可能会注意到，catchPage机制其实同样能实现skip的效果，那如果抉择呢？skip效果的触发，是需要经过等待`CFG.WAIT_CHECK_SKIP`时间后才进入检测是否发生的流程，一般为3s以上，如果把一个极低概率才会出现的界面用skip机制处理，会导致每次运行到那个流程片均需要等待`CFG.WAIT_CHECK_SKIP`的时间才能跳过，增加了流程的大量的等待时间，但使用**catchPage**则无需等待延时，出现任何一个列出的界面即可马上响应。
从本质上来说，catchPage机制就是一个无延时的，功能加强版本的skip机制，但是它增加了流程片间的耦合度。
注：demo中多使用的为原型函数`catchFewProbabilityPage`，`catchPage`为其扩展，推荐优先使用`catchPage`
### **goNextByCatchPoint**机制：检测界面上的按钮（点集）并点击
这是一个能稳定跳转并简化操作的机制，比如以流程为`{A,B,C,D}`为例，流程执行顺序为在A点击下一步到达B，然后在B上点击下一步按钮到达C，在C点击下一步到达D，具体流程为：
```
--方式一：使用延时的方式，稳定性极差，易受网络和硬件配置影响，本框架本不作讨论
tab A.button
delay(time)
find B.button
tab B.button 
delay(time)
find C.button
tab C.button 
delay(time)
do nextAction

--方式二：检测界面已经到达一下个界面后再进行点击，稳定，但繁复
tab A.button
while
    if checked PAGE_B then
        find B.button
        tab B.button
    end
end
while
    if checked PAGE_C then
        find C.button
        tab C.button
    end
end
while
    if checked PAGE_D then
        do nextAction
    end
end
```
`goNextByCatchPoint`本质上就是简化了的方式二，只需要传入B.button的特征点，然后它将循环检测B.button是否到达，在检测到B.button到达的情况下，PAGE_B肯定也已经到达，到达后将执行tap点击操作，示例：
```
--方式三：使用goNextByCatchPoint，稳定，且精简
goNextByCatchPoint(points_A.button)
goNextByCatchPoint(points_B.button)
goNextByCatchPoint(points_C.button)
do nextAction
```
### **catchError**机制：错误处理
在运行阶段所有的异常均交由catchError处理，由catchError打印记录LOG信息，然后执行错误处理方式。当判定为可以通过重启解决时，会尝试重启应用和脚本来解决问题，否则终止脚本任务。
### **restart**机制：重启断点续接运行
由于模拟器或者手机运行应用可能会出现卡死闪退的情况，必要的重启恢复机制能保证挂机的稳定性。在catchError中，被判定为可以通知重启应用解决的错误，将执行restartAPP操作，然后通过skip机制续接任务。在restart的过程中，通过getLastTaskStatus来设置是否为断点重启任务，以标识一些初始化流程的执行。

## ToDo
- `在线收集ERROR信息`：玩家反馈的非稳定复现的错误极难追踪，即使开启写LOG文件的功能，操作也极为麻烦，因此构思将报错信息发送至服务器，用户只需要提供ID便可直接查看错误，方便调试。
- `通过服务器收集脚本使用情况的信息`。
- `全分辨率适配`:开始构建次框架时离我接触叉叉平台不到一周，所以当时并不了解全分辨适配，后来想做的时候，却发现实况这个游戏界面布局既不是简单的等比缩放，也不是基于锚点的短边缩放的布局，加之框架构建之初并未做出相应的预留和兼容，因此很难直接参考现有的方案。实况会在19年初更新UE4游戏引擎，不出意外应该会采用基于锚点的短边缩放的布局，故而全分辨率适配的方案放将放在后续构建。
- `2.0引擎`：框架构建时，2.0引擎还处于内测阶段，一开始也确有尝试使用2.0引擎开发，但陆续发现了多个致命BUG（比如findColor内存泄露），尽管官方陆续在修复，但目前因时间限制，以稳为主，还是先基于1.9引擎开发，待新引擎基本稳定后将迁移至新引擎。
- `HUD信息提示`：目前的取点方式容易影响到色点判定，新引擎后再行支持。
- `UI`：1.9引擎不支持动态UI，为省时暂时使用Zui，2.0引擎已支持，故在迁移2.0后会整理一个简单是UI实现

## 其他
欢迎交流。
请不要直接用此代码发布实况足球手游的脚本，其它随意，利益相关，见谅。

## 联系方式
cndy1860@gmail.com




