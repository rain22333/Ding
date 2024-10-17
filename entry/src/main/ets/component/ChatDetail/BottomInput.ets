import { VoiceRecordEnum } from '../../models/voice'
import VoiceInput from './VoiceInput'
import { display, promptAction } from '@kit.ArkUI'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import { bundleManager, common } from '@kit.AbilityKit'
import { AudioCapturer } from '../../utils/AudioCapturer'
import { FileOperate } from '../../utils/FileOperate'
import { currentUser, UserInfo } from '../../models/users'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { PopupItem } from '../../models/PopupItem'
import { camera, cameraPicker } from '@kit.CameraKit'
import { fileIo, picker } from '@kit.CoreFileKit'
import Location from '../Location'
import { VoiceTransfer } from '../../utils/VoiceTransfer'

@Preview
@Component
struct BottomInput {

  @Require
  @Prop
  talker:UserInfo
  //新建一个发送语音信息的方法
  sendAudioMessage: (mess: MessageInfoModel) => void = () => {}

  // 定义状态控制
  @State
  showVoice: boolean = false      // 是否发送语音

  @State
  filePath: string = ''


  @State
  content : string = '' // 输入内容
  sendTextMessage:(content: string) => void = () => {}  // 发送消息

  // 发送语音消息
  sendVoiceMessage: (message: MessageInfoModel) => void = () => {
  }

  @State
  showVoiceComp: boolean = false // 是否显示发送语音组件

  tempAudioPath: string = "" // 临时录音变量

  @State
  showLocation: boolean = false

  @State
  currentAddress: string = ''

  @Provide
  transText: string = ''

