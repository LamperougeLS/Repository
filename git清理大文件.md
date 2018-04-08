## git清理大文件

  之前在网上看到一些PDF的电子书下载了下来，准备放在git仓库里，结果没注意单个文件大小好几个都是50-100M以上导致commit失败或缓慢。


  单纯删除文件不能完全解决问题，因为git的每次操作都会转成二进制文件保存在.git文件下导致文件过大，于是我用一些博客写的git命令来修改文件体交关联；
结果很感人..git文件反而越来越大了，我的内心是崩溃的。


  然后多方查找发现了一个好用的工具BFG，还真是好用..  工具地址：https://rtyley.github.io/bfg-repo-cleaner/


使用方法：
```bash
git clone --mirror git://example.com/some-big-repo.git

java -jar bfg.jar --strip-blobs-bigger-than 100M some-big-repo.git

cd some-big-repo.git

git reflog expire --expire=now --all && git gc --prune=now --aggressive

git push
```
 
  详细注明一下：这个some-big-repo就是你要瘦身的git仓库，一定一定要git clone --mirror下来，之前没注意看文档直接第二步，路径也是原项目路径，
结果就是一直提示.git不是一个仓库，或者不是有效路径。这个操作是clone一个裸仓库镜像，bfg再对镜像操作然后push，并不是直接在原仓库进行。
 

还有BFG工具要用到java的运行环境，很久以前学过java我是直接下BFg用的，没有装java的自己在百度上搜下java运行环境配置就行了。

 
另外，BFG还有其他的功能，有需要的再仔细研究，文档里写的很清楚。
