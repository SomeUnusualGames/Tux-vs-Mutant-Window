Hello everyone, today I'm taking a look at a very famous shell scripting language called Bash.

Bash is a shell program developed by computer programmer Brian Fox in 1989 for the GNU Project. It was designed as a free software alternative for Bourne shell. Bash it's the default shell program used in many Linux distributions[1]
In a shell, you can execute commands to move around directories, execute programs and interact with files. To automate this process, you can write those commands in a file and execute it instead of typing them one by one. To make this "script" more customizable, Bash has many features that help in the process of automating tasks, like:
- Variables, which can contain strings, numbers, arrays and even associative arrays.
- Conditionals
- Loops: for, while, until
- Functions

All these features make Bash a good candidate to make scripts to automate most shell tasks. Of course, when the task is complex enough, it is common to use an actual scripting programming language like Python.
Now, Bash by itself can't call external C code. For that, I used a plugin made by user taviso called ctypes.sh, which implements a foreign function interface.
As the ctypes.sh wiki says, Bash plugins are rarely used, but allow you to extend Bash at runtime with additional builtins. The two most important commands are: dlcall, to call C functions, and dlopen, to load dynamic shared objects. Another feature is the possibility to define a C struct with the struct command. Once the .so file is loaded, you can call any of its functions with dlcall and define C structs with the struct command.

Here's a simple hello world example using raylib. Notice how variables are passed from Bash to C, you have to start with the type, colon and the value of the parameter. The same thing happens to values returned from C functions to Bash. The color structure can be passed as a single integer.

Here's a more advanced example, make a texture bounce in the borders of the screen. When making this example I found two issues:
- it is not possible to call C functions that take C structs *by value*. The contents of the struct are set to "zero"/null on the C side for some reason
- Bash by itself has no floating point arithmetic

To tackle the first issue, the struct command has a parameter to define a pointer with allocated memory to the struct, so I simply made "wrappers" to some functions to take pointers, compiled to a .so file and called them from Bash. The commands pack and unpack allows you to load the contents of the struct to the pointer and vice versa. This way, it is possible to pass Rectangles, Vectors, Music, and any other C struct, as long as the wrapper function exists.

Regarding the floating point issue, I tried several things:

Use the Awk programming language to perform the operation. Awk is another scripting language for data processing. To use it, you simply print the expression you want to compute to catch it from Bash. This works, but since Awk is an external process, repeatedly calling it 60 times per second is bad for performance.

Another option is to use bc, which stands for basic calculator. It also works, but the performance is even worse than Awk.

What I ended up doing is perform all floating point operations in C. This way, there's no framerate issues whatsoever!

One thing to notice, that is used several times in the game's code, is how some variables have some kind of pattern around them. This is called parameter expansion (or substring removal), and is used to remove certain parts of the string. For example, in this line:

`x=$($op_float "$x $op_x 150 * ${df##*:}")`

`df` comes from a C function, which has the format `float [colon] number`. To be able to use it as a number we have to remove everything before the colon, which is what this expansion does. To use it as an integer in Bash, we have to remove everything after the decimal point, in that case, this pattern in used: `${df%%.*}`. The difference between `##` and `%%` is that the former is for prefixes, and the latter for subfixes.

Now that we can pass C structs and use floating point arithmetic, we're ready to make a game!

The first thing you'll notice in the main file is the variable that stores the decimal point, which can be different depending on the user locale. We need this to remove the decimal part of the float variables without hardcoding the decimal point.

Speaking of variables, it's similar to the Lua language, they are global by default, which is what I mostly used. There's a way to create variables whose scope is limited by the function they are declared, by using the `local` keyword. My convention to declare global variables is to start with a prefix depending on the script they are declared:

- For the player script, all variables start with `tux`
- For the title script, they start with `title`

...and the same applies to the other scripts.
To define a variable, you simply set a value to it with the equal operator.
You can also have typed variables by using the `declare` keyword along with its type. This way, these variables won't store any value that isn't their declared type. If you define an integer and want to set a string, Bash won't raise an error but that statement won't do anything.

One important thing to notice is that Bash is "space sensitive", which means a single space in a command changes what it does, which I actually didn't know when starting using it. For example:
`a=0` This assigns a value to a variable
`a = 0` This attempts to call a function called `a` with parameters `=` and `0`
The same thing happens with square brackets:
`if [ 2 == 2 ]; then` this works as expected, but
`if [2==2]; then` this is interpreted as calling `[2==2]` which isn't a valid command

Another thing to notice is that all `if`s use double square brackets instead of single square brackets, and the fact is, for most cases, single square brackets would have worked fine, so, what's the difference?
`[` is a standard shell command, it is the same as the command `test` but it needs a closing square bracket. `[[` is not part of the standard, it's a keyword which can use special syntax rules that single square bracket doesn't have, among other things. That's why is considered an "improved" version of the single square bracket, which is why I used it all over the codebase.

Now, to loop in Bash, there are several ways:
- while, which is like any other language
- until, which is like while but with the control expression evaluating to false
- for loop, which has two "forms"
    - `for variable in (string of elements separated by space)`, can be used to loop through a string with the elements separated by a space. There are commands like `seq` which prints a sequence of integers which can be used to loop
    - `for ((i=0; i < 10; i++))`, regular C like loop which is what I mostly used, because it's easier to read, and didn't need to loop through a string anyway. The two parentheses is an arithmetic evaluation, which is used in this kind of loop and to, well, perform math operations.

Let's now look at how arrays work in Bash, particularlly in how I used them to store the bullets.
First, arrays are one dimensional only and can be indexed or associative. To set an array, you can use _compound assignment_ by writing the variable, equal operator, and the elements of the array in parentheses. To store the bullets, I set two separate list with the x and y coordinates. To append values, you use the compound assignment with `+=` operator. The interesting part about arrays is that, to remove an element, you have to call unset on it, but that just replaces the value with "nothing", so you have to manually create a new array by using parameter expansion with "at", which returns all elements of the array without the one we just unset. Basically, there's no built-in way to remove an element from an array and shift the following elements. According to this StackOverflow answer, shell arrays are _intended to provide a second level of quoting_ in a case where, for example, you want to pass two space separated strings as two parameters instead of four.

Anyway, that's all I wanted to show for the game. As always, you can find the repository in Github. It works for both Linux and Windows by using the Windows Subsystem for Linux. Thanks for watching!


- Locale decimal point -> parameter expansion X
- All variables are global, except the local ones X
- [[ double square brackets ]] instead of [ single ] in conditionals, why? X
- different ways to make for loops
- arrays[2] -> show how they are used with bullets, insert and remove

2 https://stackoverflow.com/a/17533525

1 https://en.wikipedia.org/wiki/Bash_(Unix_shell)