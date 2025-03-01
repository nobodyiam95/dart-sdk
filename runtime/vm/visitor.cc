// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "vm/visitor.h"

#include "vm/isolate.h"

namespace dart {

ObjectPointerVisitor::ObjectPointerVisitor(IsolateGroup* isolate_group)
    : isolate_group_(isolate_group),
      gc_root_type_("unknown"),
      class_table_(isolate_group->heap_walk_class_table()) {}

}  // namespace dart
