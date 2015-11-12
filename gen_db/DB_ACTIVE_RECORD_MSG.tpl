/*******************************************************
* Copyright (c)  All rights reserved.
*
* FileName: 
* Summary: This file is auto generated, No manual modification is permitted 

* Author: yunmiao
* Date: 2015-7
*******************************************************/

#ifndef _NET_MSG_DEF
#error "must define _NET_MSG_DEF"
#endif

{{range .}}
_NET_MSG_DEF(AR_SELECT_{{.Name}})
_NET_MSG_DEF(AR_UPDATE_{{.Name}}){{end}}

#undef _NET_MSG_DEF
