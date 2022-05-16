import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PresetsSlider extends StatefulWidget {
  const PresetsSlider({
    required this.imageList,
    Key? key,
  }) : super(key: key);
  final List<String> imageList;
  @override
  State<PresetsSlider> createState() => _PresetsSliderState();
}

class _PresetsSliderState extends State<PresetsSlider>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  late TransformationController transformationController;
  late AnimationController animationController;
  late Animation<Matrix4> animation;
  OverlayEntry? entry;
  bool _isShowed = true;

  @override
  void initState() {
    transformationController = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..addListener(() => transformationController.value = animation.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _removeOverlay();
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider.builder(
              itemCount: widget.imageList.length,
              itemBuilder: (context, index, index_2) => SizedBox(
                width: double.infinity,
                child: _buildImage(index),
              ),
              options: CarouselOptions(
                aspectRatio: 1,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, changeReason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            if (_isShowed && widget.imageList.length > 1)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.4),
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    '${_current + 1} / ${widget.imageList.length}',
                    style: CustomTextStyle.bodyMedium(context)
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        if (widget.imageList.length > 1)
          Padding(
            padding: const EdgeInsets.all(10),
            child: AnimatedSmoothIndicator(
              activeIndex: _current,
              count: widget.imageList.length,
              effect: ScrollingDotsEffect(
                dotColor: kIconColorGrey,
                activeDotColor: Theme.of(context).primaryColor,
                dotWidth: 5,
                dotHeight: 5,
                spacing: 4,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage(int index) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (widget.imageList.length <= 1) {
              return;
            }
            setState(() {
              _isShowed = !_isShowed;
            });
          },
          child: InteractiveViewer(
            transformationController: transformationController,
            minScale: 1,
            maxScale: 3,
            panEnabled: false,
            clipBehavior: Clip.none,
            onInteractionStart: (details) {
              if (details.pointerCount < 2) {
                return;
              }
              _showOverlay(context, index);
            },
            onInteractionEnd: (details) {
              _resetAnimation();
            },
            child: SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.imageList[index],
                placeholder: (context, url) => Container(
                  color: kIconColorGrey,
                ),
                errorWidget: (context, url, dynamic error) => Container(
                  color: kIconColorGrey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 24,
                        ),
                        Text(error.toString())
                      ],
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOverlay(BuildContext context, int index) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;
    entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(.7),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              width: size.width,
              child: _buildImage(index),
            ),
          ],
        );
      },
    );
    final overlay = Overlay.of(context);
    overlay!.insert(entry!);
  }

  void _removeOverlay() {
    entry?.remove();
    entry = null;
  }

  void _resetAnimation() {
    animation = Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
