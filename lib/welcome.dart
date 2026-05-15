import 'package:flutter/material.dart';
import 'home.dart'; 

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/welcome.jpg"),
            fit:BoxFit.cover)
          
        ),
        
        
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 15),
          child: Column(
            
            children: [

              const SizedBox(height: 50,),
               //  Welcome Title
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.amber,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "LankaGo!",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.yellow,
                ),
              ),
          
              const SizedBox(height: 30),
          
          
              //  Logo Image
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/Logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          
              const SizedBox(height: 90),
          
             
          
              //  Success Message
              Container(
                width: double.infinity,
                

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black.withOpacity(0.4),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text(
                        "Your account has been created successfully",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.yellowAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  
                      const SizedBox(height: 20),
                            
                                const Text(
                  "Start exploring personalized travel experiences with LankaGo.",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                                ),
                    ],
                  ),
                ),
              ),
          
              
          
              const SizedBox(height: 150),
          
              //  Go to Home Button
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    icon: const Icon(Icons.travel_explore, color: Colors.brown),
                    label: const Text(
                      "Go to Home",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
