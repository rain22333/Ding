import {currentUser} from '../../models/users'

@Component
export struct Header{
  build() {
    Row(){
      Text(currentUser.firm).fontColor('#fff').fontSize(15).width("30%").maxLines(1)
      Image($r('app.media.add_friend_white')).width(25)
    }.width("100%")
      .height(50)
      .backgroundColor($r('app.color.backGroundColor_second'))
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
  }
}