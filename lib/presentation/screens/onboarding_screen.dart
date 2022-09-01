import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/Shared/constants/assets_path.dart';
import 'package:my_todo_app/Shared/constants/constant_variables.dart';
import 'package:my_todo_app/Shared/styles/colors.dart';
import 'package:my_todo_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:my_todo_app/data/shared_prefs.dart';
import 'package:my_todo_app/presentation/screens/welcome_screen_clone.dart';
import 'package:my_todo_app/presentation/widgets/circular_button.dart';
import 'package:my_todo_app/presentation/widgets/custom_dots.dart';
import 'package:my_todo_app/presentation/widgets/mybutton.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OnboardingCubit onCubit = BlocProvider.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const Spacer(),
                      MyButton(
                          color: Appcolors.buttonColor,
                          width: 20.w,
                          title: "Skip",
                          onPress: () {
                            if (onCubit.curruntindext <
                                onboardinglist.length - 1) {
                              _pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              onCubit.changeindex(index: 2);
                            }
                          }),
                    ],
                  );
                },
              ),
              Expanded(
                child: PageView.builder(
                  // onPageChanged: (index) {
                  //   onCubit.curruntindext = index;
                  // },
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return OnboardingItem(index: index);
                  }),
                  controller: _pageController,
                  itemCount: onboardinglist.length,
                ),
              ),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (onCubit.curruntindext > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              onCubit.removefromindex();
                            }
                          },
                          child: const Text("Back"),
                          style: TextButton.styleFrom(
                            primary: Colors.deepPurple,
                          )),
                      CustomDots(myindex: onCubit.curruntindext),
                      onCubit.curruntindext == 2
                          ? MyButton(
                              color: Colors.pink.withOpacity(0.6),
                              width: 22.w,
                              title: "Begin",
                              onPress: ()  {
                                Navigator.pushReplacementNamed(
                                    context, WelcomeScreen.routeName);
                                 SharedPrefs.setBool(key: 'seen',value: true);

                              })
                          : ElevatedButton(
                              onPressed: () {
                                if (onCubit.curruntindext <
                                    onboardinglist.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                  onCubit.changeindex();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Appcolors.pink.withOpacity(0.6),
                                  shape: const CircleBorder()),
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Icon(Icons.arrow_forward_rounded),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          onboardinglist[index].img,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          onboardinglist[index].title,
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 2.h,
        ),
        SizedBox(
          width: 80.w,
          child: Text(
            onboardinglist[index].description,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}














// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_todo_app/presentation/screens/welcome_screen_clone.dart';
// import 'package:sizer/sizer.dart';
// import 'package:my_todo_app/bloc/onboarding/onboarding_cubit.dart';
// import 'package:my_todo_app/presentation/widgets/circular_button.dart';
// import 'package:my_todo_app/presentation/widgets/custom_dots.dart';
// import 'package:my_todo_app/presentation/widgets/mybutton.dart';
// import 'package:my_todo_app/presentation/widgets/mycustompainter.dart';
// import 'package:my_todo_app/presentation/widgets/onboarding_item.dart';
// import 'package:my_todo_app/Shared/constants/constant_variables.dart';
// import 'package:my_todo_app/shared/styles/colors.dart';

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({Key? key}) : super(key: key);

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   late PageController _pageController;

//   @override
//   void initState() {
//     _pageController = PageController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: BlocConsumer<OnboardingCubit, OnboardingState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           OnboardingCubit cubit = BlocProvider.of(context);
//           return SafeArea(
//               child: Column(
//             children: [
//               Stack(
//                 alignment: Alignment.topCenter,
//                 children: [
//                   Container(
//                       width: 100.w,
//                       height: 95.h,
//                       color: Colors.deepPurple,
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10.w,
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     _pageController.previousPage(
//                                         duration:
//                                             const Duration(milliseconds: 500),
//                                         curve: Curves.easeIn);

//                                     cubit.curruntindext > 0
//                                         ? cubit.removefromindex()
//                                         : null;
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 20),
//                                     child: Text(
//                                       'Back',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headline1
//                                           ?.copyWith(
//                                             fontSize: 13.sp,
//                                             color: Colors.white38,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 CustomDots(myindex: cubit.curruntindext),
//                                 SizedBox(
//                                   width: 10.w,
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     width: 100.w,
//                     height: 90.h,
//                     child: CustomPaint(
//                       painter: const MycustomPainter(color: Appcolors.white),
//                       child: SizedBox(
//                         width: 80.w,
//                         height: 50.h,
//                         child: PageView.builder(
//                           itemCount: onboardinglist.length,
//                           physics: const NeverScrollableScrollPhysics(),
//                           controller: _pageController,
//                           itemBuilder: ((context, index) {
//                             return OnBoardingItem(
//                               index: index,
//                               image: onboardinglist[index].img,
//                               title: onboardinglist[index].title,
//                               description: onboardinglist[index].description,
//                             );
//                           }),
//                         ),
//                       ),
//                     ),
//                   ),
//                   cubit.curruntindext != onboardinglist.length - 1
//                       ? Align(
//                           alignment: Alignment.topRight,
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: MyButton(
//                                 color: Colors.deepPurple,
//                                 width: 19.w,
//                                 title: 'Skip',
//                                 onPress: () {
//                                   _pageController.animateToPage(
//                                       onboardinglist.length - 1,
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       curve: Curves.easeOut);
//                                   cubit.curruntindext <
//                                           onboardinglist.length - 1
//                                       ? cubit.skipindex()
//                                       : null;
//                                 }),
//                           ))
//                       : Container(),
//                   Positioned(
//                     bottom: 10.h,
//                     child: CircularButton(
//                         color: Appcolors.pink.withOpacity(0.6),
//                         width: 30.w,
//                         icon: Icons.arrow_right_alt_sharp,
//                         condition:
//                             cubit.curruntindext != onboardinglist.length - 1,
//                         func: () {
//                           _pageController.nextPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.easeInOut);
//                           if (cubit.curruntindext < onboardinglist.length - 1) {
//                             cubit.changeindex();
//                           } else {
//                             Navigator.pushReplacementNamed(
//                                 context, WelcomeScreen.routeName);
//                             cubit.savepref('seen');
//                           }
//                         }),
//                   ),
//                 ],
//               ),
//             ],
//           ));
//         },
//       ),
//     );
//   }
// }










