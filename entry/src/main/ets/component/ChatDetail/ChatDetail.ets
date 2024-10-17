import { promptAction, router } from '@kit.ArkUI'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { currentUser, UserInfo } from '../../models/users'
import { AudioRender } from '../../utils/AudioRender'
import { AVPlayerClass } from '../../utils/AVPlayerClass'
import { requestMessage } from '../../utils/request'
import { StoreClass } from '../../utils/store'
import PreviewImage from '../PreviewImage'
import BottomInput from './BottomInput'
import Message from './Message'
import { camera, cameraPicker } from '@kit.CameraKit'

@Entry
@Component
struct ChatDetail {


  // 记录要预览的图片
  previewType:MessageTypeEnum = MessageTypeEnum.IMAGE
  previewUrl: ResourceStr = ''
  previewController: CustomDialogController = new CustomDialogController({
    builder: PreviewImage({
      url: this.previewUrl,
      type:this.previewType
    }),
    autoCancel: false,
    customStyle: true
  })


  // 当正在响应时，显示对方正在输入
  @State
  talkerInputIng: boolean = false // 对方正在输入


  @State
  talker:UserInfo = {} as UserInfo
  aboutToAppear(): void {
    this.talker = router.getParams() as UserInfo

    this.talker = router.getParams() as UserInfo;
    this.messageList = StoreClass.getChatMessage(this.talker.user_id); // 加载历史消息

    AudioRender.init()

  }



  @State
  messageList: MessageInfoModel[] = []


  // 发送文本消息
  async sendTextMessage(content: string) {
    let message = new MessageInfoModel({
      messageContent: content,
      sendUser: currentUser,
      connectUser: this.talker,
    } as MessageInfo)
    this.messageList.push(message) // 添加到信息的底部
    AVPlayerClass.play("send")
    await StoreClass.addChatMessage(this.talker.user_id,message)  // 将消息存入首选项
    this.scroller.scrollEdge(Edge.Bottom)
    this.getResponseMessage(content)
  }
  // 获取响应消息
  async getResponseMessage(content:string){
    this.talkerInputIng = true
    const result = await requestMessage(content)
    let message = new MessageInfoModel({
      messageContent: result.data?.info?.text,
      sendUser: this.talker,
      connectUser: this.talker,
    } as MessageInfo)
    this.messageList.push(message) // 添加到信息的底部
    AVPlayerClass.play('information')
    await StoreClass.addChatMessage(this.talker.user_id,message)    // 存入首选项
    this.scroller.scrollEdge(Edge.Bottom)
    this.talkerInputIng = false
  }



  delMessage(messageId:string){
    let index = this.messageList.findIndex(message=>message.id===messageId)
    this.messageList.splice(index,1)
  }


  // 发送语音消息
  async sendAudioMessage (message: MessageInfoModel) {
    this.messageList.push(message) // 添加到信息的底部
    this.scroller.scrollEdge(Edge.Bottom) // 滚动到最底部
    AVPlayerClass.play('send')
    StoreClass.addChatMessage(this.talker.user_id,message) // 添加到聊天记录
  }


  // 发送图片消息
  async sendImageMessage(messageList: MessageInfoModel[]) {
    // 鸿蒙中只能对数组使用展开运算符
    // Array.isArray()
    this.messageList.push(...messageList)
    this.scroller.scrollEdge(Edge.Bottom)
    messageList.forEach((message) => {
      StoreClass.addChatMessage(this.talker.user_id, message)
    })
    AVPlayerClass.play('send')
  }



  // 创建滚动条对象
  scroller : Scroller = new Scroller()

  build() {
    Column() {
      Row() {
        Image($r('app.media.back_left'))
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back()
          })

        if(this.talkerInputIng){
          Text("对方正在输入").layoutWeight(1).textAlign(TextAlign.Center)
        }else {
          Row(){
            Text(this.talker.username)
              .textAlign(TextAlign.Center)
              .fontColor($r('app.color.text_primary'))
            Image($r('app.media.greet_safe')).width(15)
          }.layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }

        Image($r('app.media.video_call')).width(25).margin({right:10})
        Image($r('app.media.more1')).width(25)
      }
      .width("100%")
      .padding({
        left: 10,
        right: 10
      })
      .justifyContent(FlexAlign.Center)


      // 放置消息组件
      // 放置消息组件
      List({ space: 20 ,scroller : this.scroller}) {
        ForEach(this.messageList, (item: MessageInfoModel) => {
          ListItem() {
            //传入
            Message({
              currentMessage: item,
              delMessage:(message)=>{
                this.delMessage(message)
              },
              previewImage: ()=>{
                this.previewUrl = "file://" + item.sourceFilePath
                this.previewType = item.messageType
                this.previewController.open()
              }
            })
          }
        })
      }
      .layoutWeight(1)
      .width('100%')
      .padding({
        top: 20,
      })
      .backgroundColor($r('app.color.back_color'))

      BottomInput({
        talker: this.talker,
        sendTextMessage: (content: string) => {
          this.sendTextMessage(content)
        },
        sendAudioMessage:(message)=>{
          this.sendAudioMessage(message)
        },
        sendImageMessage:(list)=>{
          this.sendImageMessage(list)
        }
      })

    }.height("100%")
  }
}
