## Vue

### 指令

##### v-model

绑定data中的一个属性

```html
<input type="text" v-model="name">
<span>hello vue, hello {{name}}</span>
```

当data中有这个属性，v-model指定之后就形成了绑定，当inpu里面的值发生变化的时候，相应的vue实例里面的data属性也发生了变化

```js
const app = new Vue({
    el: "#root",
    data() {
        return {
            name: "Tao"
        }
    },
})
```



##### v-if 和 v-show

控制dom的显示，区别是v-if会从内存中删除这个dom，而v-show只是display设置为null而已，并不是把dom给删除了



##### v-for

就是个迭代器，需要注意的就是如果你对这个迭代的对象做了更改，会反应到页面上的。

v-for 接收的是一个for循环语句，看一下就知道了

```html
<ul>
    <li v-for="team in teamList">{{team.name}}</li>
</ul>
```



##### v-bind

给一个dom元素的属性绑定上值。

```html
<a v-bind:href=url>点我</a>
```

href是data里面的一个值，不用加{{}}，也可以这么写

```html
<a :href=url>点我</a>
```

这样写也是合法的。也支持一定的运算

```html
<a v-bind:href=url :class={red:isRed}>点我</a>
```

上面这个代表这当data中的isRed为true的时候，class添加red类



##### v-if



##### computed

很像python里面的property， 但是他会缓存计算出来的值，只有当data里面的数据改变了，他就会变。

```html
<div id="root">
    <input type="text" v-model.number="math">
    <input type="text" v-model.number="chinese">
    <input type="text" v-model.number="english">
    <div>show sum {{sum}}</div>
    <div>show average {{average}}</div>
</div>
```

```js
const app = new Vue({
    el: "#root",
    data() {
        return {
            math: 90,
            chinese: 100,
            english:90,
        }
    },
    computed: {
        sum: function() {
            return this.math + this.chinese + this.english
        },
        average: function() {
            return this.sum / 3
        },
    },
})
```

