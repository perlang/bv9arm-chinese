
# 构建PDF的环境

操作系统： Fedora 35

软件包：

.. code-block:: 
   # dnf -y install python3-sphinx python3-sphinx-theme-alabaster python3-sphinx_rtd_theme

texlive-* （这个数量较多，如果缺少，构建时会有相应的错误提示。）

# 生成PDF文件

$ cd arm

$ make pdf

