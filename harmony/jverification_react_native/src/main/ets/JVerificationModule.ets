import { TurboModule } from "@rnoh/react-native-openharmony/ts";
import { TM } from "./generated/ts";
import { TurboModuleContext } from '@rnoh/react-native-openharmony';
import common from '@ohos.app.ability.common';
import Logger from './Logger'

import {
  BooleanResult,
  JVerificationInitParams,
  initResult,
  VerifyCodeResult,
  LoginTokenResult,
  PreLoginResult,
  VerifyCodeParams,
  CustomConfigParams,
  CustomViewParams,
  LoginListener,
  State,
} from "./Type";

import {
  JVerificationInterface,
  JVerificationLoginSettings,
  JVerifyUIConfig,
  JVerifyUIConfigBuilder,
  GenAuthThemeConfigBuilder,
  SpanEntity,
  PrivacyBean
} from '@jg/verify';
import { UIContext, window } from '@kit.ArkUI'
import { bundleManager } from "@kit.AbilityKit";

let uiContext: UIContext;

export class JVerificationModule extends TurboModule implements TM.JVerificationModule.Spec {
  private context: common.UIAbilityContext;
  private applicationContext: common.ApplicationContext;
  private operator: string = ''

  constructor(ctx: TurboModuleContext) {
    super(ctx);
    this.context = this.ctx.uiAbilityContext;
    this.applicationContext = this.context.getApplicationContext();
  }

  // 是否启用日志
  setDebug(enable: boolean): void {
    JVerificationInterface.setDebugMode(enable);
  }

  // 初始化SDK
  setupWithConfig(params: JVerificationInitParams,
    callback: (result: initResult) => void): void {
    uiContext = this.ctx.getUIContext()!;
    JVerificationInterface.init(this.applicationContext, params.appkey, (code, msg) => {
      callback({ code: code, content: msg });
    })
  }

  // 初始化是否成功标识
  isSetupClient(callback: (result: BooleanResult) => void): void {
    let isSuccess = JVerificationInterface.isInitSuccess();
    callback({ enable: isSuccess });
  }

  // SDK判断网络环境是否支持
  async checkVerifyEnable(callback: (result: BooleanResult) => void): Promise<void> {
    let verifyEnable = await JVerificationInterface.checkVerifyEnable();
    callback({ enable: verifyEnable });
  }

  // 号码认证
  getToken(time: number, callback: (result: LoginTokenResult) => void): void {
    JVerificationInterface.getToken((code, msg, operateRet) => {
      Logger.debug("getToken" + "code:" + code + ", msg:" + msg + ", operateRet:" + operateRet);
      this.operator = operateRet;
      callback({ code: code, content: msg, operator: operateRet });
    }, time);
  }

  // SDK获取预取号token
  preLogin(time: number, callback: (result: PreLoginResult) => void): void {
    JVerificationInterface.prelogin((code, msg) => {
      callback({ code: code, content: msg });
    }, time);
  }

  // 清除预取号缓存
  clearPreLoginCache(): void {
    JVerificationInterface.clearPreLoginCache();
  }

  // SDK请求授权一键登录
  getAuthorizationWithController(enable: boolean): void {
    let settings: JVerificationLoginSettings = new JVerificationLoginSettings(uiContext);
    settings.autoFinish = enable;
    settings.authPageEventListener = (code: number, msg: string) => {
      Logger.debug('authPageEventListener code: ' + code + ", msg: " + msg);
      switch (code) {
        case LoginListener.CHECKED:
          this.ctx.rnInstance.emitDeviceEvent('UncheckBoxCallBack', { isChecked: true });
          break;
        case LoginListener.UNCHECKED:
          this.ctx.rnInstance.emitDeviceEvent('UncheckBoxCallBack', { isChecked: false });
          break;
        case LoginListener.CLICKED:
          break;
      }
    }
    JVerificationInterface.loginAuth(settings, (code, msg, operatorReturn) => {
      this.ctx.rnInstance.emitDeviceEvent('LoginEvent', { code: code, msg: msg, operator: operatorReturn });
      Logger.debug('getAuthorizationWithController = ' + "code:" + code + ", msg:" + msg + ", operateRet:" +
        operatorReturn);
    })
  }

  // 关闭授权页面
  dismissLoginController(): void {
    JVerificationInterface.dismissLoginAuthActivity(uiContext);
  }

