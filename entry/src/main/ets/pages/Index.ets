import { common } from '@kit.AbilityKit';



@Entry
@Component
struct Index {
  private context: common.Context = AppStorage.get('context')!;
  pathStack: NavPathStack = new NavPathStack()
  build() {
    Navigation(this.pathStack) {
      Column({ space: 16 }) {
        Text('Nearby Eats')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding({ top: 12 })
        Row({ space: 12 }) {
          Button('Favorites')
            .onClick(() => {
              this.pathStack.pushPathByName('favoritesPage', null)
            })
            .fontSize(11)
            .borderRadius(12)
            .backgroundColor('#ff353535')
            .padding(8)
            .width('35%')
            .height(32)
          Button('Category')
            .onClick(() => {
              this.pathStack.pushPathByName('categoryPage', null)
            })
            .width('35%')
            .height(32)
            .fontSize(10)
            .borderRadius(12)
            .padding(8)
            .backgroundColor('#ff353535')
        }
      }
      .padding(16)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
  }
}