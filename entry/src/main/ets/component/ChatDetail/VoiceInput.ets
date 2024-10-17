import { VoiceRecordEnum } from '../../models/voice'


@Preview
@Component
struct VoiceInput {
  @Consume
  voiceState: VoiceRecordEnum

  @Consume
  transText: string

  @Builder
  getDisplayContent () {
    if(this.voiceState === VoiceRecordEnum.Cancel) {
      Row()
        .height(60)
        .width(80)
        .borderRadius(20)
        .backgroundColor($r('app.color.danger'))
        .margin({
          left: 25
        })
    }
    if(this.voiceState === VoiceRecordEnum.RecordIng) {
      Row()
        .height(60)
        .width(120)
        .borderRadius(20)
        .backgroundColor($r('app.color.ding_primary'))
    }

    if(this.voiceState === VoiceRecordEnum.Transfer) {
      Row(){
        Text(this.transText)
          .fontSize(20)
          .fontColor($r('app.color.primary'))
      }
        .height(100)
        .width(200)
        .borderRadius(20)
        .backgroundColor($r('app.color.ding_primary'))
    }
  }


  build() {

    Column(){
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          this.getDisplayContent()
        }.height('100%')
        .width('100%')
        .alignItems(this.voiceState === VoiceRecordEnum.Cancel ? HorizontalAlign.Start : HorizontalAlign.Center)
        .padding({top : 20})

        // 底部内容
        Column() {
          Row() {
            // 左侧内容   取消  ×
            Row() {
              Image($r('app.media.cancel'))
                .width(30)
                .height(30)
                .fillColor(this.voiceState === VoiceRecordEnum.Cancel ? $r('app.color.text_primary') : $r('app.color.voice_round_font_color'))

            }
            .backgroundColor( this.voiceState === VoiceRecordEnum.Cancel ? $r('app.color.bottom_color') : '#f3f4f5')
            .width(70)
            .height(70)
            .borderRadius(35)
            .justifyContent(FlexAlign.Center)
            .scale({
              x: this.voiceState === VoiceRecordEnum.Cancel ? 1.2 : 1,
              y: this.voiceState === VoiceRecordEnum.Cancel ? 1.2 : 1
            })

            // 右侧内容  文字
            Row() {
              Text("文")
                .textAlign(TextAlign.Center)
                .fontSize(24)
                .fontColor(this.voiceState === VoiceRecordEnum.Transfer ? $r('app.color.text_primary') :
                $r('app.color.voice_round_font_color'))
            }.width(70)
            .aspectRatio(1)
            .borderRadius(35)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.voiceState === VoiceRecordEnum.Transfer ? $r("app.color.bottom_color") : '#f3f4f5')
            .scale({
              x: this.voiceState === VoiceRecordEnum.Transfer ? 1.2 : 1,
              y: this.voiceState === VoiceRecordEnum.Transfer ? 1.2 : 1
            })
          }.width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: 40,
            right: 40
          })
          // .margin({
          //   bottom: 30
          // })
          Stack() {
              // Image($r("app.media.lock"))
              //   .width(50)
              //   .height(50)
              //   .margin({bottom:100})
              //   .scale({
              //     x: this.voiceState === VoiceRecordEnum.RecordIng ? 1.1 : 1
              //   })
            Image($r("app.media.speak"))
              .width(50)
              .height(50)
              .margin({
                bottom: 10
              })
              .scale({
                x: this.voiceState === VoiceRecordEnum.RecordIng ? 1.2 : 1
              })
              // .fillColor(this.voiceState === VoiceRecordEnum.RecordIng ? $r("app.color.bottom_voice_color") : $r('app.color.bottom_color'))
          }
          .width('100%')
        }
      }
      .height('30%')
      .backgroundColor(Color.White)

    }.height("100%")
    .justifyContent(FlexAlign.End)


  }
}

export default VoiceInput