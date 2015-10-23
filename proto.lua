do
    --[[
        创建一个新的协议结构 foo_proto
        第一个参数是协议名称会体现在过滤器中
        第二个参数是协议的描述信息，无关紧要
    --]]
    local yzr2_proto = Proto("yzr2", "YZR2 Protolcol")

    --[[
        下面定义字段
        typedef struct _packet_base_st
		{
		    short       m_i2Begin;
		    short       m_i2PacketID;
		    int			m_i2DataSize;
			int			m_i4Compress;

			char        m_szData[0];
		    _packet_base_st() 
		    {
		        memset(this, 0, sizeof(*this));
		    }
		}EventNetPacket;
    --]]
    local m_i2Begin = ProtoField.uint16("yzr2.prototype", "Protocol Base", base.DEC)
    local m_i2PacketID = ProtoField.uint16("yzr2.servicetype", "Protocol Type", base.DEC)
    local m_i4DataSize = ProtoField.uint32("yzr2.msglen", "Protocol Length", base.DEC)
    local m_i4Compress = ProtoField.uint32("yzr2.msgcontent", "Protocol Compress", base.DEC)
    local m_szData = ProtoField.string("foo.msgcontent", "Message Content")

    -- 将字段添加都协议中
    yzr2_proto.fields = {
        m_i2Begin,
        m_i2PacketID,
        m_i4DataSize,
        m_i4Compress,
        m_szData
    }

     --[[
        下面定义 yzr2_proto 解析器的主函数，这个函数由 wireshark调用
        第一个参数是 Tvb 类型，表示的是需要此解析器解析的数据
        第二个参数是 Pinfo 类型，是协议解析树上的信息，包括 UI 上的显示
        第三个参数是 TreeItem 类型，表示上一级解析树
    --]]
    function yzr2_proto.dissector(tvb, pinfo, treeitem)
        
        -- 设置一些 UI 上面的信息
        pinfo.cols.protocol:set("YZR2")
        pinfo.cols.info:set("YZR2 Protocol")
        
        local offset = 0
        local tvb_len = tvb:len()
        
        -- 在上一级解析树上创建 foo 的根节点
        local yzr2_tree = treeitem:add(yzr2_proto, tvb:range(offset))
        
        -- 下面是想该根节点上添加子节点，也就是自定义协议的各个字段
        -- 注意 range 这个方法的两个参数的意义，第一个表示此时的偏移量
        -- 第二个参数代表的是字段占用数据的长度
        -- wireshark 默认使用的是大端字节序，如果协议中的整数采用的是小端字节序，那么请考虑使用 TreeItem 类型的 add_le() 方法替代 add() 方法
        yzr2_tree:add_le(m_i2Begin, tvb:range(offset, 2))
        offset = offset+2        
        yzr2_tree:add_le(m_i2PacketID, tvb:range(offset, 2))
        offset = offset+2
        yzr2_tree:add_le(m_i4DataSize, tvb:range(offset, 4))
        offset = offset+4
        yzr2_tree:add_le(m_i4Compress, tvb:range(offset, 4))
        offset = offset+4

        -- 计算消息内容的长度
        --local _content_len = tvb_len-offset
        --yzr2_tree:add_le(m_szData, tvb:range(offset, _content_len))
        --offset = offset+_content_len
        
    end
    
    -- 向 wireshark 注册协议插件被调用的条件
    local tcp_port_table = DissectorTable.get("tcp.port")
    tcp_port_table:add(8210, yzr2_proto)
end