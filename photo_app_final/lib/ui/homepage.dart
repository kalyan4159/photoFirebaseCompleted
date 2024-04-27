import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:photo_app_final/model/photoapp.dart';
import 'package:photo_app_final/service/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<String> photoNameList;
  List<Map<String, String>> filteringList = [];

  @override
  void dispose() {
   nameController.dispose();
   imageURLController.dispose();
   descriptionController.dispose();
    super.dispose();
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final  DatabaseService _databaseService=DatabaseService();
   String _selectedSortingCriteria = 'default';
    

  @override
  void initState() {
    _selectedSortingCriteria = 'default'; 
   _databaseService.setSortingValue(_selectedSortingCriteria);
   _datafetchingList();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar:_appbar(),
      
      body: _messagesListView(),

      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (context) {
            return Center(child: _formPage());
        });
        },
        backgroundColor: Colors.deepOrange,shape: const CircleBorder(),
        child:const Icon(Icons.add,color: Colors.white,),),
    );
    
  }

  void _updateSortingMethod(String criteria) {
    _selectedSortingCriteria=criteria;
    _databaseService.setSortingValue(criteria);
    setState(() {
    });
  }
void _datafetchingList() async{
      List<String> nameList =await _databaseService.getPhotographerNamesSync();
      filteringList.add({'title': 'default', 'criteria': 'default'},);
      filteringList.add({'title': 'liked', 'criteria': 'liked'},);
      filteringList.add({'title': 'unLiked', 'criteria': 'unLiked'},);
       for(String name in nameList) {
      
        setState(() {
          filteringList.add({'title':name,'criteria':name});
        });
      }
    }
    
  PreferredSizeWidget _appbar(){
    List<Map<String,String>> sortingList=[
      {'title': 'Default', 'criteria': 'default'},
      {'title': 'Time - Latest Last', 'criteria': 'timeLatest'},
      {'title': 'Photographer', 'criteria': 'photographerNames'},
      {'title': 'Favorites', 'criteria': 'favourites'},
    ];

    return AppBar(
           title: const  Text('Photo Gallery',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white70),),
           actions: [
           IconButton( icon: const Icon(Icons.filter_list,color: Colors.white70,),onPressed: (){
            
                showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          top: 50,
                           right: 5,
                          child: AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: sortingList.map((item) {
                                return CheckboxListTile(
                              title: Text(item['title']!),
                              value: _selectedSortingCriteria == item['criteria'],
                               onChanged: (value) {
                                 setState(() {
                                     _selectedSortingCriteria = item['criteria']!;
                                    _updateSortingMethod(item['criteria']!);
                                   });
                                  
                                },
                           );
                      }).toList(),
                                   ),
                                 ),
                              ),
                           ],
                        );
                  }
                );
  },
); 
           }),
          IconButton(
          icon: Icon(Icons.filter_list, color: Colors.white70),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Stack(
                      children: [
                        Positioned(
                          top: 50,
                           right: 5,
                          child: AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: filteringList.map((item) {
                                return CheckboxListTile(
                              title: Text(item['title']!),
                              value: _selectedSortingCriteria == item['criteria'],
                               onChanged: (value) {
                                 setState(() {
                                  if (value != null && value) {
                                     _selectedSortingCriteria = item['criteria']!;
                                    _updateSortingMethod(item['criteria']!);
                          }
                                   });
                                },
                           );
                      }).toList(),
                                   ),
                                 ),
                              ),
                           ],
                        );
                  }
                );
  },
);  },), ],
     backgroundColor: const Color(0xFF4A4C50),
    );
   } 
   Widget _messagesListView() {
        return Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: SizedBox(
        child: StreamBuilder(
        stream: _databaseService.getSortedPhotos(),
        builder: (context, snapshot) {
        List photos = snapshot.data?.docs ?? [];
        if (photos.isEmpty) {
        return const Center(
          child: Text('Add a Details'),
        );
        }
        return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1000
                      ? 5
                      : MediaQuery.of(context).size.width > 800
                      ? 3
                      : MediaQuery.of(context).size.width > 500
                      ? 2
                      : 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 5.0,  
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
        PhotoApp photoss = photos[index].data();
        String photoId = photos[index].id;
        return  ClipRRect(
       borderRadius: BorderRadius.circular(10),
       child: Container(
       decoration: BoxDecoration(
       image: DecorationImage(
        image: NetworkImage(photoss.photoURL),
        fit: BoxFit.cover,
      ),
    ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               IconButton(onPressed: () { _databaseService.deletePhoto(photoId); },icon: Icon(Icons.delete),),
               IconButton(onPressed: () {
                  setState(() {
                    PhotoApp updatePhotoApp = photoss.copyWith(isLiked: !photoss.isLiked,);
                    _databaseService.updatePhoto(photoId, updatePhotoApp,);
                     });
                   },
                    icon: Icon(Icons.favorite),color: photoss.isLiked ? Colors.red : Colors.orange,
                ),
              ],
            ),
          ],
        ),
        Align(
          
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(photoss.description,style: TextStyle(color: Colors.white),),
              ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( DateFormat("dd MMM, yyyy").format(photoss.createdTime.toDate()), style: TextStyle(color: Colors.white), ),
                    Text(photoss.photographerName,style: TextStyle(color: Colors.white),),
                  ],
                 ),
               ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);
},
 );
},
),
 ),
);
   }

   Widget _formPage(){
    Color myOrangeColor = Color(0xFFF68F50);
    double textWidthSize = 150;
    double boxWidth=300;
    return SingleChildScrollView(
      child: Builder(builder: 
         (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.grey, width: 2.0),
               ),
              title: const Center(
              child: Text('Add Photo',style: TextStyle( fontSize: 18,fontWeight: FontWeight.w900, ),),
        ),
        content: Form(  key: _formkey,
                        child: SizedBox(
                           width: boxWidth,
                           child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Row(
                                  children: [
                                    SizedBox(width: textWidthSize, child: const Text('Photographer\'s Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                                    Expanded(
                                      child: TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Something';
                                  } else if (RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'Numbers are not allowed';
                                  }
                                  return null;
                                },
                                 decoration:  InputDecoration(
                                 
                                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.5)),
                                  enabledBorder: OutlineInputBorder(
                                     borderSide:  BorderSide(color: Colors.grey.withOpacity(0.5),),
                                  ),
                                  isDense: true,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                         ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                 children: [
                                   SizedBox(width: textWidthSize, child: const Text('Image URL',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                                    Expanded(
                                    child: TextFormField(
                                controller: imageURLController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Something';
                                  }
                                  return null;
                                },
                                 decoration:  InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.5)),
                                  enabledBorder: OutlineInputBorder(
                                     borderSide:  BorderSide(color: Colors.grey.withOpacity(0.5),),
                                  ),
                                  isDense: true,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                   ),
                                  ),
                                 ],
                               ),
                              ),
               
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Row(
                                 children: [
                                 SizedBox(width: textWidthSize, child: Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                                 Expanded(
                                 child: TextFormField(
                                controller: descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Something';
                                  }
                                  return null;
                                },
                                decoration:  InputDecoration(
                                 
                                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.5)),
                                  enabledBorder: OutlineInputBorder(
                                     borderSide:  BorderSide(color: Colors.grey.withOpacity(0.5),),
                                  ),
                                  isDense: true,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                   ),
                                 ),
                                 ],
                               ),
                              ),            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    MaterialButton(
                                      onPressed: () {
                              Navigator.of(context).pop();
                            },
                          
                            color: Color(0xffff6d00),
                            padding: EdgeInsets.only(left:40,right:40,top:14,bottom:14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              
                            ),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),
                            ),
                            ),
                            const SizedBox(width: 8.0),
                            MaterialButton(onPressed: (){
                            String photographerName = nameController.text;
                            String imageURL = imageURLController.text;
                            String description = descriptionController.text;

                            PhotoApp photoAppAddValue= PhotoApp(photographerName: photographerName.toLowerCase(), photoURL: imageURL, description: description, createdTime: Timestamp.now(), isLiked: false);
                            _databaseService.addPhotos(photoAppAddValue);
                            
                            Navigator.of(context).pop();
                            nameController.clear();
                            imageURLController.clear();
                            descriptionController.clear();           
                            },
                            color: Color(0xffff6d00),
                            padding: EdgeInsets.only(left:50,right: 50,top:14,bottom:14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                              child: Text('Add',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                             ),
                            ],
                            ), 
                            ],  
                           ), 
                           ),              
                        ),
       );
    }),
    );
   }
   
   
}