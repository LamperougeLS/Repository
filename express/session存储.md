# express框架之session 存储

1.express-session 是基于express框专门用于处理session的中间件。这里不谈express-session怎么安装，只给出相应的实例代码。另外，session的认证机制离不开cookie，需要同时使用cookieParser 中间件

 

# express框架之session 内存存储

```bash
var express = require('express');
var session = require('express-session');
var cookieParser = require('cookie-parser');
 
var app = express();
 
app.use(cookieParser());
app.use(session({
    secret: '12345',
    name: 'testapp',   //这里的name值得是cookie的name，默认cookie的name是：connect.sid
    cookie: {maxAge: 80000 },  //设置maxAge是80000ms，即80s后session和相应的cookie失效过期
    resave: false,
    saveUninitialized: true,
}));
 
 
app.get('/awesome', function(req, res){
     
    if(req.session.lastPage) {
        console.log('Last page was: ' + req.session.lastPage + ".");   
    }   
    req.session.lastPage = '/awesome'; //每一次访问时，session对象的lastPage会自动的保存或更新内存中的session中去。
    res.send("You're Awesome. And the session expired time is: " + req.session.cookie.maxAge);
});
 
app.get('/radical', function(req, res){
    if (req.session.lastPage) {
        console.log('Last page was: ' + req.session.lastPage + ".");   
    }
    req.session.lastPage = '/radical'; 
    res.send('What a radical visit! And the session expired time is: ' + req.session.cookie.maxAge);
});
 
app.get('/tubular', function(req, res){
    if (req.session.lastPage){
        console.log("Last page was: " + req.session.lastPage + ".");   
    }
 
    req.session.lastPage = '/tubular';
    res.send('Are you a suffer? And the session expired time is: ' + req.session.cookie.maxAge);
});

app.listen(5000);
```

# express框架之session 数据库存储　　

上面的这种内存存储，只能短期存储，要想存个几周，就得用上数据库了。下面采用mongodb，
这里，我是首先打开自己电脑的mongodb
然后，启动服务
```bash
var express = require('express');
var session = require('express-session');
var cookieParser = require('cookie-parser');
var MongoStore = require('connect-mongo')(session);
var app = express();
 
app.use(cookieParser());
var settings = {
    cookieSecret: 'myblog',
    db: 'blog',
    host: 'localhost',
    port: 27017
}


app.use(session({
    secret: settings.cookieSecret,
    key: settings.db,//cookie name
    cookie: {maxAge: 1000 * 60 * 60 * 24 * 30},//30 days
    resave: false,
    saveUninitialized: true,
    store: new MongoStore({
        url: 'mongodb://localhost/blog'
    })
}));

app.get('/awesome', function(req, res){
 if(req.session.lastPage) { 
 console.log('Last page was: ' + req.session.lastPage + ".");
  }
  req.session.lastPage = '/awesome'; res.send("You're Awesome. And the session expired time is: " + req.session.cookie.maxAge); });
 app.get('/radical', function(req, res){ 
 if (req.session.lastPage) { console.log('Last page was: ' + req.session.lastPage + "."); }
 req.session.lastPage = '/radical'; res.send('What a radical visit! And the session expired time is: ' + req.session.cookie.maxAge); });
  app.get('/tubular', function(req, res){ if (req.session.lastPage){ console.log("Last page was: " + req.session.lastPage + "."); }
 req.session.lastPage = '/tubular'; res.send('Are you a suffer? And the session expired time is: ' + req.session.cookie.maxAge); });
 app.listen(5000);
```
最后，在存入数据之后，可以使用Robomongo查看存入的数据，并且可以看见，数据过期的时间