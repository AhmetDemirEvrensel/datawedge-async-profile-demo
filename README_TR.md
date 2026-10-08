# Asenkron Profil Hazırlık Demosu

[English README](README.md)

Bu bağımsız Flutter demosu, bir asenkron komutun `Future` sonucunun tamamlanması
ile harici sistemin gerçekten hazır olması arasındaki farkı gösterir.

> [!IMPORTANT]
> Bu proje Zebra DataWedge'e, Zebra cihazlarına veya herhangi bir şirket
> sistemine bağlanmaz. Yalnızca kontrollü bir asenkron servis simülasyonudur.

## İki yaklaşım

- **Yaklaşım A:** Komut `Future`'ı tamamlandığında profilin hazır olduğunu
  varsayar. Harici durumu sorgulamaz.
- **Yaklaşım B:** `Future` tamamlandıktan sonra aktif profili sınırlı sayıda
  sorgular ve hazır durumunu gözlemleyerek doğrular.

Kartlardaki hazır varsayımı, servis aktivasyonu, doğrulama ve zaman aşımı
süreleri çalışma sırasında gerçek bir `Stopwatch` ile ölçülür. Senaryo
değiştirildiğinde önceki sonuçlar ve timeline temizlenir.

## Çalıştırma

```bash
flutter pub get
flutter run -d chrome
```

## Test ve analiz

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

## Demo ekran görüntüleri

Türkçe arayüz için önerilen çıktılar:

- `docs/screenshots/1500ms-comparison-tr.png`
- `docs/screenshots/never-activates-timeout-tr.png`

## Teknik sınır

Testler yalnızca `FakeProfileService`, doğrulama politikası ve demo arayüzünün
davranışını doğrular. Gerçek DataWedge zamanlaması, Android broadcast teslimi,
tarayıcı hazırlığı veya gerçek Zebra profil yapılandırması hakkında kanıt
sunmaz.

## Medium makalesi

Makale bağlantısı: **Yakında eklenecek**
