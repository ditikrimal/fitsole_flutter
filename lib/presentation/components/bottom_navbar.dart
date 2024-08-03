part of 'widgets.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GNav(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.white,
        activeColor: Colors.white,
        tabBorderRadius: 15,
        iconSize: 25,
        tabBackgroundColor: Colors.grey[800]!,
        selectedIndex: selectedIndex,
        onTabChange: onItemTapped,
        tabs: [
          GButton(
            icon: Icons.home,
          ),
          GButton(
            icon: Icons.favorite,
          ),
          GButton(
            icon: Icons.shopping_cart,
          ),
          GButton(
            icon: Icons.person,
          ),
        ],
      ),
    );
  }
}
