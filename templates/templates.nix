{
  empty = {
    path = ./empty;
    description = "An empty flake with a devShell and direnv";
  };
  simple-c = {
    path = ./simple-c;
    description = "A sipmle c project with gcc and make";
  };
  ansi-c = {
    path = ./ansi-c;
    description = "A sipmle ansi c project with gcc and make";
  };
  cpp = {
    path = ./cpp;
    description = "A c++ project using CMake, clang, ccls, and the fmt library";
  };
  pio = {
    path = ./pio;
    description = "A platformio project using C++ 20, ccls, and the fmt library";
  };
  rust = {
    path = ./rust;
    description = "A simple rust project";
  };
}
