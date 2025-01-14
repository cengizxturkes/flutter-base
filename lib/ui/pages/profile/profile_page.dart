import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_dimens.dart';
import 'package:flutter_base/global_blocs/auth/auth_cubit.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/enums/profile_menu.dart';
import 'package:flutter_base/ui/pages/profile/profile_navigator.dart';
import 'package:flutter_base/ui/widgets/common/app_version_widget.dart';
import 'package:flutter_base/ui/pages/profile/widgets/profile_menu_widget.dart';
import 'package:flutter_base/ui/pages/profile/widgets/profile_banner_widget.dart';
import 'package:flutter_base/ui/widgets/divider/app_divider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfileCubit(
          navigator: ProfileNavigator(context: context),
        );
      },
      child: const _ProfileTabPage(),
    );
  }
}

class _ProfileTabPage extends StatefulWidget {
  const _ProfileTabPage();

  @override
  State<_ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<_ProfileTabPage> {
  late ProfileCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final info = await PackageInfo.fromPlatform();
      _cubit.setVersion(info.version);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (prev, current) {
            return prev.signOutStatus != current.signOutStatus;
          },
          listener: (context, state) {
            if (state.signOutStatus == LoadStatus.loading) {
              _cubit.navigator.showLoadingOverlay();
            } else if (state.signOutStatus == LoadStatus.success) {
              _cubit.navigator.hideLoadingOverlay();
              _cubit.navigator.openSignIn();
            } else if (state.signOutStatus == LoadStatus.failure) {
              _cubit.navigator.hideLoadingOverlay();
            }
          },
          child: _buildBodyWidget(),
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileBannerWidget(
          onAvatarPressed: () {
            _cubit.navigator.openUpdateAvatar();
          },
        ),
        Container(height: 4, color: AppColors.divider),
        const AppDivider(),
        ProfileMenuWidget(
          menu: ProfileMenu.updateProfile,
          onMenuTapped: () {
            _onMenuTapped(ProfileMenu.updateProfile);
          },
        ),
        const AppDivider(indent: AppDimens.paddingNormal),
        ProfileMenuWidget(
          menu: ProfileMenu.changePassword,
          onMenuTapped: () {
            _onMenuTapped(ProfileMenu.changePassword);
          },
        ),
        const AppDivider(indent: AppDimens.paddingNormal),
        ProfileMenuWidget(
          menu: ProfileMenu.openPolicy,
          onMenuTapped: () {
            _onMenuTapped(ProfileMenu.openPolicy);
          },
        ),
        const AppDivider(indent: AppDimens.paddingNormal),
        ProfileMenuWidget(
          menu: ProfileMenu.logout,
          onMenuTapped: () {
            _onMenuTapped(ProfileMenu.logout);
          },
        ),
        const AppDivider(indent: AppDimens.paddingNormal),
        ProfileMenuWidget(
          menu: ProfileMenu.deleteAccount,
          onMenuTapped: () {
            _onMenuTapped(ProfileMenu.deleteAccount);
          },
        ),
        const Spacer(),
        const Center(
          child: AppVersionWidget(),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  void _onMenuTapped(ProfileMenu menu) {
    switch (menu) {
      case ProfileMenu.updateProfile:
        _cubit.navigator.openUpdateProfile();
        break;
      case ProfileMenu.deleteAccount:
        _cubit.navigator.openDeleteAccount();
        break;
      case ProfileMenu.logout:
        context.read<AuthCubit>().signOut();
        break;
      case ProfileMenu.changePassword:
        _cubit.navigator.openChangePassword();
        break;
      case ProfileMenu.openPolicy:
        _cubit.navigator.openTermPolicy();
        break;
    }
  }
}
