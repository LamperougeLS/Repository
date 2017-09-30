//方便修改的话maxwidth,designwidth（设计稿宽度）,fontSize（约定的字体大小）可写在config配置中import进来
var maxwidth = 1080,designwidth = 750,fontSize = 32;
(function (doc, win) {
  var docEL = doc.documentElement
  // 判断是resize事件还是orientationchange（手机方向）事件
  var resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize'
  // 随便设计的，设计图宽度以750，字体32px为基准，一般页面基准320px(20px)。
  var recalc = function () {
    var clientWidth = docEL.clientWidth
    if (!clientWidth) return
    else if (clientWidth >= maxwidth) { docEL.style.fontSize = fontSize * (maxwidth / designwidth) + 'px' } 
    else { docEL.style.fontSize = fontSize * (clientWidth / designwidth) + 'px' }
  }

  if (!docEL.addEventListener) return
  // 添加事件监听
  win.addEventListener(resizeEvt, recalc, false)
  doc.addEventListener('DOMContentLoaded', recalc, false)
})(document, window)