  // 地图
  @Builder
  getLocationContent() {
    Stack({ alignContent: Alignment.Top }) {
      Location({currentAddress: $currentAddress})
      Row () {
        Text("取消")
          .fontColor($r("app.color.text_second"))
          .fontWeight(FontWeight.Bold)
        Button("发送")
          .type(ButtonType.Normal)
          .borderRadius(4)
          .backgroundColor($r("app.color.popup_back"))
          .fontColor($r("app.color.white"))
          .height(30)
          .width(60)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 20,
        right: 20
      })
      .width('100%')
      .height(60)
      .margin({
        top: 50
      })
    }
    .width('100%')
  }

  @State
  bottomList: PopupItem[] = [{
    icon: $r('app.media.photo'),
    title: '相册',
    itemClick:()=>{
      this.sendPhoto()
    }
  }, {
    icon: $r('app.media.carema'),
    title: '拍摄',
    itemClick: ()=>{
      this.openCamera()
    }

  }, {
    icon: $r('app.media.gps'),
    title: '位置',
    itemClick: ()=>{
      this.showLocation = true
    }
  }, {
    icon: $r('app.media.DING'),
    title: 'DING',
  }, {
    icon: $r('app.media.doc'),
    title: '钉钉文档',
  }, {
    icon: $r('app.media.check_in'),
    title: '签到',
  }, {
    icon: $r('app.media.file'),
    title: '文件',
  }, {
    icon: $r('app.media.schedule'),
    title: '日程',
  }
  ]

  @State
  showBottomCard: boolean = false // 显示底部

  // 开始收集声音
  beginCollectVoice() {
    this.tempAudioPath = FileOperate.createAudioFile(this.talker.user_id)
    this.startTime()
    AudioCapturer.start(this.tempAudioPath) // 开始录音
  }

  // 停止语音收集
  stopCollectVoice () {
    AudioCapturer.stop()
    this.endTime()
  }

  // 手势检测：到底是否存录音
  releaseFinger() {
    // 先关闭发语音的弹层和停止录音
    this.showVoiceComp = false
    this.stopCollectVoice()
    if (this.voiceState === VoiceRecordEnum.Cancel) {
      //   取消：先删除文件
      FileOperate.delFilePath(this.filePath)
      this.duration = 0
    } else if (this.voiceState === VoiceRecordEnum.Transfer) {
      // 如果是转化文本类
      if(this.transText){
        this.sendTextMessage(this.transText)
      }
      //   转文字
      this.transText = ''
      this.duration = 0

    } else if (this.voiceState === VoiceRecordEnum.RecordIng) {
      //   录制
      if (this.duration < 1) {
        promptAction.showToast({
          message: '录制时间过短'
        })
        FileOperate.delFilePath(this.filePath)
        return
      }
      // 生成语音消息
      let message = new MessageInfoModel({
        sendUser: currentUser,
        connectUser: this.talker,
        messageContent: `[语音] ${this.duration}"`,
        messageType: MessageTypeEnum.AUDIO,
        sourceFilePath: this.filePath,
        sourceDuration: this.duration
      } as MessageInfo)
      this.sendAudioMessage(message)
      //清空数据
      this.filePath = ''
      this.duration = 0
    }
    // 将状态恢复至默认状态
    this.voiceState = VoiceRecordEnum.RecordIng
  }

  // 计算计时器
  duration: number = 0 // 秒

  timer: number = -1 // 定时器标记
  // 开始计时
  startTime() {
    this.timer = setInterval(() => {
      this.duration++
      promptAction.showToast({
        message:`当前语音:${this.duration}秒`
      })
    }, 1000)
  }

  // 结束计时
  endTime() {
    clearInterval(this.timer)
  }

  @Builder
  getVoiceCom(){
    // Builder函数不能在根组件直接使用自定义组件
    Column(){
      VoiceInput()
    }
  }

  @Builder
  getBottomCard(item: PopupItem) {
    Column() {
      Column() {
        Image(item.icon)
          .width(30)
          .height(30)
          .fillColor("#4c4c4c")
      }
      .backgroundColor(Color.White)
      .width(56)
      .aspectRatio(1)
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(item.title)
        .fontSize(12)
        .fontColor($r('app.color.text_second'))
        .margin({
          top: 10
        })
    }.layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      item.itemClick && item.itemClick()
    })
  }

  @Provide
  voiceState: VoiceRecordEnum = VoiceRecordEnum.RecordIng // 当前的状态
  screenWidth: number = 0 // 记录整体宽度
  screenHeight: number = 0 // 记录整体高度

  // 发送图片消息
  sendImageMessage: (messageList: MessageInfoModel[]) => void = () => {
  }

  // 发送照片
  async sendPhoto() {
    const photo = new picker.PhotoViewPicker()
    const result = await photo.select({
      maxSelectNumber: 9,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (result.photoUris.length) {
      //选中的图拷贝到沙箱
      let imgList: MessageInfoModel[] = []
      result.photoUris.forEach((item) => {
        // 拷贝到沙箱-----START
        const file = fileIo.openSync(item, fileIo.OpenMode.READ_ONLY)
        // 没有目录创建文件是由问题：可以再fileIo新增createImgFile
        let newFileName = getContext().filesDir + '/' + Date.now() + '.jpg'
        fileIo.copyFileSync(file.fd, newFileName)
        // 拷贝到沙箱-----END
        const newMessage = new MessageInfoModel({
          sendUser: currentUser,
          connectUser: this.talker,
          messageContent: '[图片]',
          messageType: MessageTypeEnum.IMAGE,
          sourceFilePath: newFileName
        } as MessageInfo)
        imgList.push(newMessage)
        fileIo.closeSync(file.fd)
      })
      this.sendImageMessage(imgList)
      this.showBottomCard = false
    }
  }

  // 打开相机
  async openCamera() {
    try {
      let pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      }
      let pickerResult = await cameraPicker.pick(getContext(), [
        cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO
      ], pickerProfile)
      promptAction.showDialog({
        message: JSON.stringify(pickerResult)
      })
      if (pickerResult.resultUri !== '' && pickerResult.mediaType === 'photo') {
        const newFileName = getContext().filesDir + '/' + Date.now() + '.jpg'
        const file = fileIo.openSync(pickerResult.resultUri, fileIo.OpenMode.READ_ONLY)
        fileIo.copyFileSync(file.fd, newFileName)
        const newMessage = new MessageInfoModel({
          sendUser: currentUser,
          connectUser: this.talker,
          messageContent: '[图片]',
          messageType: MessageTypeEnum.IMAGE,
          sourceFilePath: newFileName
        } as MessageInfo)
        this.sendImageMessage([newMessage])
      } else if (pickerResult.resultUri !== '' && pickerResult.mediaType === 'video') {
        const newFileName = getContext().filesDir + '/' + Date.now() + '.mp4'
        const file = fileIo.openSync(pickerResult.resultUri, fileIo.OpenMode.READ_ONLY)
        fileIo.copyFileSync(file.fd, newFileName)
        const newMessage = new MessageInfoModel({
          sendUser: currentUser,
          connectUser: this.talker,
          messageContent: '[视频]',
          messageType: MessageTypeEnum.VIDEO,
          sourceFilePath: newFileName
        } as MessageInfo)
        this.sendImageMessage([newMessage])
      }
    } catch (err) {
      promptAction.showToast({
        message: '相机打开失败'
      })
    }
  }

  aboutToAppear(): void {
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width)
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height)

    AudioCapturer.init()
  }
  aboutToDisappear(): void {
    AudioCapturer.release()
  }

  // 检查权限
  async checkPermission() {
    try {
      const manager = abilityAccessCtrl.createAtManager() // 创建程序控制管理器
      // 获取应用信息
      const buildInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const status = manager.checkAccessTokenSync(buildInfo.appInfo?.accessTokenId, "ohos.permission.MICROPHONE")
      if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        // 不被允许，跳转应用设置
        const context = getContext() as common.UIAbilityContext
        context.startAbility({
          bundleName: 'com.huawei.hmos.settings',
          abilityName: 'com.huawei.hmos.settings.MainAbility',
          uri: "application_info_entry",
          parameters: {
            pushParams: buildInfo.name
          }
        })
      }else {
        this.showVoiceComp = true
        //   开始录音
        this.beginCollectVoice()
      }

    } catch (error) {

    }
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        // 根据状态控制图标并切换
        Image(this.showVoice ? $r('app.media.keyWorld') : $r("app.media.mic"))
          .width(25)
          .height(25)
          .onClick(()=>{
            this.showVoice = !this.showVoice

            // 语音时不展示折叠
            if(this.showVoice){
              animateTo({duration : 100},()=>{
                this.showBottomCard = false
              })
            }
          })

        // 根据状态控制发送语音的按钮和输入框
        if(this.showVoice){
          Button("按住 说话",{type: ButtonType.Normal})
            .backgroundColor(Color.White)
            .layoutWeight(1)
            .borderRadius(5)
            .fontColor(Color.Black)
            .align(Alignment.Center)
            .gesture(
              GestureGroup(GestureMode.Parallel,
                // 长按手势
                LongPressGesture()
                  .onAction(() => {
                    // this.showVoiceCom = true
                    // 检查是否有权限后再进入录音
                    this.checkPermission()
                  })
                  .onActionEnd(() => {
                    // this.showVoiceCom = false
                    // this.voiceState = VoiceRecordEnum.RecordIng
                    this.releaseFinger()
                  }),
                // 拖动手势
                PanGesture()
                  .onActionUpdate((event) => {
                    if (event.fingerList[0].globalY > this.screenHeight - 120) {
                      //   录制
                      this.voiceState = VoiceRecordEnum.RecordIng
                    } else {
                      if (event.fingerList[0].globalX > this.screenWidth / 2) {
                        //   转文字
                        this.voiceState = VoiceRecordEnum.Transfer
                        //   调用方法
                        VoiceTransfer.voiceToText(this.filePath,(result)=>{
                          this.transText = result.result
                        })

                      } else {
                        //   取消
                        this.voiceState = VoiceRecordEnum.Cancel
                      }
                    }

                  })
                  .onActionEnd(() => {
                    //     回到默认状态
                    this.voiceState = VoiceRecordEnum.RecordIng
                  })
              )

            )
            .bindContentCover($$this.showVoiceComp, this.getVoiceCom,{
              modalTransition: ModalTransition.NONE
            })

        }else {
          TextInput({placeholder:"发送加密消息",text: $$this.content})
            .height(35)
            .layoutWeight(1)
            .borderRadius(5)
            .backgroundColor(Color.White)
            .backgroundImage($r('app.media.good'))
            .backgroundImageSize({width:25})
            .backgroundImagePosition({x:'85%',y:"15%"})
            .id("input")
            .onSubmit(() => {
              if(this.content) {
                this.sendTextMessage(this.content)
                this.content = "" // 设置为空
                focusControl.requestFocus("input")
              }
            })
            .onClick(()=>{
              animateTo({duration:150},()=>{
                this.showBottomCard = false
              })
            })
        }

        Image($r('app.media.face'))
          .width(22)
          .height(22)
        Image($r('app.media.add1'))
          .width(25)
          .height(25)
          .onClick(()=>{
            animateTo({duration:150},()=>{
              this.showBottomCard = !this.showBottomCard
            })
          })
      }
      .height(60)
      .width('100%')
      .padding({
        left: 10,
        right: 10
      })
      .bindContentCover($$this.showLocation,this.getLocationContent())


      if (this.showBottomCard) {
        // 底部结构
        GridRow({ columns: 4 }) {
          ForEach(this.bottomList, (item: PopupItem) => {
            GridCol() {
              this.getBottomCard(item)
            }.height(100)
          })
        }
        .width('100%')
      }

    }
    .backgroundColor($r('app.color.second_back_color'))
  }
}

export default BottomInput

