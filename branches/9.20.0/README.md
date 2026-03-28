
# 构建环境
* 当前版本在 Fedora 42/43/44 上成功构建。
* 构建需要的软件
  * python3
  * sphinx-doc
  * texlive
  * 中文字体（Fedora系统上可选google和adobe的字体。）

软件包：

```shell
   dnf -y install python3-sphinx python3-sphinx-theme-alabaster python3-sphinx_rtd_theme
```

texlive-* ，这个数量较多，如果缺少，构建时会有相应的错误提示。大致有以下这些：

```shell
   dnf -y install texlive texlive-xecjk texlive-ctex texlive-fncychap texlive-wrapfig texlive-capt-of texlive-framed texlive-upquote texlive-needspace texlive-tabulary texlive-xindy texlive-gnu-freefont 
```

# 生成PDF文件

```shell
   $ autoreconf
   $ ./configure
   $ cd doc
   $ make pdf
```

# 生成epub文件

```shell
   $ autoreconf
   $ ./configure
   $ cd doc/arm
   $ make epub
```

# 其它
* bind-9.20.0文档
  * 在 Fedora 42上，sphinx-build 8.1.3
  * 在 Fedora 43上，sphinx-build 8.2.3
  * 在 Fedora 44上，sphinx-build 8.2.3

# 其它
* 欢迎任何建议和指正。
