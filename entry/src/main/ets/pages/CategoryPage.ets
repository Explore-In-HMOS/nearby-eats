
@Builder
export function CategoryPageBuilder() {
  CategoryPage()
}

interface categories {
  title: string;
  icon: string;
}

@Component
export struct CategoryPage {
  pathStack: NavPathStack = new NavPathStack()
  category: categories[] = [
    {title: 'Cafe', icon: '☕'},
    {title: 'Fast Food', icon: '🍕'},
    {title: 'Dessert', icon: '🍰'},
    {title: 'Street Food', icon: '🌯'}
  ]

  build() {
    NavDestination() {
      Column() {
        Text('Categories')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding({ top: 12 })

        Grid() {
          ForEach(this.category, (item: categories) => {
            GridItem() {
              Button(item.icon)
                .width(60)
                .height(60)
                .fontSize(18)
                .alignSelf(ItemAlign.Center)
                .backgroundColor('#ff353535')
                .onClick(() => {
                  this.pathStack.pushPathByName(
                    'restaurantPage',
                     item.title
                  )
                })
            }
          }, (item: string, index: number) => item)
        }
        .padding({top: 10})
        .width('100%')
        .height('100%')
        .columnsTemplate('repeat(2, 0.5fr)')
        .rowsTemplate('repeat(2, 0.35fr)')
      }
      .padding(16)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')

    }
    .hideBackButton(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
