
# 构建环境
* 当前版本在 Fedora33/34/35 上成功构建。
* 构建需要的软件
  * python3
  * sphinx-doc
  * texlive
  * 中文字体（Fedora系统上可选google和adobe的字体。）

软件包：

.. code-block:: 
   # dnf -y install python3-sphinx python3-sphinx-theme-alabaster python3-sphinx_rtd_theme

texlive-* （这个数量较多，如果缺少，构建时会有相应的错误提示。）

# 生成PDF文件

$ cd arm

$ make pdf

# 变化
* 从bind-9.16.4开始，ISC官方文档使用reStructuredText替代了以前使用的docbook5，构建工具也随之改为sphinx-doc，中文文档也对应做了改变。
* 从bind-9.16.11开始，增加了第九章《DNSSEC指南》。

# 其它
* 欢迎任何建议和指正。
