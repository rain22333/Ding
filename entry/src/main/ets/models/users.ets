// 用户信息
export interface UserInfo {
  username: string // 用户昵称
  avatar: ResourceStr // 用户头像
  firm: string  // 公司名称
  user_id: string // 用户id
}
export const DefaultUserList: UserInfo[] = [{
  username: '张三',
  avatar: 'http://e.hiphotos.baidu.com/image/pic/item/a1ec08fa513d2697e542494057fbb2fb4316d81e.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '1'
},{
  username: '李四',
  avatar: 'http://c.hiphotos.baidu.com/image/pic/item/30adcbef76094b36de8a2fe5a1cc7cd98d109d99.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '2'
},{
  username: '王五',
  avatar:'http://h.hiphotos.baidu.com/image/pic/item/7c1ed21b0ef41bd5f2c2a9e953da81cb39db3d1d.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '3'
},{
  username: '赵六',
  avatar:'http://g.hiphotos.baidu.com/image/pic/item/55e736d12f2eb938d5277fd5d0628535e5dd6f4a.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '4'
},{
  username: '田七',
  avatar:'http://e.hiphotos.baidu.com/image/pic/item/4e4a20a4462309f7e41f5cfe760e0cf3d6cad6ee.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '5'
},{
  username: '一一',
  avatar:'http://b.hiphotos.baidu.com/image/pic/item/9d82d158ccbf6c81b94575cfb93eb13533fa40a2.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '6'
},{
  username: '二二',
  avatar:'http://e.hiphotos.baidu.com/image/pic/item/4bed2e738bd4b31c1badd5a685d6277f9e2ff81e.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '7'
},{
  username: '三三',
  avatar:'http://g.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c87a3add4d52a6059252da61e.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '8'
},{
  username: '四四',
  avatar:'http://a.hiphotos.baidu.com/image/pic/item/f2deb48f8c5494ee5080c8142ff5e0fe99257e19.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '9'
},{
  username: '五五',
  avatar:'http://f.hiphotos.baidu.com/image/pic/item/4034970a304e251f503521f5a586c9177e3e53f9.jpg',
  firm:'上海博为峰股份技术有限公司',
  user_id: '10'
}]


export const currentUser:UserInfo = {
  username: 'is me',
  avatar: $r('app.media.JERRY'),
  firm:'上海博为峰股份技术有限公司',
  user_id: '11'
}