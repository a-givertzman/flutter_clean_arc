import 'package:clean_arcitecture/core/platform/network_info.dart';
import 'package:clean_arcitecture/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:clean_arcitecture/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:clean_arcitecture/features/number_trivia/data/repositories/repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
  implements NumberTriviaRemoteDataSource {

}

class MockLocalDataSource extends Mock
  implements NumberTriviaLocalDataSource {

}

class MockNetworkInfo extends Mock
  implements NetworkInfo {

}


main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSourse: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}