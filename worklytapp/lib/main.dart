import 'package:flutter/material.dart';
import 'package:workltapp/data/repositories/in_memory_job_repository.dart';
import 'package:workltapp/domain/use_cases/accept_proposal_use_case.dart';
import 'package:workltapp/domain/use_cases/create_job_use_case.dart';
import 'package:workltapp/domain/use_cases/submit_proposal_use_case.dart';

void main() async {
  final repository = InMemoryJobRepository();

  final createJobUseCase = CreateJobUseCase(repository);
  final submitProposalUseCase = SubmitProposalUseCase(repository);
  final acceptProposalUseCase = AcceptProposalUseCase(repository);

  final createdJob = await createJobUseCase.execute(
    clientId: 'client_1',
    title: 'Build a Flutter dashboard',
    description: 'Need a clean dashboard for monitoring project tasks and user activity.',
    category: 'Mobile App',
    skills: const ['Flutter', 'UI Design', 'API Integration'],
    budgetMin: 500,
    budgetMax: 1500,
    deadline: DateTime.now().add(const Duration(days: 14)),
  );

  final submittedProposal = await submitProposalUseCase.execute(
    jobId: createdJob.id,
    freelancerId: 'freelancer_1',
    price: 1100,
    coverLetter: 'I can deliver this dashboard in two weeks with a clean UI and API integration.',
  );

  await acceptProposalUseCase.execute(
    jobId: createdJob.id,
    proposalId: submittedProposal.id,
  );

  runApp(const WorklyApp());
}

class WorklyApp extends StatelessWidget {
  const WorklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WorklyHomePage(),
    );
  }
}

class WorklyHomePage extends StatelessWidget {
  const WorklyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workly')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Workly business logic initialized. UI will be added after the core flows are validated.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
