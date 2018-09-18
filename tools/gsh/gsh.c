//#include "/home/york/usr/local/include/tcl.h"
//#include "/usr/include/tcl/tcl.h"
#include "tcl.h"
#include <stdio.h>

int gsh_main(Tcl_Interp*);

static int g_argc;
static char*** g_argv;

void main(int argc, char **argv) {
    g_argc = argc;
    g_argv = &argv;
    Tcl_FindExecutable(argv[0]);
    Tcl_Main(1, argv, gsh_main);
}

// The interp is created as default.
int gsh_main(Tcl_Interp* interp) {
    Tcl_Obj* lobj;

    if (Tcl_Init(interp) == TCL_ERROR) {
        return TCL_ERROR;
    }

    Tcl_SetVar(interp, "tcl_rcFileName", "~/.gshrc", TCL_GLOBAL_ONLY);

    int i;
    // Tranfer executable argv value to Tcl interpreter
    if (g_argc > 1) {
        Tcl_SetVar2Ex(interp, "argv0", NULL, Tcl_NewStringObj((*g_argv)[1], -1), TCL_GLOBAL_ONLY);
    }
    // Transfer the reset argv
    lobj = Tcl_NewObj();
    Tcl_IncrRefCount(lobj);
    for (i = 2; i < g_argc; i++) {
        Tcl_ListObjAppendElement(interp, lobj, Tcl_NewStringObj((*g_argv)[i], -1));
    }
    Tcl_SetVar2Ex(interp, "argv", NULL, lobj, TCL_GLOBAL_ONLY);
    Tcl_DecrRefCount(lobj);
    Tcl_SetVar2Ex(interp, "argc", NULL, Tcl_NewIntObj(g_argc - 2), TCL_GLOBAL_ONLY);

    // Source the tcl script file as $argv0
    if (g_argc > 1) {
        Tcl_Eval(interp, "source $argv0");
    }
    return 0;
}

// syntax:tcl_library
