
原文 地址：https://blog.csdn.net/eguid_1/article/details/52849472 

## 前言：

  
  nodejs提供了cluster集群（支持端口共享的多进程），cluster基于child_process,process二次封装，方便我们使用该功能实现单机nodejs的web集群。
 
### 1、cluster的处理机制

都知道单线程的nodejs遇到cpu密集型操作会很容易出现CPU满载，服务阻塞的问题；通过类似nginx的master-worker多进程负载处理方式进一步压榨硬件性能，提升nodejs单机服务处理性能。

           m a s t e r（主进程，分发请求）

        |           |            |            |

     worker       worker       worker        worker(子进程，处理请求)
 
### 2、官方cluster实现

nodejs官方文档中cluster的实现demo：
```bash
const cluster = require('cluster');
const http = require('http');
const numCPUs = require('os').cpus().length;
if (cluster.isMaster) {
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }
  cluster.on('exit', (worker, code, signal) => {
    console.log(`worker ${worker.process.pid} died`);
  });
} else {
  http.createServer((req, res) => {
    res.writeHead(200);
    res.end('hello world\n');
  }).listen(8000);
}
```
### 3、实现自己的单机nodejs集群，实现多进程端口共享
 
#### 3.1、代码实现
```bash
//开启集群服务  
var startClusterSever = function(port, numCPUs) {  
    if (cluster.isMaster) {  
        for (var i = 0; i < numCPUs; i++) {  
            const work = cluster.fork();  
            console.log(work.process.pid);  
            workers[i] = work;  
        }  
        cluster.on('exit', (worker, code, signal) => {  
            console.log(`worker ${worker.process.pid} died`);  
        });  
    } else {  
        console.log(cluster.worker.id);  
        http.createServer((req, res) => {  
            console.log("子进程:" + cluster.worker.id + "正在处理请求...");  
            routeHandler(req, res);  
        }).listen(port);  
  
    }  
}  
```
#### 3.2、基于eguidRoute路由实现

使用：

eguid.start(8081, 8);//监听8081端口，多线程数量8
 
```bash
const http = require('http');  
const url = require('url');  
const path = require('path');  
const fs = require('fs');  
const cluster = require('cluster');  
//路由表  
var routeArr = {};  
//进程列表  
var workers = {};  
//进程数量  
var clusterNum;  
//解析请求地址  
var getPathName = function(reqUrl) {  
    var urlParse = getUrlParse(reqUrl);  
    return urlParse.pathname;  
};  
//获取url解析  
var getUrlParse = function(reqUrl) {  
    return url.parse(reqUrl);  
};  
//是否是一个请求  
var isFunc = function(pathName) {  
    return typeof routeArr[pathName] === 'function';  
};  
/**静态资源处理 param(req:请求,res:响应,pathName:路径) */  
var resStatic = function(req, res, pathName) {  
    fs.readFile(pathName.substr(1), function(err, data) {  
        err ? endErrorReq(res, 501) : endStaticReq(res, pathName, data);  
        res.end();  
    });  
};  
//响应静态资源  
var endStaticReq = function(res, pathName, data) {  
    var suffix = path.extname(pathName);  
    res.writeHead(200, { 'Content-Type': suffix === ".css" ? 'text/css' : 'text/html;' + 'charset=utf-8' });  
    res.write(data);  
};  
//结束错误请求  
var endErrorReq = function(res, err) {  
    res.writeHead(err);  
    res.end();  
};  
/** 路由分发处理器 */  
var routeHandler = function(req, res) {  
    var pathName = getPathName(req.url);  
    isFunc(pathName) ? routeArr[pathName](req, res, pathName) : resStatic(req, res, pathName);  
    console.log("处理了一个请求：" + pathName);  
};  
/** 添加动态路由解析   
 * param{ 
 * reqUrl:请求地址,  
 * service:function(request:请求,response:响应,pathName:请求名)} 
 */  
var addDynamicRoute = function(reqUrl, service) {  
    console.log("添加的服务名：" + reqUrl);  
    routeArr[reqUrl] = service;  
};  
/**  开启服务器并监听端口  param{port:端口号}*/  
var startServer = function(port, num) {  
    clusterNum = num;  
    if (num) {  
        startClusterSever(port, num);  
    } else {  
        //创建服务器    
        http.createServer(function(req, res) {  
            routeHandler(req, res);  
        }).listen(port); //注意这里的端口改成了变量  
        //开启后在控制台显示该服务正在运行    
        console.log('Server running at http://127.0.0.1:' + port);  
    }  
};  
/** 设置静态页面请求别名 param(newUrl:新的请求路径, oldUrl:原始路径) */  
var setIndex = function(newUrl, oldUrl) {  
    addDynamicRoute(newUrl, function(req, res) {  
        resStatic(req, res, oldUrl);  
    });  
};  
/**自定义静态页面处理方式 staticHandlerService=function(req,res,pathName)*/  
var setresStaticFunc = function(staticHandlerService) {  
    resStatic = staticHandlerService;  
};  
  
//开启集群服务  
var startClusterSever = function(port, numCPUs) {  
    if (cluster.isMaster) {  
        for (var i = 0; i < numCPUs; i++) {  
            const work = cluster.fork();  
            console.log(work.process.pid);  
            workers[i] = work;  
        }  
        cluster.on('exit', (worker, code, signal) => {  
            console.log(`worker ${worker.process.pid} died`);  
        });  
    } else {  
        console.log(cluster.worker.id);  
        http.createServer((req, res) => {  
            console.log("子进程:" + cluster.worker.id + "正在处理请求...");  
            routeHandler(req, res);  
        }).listen(port);  
  
    }  
}  
exports.route = routeHandler;  
exports.add = addDynamicRoute;  
exports.start = startServer;  
exports.index = setIndex;  
exports.modStatic = setresStaticFunc;  
/** 
 * eguidRouter快速灵活的路由 
 * 功能实现： 
 * 1、自动静态路由解析 
 * 2、支持手动设置静态路由别名 
 * 3、支持创建新的静态路由实现（方便加载模板） 
 * 4、动态路由解析 
 * 5、自动错误响应 
 * 6、使用原生API，无第三方框架 
 * 7、支持cluster单机集群（机器性能压榨机） 
 */  
```
