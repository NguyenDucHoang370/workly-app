import 'package:flutter_test/flutter_test.dart';
import 'package:worklyapp/data/repositories/in_memory_contract_repository.dart';
import 'package:worklyapp/data/repositories/in_memory_job_repository.dart';
import 'package:worklyapp/data/repositories/in_memory_work_repository.dart';
import 'package:worklyapp/domain/entities/category.dart';
import 'package:worklyapp/domain/entities/client_profile.dart';
import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/entities/favorite.dart';
import 'package:worklyapp/domain/entities/freelancer_profile.dart';
import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/entities/notification.dart';
import 'package:worklyapp/domain/entities/proposal.dart';
import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/auth_repository.dart';
import 'package:worklyapp/domain/use_cases/accept_proposal_use_case.dart';
import 'package:worklyapp/domain/use_cases/accept_submission_use_case.dart';
import 'package:worklyapp/domain/use_cases/close_job_use_case.dart';
import 'package:worklyapp/domain/use_cases/cancel_contract_use_case.dart';
import 'package:worklyapp/domain/use_cases/create_job_use_case.dart';
import 'package:worklyapp/domain/use_cases/create_review_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_categories_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_chats_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_chat_messages_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_contract_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_contracts_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_favorites_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_current_user_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_job_proposals_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_job_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_my_proposals_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_notifications_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_profile_use_case.dart';
import 'package:worklyapp/domain/use_cases/get_user_reviews_use_case.dart';
import 'package:worklyapp/domain/use_cases/mark_notification_read_use_case.dart';
import 'package:worklyapp/domain/use_cases/mark_chat_read_use_case.dart';
import 'package:worklyapp/domain/use_cases/reject_proposal_use_case.dart';
import 'package:worklyapp/domain/use_cases/request_submission_changes_use_case.dart';
import 'package:worklyapp/domain/use_cases/save_client_profile_use_case.dart';
import 'package:worklyapp/domain/use_cases/save_freelancer_profile_use_case.dart';
import 'package:worklyapp/domain/use_cases/search_jobs_use_case.dart';
import 'package:worklyapp/domain/use_cases/sign_in_use_case.dart';
import 'package:worklyapp/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:worklyapp/domain/use_cases/sign_out_use_case.dart';
import 'package:worklyapp/domain/use_cases/sign_up_use_case.dart';
import 'package:worklyapp/domain/use_cases/send_password_reset_use_case.dart';
import 'package:worklyapp/domain/use_cases/start_chat_use_case.dart';
import 'package:worklyapp/domain/use_cases/submit_proposal_use_case.dart';
import 'package:worklyapp/domain/use_cases/submit_work_use_case.dart';
import 'package:worklyapp/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:worklyapp/domain/use_cases/send_chat_message_use_case.dart';
import 'package:worklyapp/domain/use_cases/update_job_use_case.dart';
import 'package:worklyapp/domain/use_cases/update_user_use_case.dart';

