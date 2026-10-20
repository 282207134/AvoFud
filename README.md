# AvoFud

根据 Pixso「AvoFud UI Kit」实现的 Flutter 食物购物 App。涵盖 28 个参考界面，以及购物车、收藏、订单、奖励、设置等补充页面；支持浅/深色模式和本地保存。

## 交付文件

- [项目结构与架构说明](docs/ARCHITECTURE.md)
- [所有界面与截图](docs/SCREENS.md)
- [测试结果及复现步骤](docs/VALIDATION.md)
- [Pixso 节点和设计 token](docs/DESIGN_SOURCE.json)

## 运行

```powershell
flutter pub get
flutter devices
flutter run -d <Android设备ID>
# 或浏览器预览
flutter run -d chrome
```

登录时输入格式正确的邮箱或手机号及至少 6 位密码即可进入本地演示。注册/找回流程验证码为 `1490`。通过 Account → Setting → All screens 可直接浏览全部参考页面；Setting 中可以切换深色模式。

购物入口：底部 Shopping。搜索与价格排序：右侧筛选按钮。购物车：右上购物袋。点击商品查看详情，选择规格并加入购物车，确认收货地址后 Pay out 完成模拟支付。可开启 Simulate payment failure 验证失败重试。

## 检查与截图

```powershell
flutter analyze
flutter test --concurrency=1
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d <Android设备ID>
```

设备测试会重置该 App 的本地演示数据，并把截图写入 `docs/screenshots/`。

## 构建

```powershell
flutter build apk --debug
flutter build apk --release
flutter build web --release
```

Android release 目前使用 Flutter 默认调试签名，适用于本地验收；发布到商店前需要配置正式签名。iOS 项目已提供，需在 macOS 上安装 Xcode 后构建，本次 Windows 环境不能验证 iOS 编译。

## 实现边界

认证、短信、支付、银行卡和订单均为本地演示，没有后台服务。语言页只保存偏好，文案遵循英文稿。教程提供封面和交互式分步食谱，原稿没有视频文件。未提供 Cera Round Pro 字体，使用 OFL 授权 Nunito 近似替代；因此字形与原稿存在区别。食物、插画和品牌素材直接来自用户提供的 Pixso 文件。
