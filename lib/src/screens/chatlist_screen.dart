import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony/src/theme/app_styles.dart';
import 'package:harmony/src/widgets/animated_search_field.dart';
import 'package:harmony/src/widgets/dotted_circle_icon.dart';
import 'package:harmony/src/widgets/profile_image.dart';
import 'package:harmony/src/widgets/status_images.dart';

import '../models/chat_model.dart';
import '../widgets/date_text.dart';
import 'chat_details_screen.dart';

class ChatlistScreen extends StatelessWidget {
  const ChatlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Chat> chats = [
      Chat(
          profileImageUrl: 'assets/images/profile02.png',
          userName: 'Smith Mathew',
          recentMessage: "Hi, David. Hope you're doing well",
          lastReceivedMessageTime: DateTime(2023, 3, 29),
          statusImages: ['assets/images/profile02.png'],
          unreadMessages: 2),
      Chat(
        profileImageUrl: 'assets/images/profile01.png',
        userName: 'Merry An.',
        recentMessage: "Are you ready for today's class?",
        lastReceivedMessageTime: DateTime(2023, 3, 12),
        statusImages: [],
      ),
      Chat(
        profileImageUrl: 'assets/images/profile03.png',
        userName: 'John Walton',
        recentMessage: "I'm sending you a parcel received.",
        lastReceivedMessageTime: DateTime(2023, 2, 8),
        statusImages: [],
      ),
      Chat(
        profileImageUrl: 'assets/images/profile05.png',
        userName: 'Monica Randawa',
        recentMessage: "Hope you're doing well today.",
        lastReceivedMessageTime: DateTime(2023, 2, 2),
        statusImages: [],
      ),
      Chat(
        profileImageUrl: 'assets/images/profile07.png',
        userName: 'Innoxent Jay',
        recentMessage:
            "Let's get back to the work, Don't forget to take your laptop",
        lastReceivedMessageTime: DateTime(2023, 1, 25),
        statusImages: [],
      ),
      Chat(
        profileImageUrl: 'assets/images/profile08.png',
        userName: 'Harry Samit',
        recentMessage: "Listen david, i have a problem",
        lastReceivedMessageTime: DateTime(2023, 1, 18),
        statusImages: [],
      ),
    ];

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 20.w,
                  top: MediaQuery.of(context).viewPadding.top,
                  bottom: 14.w),
              child: Text(
                "Chats",
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
            ),
            const AnimatedSearchField(),
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 35.h, bottom: 33.h),
              child: Row(
                children: [
                  const DottedCircleIcon(),
                  SizedBox(
                    width: 7.w,
                  ),
                  const StatusImages(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        EdgeInsets.only(right: 10.w, left: 10.w, bottom: 39.h),
                    height: 54.h,
                    width: double.infinity,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatDetailsScreen(chat: chats[index]),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ProfileImage(
                            image: chats[index].profileImageUrl,
                            hasStatus: chats[index].statusImages.isNotEmpty,
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      chats[index].userName,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleMedium,
                                    ),
                                    Visibility(
                                      visible: chats[index].unreadMessages != 0,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.w),
                                        child: Container(
                                          width: 14.w,
                                          height: 14.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                                chats[index]
                                                    .unreadMessages
                                                    .toString(),
                                                style:
                                                    AppStyles.badgeTextStyle),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    DateText(
                                      date:
                                          chats[index].lastReceivedMessageTime,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 240.w,
                                  child: Text(
                                    chats[index].recentMessage,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: chats[index].unreadMessages ==
                                                  0
                                              ? Theme.of(context)
                                                  .primaryTextTheme
                                                  .labelMedium!
                                                  .color!
                                                  .withOpacity(
                                                      0.7) // Darker text color
                                              : Theme.of(context)
                                                  .primaryTextTheme
                                                  .labelMedium!
                                                  .color,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
