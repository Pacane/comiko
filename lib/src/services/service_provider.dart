import 'base_service.dart';
import 'event_service.dart';
import 'artist_service.dart';

typedef BaseService ServiceInstanciator();

class ServiceProvider {
  static final Map<Type, ServiceInstanciator> _providers = {
    EventService: () => new FakeEventService(),
    ArtistService: () => new FakeArtistService()
  };

  static Map<Type, BaseService> _cache = <Type, BaseService>{};

  static T get<T>(Type serviceType) {
    if (_cache.containsKey(serviceType)) {
      return _cache[serviceType] as T;
    }
    return (_cache[serviceType] = _providers[serviceType]()) as T;
  }
}