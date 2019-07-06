# Tank
坦克大战游戏代码

## quick-Cocos2dx-lua实现的坦克大战
在**慕课网徐波**大佬的视频下学习坦克大战的时候发现只有图片资源，没有代码资源，所以看完视频后就把代码对着视频撸了出来，主要是方便需要学习的人.

安装视频写的代码有些bug，所有对相关的bug进行了修改，主要是对象释放方面（坦克，子弹等）

## 整体效果
![游戏整体效果](https://upload-images.jianshu.io/upload_images/4725810-a7ba6b5264487f91.gif?imageMogr2/auto-orient/strip)

游戏效果整体不炫，毕竟只是为了学习，很多功能可以自己扩展，资源都在。游戏逻辑也简单，代码设计很规范，学习价值不错


## 目录结构
如图

![项目结构](https://upload-images.jianshu.io/upload_images/4725810-a6984d18b4ba8900.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 页面：

**EditorScene.lua** 编辑地图

**MainScene.lua** 首页 玩家主要场景

**TitleScene.lua** 选择界面，选择是进入首页还是编辑页

### 辅助类：

**AITank.lua** 坦克智能出现及发射子弹的派生类

**Block.lua** 地图相关的图片资源转换帮组类

**Map.lua** 地图创建的帮助类

**Bullet.lua** 创建子弹，发射子弹，子弹爆炸动画的帮助类

**Tank.lua** 坦克的帮组类，派生于Object

**其他的文件或类请参考具体代码**

## 感谢
**慕课网徐波大佬**
