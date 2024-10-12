import { FirmTag, RenderItem } from '../component/Common'

@Styles
function RenderItemStyle() {
  .width("95%")
  .borderRadius(5)
  .backgroundColor('#fff')
  .margin({ top: 15 })
}


@Entry
@Component
export default struct My {
  build() {
    Scroll() {

      Column() {
        Header()

        Row() {
          RenderItem($r('app.media.vip_tag'), "365会员", "未开通")
        }.RenderItemStyle()

        Row() {
          RenderItem($r('app.media.gift'), "权益", "18积分待领取")
        }.RenderItemStyle()

        Column() {
          RenderItem($r('app.media.dynamic'), "我的动态")
          Divider().width("95%")
          RenderItem($r('app.media.pay'), "钱包(支付宝)")
          Divider().width("95%")
          RenderItem($r('app.media.dir'), "收藏",)
        }.RenderItemStyle()

        Column() {
          RenderItem($r('app.media.find'), "发现")
          Divider().width("95%")
          RenderItem($r('app.media.shopping'), "应用中心")
          Divider().width("95%")
          RenderItem($r('app.media.customer'), "客服与帮助",)
        }.RenderItemStyle()


        Row() {
          RenderItem($r('app.media.setting'), "设置与隐私")
        }.RenderItemStyle()
      }.width("100%")
      .backgroundColor('#F3F4F5')

    }
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
  }
}


@Component
struct Header {
  build() {
    Column() {

      // 头像、名字、二维码
      Row({ space: 10 }) {
        Image($r('app.media.JERRY'))
          .width("25%")
          .borderRadius(8)
          .position({ x: 10, y: -50 })
        Text("张三").fontSize(18).fontWeight(8).layoutWeight(1).margin({ left: "33%" })
        Image($r('app.media.QR'))
          .width(22)
          .padding(5)
          .border({ width: 0.5, color: "#ccc" })
          .borderRadius(3)
        Row() {
          Image($r('app.media.write')).width(15)
          Text("编辑资料")
            .fontSize(12)
            .fontColor('#ccc')
        }.padding(2)
        .border({ width: 0.5, color: "#CCC" })
      }
      .width("100%")
      .padding(10)


      // 公司名称
      Text("博为峰股份 >")
        .fontSize(15)
        .fontColor('#AAA')
        .width("100%")
        .margin({ top: 25, left: 15 })

      // 公司标签
      Row({ space: 10 }) {
        FirmTag("年检认证", $r('app.media.v'))
        FirmTag("专业版", $r('app.media.masonry'))
        FirmTag("933", $r('app.media.data'))
      }.width("100%")
      .margin({ top: 15, left: 15 })

      Divider().width("95%").margin({ top: 15 })

      Row() {
        Text("＋ 状态...").fontSize(15).fontColor('#ccc')
        Row({ space: 3 }) {
          Image($r('app.media.card')).width(15)
          Text("名片").fontSize(12).fontColor('#ccc')
        }.padding(3)
        .border({ width: 0.5, color: '#ccc' })
        .borderRadius(3)
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 20 })
      .padding({ left: 10, right: 10 })

    }
    .backgroundColor('#fff')
    .borderRadius(5)
    .padding(5)
    .width("95%")
    .height(200)
    .margin({ top: 60 })

  }
}