  customUIWithConfig(customConfigParams: CustomConfigParams,
    customViewParams: CustomViewParams): void {
    if (!this.operator) {
      return;
    }
    let builder = new JVerifyUIConfigBuilder();
    // 导航栏
    let systemBarProperties: window.SystemBarProperties = {
      navigationBarColor: String(customConfigParams.navColor),
      isStatusBarLightIcon: customConfigParams.statusBarMode === State.STATUSBAR_MODE,
      navigationBarContentColor: String(customConfigParams.navTitleColor)
    };

    //全屏模式
    if (this.operator === State.OPERATOR_CM) {
      this.setCustomUICM(builder, systemBarProperties, customConfigParams);
    } else {
      this.setCustomUI(customConfigParams, builder);
    }
    let uiConfig: JVerifyUIConfig = builder.build();
    JVerificationInterface.setCustomUIWithConfig(uiConfig);
  }

  //处理移动资源路径
  handleImageSrc(imageSrc: string): Resource | string | null {
    if (imageSrc === undefined) {
      return null;
    }
    if (imageSrc.startsWith(State.PREFIX)) {
      return imageSrc
    } else {
      const str = State.PREFIX_PATH.concat(imageSrc);
      return $r(str)
    }
  }

  // 处理移动隐私协议条款
  getCMPrivacyList(customConfigParams: CustomConfigParams): SpanEntity[] {
    let spanList: SpanEntity[] = [];
    let prefixSpan = new SpanEntity();
    prefixSpan.text = customConfigParams.privacyText ? customConfigParams.privacyText[0] : '';
    prefixSpan.isProtocol = true;
    prefixSpan.fontSize = customConfigParams.privacyTextSize;
    prefixSpan.fontColor = customConfigParams.privacyColor[1] ? customConfigParams.privacyColor[1] : Color.Black;
    spanList.push(prefixSpan);
    let cmSpan = new SpanEntity();
    cmSpan.text = customConfigParams.privacyBookSymbolEnable ? "《&&Clause&&》" : "&&Clause&& ";
    cmSpan.isProtocol = true;
    cmSpan.fontSize = customConfigParams.privacyTextSize;
    cmSpan.fontColor = customConfigParams.privacyColor[0] ? customConfigParams.privacyColor[0] : Color.Blue;
    spanList.push(cmSpan);
    let privacyList: Array<Array<string>> = [];
    if (customConfigParams.privacyOne) {
      privacyList.push(customConfigParams.privacyOne);
    }
    if (customConfigParams.privacyTwo) {
      privacyList.push(customConfigParams.privacyTwo);
    }
    for (let privacy of privacyList) {
      let span = new SpanEntity();
      span.text = this.handlePrivacyBook(privacy[0], customConfigParams);
      span.url = privacy[1];
      span.isProtocol = true;
      span.fontSize = customConfigParams.privacyTextSize;
      span.fontColor =
        customConfigParams.privacyColor && customConfigParams.privacyColor[0] ? customConfigParams.privacyColor[0] :
          Color.Blue;
      spanList.push(span);
    }
    let suffixSpan = new SpanEntity();
    suffixSpan.text =
      customConfigParams.privacyText && customConfigParams.privacyText[1] ? customConfigParams.privacyText[1] : '';
    suffixSpan.isProtocol = true;
    suffixSpan.fontSize = customConfigParams.privacyTextSize;
    suffixSpan.fontColor =
      customConfigParams.privacyColor && customConfigParams.privacyColor[1] ? customConfigParams.privacyColor[1] :
        Color.Black;
    spanList.push(suffixSpan);
    return spanList;
  }

  handlePrivacyBook(privacyText: string, customConfigParams: CustomConfigParams): string {
    if (customConfigParams.privacyBookSymbolEnable) {
      privacyText = `《${privacyText}》`;
    } else {
      privacyText = `${privacyText} `;
    }
    return privacyText;
  }

