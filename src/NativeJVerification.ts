import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";

export interface BooleanResult {
  enable: boolean;
}

export interface JVerificationInitParams {
  time: number;
  appkey?: string;
  channel?: string;
  advertisingId?: string;
  isProduction?: boolean;
}

export interface initResult {
  code: number;
  content: string;
}

export interface LoginTokenResult {
  code: number;
  content: string;
  operator?: "CM" | "CU" | "CT" | null;
}

export interface PreLoginResult {
  code: number;
  content: string;
}

export interface VerifyCodeParams {
  phonenum: string;
  signid: string;
  tempid: string;
}

export interface VerifyCodeResult {
  code: number;
  msg: string;
}

export interface Margin {
  top: number;
  bottom: number;
  left: number;
  right: number;
}

export interface Rectangle {
  x: string|number;
  y: string|number;
  width: string|number;
  height: string|number;
}

export interface AlignRuleOption {
  left: {
    anchor: string;
    align: number;
  },
  right: {
    anchor: string;
    align: number;
  };
  middle: {
    anchor: string;
    align: number;
  },
  top: {
    anchor: string;
    align: number;
  };
}

export interface CustomConfigParams {
  // 背景图片
  backgroundImage: string;
  // 弹窗
  showWindow: boolean;
  dialogColor: number;
  maskRect: Rectangle;
  // 安全区域
  topSafeAreaHeight: number;
  bottomSafeAreaHeight: number;
  // 返回按钮
  returnBtnImgPath: string;
  returnBtnHidden: boolean;
  returnBtnWidth: number;
  returnBtnHeight: number;
  returnBtnOffsetX: number;
  returnBtnOffsetY: number;
  // 手机号样式
  numberTextBold: boolean;
  numberSize: number;
  numberColor: number;
  numberX: number;
  numberY: number;
  numberW: number;
  numberH: number;
  // logo
  logoHidden: boolean;
  logoImage: string;
  logoX: number;
  logoY: number;
  logoW: number;
  logoH: number;
  // 广告语
  sloganTextColor: number;
  sloganTextSize: number;
  sloganX: number;
  sloganY: number;
  sloganTextBold: boolean;
  sloganHidden: boolean; // SDK无此属性
  sloganW: number; // SDK无此属性
  sloganH: number; // SDK无此属性
  // 登录按钮
  loginBtnText: string;
  loginBtnTextSize: number;
  loginBtnTextColor: number;
  loginBtnColor: number;
  loginBtnImage: string;
  loginBtnNormalImage: string; // SDK无此属性
  loginBtnDisabledImage: string; // SDK无此属性
  loginBtnSelectedImage: string; // SDK无此属性
  loginBtnX: number;
  loginBtnY: number;
  loginBtnW: number;
  loginBtnH: number;
  loginBtnDisabledTextColor: number;
  loginBtnDisabledColor: number;
  loginBtnTextBold: boolean;
  loginBtnBorderColor: number;
  loginBtnDisabledBorderColor: number;
  loginBtnBorderWidth: number;
  loginBtnDisabledBorderWidth: number;
  // 隐私协议
  privacyColor: Array<number>;
  privacyMargin: Margin;
  privacyText: Array<string>;
  privacyUncheckedImage: string;
  privacyCheckedImage: string;
  privacyCheckEnable: boolean;
  privacyTextGravityMode: string;
  privacyTextSize: number;
  privacyCheckboxSize: number;
  checkboxX:number;
  checkboxY:number;
  privacyCheckboxInCenter: boolean;
  enableHintToastText: string;
  privacyTextBold: boolean;
  privacyUnderlineText: boolean;
  privacyOne: Array<string>;
  privacyTwo: Array<string>;
  privacyBookSymbolEnable: boolean;
  privacyX: number;
  privacyY: number;
  clauseAlignRuleOption: AlignRuleOption;
  // numberAlignRuleOption:object;
  // loginBtnAlignRuleOption:object;
  // 隐私协议页面
  privacyWebNavColor: number;
  privacyWebNavTitle: string; // SDK未提供
  privacyWebNavTitleSize: number;
  privacyWebNavTitleColor: number;
  privacyWebNavReturnImage: string;
  PrivacyNavTitleTextBold: boolean;
  // 状态栏模式
  statusBarMode: string;
  navColor: number;
  navTitleColor: number;
  // CM
  loginBtnBorderRadius: number;
  checkBoxShape: number;
  checkTipText: string;
  clauseNavMarginTop: number;
  // 未使用到的
  privacyW: number;
  privacyH: number;
  privacyCheckboxHidden: boolean;
  statusBarHidden: boolean;
  navHidden: boolean;
  navTitle: string;
  navTitleSize: number;
  navReturnHidden: boolean;
  navReturnImage: string;
  navReturnX: number;
  navReturnY: number;
  navReturnW: number;
  navReturnH: number;
}

export interface CustomViewParams {
  customViewName: string;
  customViewPoint: Array<string>;
}

export interface Spec extends TurboModule {
  // 设置调试模式
  setDebug(enable: boolean): void;

  // SDK初始化
  setupWithConfig(
    params: JVerificationInitParams,
    callback: (result: initResult) => void
  ): void;

  // 获取sdk初始化是否成功标识
  isSetupClient(callback: (result: BooleanResult) => void): void;

  // SDK判断网络环境是否支持
  checkVerifyEnable(callback: (result: BooleanResult) => void): void;

  // SDK获取号码认证token
  getToken(time: number, callback: (result: LoginTokenResult) => void): void;

  // SDK获取预取号token
  preLogin(time: number, callback: (result: PreLoginResult) => void): void;

  // SDK清除预取号缓存
  clearPreLoginCache(): void;

  // SDK请求授权一键登录
  getAuthorizationWithController(enable: boolean): void;

  // SDK关闭授权页面
  dismissLoginController(): void;

  // 设置一键登录页面样式
  customUIWithConfig(
    customConfigParams: CustomConfigParams,
    customViewParams: CustomViewParams
  ): void;

  // 登录事件监听
  addLoginEventListener(callback: (result: LoginTokenResult) => void): void;

  addUncheckBoxEventListener(
    callback: (result: LoginTokenResult) => void
  ): void;
  // 移除登录事件监听
  removeListeners: (count: number) => void;

  // SDK获取验证码
  getSmsCode(
    params: VerifyCodeParams,
    callback: (result: VerifyCodeResult) => void
  ): void;

  // 设置前后两次获取验证码的时间间隔
  setCodeTime(time: number): void;
}

export default TurboModuleRegistry.get<Spec>(
  "JVerificationModule"
) as Spec | null;
