export interface BooleanResult {
  enable: boolean;
}

export interface VerifyCodeResult {
  code: number;
  msg: string;
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
  operator?: "CM" | "CU" | "CT" | null | string;
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

export interface CustomConfigParams {
  // 背景图片
  backgroundImage: string;
  // 弹窗
  showWindow: boolean;
  // 手机号样式
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
  sloganHidden: boolean;
  sloganW: number;
  sloganH: number;
  // 登录按钮
  loginBtnText: string;
  loginBtnTextSize: number;
  loginBtnTextColor: number;
  loginBtnImage: string;
  loginBtnNormalImage: string;
  loginBtnDisabledImage: string;
  loginBtnSelectedImage: string;
  loginBtnX: number;
  loginBtnY: number;
  loginBtnW: number;
  loginBtnH: number;
  // 隐私协议
  privacyColor: Array<number>;
  privacyText: Array<string>;
  privacyUncheckedImage: string;
  privacyCheckedImage: string;
  privacyCheckEnable: boolean;
  privacyTextGravityMode: string;
  privacyTextSize: number;
  privacyCheckboxSize: number;
  privacyOne: Array<string>;
  privacyTwo: Array<string>;
  privacyBookSymbolEnable: boolean;
  privacyX: number | string;
  privacyY: number | string;
  // 隐私协议页面
  privacyWebNavColor: number;
  privacyWebNavTitle: string;
  privacyWebNavTitleSize: number;
  privacyWebNavTitleColor: number;
  privacyWebNavReturnImage: string;
  // 状态栏模式
  statusBarMode: string;
  navColor: number;
  navTitleColor: number;
  // CM
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

export enum LoginListener {
  CHECKED = 6,
  UNCHECKED = 7,
  CLICKED = 8
}

export enum State {
  STATUSBAR_MODE = 'light',
  OPERATOR_CM = 'CM',
  TEXT_MODE = 'center',
  PREFIX_PATH='app.media.',
  LOGIN_SUCCESS = 6000,
  NAV_MARGIN_TOP = 38,
  DIALOG_WIDTH = '80%',
  DIALOG_HEIGHT = '45%',
  MASK_WIDTH = '90%',
  MASK_X = '5%',
  MASK_Y = '30%',
  PREFIX = 'http'
}