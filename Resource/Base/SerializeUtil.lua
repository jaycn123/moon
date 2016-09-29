
local protobuf = require "protobuf"

local SerializeUtil = {}

function  tst( ... )
    arg = { ... }
    local a=select("1",arg)
    print(a[1])
end

SerializeUtil.Serialize = function (msgID,pkg,t)
	local msg = CreateMessage()
	assert(nil ~= t," must not be nil ")
	encode = protobuf.encode(pkg,t)

	local mw  = MessageWriter.new(msg)
	mw:WriteUint16(msgID)
	mw:WriteString(encode)
	return msg,mw
end

SerializeUtil.SerializeEx = function (msgID)
	local msg = CreateMessage()
	local mw  = MessageWriter.new(msg)
	mw:WriteUint16(msgID)
	return msg,mw
end

SerializeUtil.Deserialize = function(pkg,data)
	return protobuf.decode(pkg,data:Bytes())
end

return SerializeUtil