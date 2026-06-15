# Crystal Multiple Shared Library PoC

This directory demonstrates loading multiple Crystal-built shared libraries in
one Ruby process.

The PoC intentionally keeps the boundary to C ABI functions only. Crystal
objects, exceptions, strings, arrays and procs don't cross the shared-library
boundary.

## Build

From this directory:

```sh
cd poc
./build.sh
```

The build script is intentionally simple and assumes it is run from the
`poc` directory. By default it uses `../.build/crystal`. You can override the
compiler path:

```sh
CRYSTAL=../bin/crystal ./build.sh
```

## Run

Ruby FFI version:

```sh
ruby run_ffi.rb
```

Expected output includes three loaded libraries and independent results from
`alpha_add`, `beta_fib` and `gamma_tak`.

Each library defines its own `Worker` class internally. The class name is the
same in all three libraries on purpose; the export maps keep those Crystal
symbols local to each shared object.

## Inspect Exports

```sh
nm -D --defined-only build/libalpha.so
nm -D --defined-only build/libbeta.so
nm -D --defined-only build/libgamma.so
```

Only the prefixed C ABI symbols should be exported:

```text
alpha_*
beta_*
gamma_*
```

This includes the small public entry points such as `alpha_init`, `alpha_add`
and `alpha_last_error`.

Crystal runtime symbols such as `__crystal_main`, `__crystal_once`, `String`,
`Array` or `main` should not appear in `nm -D --defined-only`.

The internal `Worker` symbols should also be absent from `nm -D`, while they can
still be seen as local symbols with plain `nm --defined-only`.
