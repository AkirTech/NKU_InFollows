# TODO
- [ ] 修改finish.qml的qrPath，指向wx_qrcode.png(现在在x64/目录下，采取copy？或者手动拼凑绝对路径？)
- [ ] 修改WebParser的wxLoginGetQR方法（现在无法返回生成成功，目前此测试点采取断言）
- [ ] 实现获取公众号列表的功能。
    - 注意：这里需要用户auth微信公众平台，才能获取到公众号列表。
    - 实现路径：每次启动，或者达到expiretime的时候，都去获取一次，通过api的get QR Code接口。