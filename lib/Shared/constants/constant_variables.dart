import 'package:my_todo_app/Shared/constants/assets_path.dart';
import 'package:my_todo_app/data/models/onboarding_model.dart';

List<OnBoardingModel> onboardinglist = const [
  OnBoardingModel(
    img: MyAssets.onboardingOne,
    title: 'Manage Your Task',
    description:
        'With This Small App You Can Orgnize All Your Tasks and Duties In A One Single App.',
  ),
  OnBoardingModel(
    img: MyAssets.onboardingTwo,
    title: 'Plan Your Day',
    description: 'Add A Task And The App Will Remind You.',
  ),
  OnBoardingModel(
    img: MyAssets.onboardingThree,
    title: 'Accomplish Your Goals ',
    description: 'Track Your Activities And Accomplish Your Goals.',
  ),
];