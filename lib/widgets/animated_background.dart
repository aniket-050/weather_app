import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final String weatherCondition;
  final bool isDarkMode;
  final Widget child;

  const AnimatedBackground({
    Key? key,
    required this.weatherCondition,
    required this.isDarkMode,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Color> _getThemeAwareGradient() {
    final baseColors = AppColors.getWeatherGradient(widget.weatherCondition);

    if (widget.isDarkMode) {
      // Darker, more muted colors for dark mode
      return [
        _darkenColor(baseColors[0], 0.4),
        _darkenColor(baseColors[1], 0.3),
        _darkenColor(baseColors[0], 0.5),
      ];
    } else {
      // Brighter, more vibrant colors for light mode
      return [
        _lightenColor(baseColors[0], 0.1),
        baseColors[1],
        _darkenColor(baseColors[1], 0.1),
      ];
    }
  }

  Color _darkenColor(Color color, double factor) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - factor)).round(),
      (color.green * (1 - factor)).round(),
      (color.blue * (1 - factor)).round(),
    );
  }

  Color _lightenColor(Color color, double factor) {
    return Color.fromARGB(
      color.alpha,
      (color.red + (255 - color.red) * factor).round(),
      (color.green + (255 - color.green) * factor).round(),
      (color.blue + (255 - color.blue) * factor).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getThemeAwareGradient();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0],
                Color.lerp(gradientColors[0], gradientColors[1], _animation.value)!,
                gradientColors[2],
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles
              ...List.generate(widget.isDarkMode ? 15 : 25, (index) {
                return Positioned(
                  left: (index * 47) % MediaQuery.of(context).size.width,
                  top: (index * 73) % MediaQuery.of(context).size.height,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          15 * _animation.value * (index % 2 == 0 ? 1 : -1),
                        ),
                        child: Container(
                          width: widget.isDarkMode ? 3 : 4,
                          height: widget.isDarkMode ? 3 : 4,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}