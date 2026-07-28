export interface NativeTestResult {
  passed: number;
  failed: number;
  failures: string[];
}

declare const libuvTest: {
  runLoadSuite(): NativeTestResult;
  runCoreSuite(): NativeTestResult;
  runAffinitySuite(): NativeTestResult;
};

export default libuvTest;
