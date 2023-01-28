import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class FitRepo {
  static const String clientId = '1088954388524-av5sv7is023ek6kqbmtnk7r2528ptr3i.apps.googleusercontent.com';

  static Future<int> getSteps() async {
    // from health package
    try {
      HealthFactory health = HealthFactory();
      await Permission.activityRecognition.request();
      var types = [HealthDataType.STEPS];
      bool accessWasGranted = await health.requestAuthorization(types);
      if (!accessWasGranted) {
        return 0;
      }
      DateTime now = DateTime.now();
      var midnight = DateTime(now.year, now.month, now.day);
      int? steps = await health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      // if (e.toString().contains('no steps')) return 0;
      return 0;
    }
  }
}
