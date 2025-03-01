// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#ifndef RUNTIME_VM_SIMULATOR_H_
#define RUNTIME_VM_SIMULATOR_H_

#include "vm/globals.h"

#if defined(USING_SIMULATOR)
#if defined(TARGET_ARCH_IA32)
#error Simulator not implemented.
#elif defined(TARGET_ARCH_X64)
#include "vm/simulator_x64.h"
#elif defined(TARGET_ARCH_ARM)
#include "vm/simulator_arm.h"
#elif defined(TARGET_ARCH_ARM64)
#include "vm/simulator_arm64.h"
#elif defined(TARGET_ARCH_RISCV32) || defined(TARGET_ARCH_RISCV64)
#include "vm/simulator_riscv.h"
#else
#error Unknown architecture.
#endif  // defined(TARGET_ARCH_...)
#endif  // defined(USING_SIMULATOR)

#endif  // RUNTIME_VM_SIMULATOR_H_
