## Node.js 服务器部署之把 Vue 项目部署到线上

原文地址：https://segmentfault.com/a/1190000012861469

### 项目打包

npm run build后会有一个dist目录，这个文件夹就是我们要部署上线的项目

### 写一个小脚本

如果你会点nodejs，脚本就很好理解了，下面是app.js启动脚本的内容
```bash
const fs = require('fs');
const path = require('path');
const express = require('express');
const app = express();
// 模拟数据，api服务
var appData = require('./data.json');
var seller = appData.seller;
var goods = appData.goods;
var ratings = appData.ratings;
// api接口
var apiRoutes = express.Router();
apiRoutes.get('/seller', function(req, res) {
    res.json({
        erron: 0,
        data: seller
    })
});

apiRoutes.get('/goods', function(req, res) {
    res.json({
        erron: 0,
        data: goods
    })
});

apiRoutes.get('/ratings', function(req, res) {
    res.json({
        erron: 0,
        data: ratings
    })
});
app.use('/api', apiRoutes);
app.use(express.static(path.resolve(__dirname, './dist')))

app.get('*', function(req, res) {
    const html = fs.readFileSync(path.resolve(__dirname, './dist/index.html'), 'utf-8')
    res.send(html)
})
app.listen(8082);
```
简单解释一下上面的代码，由于项目需要些数据，我的模拟数据都在data.json这个文件里，所有简单的写了三个路由,对应获取到模拟数据。然后把dist目录静态出来，读取dist目录下的index.html（因为是单页应用，只有这一个html文件）,监听8082端口

我们先在本地把要上传的文件都准备好：我们的这个脚本使用了express框架,所以我们可以生成一个package.json，把依赖项添加进去
```bash
{
  "name": "vue-elm-dist",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.15.3"
  }
}
```
完成以上操作，我们要上传的文件项目大概长这样
新建一个文件夹如elm,把整个项目通过ftp上传到根目录www文件夹下

### 启动服务

登陆到你的服务端,cd到elm文件夹，执行npm install 安装依赖,然后pm2 start app.js就成功启动服务了
现在通过ip加端口形式能正常访问，但是如果想通过域名访问就需要配置nginx映射

### nginx 端口映射配置

首先你需要把一个二级域名解析到你的主机ip,比如我使用的elm.86886.wang这个二级域名配置文件和之前的基本一致
```bash
upstream elm {
    server 127.0.0.1:8082;
}

server {
    listen 80;
    server_name elm.86886.wang;

    location / {
        proxy_set_header Host  $http_host;
        proxy_set_header X-Real-IP  $remote_addr;  
        proxy_set_header X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header X-Nginx-proxy true;
        proxy_pass http://elm;
        proxy_redirect off;
    }
}
```
我把它命名为elm-8082.conf
然后通过ftp上传到/etc/nginx/conf.d/目录下
执行sudo nginx -s reload重启nginx服务器，过个十分钟就应该能正常访问了
 