void main() {
  late InMemoryJobRepository jobs;
  late InMemoryContractRepository contracts;
  late InMemoryWorkRepository work;
  late CreateJobUseCase createJob;

  setUp(() {
    jobs = InMemoryJobRepository();
    contracts = InMemoryContractRepository();
    work = InMemoryWorkRepository();
    createJob = CreateJobUseCase(jobs);
  });

  Future<Job> makeJob({String title = 'Flutter work'}) => createJob.execute(
    clientId: 'client-1',
    title: title,
    description: 'Build a mobile feature',
    category: 'Mobile',
    skills: const ['Flutter'],
    budgetMin: 100,
    budgetMax: 500,
    deadline: DateTime.now().add(const Duration(days: 5)),
  );

  test('job creation normalizes skills, rejects blank skills and non-finite budget', () async {
    final job = await createJob.execute(
      clientId: 'client-1',
      title: 'Job',
      description: 'Description',
      category: 'Mobile',
      skills: const [' Flutter ', ' '],
      budgetMin: 10,
      budgetMax: 20,
      deadline: DateTime.now().add(const Duration(days: 5)),
    );
    expect(job.skills, ['Flutter']);
    await expectLater(
      createJob.execute(
        clientId: 'client-1',
        title: 'Job',
        description: 'Description',
        category: 'Mobile',
        skills: const [' '],
        budgetMin: 10,
        budgetMax: 20,
        deadline: DateTime.now().add(const Duration(days: 5)),
      ),
      throwsArgumentError,
    );
    await expectLater(
      createJob.execute(
        clientId: 'client-1',
        title: 'Job',
        description: 'Description',
        category: 'Mobile',
        skills: const ['Flutter'],
        budgetMin: double.nan,
        budgetMax: 20,
        deadline: DateTime.now().add(const Duration(days: 5)),
      ),
      throwsArgumentError,
    );
  });

  test('search filters open jobs and paginates after a cursor', () async {
    final first = await makeJob(title: 'Flutter One');
    await makeJob(title: 'Flutter Two');
    await jobs.updateJob(first.copyWith(status: JobStatus.closed));

    final results = await SearchJobsUseCase(jobs)
        .execute(query: 'flutter', limit: 1);
    expect(results, hasLength(1));
    expect(results.single.title, 'Flutter Two');
    expect(
      () => SearchJobsUseCase(jobs).execute(minBudget: 500, maxBudget: 100),
      throwsArgumentError,
    );
  });

  test('only job owner can edit or close an open job', () async {
    final job = await makeJob();
    await expectLater(
      UpdateJobUseCase(jobs).execute(
        clientId: 'someone-else',
        job: job.copyWith(title: 'Changed'),
      ),
      throwsStateError,
    );
    final closed = await CloseJobUseCase(jobs)
        .execute(jobId: job.id, clientId: 'client-1');
    expect(closed.status, JobStatus.closed);
    expect(await GetJobUseCase(jobs).execute(job.id), closed);
  });

  test(
    'proposal acceptance creates contract and rejects competing proposals',
    () async {
      final job = await makeJob();
      final submit = SubmitProposalUseCase(jobs, jobs);
      final selected = await submit.execute(
        jobId: job.id,
        freelancerId: 'freelancer-1',
        price: 250,
        coverLetter: 'I can do this.',
      );
      final competing = await submit.execute(
        jobId: job.id,
        freelancerId: 'freelancer-2',
        price: 300,
        coverLetter: 'I can also do this.',
      );

      await expectLater(
        AcceptProposalUseCase(jobs, jobs, contracts).execute(
          clientId: 'other-client',
          jobId: job.id,
          proposalId: selected.id,
        ),
        throwsStateError,
      );
      await AcceptProposalUseCase(
        jobs,
        jobs,
        contracts,
      ).execute(clientId: 'client-1', jobId: job.id, proposalId: selected.id);

      expect(
        (await jobs.getProposalById(competing.id))?.status,
        ProposalStatus.rejected,
      );
      expect(await contracts.getContractByProposalId(selected.id), isNotNull);
      expect((await jobs.getJobById(job.id))?.status, JobStatus.inProgress);
    },
  );

  test(
    'client can list and reject proposals, then freelancer may retry',
    () async {
      final job = await makeJob();
      final first = await SubmitProposalUseCase(jobs, jobs).execute(
        jobId: job.id,
        freelancerId: 'freelancer-1',
        price: 200,
        coverLetter: 'Initial offer',
      );
      await expectLater(
        GetJobProposalsUseCase(
          jobs,
          jobs,
        ).execute(jobId: job.id, clientId: 'outsider'),
        throwsStateError,
      );
      expect(
        await GetJobProposalsUseCase(
          jobs,
          jobs,
        ).execute(jobId: job.id, clientId: 'client-1'),
        [first],
      );
      await RejectProposalUseCase(
        jobs,
        jobs,
      ).execute(jobId: job.id, proposalId: first.id, clientId: 'client-1');
      final retry = await SubmitProposalUseCase(jobs, jobs).execute(
        jobId: job.id,
        freelancerId: 'freelancer-1',
        price: 210,
        coverLetter: 'Updated offer',
      );
      expect(retry.status, ProposalStatus.pending);
      expect(
        await GetMyProposalsUseCase(jobs).execute('freelancer-1'),
        hasLength(2),
      );
    },
  );

  test('client can review submission and freelancer can resubmit after change request', () async {
    final now = DateTime.now();
    final contract = Contract(
      id: 'contract-1',
      jobId: 'job-1',
      proposalId: 'proposal-1',
      clientId: 'client-1',
      freelancerId: 'freelancer-1',
      agreedPrice: 100,
      status: ContractStatus.inProgress,
      startedAt: DateTime.utc(2026),
    );
    await contracts.createContract(contract);
    final submitWork = SubmitWorkUseCase(contracts, work);
    final first = await submitWork.execute(
      contractId: contract.id,
      freelancerId: contract.freelancerId,
      files: const ['result.zip'],
      note: 'First version',
    );
    final requestChanges = RequestSubmissionChangesUseCase(contracts, work);
    await requestChanges.execute(
      contractId: contract.id,
      clientId: contract.clientId,
    );
    final second = await submitWork.execute(
      contractId: contract.id,
      freelancerId: contract.freelancerId,
      files: const [],
      note: 'Updated version',
    );
    final accepted = await AcceptSubmissionUseCase(
      contracts,
      work,
    ).execute(contractId: contract.id, clientId: contract.clientId);

    expect(first.status.name, 'submitted');
    expect(second.status.name, 'submitted');
    expect(accepted.id, second.id);
    expect(
      (await contracts.getContractById(contract.id))?.status,
      ContractStatus.completed,
    );
    expect(now.isBefore(accepted.createdAt), isTrue);
  });

  test('profiles enforce the matching account role', () async {
    await work.saveUser(
      User(
        id: 'client-1',
        email: 'client@example.com',
        displayName: 'Client',
        role: UserRole.client,
        createdAt: DateTime.now(),
      ),
    );
    await work.saveUser(
      User(
        id: 'freelancer-1',
        email: 'freelancer@example.com',
        displayName: 'Freelancer',
        role: UserRole.freelancer,
        createdAt: DateTime.now(),
      ),
    );
    const client = ClientProfile(userId: 'client-1', company: 'Acme');
    final freelancer = FreelancerProfile(
      userId: 'freelancer-1',
      skills: const ['Dart'],
      hourlyRate: 30,
    );
    await expectLater(
      SaveFreelancerProfileUseCase(
        work,
      ).execute(FreelancerProfile(userId: 'client-1', skills: const ['Dart'])),
      throwsStateError,
    );
    await SaveClientProfileUseCase(work).execute(client);
    await SaveFreelancerProfileUseCase(work).execute(freelancer);
    expect(await GetProfileUseCase(work).execute('client-1'), client);
    expect(
      await GetProfileUseCase(work).execute('freelancer-1'),
      isA<FreelancerProfile>(),
    );
  });

  test('chat access is limited to contract participants', () async {
    final contract = Contract(
      id: 'contract-chat',
      jobId: 'job-chat',
      proposalId: 'proposal-chat',
      clientId: 'client-1',
      freelancerId: 'freelancer-1',
      agreedPrice: 50,
      status: ContractStatus.inProgress,
      startedAt: DateTime.utc(2026),
    );
    await contracts.createContract(contract);
    final chat = await StartChatUseCase(
      contracts,
      work,
    ).execute(contractId: contract.id, requesterId: 'client-1');
    final sender = SendChatMessageUseCase(work);
    final message = await sender.execute(
      chatId: chat.id,
      senderId: 'client-1',
      text: 'Hello',
    );
    expect(message.text, 'Hello');
    await sender.execute(
      chatId: chat.id,
      senderId: 'freelancer-1',
      text: 'Reply',
    );
    expect(await GetChatsUseCase(work).execute('client-1'), hasLength(1));
    final messageQueries = GetChatMessagesUseCase(work);
    await expectLater(
      messageQueries.execute(chatId: chat.id, userId: 'outsider'),
      throwsStateError,
    );
    await MarkChatReadUseCase(work)
        .execute(chatId: chat.id, userId: 'client-1');
    final messages = await messageQueries.execute(
      chatId: chat.id,
      userId: 'client-1',
    );
    expect(messages.last.isRead, isTrue);
    await expectLater(
      sender.execute(chatId: chat.id, senderId: 'outsider', text: 'Intrusion'),
      throwsStateError,
    );
  });

  test('completed contracts support one review per participant', () async {
    final contract = Contract(
      id: 'contract-review',
      jobId: 'job-r',
      proposalId: 'proposal-r',
      clientId: 'client-1',
      freelancerId: 'freelancer-1',
      agreedPrice: 80,
      status: ContractStatus.completed,
      startedAt: DateTime.utc(2026),
      completedAt: DateTime.utc(2026, 2),
    );
    await contracts.createContract(contract);
    final createReview = CreateReviewUseCase(contracts, work);
    final review = await createReview.execute(
      contractId: contract.id,
      fromUserId: 'client-1',
      rating: 5,
      comment: 'Great work',
    );
    expect(review.toUserId, 'freelancer-1');
    await expectLater(
      createReview.execute(
        contractId: contract.id,
        fromUserId: 'client-1',
        rating: 4,
      ),
      throwsStateError,
    );
    expect(
      await GetUserReviewsUseCase(work).execute('freelancer-1'),
      hasLength(1),
    );
  });

  test('contract lookup enforces participants and active contracts can be cancelled', () async {
    final contract = Contract(
      id: 'contract-cancel',
      jobId: 'job-cancel',
      proposalId: 'proposal-cancel',
      clientId: 'client-1',
      freelancerId: 'freelancer-1',
      agreedPrice: 100,
      status: ContractStatus.inProgress,
      startedAt: DateTime.now(),
    );
    await contracts.createContract(contract);
    await expectLater(
      GetContractUseCase(contracts)
          .execute(contractId: contract.id, userId: 'outsider'),
      throwsStateError,
    );
    expect(await GetContractsUseCase(contracts).execute('client-1'), [
      contract,
    ]);
    final cancelled = await CancelContractUseCase(contracts)
        .execute(contractId: contract.id, userId: 'client-1');
    expect(cancelled.status, ContractStatus.cancelled);
  });

  test('user update cannot change account role', () async {
    final user = User(
      id: 'client-1',
      email: 'client@example.com',
      displayName: 'Client',
      role: UserRole.client,
      createdAt: DateTime.now(),
    );
    await work.saveUser(user);
    final updated = await UpdateUserUseCase(work).execute(
      requesterId: user.id,
      user: user.copyWith(displayName: '  Client Updated  '),
    );
    expect(updated.displayName, 'Client Updated');
    await expectLater(
      UpdateUserUseCase(work).execute(
        requesterId: user.id,
        user: user.copyWith(role: UserRole.admin),
      ),
      throwsStateError,
    );
  });

  test(
    'notifications can be filtered and marked read; favorites toggle',
    () async {
      final notification = AppNotification(
        id: 'notice-1',
        userId: 'client-1',
        type: NotificationType.proposal,
        refId: 'proposal-1',
        createdAt: DateTime.now(),
      );
      work.seedNotification(notification);
      expect(
        await GetNotificationsUseCase(work)
            .execute('client-1', unreadOnly: true),
        hasLength(1),
      );
      await MarkNotificationReadUseCase(work)
          .execute(userId: 'client-1', notificationId: notification.id);
      expect(
        await GetNotificationsUseCase(work)
            .execute('client-1', unreadOnly: true),
        isEmpty,
      );

      final toggle = ToggleFavoriteUseCase(work);
      expect(
        await toggle.execute(
          userId: 'freelancer-1',
          targetType: FavoriteTargetType.job,
          targetId: 'job-1',
        ),
        isTrue,
      );
      expect(
        await GetFavoritesUseCase(work).execute('freelancer-1'),
        hasLength(1),
      );
      expect(
        await toggle.execute(
          userId: 'freelancer-1',
          targetType: FavoriteTargetType.job,
          targetId: 'job-1',
        ),
        isFalse,
      );
      expect(await GetFavoritesUseCase(work).execute('freelancer-1'), isEmpty);
    },
  );

  test('categories are returned from the category repository', () async {
    work.seedCategory(const Category(id: 'mobile', name: 'Mobile'));
    expect(await GetCategoriesUseCase(work).execute(), hasLength(1));
  });

  test(
    'authentication use cases validate input and delegate to provider',
    () async {
      final auth = _FakeAuthRepository();
      final signUp = SignUpUseCase(auth);
      expect(
        () => signUp.execute(
          email: 'invalid',
          password: 'short',
          displayName: '',
          role: UserRole.client,
        ),
        throwsArgumentError,
      );
      final user = await signUp.execute(
        email: ' CLIENT@example.com ',
        password: 'secure-password',
        displayName: ' Client One ',
        role: UserRole.client,
      );
      expect(user.email, 'client@example.com');
      expect(user.displayName, 'Client One');
      expect(await GetCurrentUserUseCase(auth).execute(), user);
      await SignInUseCase(auth)
          .execute(email: user.email, password: 'secure-password');
      expect(await SignInWithGoogleUseCase(auth).execute(), user);
      await SendPasswordResetUseCase(auth).execute('client@example.com');
      await SignOutUseCase(auth).execute();
      expect(await GetCurrentUserUseCase(auth).execute(), isNull);
    },
  );
}

class _FakeAuthRepository implements AuthRepository {
  User? currentUser;

  @override
  Future<User?> getCurrentUser() async => currentUser;

  @override
  Future<User> signIn({required String email, required String password}) async {
    final user = currentUser;
    if (user == null || user.email != email) {
      throw StateError('Invalid credentials.');
    }
    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final user = currentUser;
    if (user == null) throw StateError('No Google session.');
    return user;
  }

  @override
  Future<void> signOut() async => currentUser = null;

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    currentUser = User(
      id: 'new-user',
      email: email,
      displayName: displayName,
      role: role,
      createdAt: DateTime.now(),
    );
    return currentUser!;
  }
}
