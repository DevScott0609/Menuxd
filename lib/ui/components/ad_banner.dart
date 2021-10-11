import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../models/ad.dart';
import 'ad_widget.dart';

class AdBanner extends StatefulWidget {
  final List<Ad> ads;
  final Key key;
  AdBanner(this.ads, {this.key});

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  List list1;
  List list2;

  @override
  Widget build(BuildContext context) {
    final l = widget.ads.length;
    list1 = [];
    list2 = [];
    for (int i = 0; i < l; i++) {
      final ad = widget.ads[i];
      if ((i % 2) == 0) {
        list1.add(ad);
      } else {
        list2.add(ad);
      }
    }
    return SizedBox(
      height: 120,
      child: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Row(children: getList())),
    );
  }

  List<Widget> getList() {
    return [
      Expanded(
        child: SizedBox(
          width: 425,
          child: Swiper(
            itemCount: list1.length,
            itemBuilder: (context, index) {
              final ad = list1[index];
              return AdWidget(ad);
            },
            autoplay: true,
            autoplayDelay: 10 * 1000,
          ),
        ),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: SizedBox(
          width: 425,
          child: Swiper(
            key: widget.key,
            itemCount: list2.length,
            itemBuilder: (context, index) {
              final ad = list2[index];
              return AdWidget(ad);
            },
            autoplay: true,
            autoplayDelay: 10 * 1000,
          ),
        ),
      ),
      SizedBox(
        width: 15,
      ),
    ];
  }
}
