import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/pdf/widgets/pdf_control_button.dart';
import 'package:durbar_physics/features/pdf/widgets/pdf_jump_page_dialog.dart';
import 'package:durbar_physics/features/pdf/widgets/pdf_options_menu.dart';
import 'package:durbar_physics/features/pdf/widgets/pdf_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String documentTitle;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.documentTitle,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isSearching = false;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _showSearchDialog() async {
    final searchText = await showDialog<String>(
      context: context,
      builder: (context) => const PdfSearchDialog(),
    );

    if (searchText != null && searchText.isNotEmpty) {
      _pdfViewerController.searchText(searchText);
      setState(() {
        _isSearching = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search results highlighted. Scroll to view matches.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _clearSearch() {
    _pdfViewerController.clearSelection();
    setState(() {
      _isSearching = false;
    });
  }

  Future<void> _showJumpPageDialog() async {
    final pageNumber = await showDialog<int>(
      context: context,
      builder: (context) => const PdfJumpPageDialog(),
    );

    if (pageNumber != null) {
      _pdfViewerController.jumpToPage(pageNumber);
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfOptionsMenu(controller: _pdfViewerController),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          word: widget.documentTitle,
          size: 16,
          weight: FontWeight.w600,
          textColor: theme.textTheme.bodyLarge?.color,
        ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search, color: theme.iconTheme.color),
              onPressed: _showSearchDialog,
              tooltip: 'Search',
            ),
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.close, color: theme.iconTheme.color),
              onPressed: _clearSearch,
              tooltip: 'Clear search',
            ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
            onPressed: _showOptionsMenu,
            tooltip: 'More options',
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          debugPrint('PDF loaded with ${details.document.pages.count} pages');
        },
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load PDF: ${details.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
      floatingActionButton: PdfControlButtons(
        controller: _pdfViewerController,
        onJumpToPage: _showJumpPageDialog,
      ),
    );
  }
}