import 'package:worklyapp/domain/entities/chat.dart';
import 'package:worklyapp/domain/repositories/chat_repository.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';

class StartChatUseCase {
  static int _idSequence = 0;
  const StartChatUseCase(this.contracts, this.chats);
  final ContractRepository contracts;
  final ChatRepository chats;

  Future<Chat> execute({
    required String contractId,
    required String requesterId,
  }) async {
    final contract = await contracts.getContractById(contractId);
    if (contract == null) throw StateError('Contract not found.');
    final participants = [contract.clientId, contract.freelancerId];
    if (!participants.contains(requesterId)) {
      throw StateError('Only contract participants can start a chat.');
    }
    final existing = await chats.getChatForJobAndParticipants(
      contract.jobId,
      participants,
    );
    if (existing != null) return existing;
    final now = DateTime.now();
    return chats.createChat(
      Chat(
        id: 'chat_${now.microsecondsSinceEpoch}_${_idSequence++}',
        participantIds: participants,
        jobId: contract.jobId,
        updatedAt: now,
      ),
    );
  }
}
