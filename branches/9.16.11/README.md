
# 变化
* 从bind-9.16.4开始，ISC官方文档使用reStructuredText替代了以前使用的docbook5，构建工具也随之改为sphinx-doc，中文文档也对应做了改变。

# 构建环境
* 当前版本在 Fedora33 和 Windows 10 上成功构建。
* 构建需要的环境
  * python3
  * sphinx-doc
  * texlive
  * 中文字体

# 构建
    make latexpdf

# 待改进
* 支持在 FreeBSD和macOS上的构建。主要问题是Makefile语法和字体的适配。
* 对configure的支持，因为改为reStructuredText，还需要更改相应的文件。

# 其它
* 经过从9.16.3改格式到9.16.4，重新浏览核对了一遍文档，发现错误疏漏还是不少，今后有空再慢慢修订。
* 欢迎任何建议和指正。
* 欢迎对本项目有兴趣的小伙伴加入！

联系方式： sunguonian@yahoo.com
