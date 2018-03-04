##常见的 iPhone 和 Android 屏幕参数。

* 设备	     分辨率	    设备像素比率
* Android LDPI	320×240	0.75
* Iphone 3 & Android MDPI	320×480	1
* Android HDPI	480×800	1.5
* Iphone 4	960×640	2.0

iPhone 4的一个 CSS 像素实际上表现为一块 2×2 的像素。所以图片像是被放大2倍一样，模糊不清晰。

解决办法：

1、页面引用


	<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 0.75)" href="ldpi.css" />
	<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 1.0)" href="mdpi.css" />
	<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 1.5)" href="hdpi.css" />
	<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 2.0)" href="retina.css" />
 
2、CSS文件里

	#header {
		background:url(mdpi/bg.png);
	}

	@media screen and (-webkit-device-pixel-ratio: 1.5) {
		/*CSS for high-density screens*/
		#header {
			background:url(hdpi/bg.png);
		}
	}
