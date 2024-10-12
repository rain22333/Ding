import { router } from '@kit.ArkUI'


/**
 * 企业标签
 */
@Builder
export function FirmTag(label: string, icon: Resource) {
  Row({ space: 3 }) {
    Image(icon).width(10)
    Text(label).fontSize(10).fontColor('#ccc')
  }
  .border({ width: 1, color: '#ccc' })
    .borderRadius(4)
    .padding(2)
}


/**
 * 复用组件，可传入需要跳转的url
 */
@Builder
export function RenderItem (img:ResourceStr,text: string,info?:string,url:string = "pages/Index" ) {
  Row({space:10}) {
    Image(img).width(30)
    Text(text)
      .fontSize(15)
      .fontWeight(8)
      .layoutWeight(2)
    Text(info)
      .fontSize(14)
      .fontWeight(8)
      .layoutWeight(3)
      .textAlign(TextAlign.End)
    Image($r("app.media.back_right"))
      .width(16)
      .height(16)
  }
  .onClick(()=>{
    router.push({url:url})
  })
  .padding({left:15,right:15})
  .width('100%')
  .height(60)
  .justifyContent(FlexAlign.SpaceBetween)
}
