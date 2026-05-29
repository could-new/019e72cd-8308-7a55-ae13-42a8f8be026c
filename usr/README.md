# Multi-Agent System Designer

A Flutter application designed to build, visualize, and manage complex multi-agent AI systems. This tool provides an interactive flowchart interface allowing users to define agents, their roles, connections, routing, validation, and feedback loops.

## Features

*   **Interactive Flowchart:** Drag, drop, and connect nodes representing different AI agents.
*   **Agent Configuration:** Define roles, inputs, outputs, decision logic, and tasks for each agent.
*   **Workflow Routing:** Visualize routing logic and feedback loops to ensure task completion.
*   **System Overview:** Manage overarching properties like failure handling, optimization steps, and scalability strategies.
*   **Responsive Design:** Optimized for Desktop, Web, and Mobile. Mobile views utilize stackable panels and simplified layouts.

## Getting Started

1.  Clone the repository.
2.  Run `flutter pub get` to fetch dependencies.
3.  Run `flutter run` to launch the app on your preferred platform.

## Architecture

*   `MultiAgentSystem`: Represents the core system, containing lists of agents and edges (connections).
*   `Agent`: Defines an individual node in the system with properties like name, role, task, and logic.
*   `FlowEdge`: Represents the connections between agents, including condition logic for routing and feedback loops.

## CouldAI

This app was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.
