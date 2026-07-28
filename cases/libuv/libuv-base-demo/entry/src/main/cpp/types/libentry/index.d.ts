export interface LibuvTestResult {
  version: string;
  passed: number;
  failed: number;
  failures: string[];
}

declare const libuv: {
  runAll(): LibuvTestResult;
};

export default libuv;
