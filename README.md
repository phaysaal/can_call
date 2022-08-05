# can_call

A tool to check if a function can call another function in the give C program file.

## Requires

* ocaml (4.11.1)
* opam (2.0)
    * clangml
    * refl
    * cmdliner
* dune (>=3.4)
* clang (>=13.0.0)

## Build

```
dune build
```

## Install

```
dune install
```

## Usage

```
can_call C_FILE FROM_FUNCTION TO_FUNCTION
```

### Output

* `true` if `FROM_FUNCTION` eventually calls `TO_FUNCTION` in the given C program file `C_FILE`, and
* `false` otherwise.

### Example

For the code below in a file example/eg0.c

```
void baz();
 
void foo() { }
 
void bar() {
  foo();
  baz();
}
 
void baz() {
  if (0)
    bar();
}
 
void bizz() { }
 
void buzz() {
  bizz();
}
 
int main() {
  foo();
  baz();
  buzz();
}
```

the following commands give outputs accordingly

    
* `can_call examples/eg0.c main baz` -> `true`
* `can_call examples/eg0.c baz bar` -> `true`
* `can_call examples/eg0.c buzz foo` -> `false`
* `can_call examples/eg0.c baz baz` -> `true`


