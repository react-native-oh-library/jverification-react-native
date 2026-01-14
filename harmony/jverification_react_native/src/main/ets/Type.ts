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

export interface Margin {
  top: number,
  bottom: number,
  left: number
  right: number
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
  loginBtnBorderWidth: number | string;
  loginBtnDisabledBorderWidth: number | string;
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
  checkBoxX:number;
  checkBoxY:number;
  privacyCheckboxInCenter: boolean;
  enableHintToastText: string;
  privacyTextBold: boolean;
  privacyUnderlineText: boolean;
  privacyOne: Array<string>;
  privacyTwo: Array<string>;
  privacyBookSymbolEnable: boolean;
  privacyX: number | string;
  privacyY: number | string;
  clauseAlignRuleOption: AlignRuleOption;
  // 隐私协议页面
  privacyWebNavColor: number;
  privacyWebNavTitle: string; // SDK未提供
  privacyWebNavTitleSize: number;
  privacyWebNavTitleColor: number;
  privacyWebNavReturnImage: string;
  privacyNavTitleTextBold: boolean;
  // 状态栏模式
  statusBarMode: string;
  navColor: number;
  navTitleColor: number;
  // CM
  loginBtnBorderRadius: number;
  checkBoxShape: number;
  checkTipText: string;
  clauseNavMarginTop: number;
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
}

