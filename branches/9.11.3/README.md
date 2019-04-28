
# 变化
* 从bind-9.10.4开始，ISC官方文档使用docbook5替代了以前使用的docbook4.2，构建工具也随之以dblatex替代了db2latex，中文文档也对应做了改变。
* 另外，由于UTF-8环境的日渐成熟，自9.11.3起，本项目的源码改用UTF-8。

# 构建环境
* 操作系统Fedora27/28。
* texlive2015或系统所带texlive版本。
* 缺省使用系统自带思源字体，也可改为文泉驿字体或者其它系统上的字体，具体方法略。
* 构建过程中需要用到一些perl脚本，系统上需要提供perl环境，无需单独安装，一般系统必备。

# 待改进
* 支持configure