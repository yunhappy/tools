/*******************************************************
* Copyright (c)  All rights reserved.
*
* FileName: _DB_PACKET_STRUCT.h
* Summary: This file is auto generated, No manual modification is permitted 

* Author: yunmiao
* Date: 2015-7
*******************************************************/

#ifndef DB_OP_MSG
#error "must define DB_OP_MSG"
#endif

{{range .}}
DB_OP_MSG(AR_SELECT_{{.Name}}_RET)
{
	int m_nCount;
	DB_{{.Name}} m_data[0];
};
{{end}}
