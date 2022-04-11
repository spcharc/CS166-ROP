## CS166 Team Project

Requires x64 Linux system.

Compile this program with
```
gcc main.s print.s readline.s -o main -nostdlib -no-pie
```

`-nostdlib` is used since I did not use any standard library functions
`-no-pie` disables Position Independent Executable, so the address isn't randomized.

Use `objdump -d ./main` to figure out where to jump in this program.
