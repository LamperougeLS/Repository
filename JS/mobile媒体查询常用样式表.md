 
 媒体查询常用样式表：
```html
	<link rel="stylesheet" media="all and (orientation:portrait)" href="portrait.css">    // 竖放加载
	<link rel="stylesheet" media="all and (orientation:landscape)"href="landscape.css">   // 横放加载
```
	竖屏时使用的样式
```html
	<style media="all and (orientation:portrait)" type="text/css">
		#landscape { display: none; }
	</style>
```
	//横屏时使用的样式
```html
	<style media="all and (orientation:landscape)" type="text/css">
		#portrait { display: none; }
	</style>
```
