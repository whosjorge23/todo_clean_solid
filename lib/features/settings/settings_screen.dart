import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/features/settings/cubit/settings_cubit.dart';
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
          'Settings',
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
                  'Change ThemeMode:',
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
                  'Enable Creation Dates:',
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
                  "Version: ${state.version}+${state.buildNumber}",
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
