import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { PopupItem } from '../../models/PopupItem'
import { currentUser } from '../../models/users'
import { AudioRender } from '../../utils/AudioRender'
import { FileOperate } from '../../utils/FileOperate'
import { StoreClass } from '../../utils/store'
import { VoiceTransfer } from '../../utils/VoiceTransfer'

@Preview
@Component
struct Message {
  @Prop
  currentMessage: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
  @State
  audioState: AnimationStatus = AnimationStatus.Initial
  @State
  showPopup: boolean = false // 是否显示浮层
  //接收
  delMessage: (messageId: string) => void = () => {
  }

  @State
  transferResult:string = ''
  // 浮层数据
  @State
  popupList: PopupItem[] = [{
    title: '听筒播放',
    icon: $r("app.media.ears")
  },
    {
      title: '回复',
      icon: $r("app.media.Reply")
    }, {
      title: '稍后处理',
      icon: $r("app.media.Later")
    }, {
      title: '转文字',
      icon: $r("app.media.toText"),
      itemClick: ()=>{
        if(this.currentMessage.messageType === MessageTypeEnum.AUDIO){
          VoiceTransfer.voiceToText(this.currentMessage.sourceFilePath,(res)=> {
            this.transferResult = res.result
          })
        }
        this.showPopup = false
      }
    }, {
      title: '删除',
      icon: $r("app.media.del"),
      itemClick: async () => {

        if (this.currentMessage.sourceFilePath) {
          FileOperate.delFilePath(this.currentMessage.sourceFilePath)
        }

        await StoreClass.removeChatMessage(this.currentMessage.connectUser.user_id, this.currentMessage.id)
        this.delMessage(this.currentMessage.id)
      }
    }, {
      title: '收藏',
      icon: $r("app.media.collection")
    }, {
      title: '多选',
      icon: $r("app.media.AllSelect")
    }]

  @Builder
  getContent() {
    GridRow({ columns: 5 }) {
      ForEach(this.popupList, (item: PopupItem) => {
        GridCol() {
          Column({ space: 6 }) {
            Image(item.icon)
              .fillColor($r("app.color.white"))
              .width(18)
              .height(18)
            Text(item.title)
              .fontColor($r("app.color.white"))
              .fontSize(14)
          }
          .height(60)
        }
        .onClick(() => {
          item.itemClick && item.itemClick() // 如果点击事件存在 就触发
        })
      })
    }
    .width(300)
    .padding({
      top: 15,
      left: 10
    })
  }

  // 获取文本消息
  @Builder
  getTextContent() {
    Text(this.currentMessage.messageContent)// 判断是否是自己来设置背景色
      .backgroundColor(
        currentUser.user_id === this.currentMessage.sendUser.user_id ?
        $r('app.color.second_primary') : $r('app.color.white')
      )
      .fontColor($r('app.color.text_primary'))
      .padding(10)// .lineHeight(24)
      .margin({
        left: 10,
        right: 10
      })
      .borderRadius(5)
  }


  // 预览图片
  previewImage: () => void = () => {}
  // 视频消息
  videoController:VideoController = new VideoController()
  @Builder
  getVideoContent(){
    Column(){
      Stack(){
        Video({
          src:'file://'+this.currentMessage.sourceFilePath,
          controller:this.videoController
        })
          .controls(false)
          .width(100)
          .height(150)
          .borderRadius(4)
          .id(this.currentMessage.id)
          .onPrepared(()=>{
            this.videoController.setCurrentTime(0.1)
          })
        Image($r('app.media.video_call'))
          .width(30)
          .height(30)
          .fillColor($r('app.color.back_color'))
      }
    }.margin({
      left:10,
      right:10
    })
    .onClick(()=>{
      this.previewImage()
    })
  }



  // 获取图片显示
  @Builder
  getImageContent() {
    Column() {
      Image("file://" + this.currentMessage.sourceFilePath)
        .borderRadius(4)
        .width('100%')
        .enabled(false)
    }
    .width('40%')
    .margin({
      left: 10,
      right: 10
    }).onClick(() => {
      this.previewImage()
    })
  }

