/*
 * Copyright (c) 2016, 2021 Oracle and/or its affiliates. All rights reserved. This
 * code is released under a tri EPL/GPL/LGPL license. You can use it,
 * redistribute it and/or modify it under the terms of the:
 *
 * Eclipse Public License version 2.0, or
 * GNU General Public License version 2, or
 * GNU Lesser General Public License version 2.1.
 */
package org.truffleruby.core.array;

import org.truffleruby.core.array.library.ArrayStoreLibrary;
import org.truffleruby.language.RubyBaseNode;

import com.oracle.truffle.api.dsl.Bind;
import com.oracle.truffle.api.dsl.ImportStatic;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.library.CachedLibrary;

@ImportStatic(ArrayGuards.class)
public abstract class ArrayToObjectArrayNode extends RubyBaseNode {

    public static ArrayToObjectArrayNode create() {
        return ArrayToObjectArrayNodeGen.create();
    }

    public Object[] unsplat(Object[] arguments) {
        assert arguments.length == 1;
        return executeToObjectArray((RubyArray) arguments[0]);
    }

    public abstract Object[] executeToObjectArray(RubyArray array);

    @Specialization(limit = "storageStrategyLimit()")
    protected Object[] toObjectArrayOther(RubyArray array,
            @Bind("array.store") Object store,
            @CachedLibrary("store") ArrayStoreLibrary stores) {
        final int size = array.size;
        return stores.boxedCopyOfRange(store, 0, size);
    }

}
