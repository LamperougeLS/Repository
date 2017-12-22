# Virtual DOM是什么

在之前，React和Ember早就开始用虚拟DOM技术来提高页面更新的速度了。 若想了解它是如何工作的，就要先认清这几个概念：

## 1.更新DOM是非常昂贵的操作

当我们使用Javascript来修改我们的页面，浏览器已经做了一些工作，以找到DOM节点进行更改，例如：

document.getElementById('myId').appendChild(myNewNode);
在现代的应用中，会有成千上万数量个DOM节点。所以因更新的时候产生的计算非常昂贵。琐碎且频繁的更新会使页面缓慢，同时这也是不可避免的。

## 2.我们可以用JavaScript对象来代替DOM节点

DOM节点在HTML文档中的表现通常是这样的：

```bash
<ul id='myId'>
  <li>Item 1</li>
  <li>Item 2</li>
<ul>
```

DOM节点也可以表示为一个JavaScript对象，就像这样：

```bash
//用Javascript代码表示DOM节点的伪代码
Let domNode = {
  tag: 'ul'
  attributes: { id: 'myId' }
  children: [
//这里是 li
  ]
};
```

这就是虚拟的DOM节点，很好理解吧。

## 3.更新虚拟节点， 并不昂贵贵

```bash
//更新虚拟DOM的代码
domNode.children.push('<ul>Item 3</ul>');
```

如果我们用一个虚拟DOM，而不是直接调用像.getElementById的方法，这样只操作JavaScript对象，这样是相当便宜的。

然后，再把更改的部分更新到真正的DOM，方法如下：

```bash
//这个方法是调用DOM API来更改真正DOM的
//它会分批执行从而获取更高的效率
sync(originalDomNode, domNode);
```

# Vue.js在2.0 版本中引入虚拟DOM是一个正确的选择吗 ？

引入虚拟DOM实际上有优点也缺点。

## 1.尺寸
  更多的功能意味着更多的代码。幸运的是Vue.js 2.0仍然是相当小的（21.4kb当前版本）。
## 2.内存
  虚拟DOM需要在内存中的维护一份DOM的副本。在DOM更新速度和使用内存空间之间取得平衡。
  不是适合所有情况
  如果虚拟DOM大量更改，这是合适的。但是单一的，频繁的更新的话，虚拟DOM将会花费更多的时间处理计算的工作。
  所以，如果你有一个DOM节点相对较少页面，用虚拟DOM，它实际上有可能会更慢。
  但对于大多数单页面应用，这应该都会更快。
  除了性能提升外还有什么
  引入虚拟DOM，这不仅仅是一种性能增强，这同时意味着更多的功能。

例如，您可以在虚拟DOM中的 render() 方法直接创建新的节点：
```bash
new Vue({
  el: '#app',
  data: {
   message: 'hello world'
  },
  render() {
    var node = this.$createElement;
    return node(
      'div', 
      { attrs: { id: 'myId' } }, 
       this.message
    );
  }
});
```
输出：
```bash
<div id='app'>
  <div id='myId'>hello world</div>
</div>
```
为什么这样做？你可以用全编程语言JavaScript编程，您可以创建工厂式的功能来建立虚拟节点。

原地址：<https://www.cnblogs.com/lvyongbo/p/5931636.html>