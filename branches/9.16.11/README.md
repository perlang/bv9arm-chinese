
# 主要变化
* 与上一版对比，增加了 DNSSEC指南

# 构建环境
* 当前版本在 Fedora33/34/35 和 Windows 10 上成功构建。
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

联系方式： sunguonian@yahoo.com
