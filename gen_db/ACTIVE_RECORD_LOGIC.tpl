/*******************************************************
* Copyright (c)  All rights reserved.
*
* FileName: 
* Summary: This file is auto generated, No manual modification is permitted 

* Author: yunmiao
* Date: 2015-7
*******************************************************/

#include "MySqlMacro.h"
#include "MySqlHelper.h"
#include "DBThread.h"
#include "DataServer.h"
#include "Logger.h"
#include "Utils.h"
#include "LogLayout.h"
#include "DB_STRUCT.h"
#include "DB_PACKET_STRUCT.h"

{{range .}}
void DataServer::Process_AR_SELECT_{{.Name}}(EventSocket *pSocket, EventNetPacket *pNetPacket)
{
    DBThread *pThread = dynamic_cast<DBThread *>(pSocket->GetEventThread());
    mysqlpp::Connection *pConn = (mysqlpp::Connection *)pThread->GetConnection();
    DB_PACKET_STRUCT(DS_MSG_AUTO_SELECT) *pPacket = (DB_PACKET_STRUCT(DS_MSG_AUTO_SELECT) *)(pNetPacket->m_szData);    
    gDebugStream("guid: " << pPacket->m_guid << " player_guid: " << pPacket->m_player_guid);

    _DB_TRY
    {
        _DB_QUERY("select * from {{.Name}} where %0 = %1q");
        SerializeSQL(pPacket, sqp);  
        gDebugStream(query.str(sqp));
        mysqlpp::StoreQueryResult res = query.store(sqp);
        if (res.num_rows() == 0)
        {
            VARI_DS_MSG_DEFINITION(AR_SELECT_{{.Name}}_RET, sizeof(DB_{{.Name}})*1);
            pStruct->m_i8OPGUID = pPacket->m_i8OPGUID;
            pStruct->m_nCount = 0;

            pSocket->SendNetPacket(Msg.GetHeader());
            return;
        }
        else
        {
            VARI_DS_MSG_DEFINITION(AR_SELECT_{{.Name}}_RET, sizeof(DB_{{.Name}})*res.num_rows());
            pStruct->m_i8OPGUID = pPacket->m_i8OPGUID;
            pStruct->m_nCount = res.num_rows();

            for (unsigned int i = 0; i < res.num_rows(); i++)
            {
                {{range .Members}}
                {{if eq .Type "char"}}junne_utils::mystrncpy(pStruct->m_data[i].m_{{.Field}}, std::string(res[i]["{{.Field}}"]).c_str());{{else}}pStruct->m_data[i].m_{{.Field}} = {{.Type}}(res[i]["{{.Field}}"]);{{end}}{{end}}
            }

            pSocket->SendNetPacket(Msg.GetHeader());
        }
    }
    _DB_CATCH
    return;
}

void DataServer::Process_AR_UPDATE_{{.Name}}(EventSocket *pSocket, EventNetPacket *pNetPacket)
{
    DBThread *pThread = dynamic_cast<DBThread *>(pSocket->GetEventThread());
    mysqlpp::Connection *pConn = (mysqlpp::Connection *)pThread->GetConnection();

    struct DB_{{.Name}} *pDBStruct = (struct DB_{{.Name}} *)((_DS_MSG_AUTO_QUERY *)pNetPacket->m_szData)->m_szData;
    _DB_TRY
    {
        char sql[] = "INSERT INTO {{.Name}}({{range .Members}}{{.Field}}, {{end}}update_time, create_time) "\
            "VALUES ({{range $index, $elmt := .Members}}%{{$index}}q, {{end}}NOW(), NOW()) "\
            "ON DUPLICATE KEY UPDATE "\
            "{{range .Members}}{{.Field}} = VALUES({{.Field}}), {{end}}"\
            "update_time = NOW()";

        _DB_QUERY(sql);
        sqp << {{range $index, $elmt := .Members}}{{if $index}} << {{else}}{{end}}pDBStruct->m_{{.Field}}{{end}};
        gDebugStream(query.str(sqp));
        mysqlpp::StoreQueryResult res = query.store(sqp);
        if (res.num_rows() == 0)
        {
        }
        else
        {
        }
    }
    _DB_CATCH
    return;
}
{{end}}
