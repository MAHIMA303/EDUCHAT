import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [
    'quadratic equations',
    'newton laws',
    'shakespeare',
    'chemical reactions',
    'world war II',
  ];

  final List<String> _filters = [
    'All',
    'Chats',
    'Assignments',
    'Notes',
    'Resources',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
    } else {
      _performSearch();
    }
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _getSearchResults(_searchController.text);
        });
      }
    });
  }

  List<Map<String, dynamic>> _getSearchResults(String query) {
    // Mock search results
    final allResults = [
      {
        'type': 'Chat',
        'title': 'Math Class Discussion',
        'subtitle': 'Recent chat about $query',
        'icon': Icons.chat_bubble_outline,
        'color': Colors.blue,
      },
      {
        'type': 'Assignment',
        'title': 'Assignment on $query',
        'subtitle': 'Due in 3 days',
        'icon': Icons.assignment,
        'color': Colors.orange,
      },
      {
        'type': 'Note',
        'title': 'Notes about $query',
        'subtitle': 'Personal study notes',
        'icon': Icons.note,
        'color': Colors.green,
      },
      {
        'type': 'Resource',
        'title': 'Resource: $query Guide',
        'subtitle': 'PDF document',
        'icon': Icons.description,
        'color': Colors.purple,
      },
    ];

    if (_selectedFilter == 'All') {
      return allResults.where((result) =>
          (result['title'] as String).toLowerCase().contains(query.toLowerCase()) ||
          (result['subtitle'] as String).toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      return allResults.where((result) =>
          result['type'] == _selectedFilter &&
          ((result['title'] as String).toLowerCase().contains(query.toLowerCase()) ||
           (result['subtitle'] as String).toLowerCase().contains(query.toLowerCase()))).toList();
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch();
    }
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _performSearch();
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B6CB7)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search chats, assignments, notes...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 16),
              ),
            ),
          ),

          // Filters
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFF4B6CB7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => _onFilterChanged(filter),
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF4B6CB7),
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF4B6CB7) : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Content
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildRecentSearches()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (_recentSearches.isNotEmpty)
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4B6CB7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_recentSearches.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recent searches',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _recentSearches.length,
                itemBuilder: (context, index) {
                  final search = _recentSearches[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B6CB7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.history,
                        color: const Color(0xFF4B6CB7),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      search,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    onTap: () => _onRecentSearchTap(search),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4B6CB7)),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or filters',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: result['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
                             child: Icon(
                 result['icon'] as IconData,
                 color: result['color'] as Color,
                 size: 24,
               ),
            ),
                         title: Text(
               result['title'] as String,
               style: GoogleFonts.poppins(
                 fontWeight: FontWeight.w600,
                 fontSize: 16,
                 color: Colors.black87,
               ),
             ),
             subtitle: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const SizedBox(height: 4),
                 Text(
                   result['subtitle'] as String,
                   style: GoogleFonts.inter(
                     fontSize: 14,
                     color: Colors.grey[600],
                   ),
                 ),
                 const SizedBox(height: 4),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                   decoration: BoxDecoration(
                     color: (result['color'] as Color).withOpacity(0.1),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Text(
                     result['type'] as String,
                     style: GoogleFonts.inter(
                       fontSize: 10,
                       color: result['color'] as Color,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
               ],
             ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
                         onTap: () {
               // TODO: Navigate to the specific item
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Opening ${result['title'] as String}'),
                   backgroundColor: const Color(0xFF4B6CB7),
                 ),
               );
             },
          ),
        );
      },
    );
  }
}
