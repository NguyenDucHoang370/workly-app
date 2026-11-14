import 'package:flutter_test/flutter_test.dart';
import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/entities/proposal.dart';
import 'package:workltapp/domain/use_cases/accept_proposal_use_case.dart';
import 'package:workltapp/domain/use_cases/create_job_use_case.dart';
import 'package:workltapp/domain/use_cases/get_open_jobs_use_case.dart';
import 'package:workltapp/domain/use_cases/submit_proposal_use_case.dart';
import 'package:workltapp/data/repositories/in_memory_job_repository.dart';

void main() {
  group('Workly core business logic', () {
    late InMemoryJobRepository repository;
    late CreateJobUseCase createJobUseCase;
    late GetOpenJobsUseCase getOpenJobsUseCase;
    late SubmitProposalUseCase submitProposalUseCase;
    late AcceptProposalUseCase acceptProposalUseCase;

    setUp(() {
      repository = InMemoryJobRepository();
      createJobUseCase = CreateJobUseCase(repository);
      getOpenJobsUseCase = GetOpenJobsUseCase(repository);
      submitProposalUseCase = SubmitProposalUseCase(repository);
      acceptProposalUseCase = AcceptProposalUseCase(repository);
    });

    test('create job succeeds with valid data', () async {
      final job = await createJobUseCase.execute(
        clientId: 'client_1',
        title: 'Build mobile dashboard',
        description: 'Need a dashboard with charts and task summary.',
        category: 'Mobile App',
        skills: const ['Flutter', 'Charts'],
        budgetMin: 400,
        budgetMax: 1000,
        deadline: DateTime.now().add(const Duration(days: 10)),
      );

      expect(job.status, JobStatus.open);
      expect(job.title, 'Build mobile dashboard');
    });

    test('create job rejects invalid budget', () async {
      expect(
        () => createJobUseCase.execute(
          clientId: 'client_1',
          title: 'Invalid budget job',
          description: 'This should fail.',
          category: 'Mobile App',
          skills: const ['Flutter'],
          budgetMin: 1500,
          budgetMax: 1000,
          deadline: DateTime.now().add(const Duration(days: 10)),
        ),
        throwsArgumentError,
      );
    });

    test('getOpenJobs only returns open jobs', () async {
      await createJobUseCase.execute(
        clientId: 'client_1',
        title: 'Open job',
        description: 'This remains open.',
        category: 'Web App',
        skills: const ['Flutter'],
        budgetMin: 100,
        budgetMax: 500,
        deadline: DateTime.now().add(const Duration(days: 7)),
      );

      final closedJob = await createJobUseCase.execute(
        clientId: 'client_1',
        title: 'Closed job',
        description: 'This should be closed manually.',
        category: 'Web App',
        skills: const ['Flutter'],
        budgetMin: 100,
        budgetMax: 500,
        deadline: DateTime.now().add(const Duration(days: 7)),
      );

      await repository.updateJob(closedJob.copyWith(status: JobStatus.closed));

      final jobs = await getOpenJobsUseCase.execute();

      expect(jobs.length, 1);
      expect(jobs.single.title, 'Open job');
    });

    test('submit proposal succeeds for an open job and prevents duplicates', () async {
      final job = await createJobUseCase.execute(
        clientId: 'client_1',
        title: 'Full stack dashboard',
        description: 'Looking for a freelancer to build dashboard.',
        category: 'Web App',
        skills: const ['Dart', 'API'],
        budgetMin: 200,
        budgetMax: 800,
        deadline: DateTime.now().add(const Duration(days: 12)),
      );

      final firstProposal = await submitProposalUseCase.execute(
        jobId: job.id,
        freelancerId: 'freelancer_1',
        price: 700,
        coverLetter: 'I can do it quickly.',
      );

      expect(firstProposal.status, ProposalStatus.pending);

      expect(
        () => submitProposalUseCase.execute(
          jobId: job.id,
          freelancerId: 'freelancer_1',
          price: 750,
          coverLetter: 'This should fail due to duplicate.',
        ),
        throwsStateError,
      );
    });

    test('accept proposal changes job status to inProgress', () async {
      final job = await createJobUseCase.execute(
        clientId: 'client_1',
        title: 'Accept proposal flow',
        description: 'This should test acceptance logic.',
        category: 'Mobile App',
        skills: const ['Flutter'],
        budgetMin: 100,
        budgetMax: 300,
        deadline: DateTime.now().add(const Duration(days: 8)),
      );

      final proposal = await submitProposalUseCase.execute(
        jobId: job.id,
        freelancerId: 'freelancer_1',
        price: 250,
        coverLetter: 'I am ready to start.',
      );

      final acceptedProposal = await acceptProposalUseCase.execute(
        jobId: job.id,
        proposalId: proposal.id,
      );

      expect(acceptedProposal.status, ProposalStatus.accepted);

      final savedJob = await repository.getJobById(job.id);
      expect(savedJob?.status, JobStatus.inProgress);
    });
  });
}
