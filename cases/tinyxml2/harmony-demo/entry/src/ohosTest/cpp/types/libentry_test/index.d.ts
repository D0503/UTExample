export interface NativeTestResult {
  passed: number;
  failed: number;
  failures: string[];
}

export const runLoadSuite: () => NativeTestResult;
export const runCoreSuite: () => NativeTestResult;
