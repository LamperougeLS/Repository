 ### webpack异步加载
 
 webpack ensure一般用来做代码切割，那这 个家伙到底是用来干嘛的？其实说白了，它就是把js模块给独立导出一个.js文件的，然后使用这个 模块的时候，webpack会构造script dom元素，由浏览器发起异步请求这个js文件。   
      
      vue-router中使用如下：
      {
            path: '/promisedemo',
            name: 'PromiseDemo',
            component: r => require.ensure([], () => r(require('../components/PromiseDemo')), 'demo')
        },
        {
            path: '/hello',
            name: 'Hello',
            // component: Hello
            component: r => require.ensure([], () => r(require('../components/Hello')), 'demo')
        }
        
       require.ensure() 是 webpack 特有的，已经被 import() 取代。
       
       vue-router中import使用如下：
       
       // 下面2行代码，没有指定webpackChunkName，每个组件打包成一个js文件。
       const ImportFuncDemo1 = () => import('../components/ImportFuncDemo1')
       const ImportFuncDemo2 = () => import('../components/ImportFuncDemo2')
       // 下面2行代码，指定了相同的webpackChunkName，会合并打包成一个js文件。
       // const ImportFuncDemo = () => import(/* webpackChunkName: 'ImportFuncDemo' */ '../components/ImportFuncDemo')
       // const ImportFuncDemo2 = () => import(/* webpackChunkName: 'ImportFuncDemo' */ '../components/ImportFuncDemo2')
       export default new Router({
           routes: [
               {
                   path: '/importfuncdemo1',
                   name: 'ImportFuncDemo1',
                   component: ImportFuncDemo1
               },
               {
                   path: '/importfuncdemo2',
                   name: 'ImportFuncDemo2',
                   component: ImportFuncDemo2
               }
           ]
       })
