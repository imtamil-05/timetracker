import 'dart:async';
import 'package:slider_button/slider_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({ Key? key }) : super(key: key);

  @override
  HomepageViewState createState() => HomepageViewState();
}

class HomepageViewState extends State<HomepageView> {
  String buttonText="Check In";
  String currentTime="";
  DateTime? checkinTime;
  DateTime? checkoutTime;
  Duration totalTime=Duration.zero;
  Timer? timer;
  bool isChecked = false;
  StreamController<bool> radioController=StreamController<bool>.broadcast();
  bool isRadioChecked = false;
  bool sliderCompleted = false;
  @override
  void initState() {
    super.initState();
    startTimer();
    radioController.add(isRadioChecked);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('hh:mm:ss a').format(DateTime.now()); 
    });
    });
  }

  void dispose(){
    timer?.cancel();
    radioController.close();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
    
  }

  void handleButtonClick(){
   if (buttonText == "Check In"){
    showModal("Check In");
   }else{
    showModal("Check Out");
   }
  }
  
  


  void showModal(String action){
    radioController.add(false);
    setState(() {
      sliderCompleted = false;
    });
    
    showModalBottomSheet(
      context: context, 
      builder: (contex){
        return StreamBuilder<bool>(
          stream: radioController.stream,
          builder: (context, snapshot) {
            bool isChecked = snapshot.data ?? false;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          
                          radius: 23,
                          backgroundImage: AssetImage('assets/images/people.jpeg',),
                          backgroundColor: Colors.black,
                        ),
                      
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RIS Pvt Ltd',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
                            Text('17 Corporate Avenue, Coimbatore',style: TextStyle(fontSize: 10,color: Colors.grey),),
                          ],
                        ),
                         SizedBox(width: 15,),
                           Radio<bool>(
                              value: true, 
                              groupValue: isChecked,
                              onChanged: (value){
                                radioController.add(value??false);
                              },
                              ),  
                               
                            
                          ],
                        ),
                        
                     
                    SizedBox(height: 20),
                    Center(
                      child: sliderCompleted
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 30, 
                           ),
                        ],
                       )

                      : SliderButton(
                       action: () async { 
                        if (isChecked){
                          setState(() {
                            sliderCompleted = true;
                          });
                          Navigator.pop(context);
                          if (buttonText=="Check In") {
                            handleCheckIn();
                          }else{
                            handleCheckOut();
                          }
                          return true;
                          }else {
                            Fluttertoast.showToast(
                              msg: "Please check the box to confirm.",
                              backgroundColor: Colors.red,
                              textColor: Colors.black,
                              );
    

                             return false;
                          }
                        },
                      label: Center(child: Text("Swipe to complete",style: TextStyle(fontSize: 10,color: Colors.white),)),
                      icon: Icon(Icons.arrow_forward,color: Colors.black,size:18,),
                      backgroundColor: isChecked ? Colors.blue : Colors.grey,
                      //highlightedColor: Colors.lightBlue,
                      width: 300,
                      height: 50,
                      radius: 40,
                      baseColor: Colors.white,
                      buttonSize: 30,
                    ),
                    )
                  ],
                ),
                ),
              
            
        );
          }
        );
      },
    );    
  }

  void handleCheckIn(){
  setState(() {
    buttonText="Check Out";
    checkinTime=DateTime.now();
  });
  Fluttertoast.showToast(
    msg: "Check In Successful",
    backgroundColor: Colors.green,
    textColor: Colors.white,
    );
  }

  void handleCheckOut(){
  setState(() {
    buttonText="Check In";
    checkoutTime=DateTime.now();
    totalTime=checkoutTime!.difference(checkinTime!);
  });
  Fluttertoast.showToast(
    msg: "Check Out Successful",
    backgroundColor: Colors.red,
    textColor: Colors.white,
    );
  }

  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        
        child:Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
                
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const Card(
                
                 color: Colors.black,
                child: ListTile(
                  title: Text('Hi Rishi!!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                  subtitle: Text('Good Morning!',style: TextStyle(fontSize: 15,color: Colors.grey),),
                  trailing: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/people.jpeg'),
                    backgroundColor: Colors.transparent,
                  ),
                )
                           ),
          
               SizedBox(height: 50),
          
               Text(
                currentTime,
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,)),
               SizedBox(height: 10),
          
               Text(DateFormat('dd MMMM yyyy - EEEE').format(DateTime.now()),style: TextStyle(fontSize: 15,)),
               SizedBox(height: 40),
               GestureDetector(
                 onTap: handleButtonClick,
                 
                 child: Container(
                  decoration:BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300,width: 2, ),
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors:[Color(0xFFC8C8C8),Color(0xFFE8E8E8)],

                    ),
                    //color: Colors.grey.shade400,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]
                  ),
                  
                  padding: EdgeInsets.all(50),
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_outlined,size: 30,color: buttonText=="Check In" ? Colors.white : Colors.red ,),
                      SizedBox(height: 10,),
                      Text(buttonText,style: TextStyle(fontSize: 20,color: buttonText=="Check In" ? Colors.black : Colors.red),),
          
                    ],
                  )
                 )
               ),
               SizedBox(height: 30),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  timeTracking('Check In',checkinTime),
                  timeTracking('Check Out',checkoutTime),
                  timeTracking('Total Hours',totalTime.inSeconds==0 ? "--:--:--":formatDuration(totalTime)),
          
                ],
               ),
          
               ],),
        )

          
        ) 
      
      
    );
  }

  Widget timeTracking(String label,dynamic value){
    return Column (children: [
      Icon(label == 'Check In' ? Icons.login : (label == 'Check Out' ? Icons.logout : Icons.access_time),size: 30,),
      SizedBox(height: 10,),
      Text(label,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
      SizedBox(height: 10,),
       Text(value != null ?(value is DateTime ? DateFormat('hh:mm:ss a').format(value):value):"--:--:--",style:TextStyle(fontSize: 15,)),
    ],);
  }
}