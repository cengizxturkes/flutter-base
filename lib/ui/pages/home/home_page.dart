// ignore_for_file: unused_field

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_dimens.dart';
import 'package:flutter_base/configs/app_configs.dart';
import 'package:flutter_base/global_blocs/user/user_cubit.dart';
import 'package:flutter_base/models/entities/movie_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/movie_repository.dart';
import 'package:flutter_base/ui/pages/home/home_cubit.dart';
import 'package:flutter_base/ui/pages/home/home_navigator.dart';
import 'package:flutter_base/ui/widgets/images/app_cache_image.dart';
import 'package:flutter_base/ui/widgets/list/list_empty_widget.dart';
import 'package:flutter_base/ui/widgets/list/list_error_widget.dart';
import 'package:flutter_base/ui/widgets/list/list_loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/movie_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HomeCubit(
          navigator: HomeNavigator(context: context),
          movieRepo: context.read<MovieRepository>(),
        );
      },
      child: const HomeChildPage(),
    );
  }
}

class HomeChildPage extends StatefulWidget {
  const HomeChildPage({super.key});

  @override
  State<HomeChildPage> createState() => _HomeChildPageState();
}

class _HomeChildPageState extends State<HomeChildPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  final _scrollController = ScrollController();
  late HomeCubit _cubit;
  bool _isFlushbarShown = false;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
    _cubit.fetchInitialMovies();
    context.read<UserCubit>().updateUser(UserEntity.mockData());
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: _buildBodyWidget(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.loadMovieStatus == LoadStatus.initial) {
          return Container();
        } else if (state.loadMovieStatus == LoadStatus.loading) {
          return const ListLoadingWidget();
        } else if (state.loadMovieStatus == LoadStatus.failure) {
          return const ListErrorWidget();
        } else {
          if (state.movies.isEmpty) {
            return ListEmptyWidget(onRefresh: _onRefreshData);
          } else {
            return _buildSuccessList(state.movies);
          }
        }
      },
    );
  }

  Widget _buildSuccessList(List<MovieEntity> items) {
    return RefreshIndicator(
      onRefresh: _onRefreshData,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.paddingNormal),
        controller: _scrollController,
        itemBuilder: (context, index) {
          final item = items[index];
          return MovieWidget(
            movie: item,
            onPressed: () {
              _showFlushbar(item);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: AppDimens.paddingNormal);
        },
        itemCount: items.length,
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= AppConfigs.scrollThreshold) {
      _cubit.fetchNextMovies();
    }
  }

  Future<void> _onRefreshData() async {
    _cubit.fetchInitialMovies();
  }

  void _showFlushbar(MovieEntity item) {
    Flushbar(
      message: item.title,
      titleText: SizedBox(
        width: 80,
        height: 120,
        child: AppCacheImage(
          url: item.posterUrl,
          fit: BoxFit.cover,
        ),
      ),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context).then((_) {
      _isFlushbarShown = false;
    });
  }
}
