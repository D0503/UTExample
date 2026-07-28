import LibuvLoadSuite from './LibuvLoadSuite.test';
import LibuvCoreSuite from './LibuvCoreSuite.test';
import LibuvAffinitySuite from './LibuvAffinitySuite.test';

export default function testsuite() {
  LibuvLoadSuite();
  LibuvCoreSuite();
  LibuvAffinitySuite();
}