  // 移动ui设置
  setCustomUICM(builder: JVerifyUIConfigBuilder, systemBarProperties: window.SystemBarProperties,
    customConfigParams: CustomConfigParams) {
    const builderCM = new GenAuthThemeConfigBuilder();
    const spanList = this.getCMPrivacyList(customConfigParams);
    const imagePathCM = this.handleImageSrc(customConfigParams.loginBtnImage);
    const imageDisPathCM = this.handleImageSrc(customConfigParams.loginBtnDisabledImage);
    const checkSrcCM = this.handleImageSrc(customConfigParams.privacyCheckedImage);
    const unCheckSrcCM = this.handleImageSrc(customConfigParams.privacyUncheckedImage);

    // 弹窗模式
    if (customConfigParams.showWindow) {
      builderCM.setWindowMode({
        width: State.DIALOG_WIDTH,
        height: State.DIALOG_HEIGHT,
        maskRect: {
          x: State.MASK_X,
          y: State.MASK_Y,
          width: State.MASK_WIDTH,
          height: State.DIALOG_HEIGHT,
        },
        maskColor: Color.White,
        alignment: DialogAlignment.Center,
        isModal: true,
        autoCancel: true,
      })
    }

    builderCM
      .setSystemBarProperties(systemBarProperties)
      .setClauseNavMarginTop(State.NAV_MARGIN_TOP)
      // 隐私协议页面颜色字体
      .setNavTextColor(customConfigParams.privacyWebNavTitleColor)
      .setNavColor(customConfigParams.privacyWebNavColor)
      .setNavTextSize(customConfigParams.privacyWebNavTitleSize)
      // 手机号样式
      .setNumberSize(customConfigParams.numberSize, true)
      .setNumberColor(customConfigParams.numberColor)
      .setNumberMargin({ left: customConfigParams.numberX, top: customConfigParams.numberY })
      .setNumberWidth(customConfigParams.numberW)
      .setNumberHeight(customConfigParams.numberH)
      // 登录按钮
      .setLogBtnText(customConfigParams.loginBtnText)
      .setLoginBtnTextSize(customConfigParams.loginBtnTextSize)
      .setLoginBtnTextColor(customConfigParams.loginBtnTextColor)
      .setLoginBtnWidth(customConfigParams.loginBtnW)
      .setLoginBtnHeight(customConfigParams.loginBtnH)
      .setLoginBtnMargin({ top: customConfigParams.loginBtnY, bottom: customConfigParams.loginBtnX })
      // 隐私协议和checkbox
      .setClauses(spanList)
      .setClauseMargin({ left: customConfigParams.privacyX, top: customConfigParams.privacyY })
      .setClauseAlignRuleOption({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: 'clause_checkBox', align: VerticalAlign.Center }
      })
      .setCheckBoxAlignRuleOption({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .setClauseTextAlign(customConfigParams.privacyTextGravityMode === State.TEXT_MODE ? TextAlign.Center :
        TextAlign.Start)
      .setClauseState(customConfigParams.privacyCheckEnable)
      .setCheckBox(customConfigParams.privacyCheckboxSize, customConfigParams.privacyCheckboxSize)
      .setCheckedColor(Color.Red)
      .setGenCheckedChangeListener({
        onCheckedChanged: (isChecked: boolean) => {
          this.ctx.rnInstance.emitDeviceEvent('UncheckBoxCallBack', { isChecked: isChecked });
        }
      })

    if (imagePathCM) {
      builderCM.setLoginBtnImgPath($r(imagePathCM));
    }

    if (imageDisPathCM) {
      builderCM.setLoginBtnDisabledImgPath($r(imageDisPathCM));
    }

    if (checkSrcCM && unCheckSrcCM) {
      builderCM.setCheckBoxImg($r(checkSrcCM), $r(unCheckSrcCM));
    }
    builder.setCmUIConfig(builderCM);
  }

  // 联通电信UI设置
  setCustomUI(customConfigParams: CustomConfigParams, builder: JVerifyUIConfigBuilder) {
    const privacyList = this.getNormalPrivacyList(customConfigParams);
    builder.setAuthBGImgPath(customConfigParams.backgroundImage)
    // logo
      .setLogoHidden(customConfigParams.logoHidden)
      .setLogoImgPath(customConfigParams.logoImage)
      .setLogoOffsetX(customConfigParams.logoX)
      .setLogoOffsetY(customConfigParams.logoY)
      .setLogoWidth(customConfigParams.logoW)
      .setLogoHeight(customConfigParams.logoH)
      // 手机号样式
      .setNumberColor(customConfigParams.numberColor)
      .setNumberSize(customConfigParams.numberSize)
      .setNumberFieldOffsetX(customConfigParams.numberX)
      .setNumberFieldOffsetY(customConfigParams.numberY)
      .setNumberFieldWidth(customConfigParams.numberW)
      .setNumberFieldHeight(customConfigParams.numberH)
      // slogan
      .setSloganTextColor(customConfigParams.sloganTextColor)
      .setSloganTextSize(customConfigParams.sloganTextSize)
      .setSloganOffsetX(customConfigParams.sloganX)
      .setSloganOffsetY(customConfigParams.sloganY)
      // login
      .setLogBtnText(customConfigParams.loginBtnText)
      .setLogBtnTextColor(customConfigParams.loginBtnTextColor)
      .setLogBtnImgPath(customConfigParams.loginBtnImage)
      .setLogBtnOffsetX(customConfigParams.loginBtnX)
      .setLogBtnOffsetY(customConfigParams.loginBtnY)
      .setLogBtnWidth(customConfigParams.loginBtnW)
      .setLogBtnHeight(customConfigParams.loginBtnH)
      .setLogBtnTextSize(customConfigParams.loginBtnTextSize)
      // 隐私协议部分
      .setPrivacyColor(customConfigParams.privacyColor[0], customConfigParams.privacyColor[1])
      .setPrivacyMargin({
        left: customConfigParams.privacyX,
        right: customConfigParams.privacyX,
        bottom: customConfigParams.privacyY
      })
      .setPrivacyText(customConfigParams.privacyText[0], customConfigParams.privacyText[1])
      .setUncheckedImgPath(customConfigParams.privacyUncheckedImage)
      .setCheckedImgPath(customConfigParams.privacyCheckedImage)
      .setPrivacyState(customConfigParams.privacyCheckEnable)
      .setPrivacyTextCenterGravity(customConfigParams.privacyTextGravityMode ?
        customConfigParams.privacyTextGravityMode.toLowerCase() === State.TEXT_MODE : true)
      .setPrivacyTextSize(customConfigParams.privacyTextSize)
      .setPrivacyCheckboxSize(customConfigParams.privacyCheckboxSize)
      .setPrivacyWithBookTitleMark(customConfigParams.privacyBookSymbolEnable)
      .setPrivacyNameAndUrlBeanList(privacyList)
      // 隐私协议页面
      .setPrivacyNavColor(customConfigParams.privacyWebNavColor)
      .setPrivacyNavTitleTextColor(customConfigParams.privacyWebNavTitleColor)
      .setPrivacyNavTitleTextSize(customConfigParams.privacyWebNavTitleSize)
      .setPrivacyNavReturnBtnPath(customConfigParams.privacyWebNavReturnImage)
  }

  // 处理电信，联通隐私协议
  getNormalPrivacyList(customConfigParams: CustomConfigParams): PrivacyBean[] {
    let privacyList: PrivacyBean[] = [];
    let privacyOne = new PrivacyBean();
    privacyOne.name = customConfigParams.privacyOne[0];
    privacyOne.text = customConfigParams.privacyOne[0];
    privacyOne.url = customConfigParams.privacyOne[1];
    privacyOne.separator = ' ';
    privacyList.push(privacyOne);
    let privacyTwo = new PrivacyBean();
    privacyTwo.name = customConfigParams.privacyTwo[0];
    privacyTwo.text = customConfigParams.privacyTwo[0];
    privacyTwo.url = customConfigParams.privacyTwo[1];
    privacyTwo.separator = ' ';
    privacyList.push(privacyTwo);
    return privacyList;
  }

  // 登录监听事件
  addLoginEventListener(callback: (result: LoginTokenResult) => void): void {
    Logger.info("###turboModule addLoginEventListener");
  }

  // 授权页勾选
  addUncheckBoxEventListener(callback: (result: LoginTokenResult) => void): void {
    Logger.info("###turboModule addUncheckBoxEventListener");
  }

  // 移除监听事件
  removeListeners(count: number): void {
    Logger.info("###turboModule removeListeners");
  }

  // SDK获取验证码，SDK无对应接口
  getSmsCode(params: VerifyCodeParams,
    callback: (result: VerifyCodeResult) => void): void {
    Logger.info("###turboModule getSmsCode not implement");
  }

  // 设置前后两次获取验证码的时间间隔，SDK无对应接口
  setCodeTime(time: number): void {
    Logger.info("###turboModule setCodeTime not implement");
  }
}