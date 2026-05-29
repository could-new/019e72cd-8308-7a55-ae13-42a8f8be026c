import 'package:flutter/material.dart';

void main() {
  runApp(const BattleRoyaleApp());
}

class BattleRoyaleApp extends StatelessWidget {
  const BattleRoyaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battle Royale Lobby',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.deepOrangeAccent,
          background: Colors.black,
        ),
        fontFamily: 'Roboto', // Defaulting to Roboto, but bolded everywhere for gaming feel
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LobbyScreen(),
      },
    );
  }
}

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background representing the 3D lobby hangar
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          
          // Character Placeholder (Center)
          Center(
            child: Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.amber.withOpacity(0.2), Colors.transparent],
                  radius: 0.8,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 200, color: Colors.white70),
                  SizedBox(height: 20),
                  Text(
                    "PLAYER CHARACTER",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  )
                ],
              ),
            ),
          ),

          // SafeArea for UI Elements
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TOP BAR
                _buildTopBar(isMobile),
                
                // MIDDLE SECTION (Left and Right panels)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT MENU
                      _buildLeftMenu(isMobile),
                      
                      // RIGHT MENU
                      _buildRightMenu(isMobile),
                    ],
                  ),
                ),
                
                // BOTTOM BAR (Mode, Start)
                _buildBottomBar(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile & Level
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 2),
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1566577739112-5180d4bf9390?q=80&w=200&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SURVIVOR_99",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Lv. 42",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
          
          if (!isMobile) ...[
            // Currencies
            Row(
              children: [
                _buildCurrency(Icons.monetization_on, Colors.yellow, "12,450"),
                const SizedBox(width: 16),
                _buildCurrency(Icons.diamond, Colors.lightBlueAccent, "340"),
              ],
            ),
          ],

          // Settings & Mail
          Row(
            children: [
              if (isMobile) _buildCurrency(Icons.diamond, Colors.lightBlueAccent, "340", compact: true),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCurrency(IconData icon, Color iconColor, String amount, {bool compact = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          if (!compact) const SizedBox(width: 6),
          if (!compact) Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.add_circle, color: Colors.amber, size: 16),
        ],
      ),
    );
  }

  Widget _buildLeftMenu(bool isMobile) {
    return Container(
      width: isMobile ? 70 : 120,
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSideButton(Icons.store, "STORE", isMobile),
          _buildSideButton(Icons.casino, "LUCK ROYALE", isMobile),
          _buildSideButton(Icons.person, "CHARACTER", isMobile),
          _buildSideButton(Icons.shield, "VAULT", isMobile),
          _buildSideButton(Icons.pets, "PET", isMobile),
          _buildSideButton(Icons.colorize, "WEAPON", isMobile),
        ],
      ),
    );
  }

  Widget _buildRightMenu(bool isMobile) {
    return Container(
      width: isMobile ? 70 : 200,
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          _buildRightPanelItem(Icons.calendar_today, "EVENTS", isMobile),
          _buildRightPanelItem(Icons.task, "MISSIONS", isMobile),
          const Spacer(),
          if (!isMobile)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black45,
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white10,
                    padding: const EdgeInsets.all(8),
                    child: const Text("FRIENDS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                          title: Text("Friend_${index + 1}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          trailing: const Icon(Icons.circle, color: Colors.green, size: 10),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon, String label, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border(left: BorderSide(color: Colors.amber.shade700, width: 3)),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                if (!isMobile) const SizedBox(width: 10),
                if (!isMobile)
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanelItem(IconData icon, String label, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          border: Border.all(color: Colors.white24),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.amber, size: 20),
                if (!isMobile) const SizedBox(width: 10),
                if (!isMobile)
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Mode Selector
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("BATTLE ROYALE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 16)),
                      Text("Bermuda - Ranked", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Team Mode
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.group, color: Colors.white),
                )
              ],
            ),
          ),
          
          // START BUTTON
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 60, vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Text(
                "START",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
