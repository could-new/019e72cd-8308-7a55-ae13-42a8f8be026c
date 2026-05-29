import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MultiAgentDesignerApp());
}

class MultiAgentDesignerApp extends StatelessWidget {
  const MultiAgentDesignerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Agent System Designer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DesignerScreen(),
      },
    );
  }
}

// --- Data Models ---

class Agent {
  final String id;
  String name;
  String role;
  String inputs;
  String outputs;
  String decisionLogic;
  Offset position;

  Agent({
    required this.id,
    required this.name,
    required this.role,
    required this.inputs,
    required this.outputs,
    required this.decisionLogic,
    this.position = const Offset(100, 100),
  });
}

class FlowEdge {
  final String id;
  final String sourceId;
  final String targetId;
  String label;
  bool isFeedback;

  FlowEdge({
    required this.id,
    required this.sourceId,
    required this.targetId,
    this.label = '',
    this.isFeedback = false,
  });
}

class MultiAgentSystem {
  String task;
  String failureHandling;
  String optimizationSteps;
  String scalability;
  List<Agent> agents;
  List<FlowEdge> edges;

  MultiAgentSystem({
    this.task = 'Define Task...',
    this.failureHandling = 'Describe failure handling...',
    this.optimizationSteps = 'Describe optimization...',
    this.scalability = 'Describe scalability...',
    List<Agent>? agents,
    List<FlowEdge>? edges,
  })  : agents = agents ?? [],
        edges = edges ?? [];
}

