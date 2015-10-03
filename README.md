# bv9arm-chinese
Chinese translation of BIND 9 administrator reference manual

当前构建环境：

Fedora release 22 (Twenty Two)

  4.1.7-200.fc22.x86_64

texlive2015-20150523.iso

db2latex-xsl-0.8pre1.tar.gz

建立环境的步骤

1. 安装db2latex  
将db2latex解包并移到/usr/local/share/ 目录下。  
即db2latex的主目录为：/usr/local/share/db2latex  

2. 按照bind-9.x.x/docutil/目录下的三个*bug文件修改  
/usr/local/share/db2latex 下的三个文件。  

3. 安装texlive-2015（略）到/usr/local/texlive  
如安装好的pdflatex路径为：  
/usr/local/texlive/2015/bin/x86_64-linux/pdflatex  

4. 安装gbk2uni工具  
svn checkout http://ctex-kit.googlecode.com/svn/trunk/ ctex-kit-read-only  
cd ctex-kit-read-only/gbk2uni  
make  
su   # 获取root权限  
install -c -m 755 gbk2uni /usr/local/bin/  
