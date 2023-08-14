import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqlite_data/config/colors.dart';
import 'package:sqlite_data/database/database_helper.dart';
import 'package:sqlite_data/screen/todo_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  List<Map<String, dynamic>> myData = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the data when the app starts
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

// Insert a new data to the database
  Future<void> addItem() async {
    await DatabaseHelper.createItem(
      _titleController.text,
      _descriptionController.text,
    );
    _refreshData();
  }

  // Update an existing data
  Future<void> updateItem(int id) async {
    await DatabaseHelper.updateItem(
      id,
      _titleController.text,
      _descriptionController.text,
    );
    _refreshData();
  }

  // Delete an item
  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted!'),
        backgroundColor: Colors.green,
      ),
    );
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        title: const Text('ToDo Notes'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : myData.isEmpty
              ? const Center(
                  child: Text("Data is Not Available"),
                )
              : GridView.builder(
                  itemCount: myData.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 11.w,
                        right: 11.w,
                        top: 14.h,
                      ),
                      child: Container(
                        height: 180.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TodeViewer(),
                              ),
                            );
                          },
                          onLongPress: () {
                            deleteDialog();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 20.h,
                              left: 8.w,
                              right: 4.w,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  myData[index]['title'],
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  myData[index]['description'],
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                              // trailing: SizedBox(
                              //   width: 100,
                              // child: Row(
                              //   children: [
                              //     IconButton(
                              //       icon: const Icon(Icons.edit),
                              //       onPressed: () =>
                              //           dialogSheet(myData[index]['id']),
                              //     ),
                              //     IconButton(
                              //       icon: const Icon(Icons.delete),
                              //       onPressed: () =>
                              //           deleteItem(myData[index]['id']),
                              //     ),
                              //   ],
                              // ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.appBarColor,
        child: const Icon(Icons.add),
        onPressed: () => dialogSheet(null),
      ),
    );
  }

  void dialogSheet(int? id) async {
    if (id != null) {
      final existingData = myData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
    } else {
      _titleController.text = "";
      _descriptionController.text = "";
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    color: AppColors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                "Add Notes",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: TextFormField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    // hintStyle: dialog1,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.deepGreen,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.deepGreen,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.deepGreen,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: TextFormField(
                                  maxLines: 8,
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                    // hintStyle: dialog1,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.deepGreen),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.deepGreen),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.deepGreen),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'message_cannot_empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 42.h,
                                width: 107.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: AppColors.appBarColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (id == null) {
                                    await addItem();
                                  }
                                  if (id != null) {
                                    await updateItem(id);
                                  }

                                  // Clear the text fields
                                  setState(() {
                                    _titleController.text = '';
                                    _descriptionController.text = '';
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: 42.h,
                                width: 107.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: AppColors.appBarColor,
                                ),
                                child: Center(
                                  child: Text(
                                    id == null ? 'save' : 'Update',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
  }

  deleteDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          child: Container(
            height: 100.h,
            width: 210.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    "আপনি কি নোটটি ডিলিট করতে চাচ্ছেন",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 32.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            // color: AppColors.appBarColor,
                          ),
                          child: const Center(
                            child: Text(
                              'না',
                              textAlign: TextAlign.center,
                              // style: dialog2,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // deleteItem(myData[index]['id']);
                          // Close the bottom sheet
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 32.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            // color: AppColors.appBarColor,
                          ),
                          child: const Center(
                            child: Text(
                              'হ্যা',
                              textAlign: TextAlign.center,
                              // style: dialog2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
