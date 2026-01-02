import { loadFavorites, saveFavorites } from '../utils/FavoritesStore'
import { calcDistance } from '../utils/LocationUtils'
import { geoLocationManager } from '@kit.LocationKit'
import { ArcList, ArcListItem, LengthMetrics, ArcListAttribute } from '@kit.ArkUI'

interface Restaurant {
  id: string
  name: string
  category: string
  rating: number
  description: string
  isOpen: boolean
  latitude: number
  longitude: number
  cuisines: string[]
  priceLevel: number
  openingHours: string
  isFavorite: boolean
}

@Builder
export function FavoritesPageBuilder() {
  FavoritesPage()
}

@Component
export struct FavoritesPage {
  private context: Context = AppStorage.get('context') as Context
  pathStack: NavPathStack = new NavPathStack()

  @State favorites: Restaurant[] = []
  @State userLat: number = 0
  @State userLon: number = 0

  getDistance(r: Restaurant): string {
    const d = calcDistance(
      this.userLat,
      this.userLon,
      r.latitude,
      r.longitude
    )
    return d < 1000 ? `${Math.round(d)} m` : `${(d / 1000).toFixed(1)} km`
  }

  async removeFavorite(id: string) {
    this.favorites = this.favorites.filter(r => r.id !== id)
    await saveFavorites(this.context, this.favorites)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Text('❤️ Favorites')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        this.RenderContent()
      }
      .padding(16)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
    .onReady(async (context: NavDestinationContext) => {
      this.pathStack = context.pathStack

      this.favorites = await loadFavorites(this.context)

      let request: geoLocationManager.ContinuousLocationRequest = {
        interval: 1000,
        locationScenario: geoLocationManager.UserActivityScenario.NAVIGATION
      }

      geoLocationManager.on('locationChange', request, (location) => {
        this.userLat = location.latitude
        this.userLon = location.longitude
      })
    })
  }

  @Builder
  RenderContent() {
    if (this.favorites.length === 0) {
      this.EmptyState()
    } else {
      this.FavoritesList()
    }
  }

  @Builder
  EmptyState() {
    Text('No favorites yet')
      .fontSize(14)
      .fontColor('#999')
      .margin({ top: 32 })
  }

  @Builder
  FavoritesList() {
    ArcList() {
    ForEach(
      this.favorites,
      (item: Restaurant) => {
        ArcListItem() {
          this.FavoriteCard(item)
        }
      },
      (item: Restaurant) => item.id
    )
    } .scrollBar(BarState.Off)
    .space(LengthMetrics.px(50))
    .height(150)
  }

  @Builder
  FavoriteCard(item: Restaurant) {
    Column({ space: 6 }) {
      Row() {
        Text(item.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
        Text('❤️')
          .fontSize(14)
          .onClick(() => this.removeFavorite(item.id))
      }

      Row() {
        Text(item.isOpen ? 'OPEN' : 'CLOSED')
          .fontSize(10)
          .fontColor(item.isOpen ? '#4CAF50' : '#F44336')
        Text(` 📍${this.getDistance(item)}`)
          .fontSize(10)
          .fontColor('#ccc')
      }

      Text(item.description)
        .fontSize(10)
        .fontColor('#aaa')
        .maxLines(1)
      Text(`⭐ ${item.rating}`)
        .fontSize(10)
    }
    .padding(12)
    .width('90%')
    .backgroundColor('#2a2a2a')
    .borderRadius(16)
    .onClick(() => {
      this.pathStack.pushPathByName(
        'restaurantDetailsPage',
        item
      )
    })
  }
}
