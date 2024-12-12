import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony/src/theme/app_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<String> navItems;
  final int initialIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.navItems,
    this.initialIndex = 0,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create a curved animation for a smooth effect
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start the animation forward
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.w,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: AppColors.borderColor.withOpacity(0.15))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.navItems.length, (index) {
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _selectedIndex = index;

                  // Reset and replay animation
                  _animationController.reset();
                  _animationController.forward();
                });

                widget.onItemTapped(index);
              },
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    widget.navItems[index],
                    width: 20.w,
                    height: 20.w,
                    color: _selectedIndex == index
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFC5BCBC),
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 77.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Theme.of(context)
                                  .primaryColor
                                  .withOpacity(_animation.value)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
