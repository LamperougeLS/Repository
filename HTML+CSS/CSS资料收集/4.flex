
1、
    伸缩布局：
    display:flex;

    主轴 ，侧轴（垂直于主轴的方向）

    主轴方向：flex-direction:
        row  row-reverse
        column column-reverse

    主轴方向上的对齐方式：justify-content
        flex-start: 主轴开始
        flex-end: 主轴结束
        center: 居中
        space-around:平分
        sapce-between：两端对齐 中间平均


    侧轴对齐方式：
          flex-start: 侧轴开始
          flex-end: 侧轴结束
          center: 居中
          baseline:基线对齐
          streth:拉伸

    子盒子伸缩比例：
        flex: 1;
        如果某盒子不参与划分比里， 不写flex属性即可


    2、图标字体
        优点：
        1、将所有图标打包成字体库，减少请求；
        2、具有矢量性，可保证清晰度；
        3、使用灵活，便于维护；

        使用步骤：
               1、引入字体包
               2、申明字体：告诉浏览器去哪找字体
               3、定义类名
               4、在结构中写 图标的编码，给标签添加类名


         伪元素中：
            &#xe628;  ----> content:"\e628";

        3-360全屏滚动案例

        鼠标滚轮事件：
            onmousewheel=function(){}


