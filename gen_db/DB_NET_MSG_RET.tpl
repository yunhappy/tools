/*******************************************************
* Copyright (c)  All rights reserved.
*
* FileName: DB_NET_MSG_RET.H
* Summary: This file is auto generated, No manual modification is permitted 

* Author: yunmiao
* Date: 2015-7
*******************************************************/

#ifndef _NET_MSG_DEF
#error "must define _NET_MSG_DEF"
#endif

{{range $index, $elmt := .}}
_NET_MSG_DEF(AR_SELECT_{{.Name}}_RET, 710+{{$index}}){{end}}

#undef _NET_MSG_DEF
