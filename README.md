这是一个可以让你的Windows更加小巧的项目，接下来是使用指南：

1.下载镜像文件
打开 https://www.microsoft.com/zh-cn/software-download/windows10
在此页面按下F12键，打开开法者工具
<img width="698" height="916" alt="{3A691AB3-39DC-4082-97B7-26BE8483E4E9}" src="https://github.com/user-attachments/assets/808f529f-9635-4c78-9f7b-110379669035" />
将上方的“维度”从“响应”改为任意非Windows设备。这里以iPad Air作为演示
<img width="261" height="628" alt="{C92590C5-98B3-4453-A0FB-BD6E93B495AB}" src="https://github.com/user-attachments/assets/39a430a7-7533-400a-b9b6-1f751bd00317" />
然后刷新页面
接下来选择Windows10多版本ISO进行下载，大概长这样：

Windows 10 2023 更新 | 版本 22H2
选择版本

以下 Windows 10 版本对于 Windows 10 家庭版和 Windows 10 专业版都有效。

Windows 10（多版本 ISO）
确认

选择“确认”，然后在下一步选择简体中文
<img width="1085" height="290" alt="image" src="https://github.com/user-attachments/assets/5ed93428-1888-47b5-bb41-b726c5a3b128" />
选择“确认”，并在下一个页面选择64位下载

2.制作精简镜像
打开你下载的ISO（打不开的可以使用UltraISO等工具）
将镜像中sources文件夹下的install.wim拷贝到脚本目录下的image文件夹下
接着运行脚本
然后等待45-90分钟，你就会得到一个install.esd，该文件在image目录下

3.后续
镜像制作好后你可以丢到虚拟机里测试
一般情况下安装后大小不会超过10GB
或者作为主力系统使用，但我不建议你这样做
毕竟是精简系统，会有什么问题可能我也不知道

4.免责声明
本项目只是一个Windows自动化精简脚本，仅供学习研究使用
脚本会修改Windows系统镜像，若出现任何数据丢失和其他损坏，项目作者概不负责
精简后的Windows不包含任何激活信息，请自行进行合法授权
使用者应确保使用本脚本符合当前国家/地区的法律
本项目与Microsoft无关，Windows是Microsoft的商标

