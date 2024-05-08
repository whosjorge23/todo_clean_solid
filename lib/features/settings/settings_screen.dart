import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/features/settings/cubit/settings_cubit.dart';
import 'package:todo_clean_solid/services/context_extension.dart';
import 'package:todo_clean_solid/shared_export.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.watch<SettingsCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          context.l10n.settings,
          style: appTextStyle.getQuicksand(MyFontWeight.semiBold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.l10n.change_theme}:',
                  style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(fontSize: 16),
                ),
                // Switch(
                //   value: settingsCubit.state == ThemeMode.dark ? true : false,
                //   onChanged: (isDarkMode) {
                //     settingsCubit.toggleTheme();
                //   },
                // ),
                CupertinoSlidingSegmentedControl<ThemeMode>(
                  children: const {
                    ThemeMode.system: Text('📱'),
                    ThemeMode.light: Text('🌞️'),
                    ThemeMode.dark: Text('🌕'),
                  },
                  groupValue: settingsCubit.state.themeMode,
                  onValueChanged: (themeMode) {
                    settingsCubit.toggleTheme(themeMode!);
                  },
                ),
              ],
            ),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.language,
                  style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                        fontSize: 16,
                      ),
                ),
                const Gap(10),
                const LanguageDropdown(),
              ],
            ),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.l10n.enable_creation_date}:',
                  style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(fontSize: 16),
                ),
                CupertinoSwitch(
                    value: settingsCubit.state.isDateTimeEnabled!,
                    onChanged: (value) {
                      settingsCubit.toggleDateTime();
                    }),
              ],
            ),
            const Spacer(),
            BlocConsumer<SettingsCubit, SettingsState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Text(
                  "${context.l10n.version}: ${state.version}+${state.buildNumber}",
                  style: appTextStyle.getQuicksand(MyFontWeight.semiBold),
                );
              },
            ),
            const Gap(32)
          ],
        ),
      ),
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return DropdownButton<Locale>(
          // dropdownColor: ThemeData().scaffoldBackgroundColor,
          // iconEnabledColor: ,
          // iconDisabledColor: appColors.white,
          elevation: 0,
          value: state.locale,
          onChanged: (Locale? newValue) {
            if (newValue != null) {
              context.read<SettingsCubit>().setLocale(newValue);
            }
          },
          items: [
            DropdownMenuItem(
              value: const Locale('en'),
              child: Text(
                context.l10n.language_en,
                style: appTextStyle
                    .getQuicksand(MyFontWeight.bold)
                    .copyWith(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
              ),
            ),
            DropdownMenuItem(
              value: const Locale('it'),
              child: Text(
                context.l10n.language_it,
                style:
                    appTextStyle.getQuicksand(MyFontWeight.bold).copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
