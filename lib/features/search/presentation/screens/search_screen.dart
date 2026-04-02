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

  @override
  void initState() {
    super.initState();
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
