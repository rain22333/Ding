import { Header } from '../component/phoneBook/Header'
import {RenderItem,FirmTag} from "../component/Common"

@Entry
@Component
struct Phonebook {



  build() {

    Column(){
      //头部
      Header()

      Body()

    }.width("100%")
      .height("100%")
  }
}

export default Phonebook

@Component
struct Body {

  build() {
    Scroll() {
      Column() {
        Column() {
          RenderItem($r('app.media.my_friend'), "我的好友", "","pages/Connect")
          Divider()
          RenderItem($r('app.media.Refer_friend'), "好友推荐")
          Divider()
          RenderItem($r('app.media.dynamic'), "动态")
        }
        .borderRadius(12)
        .width("95%")
        .margin(15)
        .backgroundColor("#fff")
        .padding({ left: 10, right: 10 })

        Firm()

        // 企业内
        Column() {
          Text("企业内")
            .width("100%")
            .fontSize(12)
            .fontColor($r('app.color.text_gray'))
            .textAlign(TextAlign.Start)

          RenderItem($r('app.media.sxy'), "上下游")
        }
        .borderRadius(12)
        .width("95%")
        .margin(15)
        .backgroundColor("#fff")
        .padding(10)

        // 企业服务
        Column() {
          Text("企业服务")
            .width("100%")
            .fontSize(12)
            .fontColor($r('app.color.text_gray'))
            .textAlign(TextAlign.Start)

          RenderItem($r('app.media.ping'), "钉钉职聘")
          RenderItem($r('app.media.qy'), "钉企知")
          RenderItem($r('app.media.sc'), "服务窗")
          RenderItem($r('app.media.more'), "更多","客户管理等")
        }
        .borderRadius(12)
        .width("95%")
        .margin(15)
        .backgroundColor("#fff")
        .padding(10)

      }.width("100%")
      .backgroundColor('#f3f4f5')


    }.edgeEffect(EdgeEffect.Spring)
    .friction(0.6)
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }
}


@Component
struct Firm{
  build() {
    Column(){
      Text("企业内")
        .width("100%")
        .fontColor($r('app.color.text_gray'))
        .fontSize(13)
        .textAlign(TextAlign.Start)


      Row(){
        // 公司logo
        Image($r('app.media.bwf')).width(55)

        // 公司详细信息
        Column({space:10}){
          // 公司名称
          Row(){
            Text("博为峰股份")
            Image($r('app.media.safe')).width(15)
            Image($r('app.media.back_right')).width(10)
          }

          //公司标签
          Row({space:5}){
            FirmTag("年检认证",$r('app.media.v'))
            FirmTag("专业版",$r('app.media.masonry'))
            FirmTag("933",$r('app.media.data'))
          }
        }.layoutWeight(3)
        .alignItems(HorizontalAlign.Start)
        .margin({left:10})

        // 邀请按钮
        Text("邀请").padding({left:15,right:15,top:5,bottom:5}).border({width:0.5,color:'#ccc'}).borderRadius(3)
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({top:10})


      Row({space:15}){
        Image($r('app.media.l')).width(8).margin({left:25})
        Text("组织架构").margin({left:25}).fontWeight(7)
      }.width("100%")
      .margin({top:15})

      Row({space:15}){
        Image($r('app.media.l')).width(8).margin({left:25})
        Text("AI 助手").margin({left:25}).fontWeight(7)
      }.width("100%")
      .margin({top:15})

    }.width("95%")
      .backgroundColor('#fff')
      .padding(10)
      .borderRadius(12)
  }
}