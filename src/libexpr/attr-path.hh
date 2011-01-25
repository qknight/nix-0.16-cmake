#ifndef __ATTR_PATH_H
#define __ATTR_PATH_H

#include <string>
#include <map>

#include "eval.hh"


namespace nix {

    
void findAlongAttrPath(EvalState & state, const string & attrPath,
    const Bindings & autoArgs, Expr * e, Value & v);

    
}


#endif /* !__ATTR_PATH_H */
