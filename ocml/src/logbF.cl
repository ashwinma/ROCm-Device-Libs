
#include "mathF.h"

CONSTATTR INLINEATTR float
MATH_MANGLE(logb)(float x)
{
    int ax = as_int(x) & EXSIGNBIT_SP32;
    float ret;

    if (AMD_OPT()) {
        ret = (float)(BUILTIN_FREXP_EXP_F32(x) - 1);
    } else {
        ret = (float)((ax >> EXPSHIFTBITS_SP32) - EXPBIAS_SP32);
        if (!DAZ_OPT()) {
            float s = (float)(-118 - (int)MATH_CLZI(ax));
            ret = ax < 0x00800000 ? s : ret;
        }
    }

    if (!FINITE_ONLY_OPT()) {
        ret = ax >= PINFBITPATT_SP32 ? as_float(ax) : ret;
        ret = x == 0.0f ? as_float(NINFBITPATT_SP32) : ret;
    }

    return ret;
}
