import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/Notification/Notification_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 120), () {
      _headerController.forward();
    });
    Future.delayed(const Duration(milliseconds: 320), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Color _tagColor(String tag) {
    switch (tag) {
      case 'مهم':
        return const Color(0xFFFFE8D6);
      case 'موعد':
        return const Color(0xFFEFF8FF);
      case 'تذكير':
        return const Color(0xFFEEF9F1);
      case 'رسالة':
        return const Color(0xFFF3F5FF);
      default:
        return const Color(0xFFF3F5FF);
    }
  }

  Color _tagTextColor(String tag) {
    switch (tag) {
      case 'مهم':
        return const Color(0xFFB36A00);
      case 'موعد':
        return const Color(0xFF2B7BE4);
      case 'تذكير':
        return const Color(0xFF1C9A54);
      case 'رسالة':
        return const Color(0xFF5B5FD6);
      default:
        return const Color(0xFF2B7BE4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<NotificationsController>(
        init: NotificationsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F8FB),
            body: Stack(
              children: [
                // خلفية الموج (علوي + سفلي خفيف)
                const _AnimatedWavesBackground(),
                controller.isLoading
                    ? Container()
                    : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedBuilder(
                              animation: _headerController,
                              builder: (context, child) {
                                final slide = Tween<Offset>(
                                  begin: const Offset(0, -0.18),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _headerController,
                                    curve: Curves.easeOutCubic,
                                  ),
                                );
                                final fade = Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _headerController,
                                    curve: Curves.easeIn,
                                  ),
                                );
                                return Opacity(
                                  opacity: fade.value,
                                  child: Transform.translate(
                                    offset: Offset(0, slide.value.dy * 36),
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4EA8FF),
                                      Color(0xFF2B7BE4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.18,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.notifications,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "التنبيهات",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "تنبيهاتك اليومية",
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.92,
                                                ),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                controller.newCount > 0
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(
                                                      0.16,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            "جديدة ${controller.newCount}",
                                            style: TextStyle(
                                              color:
                                                  controller.newCount > 0
                                                      ? const Color(0xFF2B7BE4)
                                                      : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 46,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: TextField(
                                                    onChanged:
                                                        controller.updateSearch,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    decoration:
                                                        const InputDecoration(
                                                          hintText:
                                                              'ابحث في التنبيهات...',
                                                          border:
                                                              InputBorder.none,
                                                          isCollapsed: true,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () => controller.markAllRead(),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.done_all,
                                              color: Color(0xFF2B7BE4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // فلترة حسب  (جميع - جديدة - مقروءة)
                            Row(
                              children:
                                  controller.filters.map((f) {
                                    final bool active =
                                        controller.selectedFilter == f;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => controller.changeFilter(f),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                active
                                                    ? Colors.white
                                                    : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color:
                                                  active
                                                      ? const Color(0xFF2B7BE4)
                                                      : Colors.grey.withOpacity(
                                                        0.18,
                                                      ),
                                              width: active ? 2 : 1,
                                            ),
                                            boxShadow:
                                                active
                                                    ? [
                                                      BoxShadow(
                                                        color: Colors.blueAccent
                                                            .withOpacity(0.10),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          6,
                                                        ),
                                                      ),
                                                    ]
                                                    : [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.02),
                                                        blurRadius: 4,
                                                        offset: const Offset(
                                                          0,
                                                          3,
                                                        ),
                                                      ),
                                                    ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              f,
                                              style: TextStyle(
                                                color:
                                                    active
                                                        ? const Color(
                                                          0xFF2B7BE4,
                                                        )
                                                        : Colors.grey[800],
                                                fontWeight:
                                                    active
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),

                            const SizedBox(height: 12),

                            Expanded(
                              child: AnimatedBuilder(
                                animation: _listController,
                                builder: (context, child) {
                                  final fade = Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _listController,
                                      curve: Curves.easeIn,
                                    ),
                                  );
                                  final slide = Tween<Offset>(
                                    begin: const Offset(0, 0.08),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _listController,
                                      curve: Curves.easeOut,
                                    ),
                                  );
                                  return Opacity(
                                    opacity: fade.value,
                                    child: Transform.translate(
                                      offset: Offset(0, slide.value.dy * 40),
                                      child: child,
                                    ),
                                  );
                                },
                                child:
                                    controller.filteredNotifications.isEmpty
                                        ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(height: 30),
                                              Icon(
                                                Icons.inbox,
                                                size: 48,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                "لا توجد تنبيهات",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : ListView.builder(
                                          padding: const EdgeInsets.only(
                                            bottom: 20,
                                          ),
                                          itemCount:
                                              controller
                                                  .filteredNotifications
                                                  .length,
                                          itemBuilder: (context, index) {
                                            final n =
                                                controller
                                                    .filteredNotifications[index];
                                            final bool isRead = n.isRead == 1;

                                            return Dismissible(
                                              key: ValueKey(n.id),
                                              direction:
                                                  DismissDirection.endToStart,
                                              confirmDismiss: (_) async {
                                                final res = await showDialog<
                                                  bool
                                                >(
                                                  context: context,
                                                  builder:
                                                      (ctx) => AlertDialog(
                                                        title: const Text(
                                                          'حذف الإشعار',
                                                        ),
                                                        content: const Text(
                                                          'هل تريد حذف هذا التنبيه؟',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      ctx,
                                                                      false,
                                                                    ),
                                                            child: const Text(
                                                              'إلغاء',
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      ctx,
                                                                      true,
                                                                    ),
                                                            child: const Text(
                                                              'حذف',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                                return res == true;
                                              },
                                              onDismissed: (_) {
                                                controller.removeNotification(
                                                  n.id,
                                                );
                                              },
                                              background: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent
                                                      .withOpacity(0.95),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.markAsRead(n.id);
                                                  // TODO: افتح تفاصيل الاشعار إذا لزم
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 260,
                                                  ),
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                      ),
                                                  padding: const EdgeInsets.all(
                                                    14,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isRead
                                                            ? Colors.white
                                                            : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          isRead
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                    0.08,
                                                                  )
                                                              : const Color(
                                                                0xFF2B7BE4,
                                                              ).withOpacity(
                                                                0.12,
                                                              ),
                                                      width: isRead ? 1 : 1.3,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                              isRead
                                                                  ? 0.03
                                                                  : 0.06,
                                                            ),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          6,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // أيقونة حسب  نوع الاشعار
                                                      Container(
                                                        width: 52,
                                                        height: 52,
                                                        decoration: BoxDecoration(
                                                          color: _tagColor(
                                                            n.type,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            n.type == "موعد"
                                                                ? Icons
                                                                    .calendar_today
                                                                : n.type ==
                                                                    "تذكير"
                                                                ? Icons
                                                                    .notifications
                                                                : n.type ==
                                                                    "رسالة"
                                                                ? Icons.message
                                                                : Icons.info,
                                                            color:
                                                                _tagTextColor(
                                                                  n.type,
                                                                ),
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(width: 12),

                                                      // محتوى الإشعار
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    n.title,
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15,
                                                                      color:
                                                                          isRead
                                                                              ? Colors.grey[800]
                                                                              : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // تاج الحالة (مثل: مهم)
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets.only(
                                                                        left: 8,
                                                                      ),
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        n.type ==
                                                                                "مهم"
                                                                            ? const Color(
                                                                              0xFFFFF4E5,
                                                                            )
                                                                            : const Color(
                                                                              0xFFEFF8FF,
                                                                            ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    n.type,
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          n.type ==
                                                                                  "مهم"
                                                                              ? const Color(
                                                                                0xFFB36A00,
                                                                              )
                                                                              : const Color(
                                                                                0xFF2B7BE4,
                                                                              ),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              n.body,
                                                              style: TextStyle(
                                                                color:
                                                                    isRead
                                                                        ? Colors
                                                                            .grey[600]
                                                                        : Colors
                                                                            .grey[700],
                                                                fontSize: 13,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  n.createdAt
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .grey[500],
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                // Row(
                                                                //   children: [
                                                                //     GestureDetector(
                                                                //       onTap: () {
                                                                //         controller
                                                                //             .toggleRead(
                                                                //               n.id,
                                                                //             );
                                                                //       },
                                                                //       child: Container(
                                                                //         padding: const EdgeInsets.symmetric(
                                                                //           horizontal:
                                                                //               8,
                                                                //           vertical:
                                                                //               6,
                                                                //         ),
                                                                //         decoration: BoxDecoration(
                                                                //           color:
                                                                //               isRead
                                                                //                   ? Colors.grey.shade100
                                                                //                   : const Color(
                                                                //                     0xFF2B7BE4,
                                                                //                   ),
                                                                //           borderRadius: BorderRadius.circular(
                                                                //             10,
                                                                //           ),
                                                                //         ),
                                                                //         child: Icon(
                                                                //           isRead
                                                                //               ? Icons.mark_email_read
                                                                //               : Icons.mark_email_unread,
                                                                //           size:
                                                                //               18,
                                                                //           color:
                                                                //               isRead
                                                                //                   ? Colors.grey
                                                                //                   : Colors.white,
                                                                //         ),
                                                                //       ),
                                                                //     ),
                                                                //     const SizedBox(
                                                                //       width: 8,
                                                                //     ),
                                                                //     GestureDetector(
                                                                //       onTap: () {
                                                                //         // placeholder: فتح المحادثة أو تنفيذ أمر
                                                                //       },
                                                                //       child: Container(
                                                                //         padding:
                                                                //             const EdgeInsets.all(
                                                                //               8,
                                                                //             ),
                                                                //         decoration: BoxDecoration(
                                                                //           color:
                                                                //               Colors.white,
                                                                //           borderRadius: BorderRadius.circular(
                                                                //             10,
                                                                //           ),
                                                                //           boxShadow: [
                                                                //             BoxShadow(
                                                                //               color: Colors.black.withOpacity(
                                                                //                 0.03,
                                                                //               ),
                                                                //               blurRadius:
                                                                //                   4,
                                                                //               offset: const Offset(
                                                                //                 0,
                                                                //                 2,
                                                                //               ),
                                                                //             ),
                                                                //           ],
                                                                //         ),
                                                                //         child: const Icon(
                                                                //           Icons
                                                                //               .chat,
                                                                //           size:
                                                                //               18,
                                                                //           color:
                                                                //               Colors.blueAccent,
                                                                //         ),
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// خلفية الموج المتحركة (علوي + سفلي خفيف)
class _AnimatedWavesBackground extends StatefulWidget {
  const _AnimatedWavesBackground();

  @override
  State<_AnimatedWavesBackground> createState() =>
      _AnimatedWavesBackgroundState();
}

class _AnimatedWavesBackgroundState extends State<_AnimatedWavesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // أسرع شوي
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // أعلى
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 180),
              painter: _WavePainter(_controller.value, isTop: true),
            ),
            // أسفل خفيف
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 120),
                painter: _WavePainter(_controller.value, isTop: false),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final bool isTop;
  _WavePainter(this.animationValue, {this.isTop = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF4EA8FF), Color(0xFF2B7BE4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

    final path = Path();
    final waveHeight = 18.0;
    final speed = animationValue * 2 * Math.pi;

    if (isTop) {
      path.moveTo(0, waveHeight * Math.sin(speed));
      for (double i = 0; i <= size.width; i++) {
        path.lineTo(
          i,
          waveHeight * Math.sin((i / size.width * 2 * Math.pi) + speed) + 70,
        );
      }
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else {
      path.moveTo(0, size.height - 50);
      for (double i = 0; i <= size.width; i++) {
        path.lineTo(
          i,
          size.height -
              50 +
              waveHeight * Math.sin((i / size.width * 2 * Math.pi) - speed),
        );
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => true;
}
