import { RNPackage, TurboModulesFactory, } from "@rnoh/react-native-openharmony/ts";
import type { TurboModule, TurboModuleContext, } from "@rnoh/react-native-openharmony/ts";
import { TM } from "./generated/ts";
import { JVerificationModule } from './JVerificationModule';

class JVerificationModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.JVerificationModule.NAME) {
      return new JVerificationModule(this.ctx);
    }
    return null;
  }

  hasTurboModule(name: string): boolean {
    return name === TM.JVerificationModule.NAME;
  }
}

export class JVerificationPackage extends RNPackage {
  createTurboModulesFactory(ctx: TurboModuleContext): TurboModulesFactory {
    return new JVerificationModulesFactory(ctx);
  }
}