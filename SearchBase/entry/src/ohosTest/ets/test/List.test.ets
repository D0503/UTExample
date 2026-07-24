import abilityTest from './Ability.test';
import allDevicePassToPassTest from './00_common_pass_to_pass/AllDevicePassToPass.test';
import entryPhoneSmPassToPassTest from './01_entry_shape/EntryPhoneSmPassToPass.test';
import entryMdLgXlFailToPassTest from './01_entry_shape/EntryMdLgXlFailToPass.test';
import listMdFailToPassTest from './02_list_columns/ListMdFailToPass.test';
import listLgXlFailToPassTest from './02_list_columns/ListLgXlFailToPass.test';
import listPhoneSmPassToPassTest from './02_list_columns/ListPhoneSmPassToPass.test';
import spacingSmPassToPassTest from './03_spacing/SpacingSmPassToPass.test';
import spacingMdFailToPassTest from './03_spacing/SpacingMdFailToPass.test';
import spacingLgXlFailToPassTest from './03_spacing/SpacingLgXlFailToPass.test';
import historyCapsuleSmPassToPassTest from './04_history_capsule/HistoryCapsuleSmPassToPass.test';
import historyCapsuleMdLgXlFailToPassTest from './04_history_capsule/HistoryCapsuleMdLgXlFailToPass.test';
import shallowHomeSmMdPassToPassTest from './05_shallow_home/ShallowHomeSmMdPassToPass.test';
import shallowHomeLgXlFailToPassTest from './05_shallow_home/ShallowHomeLgXlFailToPass.test';
import shallowResultSmMdPassToPassTest from './06_shallow_result/ShallowResultSmMdPassToPass.test';
import shallowResultLgXlFailToPassTest from './06_shallow_result/ShallowResultLgXlFailToPass.test';
import entryPageRotationFailToPassTest from './07_rotation/EntryPageRotationFailToPass.test';
import searchHomeRotationFailToPassTest from './07_rotation/SearchHomeRotationFailToPass.test';
import resultPageRotationFailToPassTest from './07_rotation/ResultPageRotationFailToPass.test';

// 方法说明：注册 SearchBase 全部 UI 自动化测试套件，目录顺序对应汇报中的适配点顺序。
export default function testsuite() {
  abilityTest();
  allDevicePassToPassTest();
  entryPhoneSmPassToPassTest();
  entryMdLgXlFailToPassTest();
  listPhoneSmPassToPassTest();
  listMdFailToPassTest();
  listLgXlFailToPassTest();
  spacingSmPassToPassTest();
  spacingMdFailToPassTest();
  spacingLgXlFailToPassTest();
  historyCapsuleSmPassToPassTest();
  historyCapsuleMdLgXlFailToPassTest();
  shallowHomeSmMdPassToPassTest();
  shallowHomeLgXlFailToPassTest();
  shallowResultSmMdPassToPassTest();
  shallowResultLgXlFailToPassTest();
  entryPageRotationFailToPassTest();
  searchHomeRotationFailToPassTest();
  resultPageRotationFailToPassTest();
}
