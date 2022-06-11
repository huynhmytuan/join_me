import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PhotoViewGallery.builder(
                itemCount: widget.imageList.length,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                  if (index == 0 || index == widget.imageList.length - 1) {
                    setState(() {
                      _isShowed = true;
                    });
                  }
                },
                builder: (context, index) =>
                    PhotoViewGalleryPageOptions.customChild(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: Key(widget.imageList[index]),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      open(context, index);
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.imageList[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            if (_isShowed && widget.imageList.length > 1)
              _imageCountLabel(context),
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

  void open(BuildContext context, final int index) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          imgUrls: widget.imageList,
          backgroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(.2),
          ),
          initialIndex: index,
        ),
      ),
    );
  }

  Positioned _imageCountLabel(BuildContext context) {
    Future<void>.delayed(const Duration(seconds: 3)).then((v) {
      setState(() {
        _isShowed = false;
      });
    });
    return Positioned(
      top: 5,
      right: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.4),
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          '${_current + 1} / ${widget.imageList.length}',
          style:
              CustomTextStyle.bodyMedium(context).copyWith(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.imgUrls,
    this.scrollDirection = Axis.horizontal,
    Key? key,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> imgUrls;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AutoRouter.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.imgUrls.length,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: widget.imgUrls.length,
                  effect: ScrollingDotsEffect(
                    dotColor: kIconColorGrey,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotWidth: 5,
                    dotHeight: 5,
                    spacing: 4,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final itemUrl = widget.imgUrls[index];
    return PhotoViewGalleryPageOptions.customChild(
      child: CachedNetworkImage(
        imageUrl: itemUrl,
        fit: BoxFit.fitWidth,
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: Key(itemUrl)),
    );
  }
}
