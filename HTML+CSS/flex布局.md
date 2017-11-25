# flex布局
1、元素位置：由6个容器属性和2个项目属性控制

  6个容器属性

    flex-direction
    flex-wrap
    flex-flow
    justify-content
    align-items
    align-content

  2个项目属性

    order 排序
    align-self 对本身进行布局

2、元素尺寸或自适应能力：由4个项目属性控制

    4个项目属性（也可以说是3个，因flex是flex-grow、flex-shrink、flex-basis的集合，后两个可选）

    flex-grow
    flex-shrink
    flex-basis
    flex




Flex 布局教程：语法篇
http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html

阮一峰flex布局实例
http://www.ruanyifeng.com/blog/2015/07/flex-examples.html

注：如果我理解的没错的话，实例中的FLEX圣杯布局 header,footer不应该是flex：1,应该是flex：0 0  xxx宽度;
否则header，footer，和主体部分应该是1:1:1?
原理是header，footer，主体部分，进行  flex-direction: column纵向布局，header，footer的flex basic为固定值，
flex-shrink，flex-grow为0在有空余空间情况不进行缩放，主体部分flex：1（flex：1= flex：1 1 auto）空余空间填满。
主体部分内部左右固定中间自适应的布局其实和header，footer，主体部分是一样的 只是没加纵向布局column。
然后order属性-1给最左侧部分进行排序。
