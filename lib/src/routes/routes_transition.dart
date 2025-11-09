import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlassmorphicTransition extends CustomTransitionPage<void> {
  GlassmorphicTransition({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.transitionDuration = const Duration(milliseconds: 400),
    super.reverseTransitionDuration = const Duration(milliseconds: 350),
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final smoothCurve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return Stack(
              children: [
                // Previous screen fade out
                FadeTransition(
                  opacity: Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(
                    CurvedAnimation(
                      parent: secondaryAnimation,
                      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
                    ),
                  ),
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                
                // Subtle glow effect
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Positioned.fill(
                      child: IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 0.7,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.1, 0.6, curve: Curves.easeInOut),
                            ),
                          ).value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: const Alignment(0.0, 0.8),
                                radius: 0.8,
                                colors: [
                                  const Color(0xFF0066FF).withOpacity(0.15),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // New screen slide up with fade
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(smoothCurve),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
                      ),
                    ),
                    child: child,
                  ),
                ),
                
                // Progressive blur effect with gradient
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: MediaQuery.of(context).size.height * (1 - smoothCurve.value),
                      child: IgnorePointer(
                        ignoring: true,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.9),
                                Colors.white,
                              ],
                              stops: const [0.0, 0.3, 0.6],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstOut,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY: 5,
                            ),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Edge highlight effect
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 80,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 0.4,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
                            ),
                          ).value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  const Color(0xFF0066FF).withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
}

class SlideUpTransition extends CustomTransitionPage<void> {
  SlideUpTransition({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.transitionDuration = const Duration(milliseconds: 400),
    super.reverseTransitionDuration = const Duration(milliseconds: 350),
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final smoothCurve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            
            return Stack(
              children: [
                // Previous screen fade out
                FadeTransition(
                  opacity: Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(
                    CurvedAnimation(
                      parent: secondaryAnimation,
                      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
                    ),
                  ),
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                
                // New screen with slide and fade
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(smoothCurve),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
                    ),
                    child: child,
                  ),
                ),
                
                // Bottom edge glow
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 100,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 0.3,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
                            ),
                          ).value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  const Color(0xFF0066FF).withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
}

/// Horizontal slide transition for offcanvas menu navigation
/// Pages slide in from right to left when navigating forward
/// Pages slide out from left to right when navigating back
class HorizontalSlideTransition extends CustomTransitionPage<void> {
  HorizontalSlideTransition({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.transitionDuration = const Duration(milliseconds: 350),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final smoothCurve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            
            final secondarySmoothCurve = CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOut,
            );
            
            return Stack(
              children: [
                // Current page sliding out (to the left when going forward)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(-0.25, 0.0),
                  ).animate(secondarySmoothCurve),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 1.0,
                      end: 0.3,
                    ).animate(
                      CurvedAnimation(
                        parent: secondaryAnimation,
                        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
                      ),
                    ),
                    child: Container(color: Colors.black),
                  ),
                ),
                
                // New page sliding in (from the right when going forward)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(smoothCurve),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
                    ),
                    child: child,
                  ),
                ),
                
                // Subtle shadow on the edge of the entering page
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 20,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 0.5,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
                            ),
                          ).value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
}

/// Reverse horizontal slide transition for returning from offcanvas navigation
/// Pages slide out to the right when navigating back
/// Offcanvas menu slides in from the left when returning
class ReverseHorizontalSlideTransition extends CustomTransitionPage<void> {
  ReverseHorizontalSlideTransition({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.transitionDuration = const Duration(milliseconds: 350),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final smoothCurve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            
            final secondarySmoothCurve = CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOut,
            );
            
            return Stack(
              children: [
                // Current page sliding out (to the right when going back)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(1.0, 0.0),
                  ).animate(secondarySmoothCurve),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 1.0,
                      end: 0.3,
                    ).animate(
                      CurvedAnimation(
                        parent: secondaryAnimation,
                        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
                      ),
                    ),
                    child: Container(color: Colors.black),
                  ),
                ),
                
                // Offcanvas sliding in (from the left when going back)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.25, 0.0),
                    end: Offset.zero,
                  ).animate(smoothCurve),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
                    ),
                    child: child,
                  ),
                ),
                
                // Subtle shadow on the edge of the entering page
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 20,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 0.5,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
                            ),
                          ).value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
}