// --- Main Designer Screen ---

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  late MultiAgentSystem _system;
  Agent? _selectedAgent;
  bool _showSystemPanel = false;

  @override
  void initState() {
    super.initState();
    _initSampleData();
  }

  void _initSampleData() {
    final agent1 = Agent(
      id: 'a1',
      name: 'Task Receiver',
      role: 'Parses incoming requests',
      inputs: 'Raw text',
      outputs: 'Structured task JSON',
      decisionLogic: 'If valid, route to Planner; else return error.',
      position: const Offset(50, 150),
    );
    final agent2 = Agent(
      id: 'a2',
      name: 'Planner Agent',
      role: 'Breaks down tasks into steps',
      inputs: 'Structured task JSON',
      outputs: 'Sub-task list',
      decisionLogic: 'Divide based on capability registry.',
      position: const Offset(300, 100),
    );
    final agent3 = Agent(
      id: 'a3',
      name: 'Executor Agent',
      role: 'Performs specific actions',
      inputs: 'Sub-task',
      outputs: 'Result data',
      decisionLogic: 'Execute tool, retry 3 times on failure.',
      position: const Offset(550, 200),
    );
    
    final edge1 = FlowEdge(id: 'e1', sourceId: 'a1', targetId: 'a2', label: 'Route valid task');
    final edge2 = FlowEdge(id: 'e2', sourceId: 'a2', targetId: 'a3', label: 'Assign sub-task');
    final edge3 = FlowEdge(id: 'e3', sourceId: 'a3', targetId: 'a2', label: 'Report failure', isFeedback: true);

    _system = MultiAgentSystem(
      task: 'Process user natural language requests and execute tool actions.',
      failureHandling: 'Retry transient errors up to 3 times. Fallback to human in the loop for persistent errors.',
      optimizationSteps: 'Cache frequent requests. Batch tool calls where possible.',
      scalability: 'Deploy stateless agent instances behind load balancer.',
      agents: [agent1, agent2, agent3],
      edges: [edge1, edge2, edge3],
    );
  }

  void _addAgent() {
    setState(() {
      final newId = 'a${DateTime.now().millisecondsSinceEpoch}';
      _system.agents.add(Agent(
        id: newId,
        name: 'New Agent',
        role: 'Define role...',
        inputs: 'Define inputs...',
        outputs: 'Define outputs...',
        decisionLogic: 'Define logic...',
        position: const Offset(100, 100),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Agent AI Designer'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Agent',
            onPressed: _addAgent,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'System Settings',
            onPressed: () {
              setState(() {
                _showSystemPanel = !_showSystemPanel;
                if (_showSystemPanel) _selectedAgent = null;
              });
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;

          Widget canvas = FlowCanvas(
            system: _system,
            selectedAgentId: _selectedAgent?.id,
            onAgentSelected: (agent) {
              setState(() {
                _selectedAgent = agent;
                _showSystemPanel = false;
              });
            },
            onAgentMoved: (agent, delta) {
              setState(() {
                agent.position += delta;
              });
            },
          );

          if (isDesktop) {
            return Row(
              children: [
                Expanded(child: canvas),
                if (_showSystemPanel || _selectedAgent != null)
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey.shade300)),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: _showSystemPanel
                        ? SystemPanel(system: _system, onChanged: () => setState(() {}))
                        : AgentPanel(agent: _selectedAgent!, onChanged: () => setState(() {})),
                  )
              ],
            );
          } else {
            // Mobile layout
            return Stack(
              children: [
                canvas,
                if (_showSystemPanel || _selectedAgent != null)
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: constraints.maxHeight * 0.6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _showSystemPanel = false;
                                  _selectedAgent = null;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: _showSystemPanel
                                ? SystemPanel(system: _system, onChanged: () => setState(() {}))
                                : AgentPanel(agent: _selectedAgent!, onChanged: () => setState(() {})),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

// --- Flow Canvas ---

class FlowCanvas extends StatelessWidget {
  final MultiAgentSystem system;
  final String? selectedAgentId;
  final Function(Agent) onAgentSelected;
  final Function(Agent, Offset) onAgentMoved;

  const FlowCanvas({
    super.key,
    required this.system,
    this.selectedAgentId,
    required this.onAgentSelected,
    required this.onAgentMoved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Deselect logic handled by parent if needed, simplified here.
      },
      child: Container(
        color: Colors.grey.shade100,
        child: CustomPaint(
          painter: FlowPainter(system: system),
          child: Stack(
            children: system.agents.map((agent) {
              bool isSelected = agent.id == selectedAgentId;
              return Positioned(
                left: agent.position.dx,
                top: agent.position.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    onAgentMoved(agent, details.delta);
                  },
                  onTap: () => onAgentSelected(agent),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
                    ),
                    width: 140,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.smart_toy, size: 24, color: Colors.blueGrey),
                        const SizedBox(height: 8),
                        Text(
                          agent.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class FlowPainter extends CustomPainter {
  final MultiAgentSystem system;

  FlowPainter({required this.system});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final feedbackPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double nodeWidth = 140;
    const double nodeHeight = 80; // approximate

    for (var edge in system.edges) {
      final source = system.agents.where((a) => a.id == edge.sourceId).firstOrNull;
      final target = system.agents.where((a) => a.id == edge.targetId).firstOrNull;

      if (source != null && target != null) {
        final start = Offset(source.position.dx + nodeWidth / 2, source.position.dy + nodeHeight / 2);
        final end = Offset(target.position.dx + nodeWidth / 2, target.position.dy + nodeHeight / 2);

        final activePaint = edge.isFeedback ? feedbackPaint : paint;
        
        // Draw line
        if (edge.isFeedback) {
           final controlPoint = Offset((start.dx + end.dx) / 2, start.dy - 100);
           final path = Path()..moveTo(start.dx, start.dy)..quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);
           canvas.drawPath(path, activePaint);
        } else {
           canvas.drawLine(start, end, activePaint);
        }

        // Draw arrow head (simplified)
        final direction = (end - start).direction;
        final arrowPoint = edge.isFeedback ? end : Offset(
          end.dx - cos(direction) * (nodeWidth/2 + 10),
          end.dy - sin(direction) * (nodeHeight/2 + 10)
        );
        
        final path = Path()
          ..moveTo(arrowPoint.dx, arrowPoint.dy)
          ..lineTo(arrowPoint.dx - 10 * cos(direction - pi / 6), arrowPoint.dy - 10 * sin(direction - pi / 6))
          ..lineTo(arrowPoint.dx - 10 * cos(direction + pi / 6), arrowPoint.dy - 10 * sin(direction + pi / 6))
          ..close();
        
        canvas.drawPath(path, Paint()..color = edge.isFeedback ? Colors.orange : Colors.grey.shade600);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Side Panels ---

class AgentPanel extends StatelessWidget {
  final Agent agent;
  final VoidCallback onChanged;

  const AgentPanel({super.key, required this.agent, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('Agent Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildTextField('Name', agent.name, (val) { agent.name = val; onChanged(); }),
          _buildTextField('Role', agent.role, (val) { agent.role = val; onChanged(); }),
          _buildTextField('Inputs', agent.inputs, (val) { agent.inputs = val; onChanged(); }),
          _buildTextField('Outputs', agent.outputs, (val) { agent.outputs = val; onChanged(); }),
          _buildTextField('Decision Logic', agent.decisionLogic, (val) { agent.decisionLogic = val; onChanged(); }, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }
}

class SystemPanel extends StatelessWidget {
  final MultiAgentSystem system;
  final VoidCallback onChanged;

  const SystemPanel({super.key, required this.system, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('System Properties', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildTextField('Task', system.task, (val) { system.task = val; onChanged(); }, maxLines: 2),
          _buildTextField('Failure Handling', system.failureHandling, (val) { system.failureHandling = val; onChanged(); }, maxLines: 2),
          _buildTextField('Optimization Steps', system.optimizationSteps, (val) { system.optimizationSteps = val; onChanged(); }, maxLines: 2),
          _buildTextField('Scalability', system.scalability, (val) { system.scalability = val; onChanged(); }, maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }
}
