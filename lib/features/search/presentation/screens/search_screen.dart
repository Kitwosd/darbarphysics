import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/features/search/presentation/bloc/search_bloc.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_field_widget.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  // String _searchQuery = '';
  // SearchTab _currentTab = SearchTab.all;

  // // Yeha real data halne
  // List<dynamic> _allVideos = [];
  // List<dynamic> _allCourses = [];
  // List<dynamic> _allLiveClasses = [];

  @override
  void initState() {
    super.initState();

    // TODO: Fetch data from your BLoC or repository
    // Actually we have search api for this and we receive different list of live videos, and courses.
    // Example:
    // context.read<VideosBloc>().add(FetchVideos());
    // context.read<CoursesBloc>().add(FetchCourses());
    // context.read<LiveClassesBloc>().add(FetchLiveClasses());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchBloc>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(title: const Text('Search')),
          body: Column(
            children: [
              SearchFieldWidget(searchController: SearchController()),
              Expanded(child: SearchResultWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
