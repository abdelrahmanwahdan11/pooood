import '../models/price_watch.dart';

abstract class PriceWatchRepository {
  List<PriceWatch> getWatches();
  void addWatch(PriceWatch watch);
}

class InMemoryPriceWatchRepository implements PriceWatchRepository {
  InMemoryPriceWatchRepository();

  final _watches = <PriceWatch>[
    const PriceWatch(
      id: 'pw1',
      productName: 'آيفون 15 برو ماكس',
      targetPrice: 4300,
      notes: 'ألوان تيتانيوم فقط',
      isActive: true,
    ),
    const PriceWatch(
      id: 'pw2',
      productName: 'كرسي ゲーミング',
      targetPrice: 950,
      notes: 'دعم أسفل الظهر',
      isActive: false,
    ),
  ];

  @override
  List<PriceWatch> getWatches() => List.unmodifiable(_watches);

  @override
  void addWatch(PriceWatch watch) => _watches.add(watch);
}
