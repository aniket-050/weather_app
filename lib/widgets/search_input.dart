import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/settings_controller.dart';

class SearchInput extends StatefulWidget {
  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _updateSuggestions(_controller.text);
      setState(() {
        _showSuggestions = true;
      });
    } else {
// Delay hiding suggestions to allow tap on suggestions
      Future.delayed(Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _showSuggestions = false;
          });
        }
      });
    }
  }

  void _updateSuggestions(String query) {
    final weatherController = Get.find<WeatherController>();
    setState(() {
      _suggestions = weatherController.getFilteredSuggestions(query);
    });
  }

  void _selectSuggestion(String city) {
    _controller.text = city;
    setState(() {
      _showSuggestions = false;
    });
    _focusNode.unfocus();
    _searchCity(city);
  }

  void _searchCity(String city) {
    if (city.isNotEmpty) {
      final weatherController = Get.find<WeatherController>();
      weatherController.searchWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsController.isDarkMode.value;

      return Column(
        children: [
// Search Input Container
          Container(
            decoration: BoxDecoration(
              color: _getSearchBackground(isDark),
              borderRadius: BorderRadius.circular(25),
              border: _showSuggestions
                  ? Border.all(
                      color: _getSearchBorderActive(isDark),
                      width: 2,
                    )
                  : Border.all(
                      color: _getSearchBorder(isDark),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: _getSearchShadow(isDark),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(
                  color: _getHintColor(isDark),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: _getIconColor(isDark),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: _getIconColor(isDark),
                        ),
                        onPressed: () {
                          _controller.clear();
                          _updateSuggestions('');
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.history,
                        color: _getIconColor(isDark),
                      ),
                      onPressed: () {
                        _focusNode.requestFocus();
                        _updateSuggestions('');
                      },
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              style: TextStyle(
                color: _getTextColor(isDark),
                fontSize: 16,
              ),
              onChanged: (value) {
                _updateSuggestions(value);
                setState(() {});
              },
              onSubmitted: _searchCity,
              textInputAction: TextInputAction.search,
            ),
          ),

// Suggestions Dropdown
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: _getDropdownBackground(isDark),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _getDropdownBorder(isDark),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getDropdownShadow(isDark),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
// Recent Cities Header
                  if (_controller.text.isEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getHeaderBackground(isDark),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 16,
                            color: _getHeaderIconColor(isDark),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Recent Searches',
                            style: TextStyle(
                              color: _getHeaderTextColor(isDark),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          if (_suggestions.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                final weatherController =
                                    Get.find<WeatherController>();
                                weatherController.clearRecentCities();
                                _updateSuggestions(_controller.text);
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  color: _getClearButtonColor(isDark),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

// Suggestions List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final city = _suggestions[index];
                      final isLast = index == _suggestions.length - 1;

                      return InkWell(
                        onTap: () => _selectSuggestion(city),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: isLast
                                ? null
                                : Border(
                                    bottom: BorderSide(
                                      color: _getSeparatorColor(isDark),
                                      width: 0.5,
                                    ),
                                  ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _controller.text.isEmpty
                                    ? Icons.history
                                    : Icons.location_on,
                                size: 18,
                                color: _getSuggestionIconColor(isDark),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  city,
                                  style: TextStyle(
                                    color: _getSuggestionTextColor(isDark),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.north_west,
                                size: 16,
                                color: _getSuggestionArrowColor(isDark),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

// Theme-aware color methods for search input
  Color _getSearchBackground(bool isDark) {
    return isDark
        ? Color(0xFF2D2D44).withOpacity(0.9)
        : Colors.white.withOpacity(0.9);
  }

  Color _getSearchBorder(bool isDark) {
    return isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.3);
  }

  Color _getSearchBorderActive(bool isDark) {
    return isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2);
  }

  Color _getSearchShadow(bool isDark) {
    return isDark
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.1);
  }

  Color _getTextColor(bool isDark) {
    return isDark ? Colors.white : Color(0xFF1A1A1A);
  }

  Color _getHintColor(bool isDark) {
    return isDark ? Colors.white.withOpacity(0.7) : Color(0xFF666666);
  }

  Color _getIconColor(bool isDark) {
    return isDark ? Colors.white.withOpacity(0.7) : Color(0xFF666666);
  }

// Dropdown colors
  Color _getDropdownBackground(bool isDark) {
    return isDark ? Color(0xFF2D2D44) : Colors.white;
  }

  Color _getDropdownBorder(bool isDark) {
    return isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.3);
  }

  Color _getDropdownShadow(bool isDark) {
    return isDark
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.1);
  }

  Color _getHeaderBackground(bool isDark) {
    return isDark
        ? Color(0xFF4FC3F7).withOpacity(0.1)
        : Color(0xFF1976D2).withOpacity(0.05);
  }

  Color _getHeaderIconColor(bool isDark) {
    return isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2);
  }

  Color _getHeaderTextColor(bool isDark) {
    return isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2);
  }

  Color _getClearButtonColor(bool isDark) {
    return isDark ? Color(0xFFFF6B6B) : Color(0xFFD32F2F);
  }

  Color _getSeparatorColor(bool isDark) {
    return isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.2);
  }

  Color _getSuggestionIconColor(bool isDark) {
    return isDark ? Colors.white.withOpacity(0.6) : Color(0xFF666666);
  }

  Color _getSuggestionTextColor(bool isDark) {
    return isDark ? Colors.white : Color(0xFF1A1A1A);
  }

  Color _getSuggestionArrowColor(bool isDark) {
    return isDark ? Colors.white.withOpacity(0.4) : Color(0xFF999999);
  }
}
