import 'package:get_it/get_it.dart';
import 'package:imp/infra/calculator/client.dart';
import 'package:imp/infra/statistics/client.dart';
import 'package:imp/main.dart';

class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._();

  final GetIt getIt = GetIt.instance;

  DependencyInjection._();

  factory DependencyInjection() {
    return _instance;
  }

  void registerDependencies() {
    if (!getIt.isRegistered<StatisticsClient>()) {
      StatisticsClient apiClientInstance = StatisticsClient(apiUrl);

      getIt.registerSingleton<StatisticsClient>(apiClientInstance);
    }

    if (!getIt.isRegistered<CalculatorClient>()) {
      CalculatorClient apiClientInstance = CalculatorClient(calculatorUrl);

      getIt.registerSingleton<CalculatorClient>(apiClientInstance);
    }
  }
}
