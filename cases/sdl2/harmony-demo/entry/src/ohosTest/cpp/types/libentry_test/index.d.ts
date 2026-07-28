export interface SuiteResult {
  assertions: number;
  failures: number;
  message: string;
}

export const runLoadSuite: () => SuiteResult;
export const runRenderSuite: () => SuiteResult;
export const runGuiStateSuite: () => SuiteResult;
