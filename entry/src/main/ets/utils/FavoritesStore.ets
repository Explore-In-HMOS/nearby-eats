import dataPreferences from '@ohos.data.preferences';

const PREFERENCES_FILE = 'favorites_prefs';

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

export async function loadFavorites(context: Context): Promise<Restaurant[]> {
  const prefs = await dataPreferences.getPreferences(context, PREFERENCES_FILE);
  const raw = await prefs.get('favorites', '[]') as string;
  return JSON.parse(raw) as Restaurant[];
}

export async function saveFavorites(context: Context, favorites: Restaurant[]) {
  const prefs = await dataPreferences.getPreferences(context, PREFERENCES_FILE);
  await prefs.put('favorites', JSON.stringify(favorites));
  await prefs.flush();
}