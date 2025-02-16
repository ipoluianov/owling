import 'dart:ffi';

final DynamicLibrary nativeLib = DynamicLibrary.open('libbackend.dylib');

typedef IncrementFunc = Int32 Function(Int32);
typedef Increment = int Function(int);
final Increment increment =
    nativeLib.lookup<NativeFunction<IncrementFunc>>('Increment').asFunction();
