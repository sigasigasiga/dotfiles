# enable multi-thread symbol loading (works on GDB 9.1+)
maint set worker-threads unlimited

# disable `press c to continue listing`
set pagination off

# print actual type when using `ptype`
set print object on

# do not step into library routines
skip -rfu std::.*
skip -rfu boost::.*

# function that prints fault address
define faultaddr
print $_siginfo._sifields._sigfault.si_addr
end
