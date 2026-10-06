# Ameli для Android и iOS

Первая Flutter-версия с тёмным интерфейсом, карточками трекеров, таймерами сна
и кормления (отдельные стороны), формами событий, профилем ребёнка,
фильтрами отчётов и экспортом PDF через системное меню сохранения/отправки.

Записи хранятся локально через SharedPreferences, отдельно от сайта.
Это прототип для тестирования, без авторизации, серверной синхронизации,
Live Activities и уведомлений на экране блокировки. Таймер считает прошедшее
время по отметкам времени и восстанавливается после блокировки/перезапуска;
никакой фоновый сервис пока не запускается. Изменение системного времени
влияет на отсчёт. Не используйте эту версию как единственное хранилище записей.

## Запуск на Mac

Установите Flutter stable по https://docs.flutter.dev/install и Xcode из
App Store. Откройте Xcode один раз для установки компонентов и принятия
лицензии. Выполните `flutter doctor` и исправьте пункты iOS/Android.
Для iOS-плагинов может потребоваться CocoaPods — следуйте подсказкам doctor.

Из корня репозитория:

```bash
cd mobile
bash scripts/bootstrap.sh
flutter doctor
flutter devices
flutter run -d <device-id>
```

Скрипт `bootstrap.sh` генерирует отсутствующие папки `android/` и `ios/` через
`flutter create`, сохраняя существующие файлы Dart, и устанавливает зависимости.
Организация `dev.ameli` — временный идентификатор для разработки, перед
публикацией нужно выбрать собственный bundle/application ID.

Для симулятора iPhone:

```bash
open -a Simulator
flutter run
```

Для физического iPhone подключите телефон, включите Developer Mode и доверьтесь
Mac. Откройте `ios/Runner.xcworkspace`, выберите Runner → Signing & Capabilities,
укажите свою Team/Apple ID и уникальный Bundle Identifier, затем запускайте
из Xcode или `flutter run`. Бесплатный Apple ID имеет ограничения подписи.

## Тестовый APK для Android

Установите Android Studio и SDK, примите лицензии через
`flutter doctor --android-licenses`. После bootstrap:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

APK: `build/app/outputs/flutter-apk/app-debug.apk`. Передайте файл на Android,
разрешите установку из выбранного источника и установите его. APK не работает
на iPhone. Debug-сборка предназначена для тестирования; для магазина нужны
release-подпись и отдельная сборка. APK и секреты подписи не хранятся в Git.

## Сборка через GitHub Actions

Workflow **Flutter mobile** проверяет код и тесты, собирает Android debug APK
и iOS-приложение для симулятора. После успешного Android job в Actions появится
артефакт `ameli-android-debug`: скачайте ZIP и распакуйте APK. Для скачивания
артефактов потребуется вход в GitHub. CI не создаёт подписанную сборку для
физического iPhone и не публикует приложение в магазины.

После генерации native runners их можно добавить в Git при настройке
Live Activities, Android-уведомлений и release-подписи. Не коммитьте
`local.properties`, ключи подписи и сгенерированные файлы зависимостей.

Шрифт DejaVu Sans обеспечивает кириллицу в PDF; лицензия в `assets/fonts/LICENSE.txt`.
