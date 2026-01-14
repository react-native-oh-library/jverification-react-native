#pragma once

#include "RNOH/generated/BaseJverificationReactNativePackage.h"

namespace rnoh {

class JVerificationPackage : public BaseJverificationReactNativePackage {
    using Super = BaseJverificationReactNativePackage;

public:
    JVerificationPackage(Package::Context ctx) : Super(ctx) {}
};

}