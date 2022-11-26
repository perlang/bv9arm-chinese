
# 构建环境
* 当前版本在 Fedora 36 上成功构建。
* 构建需要的软件
  * python3
  * sphinx-doc
  * texlive
  * 中文字体（Fedora系统上可选google和adobe的字体。）

软件包：

```shell
   # dnf -y install python3-sphinx python3-sphinx-theme-alabaster python3-sphinx_rtd_theme
```

texlive-* ，这个数量较多，如果缺少，构建时会有相应的错误提示。大致有以下这些：

```shell
   # dnf -y install texlive texlive-xecjk texlive-ctex texlive-fncychap texlive-wrapfig texlive-capt-of texlive-framed texlive-upquote texlive-needspace texlive-tabulary texlive-xindy texlive-gnu-freefont 
```

# 生成PDF文件

```shell
   $ autoreconf
   $ ./configure
   $ cd doc
   $ make pdf
```

# 变化
* bind-9.18.5的变化：
  * 增加块的定义，每条语句都定义了语法及所属的块
  * DNSSEC从第七章调整为第五章，并且内容有较大变化
* bind-9.18.4的变化：
  * 章节结构调整
  * 增加了7张图
  * 从bind抄了configure.ac，增加了一级目录。
* 从bind-9.16.11开始，增加了第九章《DNSSEC指南》。
* 从bind-9.16.4开始，ISC官方文档使用reStructuredText替代了以前使用的docbook5，构建工具也随之改为sphinx-doc，中文文档也对应做了改变。

# 其它
* 欢迎任何建议和指正。
