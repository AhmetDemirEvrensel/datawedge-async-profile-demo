import 'package:datawedge_async_profile_demo/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in <Locale>[const Locale('tr'), const Locale('en')]) {
    for (final size in <Size>[const Size(390, 844), const Size(1440, 1200)]) {
      testWidgets('${locale.languageCode} renders without layout errors at '
          '${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(ProfileReadinessDemoApp(initialLocale: locale));
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('approach-a-card')), findsOneWidget);
        expect(find.byKey(const Key('approach-b-card')), findsOneWidget);
      });
    }
  }

  testWidgets('starts in Turkish and switches the complete UI to English', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfileReadinessDemoApp());

    expect(
      find.text(
        "Future'ın tamamlanması, harici sistemin hazır olduğu anlamına gelmez.",
      ),
      findsOneWidget,
    );
    expect(find.text('Yaklaşım A'.toUpperCase()), findsOneWidget);
    expect(find.text('Simülasyonu başlat'), findsOneWidget);
    expect(find.text('Sıfırla'), findsOneWidget);

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'A completed Future is not the same as a ready external system.',
      ),
      findsOneWidget,
    );
    expect(find.text('APPROACH A'), findsOneWidget);
    expect(find.text('Run simulation'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Simülasyonu başlat'), findsNothing);
  });

  testWidgets('shows the boundary note only for the 5000 ms scenario', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(const ProfileReadinessDemoApp());

    expect(find.text('Sınır kuralı'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, '5000 ms'));
    await tester.pump();
    expect(find.text('Sınır kuralı'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '1500 ms'));
    await tester.pump();
    expect(find.text('Sınır kuralı'), findsNothing);
  });

  testWidgets('translates live simulation state and timeline immediately', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ProfileReadinessDemoApp());

    expect(find.byKey(const Key('approach-a-card')), findsOneWidget);
    expect(find.byKey(const Key('approach-b-card')), findsOneWidget);

    final fastScenario = find.widgetWithText(ChoiceChip, '200 ms');
    await tester.tap(fastScenario);
    await tester.pump();
    await tester.tap(find.byKey(const Key('run-comparison-button')));
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      find.text('Sonuç: Profil henüz aktif değilken hazır varsayımı yapıldı.'),
      findsOneWidget,
    );
    expect(find.text("Komut Future'ı tamamlandı."), findsNWidgets(2));
    expect(
      find.text(
        'Yaklaşım A, doğrulama yapmadan profilin hazır olduğunu varsaydı.',
      ),
      findsOneWidget,
    );
    expect(find.text('O anda profil aktif mi?'), findsOneWidget);
    expect(find.byKey(const Key('assumption-time-value')), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(const Key('profile-at-assumption-value')))
          .data,
      'Hayır',
    );
    expect(find.text('Kontrol edilmedi'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('assumption-time-value'))).data,
      matches(RegExp(r'^\d+ ms$')),
    );

    await tester.tap(find.text('EN'));
    await tester.pump();

    expect(
      find.text(
        'Result: readiness was assumed while the profile was still inactive.',
      ),
      findsOneWidget,
    );
    expect(find.text('Command Future completed.'), findsNWidgets(2));
    expect(
      find.text(
        'Approach A assumed the profile was ready without verification.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Yaklaşım A, doğrulama yapmadan profilin hazır olduğunu varsaydı.',
      ),
      findsNothing,
    );

    await tester.pump(const Duration(milliseconds: 1050));
    await tester.pump();
    expect(
      find.text('Ready was declared only after the active profile matched.'),
      findsOneWidget,
    );
    expect(find.text('Attempt 1 of 5'), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(const Key('verification-time-value')))
          .data,
      matches(RegExp(r'^\d+ ms$')),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('service-activation-time-value')))
          .data,
      matches(RegExp(r'^\d+ ms$')),
    );
    expect(
      find.text(
        'Result: readiness was assumed while the profile was still inactive.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('scenario change clears results and cancels the active run', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(const ProfileReadinessDemoApp());

    await tester.tap(find.byKey(const Key('run-comparison-button')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text("Komut Future'ı tamamlandı."), findsNWidgets(2));

    await tester.tap(find.widgetWithText(ChoiceChip, '200 ms'));
    await tester.pump();

    expect(
      find.text('Henüz olay yok. Bir gecikme seçip karşılaştırmayı başlatın.'),
      findsOneWidget,
    );
    expect(find.text("Komut Future'ı tamamlandı."), findsNothing);

    await tester.pump(const Duration(milliseconds: 1600));
    expect(find.text("Komut Future'ı tamamlandı."), findsNothing);
    expect(
      find.text('Profil sahte harici serviste aktif hâle geldi.'),
      findsNothing,
    );
  });

  testWidgets('scenario change also clears completed results', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(const ProfileReadinessDemoApp());

    await tester.tap(find.widgetWithText(ChoiceChip, '200 ms'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('run-comparison-button')));
    await tester.pump(const Duration(milliseconds: 1100));
    expect(find.text('1. deneme / 5'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '1500 ms'));
    await tester.pump();

    expect(find.text('1. deneme / 5'), findsNothing);
    expect(
      find.text('Henüz olay yok. Bir gecikme seçip karşılaştırmayı başlatın.'),
      findsOneWidget,
    );
  });

  testWidgets('never-active scenario reports timeout and attempt count', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(const ProfileReadinessDemoApp());

    await tester.tap(find.widgetWithText(ChoiceChip, 'Hiç aktifleşmesin'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('run-comparison-button')));
    await tester.pump(const Duration(milliseconds: 50));
    for (var attempt = 1; attempt <= 5; attempt++) {
      await tester.pump(Duration(seconds: attempt));
    }
    await tester.pump();

    expect(
      find.text(
        'Sınırlı doğrulama politikası içinde hazır durumu gözlemlenemedi.',
      ),
      findsOneWidget,
    );
    expect(find.text('5. deneme / 5'), findsOneWidget);
    expect(find.text('Zaman aşımının bildirildiği an'), findsOneWidget);
    expect(find.text('Gözlemlenmedi'), findsNWidgets(2));
  });
}

void _useLargeViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 1800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}
