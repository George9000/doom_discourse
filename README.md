# Emacs for Julia on macOS
Install Xcode

Then, the command line developer tools. 
Afterwards, accept the Xcode license.

``` shell
xcode-select --install

xcodebuild -license
```
Install [XQuartz](https://www.xquartz.org/)

Then install [MacPorts](https://www.macports.org/install.php)

Add MacPorts to your PATH, optionally first in your PATH

Install `git, ripgrep, fd, vterm, tree-sitter, emacs`

Add newly installed Emacs to your PATH.

``` shell
# in your .bashrc or .zshrc
export PATH="/opt/local/bin:$PATH"

sudo port selfupdate

sudo port install git
sudo port install ripgrep
sudo port install fd
sudo port install libvterm
sudo port install tree-sitter

sudo port install emacs-mac-app-devel +nativecomp +imagemagick +rsvg +treesitter +metal

export PATH="/Applications/MacPorts/EmacsMac.app/Contents/MacOS:$PATH"
```

**Don't launch emacs yet.**

Place this current repo in a directory called doom in ~/.config

Note that this repo is a modified version of one by [ronisbr](https://github.com/ronisbr/doom.d). See [this](https://discourse.julialang.org/t/current-emacs-recommendations/109008/10?u=george9000) discussion on the Julia Discourse.

``` shell
git clone https://github.com/George9000/doom_discourse.git ~/.config/doom
``` 

Now install [doom emacs](https://github.com/doomemacs/doomemacs).

Add its binary directory to the PATH.

``` shell
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs

~/.config/emacs/bin/doom install

export PATH="/Users/your_user/.config/emacs/bin"
```

After install, launch `/Applications/MacPorts/EmacsMac.app`

Note that on first launch, emacs will compile for a while (native compilation).

One can monitor the status of compilation by looking at `ibuffer` (C-x C-b)

When compilation is finished, run `M-x nerd-icons-install-fonts` for correct icon display on the modeline.

Then, `M-x vterm` and answer yes to install and compile.

Then quit emacs.

`doom sync`

launch EmacsMac.app

Open a `.jl` file, respond 'yes' to download treesitter, allow compilation. Then quit Emacs, `doom sync`. 

Correct ibuffer [behavior](https://github.com/doomemacs/doomemacs/issues/6314).

Edit `~/.config/emacs/modules/emacs/ibuffer/config.el`

On line 49: move the last parenthesis to a new line.
Then comment out line 49. Result as shown below.

```lisp
; (define-key ibuffer-mode-map [remap ibuffer-visit-buffer] #'+ibuffer/visit-workspace-buffer)
)

```

## A Julia Workflow

Add the following packages to your global julia environment:

`Revise, SymbolServer, LanguageServer`

Then...

In `~.julia/config/startup.jl` have the following:

``` julia
using Pkg
if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end
try
    using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

println(":")
println(":" * pwd())
println(":")

# if one installs python3 with MacPorts...
#ENV["PYTHON"]="python3"
# alternate location for package dev
#ENV["JULIA_PKG_DEVDIR"] = "/Users/user_name/Documents/julia/dev"
```

For each julia project or exploration, make a self-contained package.

``` shell
julia --eval 'using Pkg; Pkg.generate("testpackage")'
cd testpackage
julia --eval 'using Pkg; Pkg.activate("."); Pkg.instantiate()'

touch exploration.jl
echo using testpackage >> exploration.jl 

git init .
git add Project.toml
git add exploration.jl
git add src/
git commit -m 'Initial'
```

Now write functions in `src/testpackage.jl`. These will be run in `exploration.jl`

In doom emacs, one can add a project directory using `SPC p a`. (A directory with a git repo will be recognized as a project.)

Now switch to the project using `SPC p p`

Open `exploration.jl`

Start the language server with `SPC c l w s`

`SPC c D` for jump to reference is quite useful.

`C-c C-c` will execute a line in `exploration.jl` and open a separate frame with a REPL.

`SPC SPC` should bring up a list of project files.

 `SPC b l` is handy to go back to the last buffer in the project.



