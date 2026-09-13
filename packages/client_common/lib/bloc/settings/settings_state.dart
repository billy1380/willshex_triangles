import "package:equatable/equatable.dart";
import "package:client_common/models/generator_settings.dart";

class SettingsState extends Equatable {
  final GeneratorSettings settings;
  final bool isLoaded;

  const SettingsState({
    this.settings = const GeneratorSettings(),
    this.isLoaded = false,
  });

  SettingsState copyWith({
    GeneratorSettings? settings,
    bool? isLoaded,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => [settings, isLoaded];
}