  // 获取语音宽度
  getAudioWidth() {
    let minWidth: number = 20
    let maxWidth: number = 90
    let calWidth: number = minWidth + (100 * this.currentMessage.sourceDuration / 60)
    if (calWidth > maxWidth) {
      return maxWidth + "%"
    }
    return calWidth + "%"
  }

  // 获取语音消息
  @Builder
  getAudioContent() {

    Column({space:10}){
      Row({ space: 5 }) {

        ImageAnimator()
          .images([
            {
              src: $r('app.media.ic_public_voice3')
            },
            {
              src: $r('app.media.ic_public_voice1')
            },
            {
              src: $r('app.media.ic_public_voice2')
            },
            {
              src: $r('app.media.ic_public_voice3')
            }
          ])
          .iterations(-1)
          .state(this.audioState)
          .duration(300)
          .fillMode(FillMode.None)
          .width(20)
          .height(20)
          .rotate({
            angle: currentUser.user_id === this.currentMessage.sendUser.user_id ? 180 : 0
          })

        Text(`${this.currentMessage.sourceDuration}`)
          .textAlign(TextAlign.Center)

      }
      .width(this.getAudioWidth())
      .backgroundColor(currentUser.user_id === this.currentMessage.sendUser.user_id ? $r('app.color.ding_primary') :
      $r('app.color.white'))
      .justifyContent(currentUser.user_id === this.currentMessage.sendUser.user_id ? FlexAlign.End : FlexAlign.Start)
      .height(40)
      .padding({
        left: 10,
        right: 10
      })
      .margin({
        left: 10,
        right: 10
      })
      .borderRadius(4)
      .direction(currentUser.user_id === this.currentMessage.sendUser.user_id ? Direction.Ltr : Direction.Rtl)
      .onClick(() => {
        AudioRender.start(this.currentMessage.sourceFilePath, () => {
          this.audioState = AnimationStatus.Running
        }, () => {
          this.audioState = AnimationStatus.Stopped
        })
      })
      // 添加条件渲染
      if(this.transferResult){
        Text(this.transferResult)
          .backgroundColor(currentUser.user_id === this.currentMessage.sendUser.user_id ?
          $r('app.color.second_primary') : $r('app.color.white'))
          .fontColor($r('app.color.text_primary'))
          .padding(10)
          .lineHeight(24)
          .margin({
            left: 10,
            right: 10
          })
          .borderRadius(5)
      }
    }.alignItems(currentUser.user_id === this.currentMessage.sendUser.user_id ? HorizontalAlign.End : HorizontalAlign.Start)


  }

  build() {
    Row() {
      Image(this.currentMessage.sendUser.avatar)
        .height(40)
        .width(40)
        .borderRadius(6)
      Row() {
        Column() {
          if (this.currentMessage.messageType === MessageTypeEnum.TEXT) {
            this.getTextContent()
          } else if (this.currentMessage.messageType === MessageTypeEnum.AUDIO) {
            this.getAudioContent()
          }else if(this.currentMessage.messageType === MessageTypeEnum.IMAGE){
            // 图片消息
            this.getImageContent()
          }else if(this.currentMessage.messageType === MessageTypeEnum.VIDEO){
            // 视频消息

          }
        }
        .bindPopup(this.showPopup, {
          builder: this.getContent(),
          popupColor: $r('app.color.popup_back'),
          // 背景失焦样式控制
          backgroundBlurStyle: BlurStyle.NONE,
          onStateChange: (event) => {
            // 手指点击其他位置进行关闭
            this.showPopup = event.isVisible
          }
        })
      }.layoutWeight(6)
      .justifyContent(currentUser.user_id === this.currentMessage?.sendUser?.user_id ? FlexAlign.End : FlexAlign.Start)

      Text().layoutWeight(1)
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20
    })
    .alignItems(VerticalAlign.Top)
    .direction(currentUser.user_id === this.currentMessage?.sendUser?.user_id ? Direction.Rtl : Direction.Ltr)
    .gesture(LongPressGesture()
      .onAction(() => {
        this.showPopup = true
      }))
  }
}


export default Message