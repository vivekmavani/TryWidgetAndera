import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
//private constroctor so can not genrate obj directly but using classname.instance
  FireStoreService._();
  //signlton object  create only ones
  static final instance = FireStoreService._();
  Future<void> setData({required String path,required Map<String,dynamic> data})async {
    final refence = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await refence.set(data);
  }

  Future<void> deletedata({required String path}) async{
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete : $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String,dynamic> data,String documentId) builder,
  })
  {
    final referance= FirebaseFirestore.instance.collection(path);
    final snapshots = referance.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map(
          (snapshot)=> builder(snapshot.data(),snapshot.id),
    ).toList(growable: true));
  }
}