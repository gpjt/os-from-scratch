void caller_function() {
    callee_function(0xdede);
}

int callee_function(int my_arg) {
    return my_arg;
}
