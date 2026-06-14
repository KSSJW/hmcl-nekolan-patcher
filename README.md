# HMCL Nekolan Patcher

把猫娘语注入HMCL喵！

## 让我看看

![1](/Images/1.png)

![2](/Images/2.png)

不要学猫猫这样截图喵（

## 支持情况

目前支持注入的类型有`jar`、`sh`和`deb`喵。（即`HMCL-xxx.jar`、`HMCL-xxx.sh`和`HMCL-xxx.deb`喵。）

## 食用指南

0. 本脚本运行需要用到的外部命令为`jar` ，若需要注入`deb`格式的HMCL还需要命令`dpkg-deb`喵。

1. 准备好`HMCL`本体喵。（即`HMCL-xxx.xxx`喵。）

2. 看见仓库里的`Inject.sh`了喵？下载到你的设备里喵。

3. 将`Inject.sh`与`HMCL-xxx.xxx`放在同一目录下喵。请注意保证HMCl的**唯一性**，即同一目录下**不能**有多个HMCL，不然……Shell会哭哭的喵……

猫猫给你举个例子喵：

```
.
├── HMCL-3.14.1.jar
├── Inject.sh
└── ...
```

4. 在该目录下执行命令`chmod +x Inject.sh`，授予可执行权限喵。

5. 在该目录下执行命令`./Inject`，狠狠地注入喵（

6. 小手捂住大眼睛，等待脚本执行完成喵。

7. 瞟一眼，不出意外的话就能在生成的`Out`目录下得到`HMCL-xxx-patched.xxx`喵！

## 注意事项

- 由于注入破坏了完整性，会导致HMCL自检失败，从而无法获取HMCL的更新喵。不过猫猫从[官方文档](https://github.com/HMCL-dev/HMCL/blob/main/docs/Contributing_zh.md#%E8%B0%83%E8%AF%95%E9%80%89%E9%A1%B9)里发现添加JVM参数`-Dhmcl.self_integrity_check.disable=true`可以忽略完整性检查喵。