import 'package:trywidgests/app/home/models/job.dart';
import 'package:trywidgests/services/api_path.dart';
import 'package:trywidgests/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  FireStoreDatabase({required this.uid});

  final String uid;
  final _service = FireStoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
      path: APIPath.job(
        uid,
        job.id,
      ),
      data: job.toMap());

  @override
  Future<void> deleteJob(Job job)  => _service.deletedata(
      path: APIPath.job(uid, job.id));

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data,documentId) => Job.fromMap(data,documentId));
}
