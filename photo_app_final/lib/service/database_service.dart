import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_app_final/model/photoapp.dart';


const String PHOTO_APP_REF ='photoAppFire';

class DatabaseService{
  final _firestore =FirebaseFirestore.instance;

  late final CollectionReference _photoRef;
  late String _currentSortValue;
 
 

DatabaseService() {
    _photoRef =_firestore.collection(PHOTO_APP_REF).withConverter<PhotoApp>(
      fromFirestore: ((snapshots, _) => PhotoApp.fromJson(snapshots.data()!) ), 
      toFirestore:  (photos,_)=> photos.toJson() );
      _currentSortValue='default';
      
}

void addPhotos(PhotoApp photos) async {
  _photoRef.add(photos);
}


void updatePhoto (String photoId,PhotoApp photo) {
   _photoRef.doc(photoId).update(photo.toJson());
 }

void deletePhoto(String photoId) {
  _photoRef.doc(photoId).delete();
 }

Future<List<String>> getPhotographerNamesSync() async {
  List<String> photographerNames = [];
  QuerySnapshot snapshot = await _photoRef.get();
  for (var doc in snapshot.docs) {
    String photographerName = doc.get('photographerName');
    if (!photographerNames.contains(photographerName)) {
      photographerNames.add(photographerName);
    }
  }
  return photographerNames;
}

  Stream<QuerySnapshot> retrievePhotos(){
    return _photoRef.snapshots();
  }


void setSortingValue(String sortValue){
  _currentSortValue=sortValue;

}
 

Stream<QuerySnapshot> getSortedPhotos() {
    var ss=_currentSortValue;
  Query query=_photoRef;
  switch(_currentSortValue) {
    case 'timeLatest':
        query=query.orderBy('createdTime', descending: true);
        break;
    case 'photographerNames':
        query=query.orderBy('photographerName');
        break;
    case 'favourites':
        query=query.orderBy('isLiked', descending: true);
        break;
    case 'liked':
        query=query.where('isLiked', isEqualTo: true);
        break;
    case 'unLiked':
        query=query.where('isLiked', isEqualTo: false);
        break;
    case 'default':
         query=query.where('photographerName');
         break;
    
    default:
        query=query.where('photographerName', isEqualTo: ss);
        break;
      
  }

 
 
  return query.snapshots();
}

}

