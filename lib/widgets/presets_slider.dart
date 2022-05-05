import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PresetsSlider extends StatefulWidget {
  const PresetsSlider({
    required this.imageList,
    Key? key,
  }) : super(key: key);
  final List<String> imageList;
  @override
  State<PresetsSlider> createState() => _PresetsSliderState();
}

class _PresetsSliderState extends State<PresetsSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.imageList.length,
          itemBuilder: (context, index, index_2) => SizedBox(
            width: double.infinity,
            child: Image.network(
              widget.imageList[index],
              fit: BoxFit.cover,
            ),
          ),
          options: CarouselOptions(
            enableInfiniteScroll: false,
            viewportFraction: 1,
            // enlargeCenterPage: true,
            onPageChanged: (index, changeReason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        if (widget.imageList.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageList.asMap().entries.map((entry) {
              return Container(
                width: _current == entry.key ? 7 : 6,
                height: _current == entry.key ? 7 : 6,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.4 : 0.2),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
