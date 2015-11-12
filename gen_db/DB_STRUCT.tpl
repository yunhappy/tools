/*******************************************************
* Copyright (c)  All rights reserved.
*
* FileName: 
* Summary: This file is auto generated, No manual modification is permitted 

* Author: yunmiao
* Date: 2015-7
*******************************************************/

#ifndef DB_STRUCT_h__
#define DB_STRUCT_h__

#pragma pack(push,1)

#include "Def.h"

{{range .}}
struct DB_{{.Name}}
{
	{{range .Members}}
	{{.Type}} m_{{.Field}}{{if .Len}}[{{.Len}}]{{end}};{{end}}

	DB_{{.Name}}()
	{
		memset(this, 0, sizeof(*this));
	}
	
	~DB_{{.Name}}()
	{
		memset(this, 0, sizeof(*this));
	}
};
{{end}}

#pragma pack(pop)

#endif // DB_STRUCT_h__
