// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Asenkron Profil Hazırlık Demosu';

  @override
  String get heroEyebrow => 'ASENKRON HAZIRLIK LABORATUVARI';

  @override
  String get heroTitle =>
      'Future\'ın tamamlanması, harici sistemin hazır olduğu anlamına gelmez.';

  @override
  String get heroDescription =>
      'İki yaklaşımı aynı simülasyon gecikmesiyle çalıştırın ve zaman çizelgelerinin nasıl ayrıştığını görün.';

  @override
  String get simulationNotice =>
      'Bu uygulama Zebra DataWedge\'e bağlanmaz. Daha genel bir asenkron entegrasyon problemini kontrollü biçimde simüle eder: komutun alındığı bilgisi, harici sistem hazır olmadan gelebilir.';

  @override
  String get chooseActivationDelay => 'Aktivasyon gecikmesini seçin';

  @override
  String get scenarioFast => '200 ms';

  @override
  String get scenarioTypical => '1500 ms';

  @override
  String get scenarioBoundary => '5000 ms';

  @override
  String get scenarioNever => 'Hiç aktifleşmesin';

  @override
  String get scenarioFastDescription => 'Profil ilk sorgudan önce aktifleşir.';

  @override
  String get scenarioTypicalDescription =>
      'İlk sorgu profili bulamaz; sonraki sorgu başarılı olur.';

  @override
  String get scenarioBoundaryDescription =>
      'Aktivasyon tam doğrulama süresi sınırında gerçekleşir.';

  @override
  String get scenarioNeverDescription =>
      'Aktivasyon olayı hiçbir zaman üretilmez.';

  @override
  String get policyCommandFuture => 'Komut Future\'ı';

  @override
  String get policyPollInterval => 'Sorgu aralığı';

  @override
  String get policyMaxAttempts => 'Maksimum deneme';

  @override
  String get policyTimeout => 'Zaman aşımı';

  @override
  String get simulationRunning => 'Simülasyon çalışıyor…';

  @override
  String get runSimulation => 'Simülasyonu başlat';

  @override
  String get reset => 'Sıfırla';

  @override
  String get approachA => 'Yaklaşım A';

  @override
  String get approachATitle => 'Future tamamlanınca hazır olduğunu varsay';

  @override
  String get approachADescription =>
      'Future tamamlandığında durur ve harici sistemin durumunu hiç kontrol etmez.';

  @override
  String get approachB => 'Yaklaşım B';

  @override
  String get approachBTitle => 'Gözlemlenebilir durumu doğrula';

  @override
  String get approachBDescription =>
      'Aktif profili sınırlı sayıda sorgu ve kesin bir süre sınırıyla kontrol eder.';

  @override
  String get statusCommandDispatched => 'Komut gönderildi';

  @override
  String get statusFutureCompleted => 'Future tamamlandı';

  @override
  String get statusReadinessAssumed => 'Hazır olduğu varsayıldı';

  @override
  String get statusServiceProfileActive => 'Simülasyon servisinde profil aktif';

  @override
  String get statusActivationVerified => 'Aktivasyon doğrulandı';

  @override
  String get statusVerificationFailed => 'Doğrulama başarısız / zaman aşımı';

  @override
  String get statusWaiting => 'Bekliyor';

  @override
  String get statusYes => 'Evet';

  @override
  String get statusNo => 'Hayır';

  @override
  String get statusNotChecked => 'Kontrol edilmedi';

  @override
  String get statusNotObserved => 'Gözlemlenmedi';

  @override
  String get measurementAssumedAt => 'Hazır varsayılan an';

  @override
  String get measurementProfileAtAssumption => 'O anda profil aktif mi?';

  @override
  String get measurementServiceActivation =>
      'Simülasyon servisindeki aktivasyon';

  @override
  String get measurementVerificationAt => 'Aktivasyonun doğrulandığı an';

  @override
  String get measurementVerificationAttempt => 'Başarılı sorgulama denemesi';

  @override
  String get measurementTimeoutAt => 'Zaman aşımının bildirildiği an';

  @override
  String millisecondsValue(int milliseconds) {
    return '$milliseconds ms';
  }

  @override
  String attemptValue(int attempt, int maxAttempts) {
    return '$attempt. deneme / $maxAttempts';
  }

  @override
  String get valuePending => 'Bekleniyor';

  @override
  String get valueEmpty => '—';

  @override
  String get outcomeIdle =>
      'Bu yaklaşımı görmek için karşılaştırmayı başlatın.';

  @override
  String get outcomeAssumedAfterActivation =>
      'Sonuç: Simüle edilen profil zaten aktifken hazır varsayımı yapıldı; ancak Yaklaşım A bunu yine de doğrulamadı.';

  @override
  String get outcomeAssumedInactive =>
      'Sonuç: Profil henüz aktif değilken hazır varsayımı yapıldı.';

  @override
  String outcomeVerifying(int count) {
    return 'Aktif profil sorgulanıyor… $count deneme tamamlandı.';
  }

  @override
  String get outcomeVerified =>
      'Hazır durumu yalnızca aktif profil eşleştikten sonra bildirildi.';

  @override
  String get outcomeFailed =>
      'Sınırlı doğrulama politikası içinde hazır durumu gözlemlenemedi.';

  @override
  String get timelineTitle => 'Canlı zaman çizelgesi';

  @override
  String get timelineStopwatchDescription =>
      'Her zaman damgası bu çalıştırmada kullanılan Stopwatch üzerinden ölçülür.';

  @override
  String get timelineEmpty =>
      'Henüz olay yok. Bir gecikme seçip karşılaştırmayı başlatın.';

  @override
  String get timelineCommandDispatched => 'createProfile komutu gönderildi.';

  @override
  String get timelineFutureCompleted => 'Komut Future\'ı tamamlandı.';

  @override
  String get timelineReadinessAssumed =>
      'Yaklaşım A, doğrulama yapmadan profilin hazır olduğunu varsaydı.';

  @override
  String get timelineVerificationStarted =>
      'Yaklaşım B, hazır olma durumunu doğrulamaya başladı.';

  @override
  String timelinePollingAttempt(int attempt, int maxAttempts) {
    return 'Aktif profil sorgulandı (deneme $attempt/$maxAttempts).';
  }

  @override
  String timelineActivationVerified(int count) {
    return 'Aktivasyon $count sorgudan sonra doğrulandı.';
  }

  @override
  String get timelineVerificationFailed =>
      'Doğrulama başarısız: zaman aşımı veya maksimum deneme sayısına ulaşıldı.';

  @override
  String get timelineProfileActivated =>
      'Simüle edilen serviste profil aktifleşti.';

  @override
  String get boundaryTitle => 'Sınır kuralı';

  @override
  String get boundaryDescription =>
      'Doğrulayıcı tam 5000 ms\'de zaman aşımı kararı vermeden önce son profil sorgusunu yapar. Bu nedenle tam süre sınırında planlanan aktivasyon kabul edilir; sınırdan sonraki aktivasyon kabul edilmez.';

  @override
  String get languageSelectorLabel => 'Dil';
}
