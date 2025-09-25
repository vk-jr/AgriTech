import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pageAnimationController;
  late AnimationController _navAnimationController;
  late Animation<double> _pageAnimation;
  late Animation<double> _navAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Page content animation
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pageAnimation = CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOutCubic,
    );
    
    // Navigation bar animation
    _navAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _navAnimation = CurvedAnimation(
      parent: _navAnimationController,
      curve: Curves.easeInOut,
    );
    
    // Slide animation for page transitions
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _pageAnimationController.forward();
    _navAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _navAnimationController.dispose();
    super.dispose();
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home') || location == '/main') return 0;
    if (location.startsWith('/ai-tools')) return 1;
    if (location.startsWith('/market')) return 2;
    if (location.startsWith('/community')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index) {
    final currentIndex = _getCurrentIndex(context);
    if (currentIndex == index) return;
    
    // Animate navigation transition
    _previousIndex = currentIndex;
    _navAnimationController.reset();
    _navAnimationController.forward();
    
    // Add slight delay for smoother transition
    Future.delayed(const Duration(milliseconds: 50), () {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/ai-tools');
          break;
        case 2:
          context.go('/market');
          break;
        case 3:
          context.go('/community');
          break;
        case 4:
          context.go('/profile');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageAnimationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _pageAnimation,
              child: widget.child,
            ),
          );
        },
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _navAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, (1 - _navAnimation.value) * 20),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _getCurrentIndex(context),
                onTap: _onItemTapped,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey[600],
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: _buildNavIcon(Icons.home_outlined, Icons.home, 0),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildNavIcon(MdiIcons.brain, MdiIcons.brain, 1),
                    label: 'AI Tools',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildNavIcon(MdiIcons.storeOutline, MdiIcons.store, 2),
                    label: 'Market',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildNavIcon(MdiIcons.forumOutline, MdiIcons.forum, 3),
                    label: 'Community',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildNavIcon(Icons.person_outline, Icons.person, 4),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavIcon(IconData outlinedIcon, IconData filledIcon, int index) {
    final isSelected = _getCurrentIndex(context) == index;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(isSelected),
        padding: const EdgeInsets.all(4),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          size: 24,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[600],
        ),
      ),
    );
  }
}
