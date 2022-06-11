local MessageEmbed = {}
MessageEmbed.__index = MessageEmbed

function MessageEmbed.new()
	return setmetatable({ fields = {}, type = 'rich' }, MessageEmbed)
end

function MessageEmbed:setColor(color)
	self.color = tonumber(tostring(color):gsub('#', '0x'))
	return self
end

function MessageEmbed:setTitle(title)
	self.title = title
	return self
end

function MessageEmbed:setURL(url)
	self.url = url
	return self
end

function MessageEmbed:setAuthor(data)
	self.author = data
	return self
end

function MessageEmbed:setDescription(description)
	self.description = description
	return self
end

function MessageEmbed:setThumbnail(thumbUrl)
	self.thumbnail = { url = thumbUrl }
	return self
end

function MessageEmbed:addFields(...)
	local t = { ... }
	for i = 1, select('#', ...) do
		table.insert(self.fields, t[i])
	end
	return self
end

function MessageEmbed:addField(name, value, inline)
	self:addFields({ name = name, value = value, inline = inline })
	return self
end

function MessageEmbed:setImage(imageUrl)
	self.image = { url = imageUrl }
	return self
end

function MessageEmbed:setFooter(data)
	local _type = typeof(data)
	if _type == 'string' then
		self.footer = { text = data }
	elseif _type == 'table' then
		self.footer = data
	end

	return self
end

--[[

local HttpService = game:GetService'HttpService'

local embed = MessageEmbed.new()
	:setTitle'hello'
	:setDescription'from Lua'
	:addField('test1', 'test2', true)
	:setFooter(tostring(game.PlaceId));

syn.request({
	Url = 'webhook',
	Method = 'POST',
	Headers = { ['Content-Type'] = 'application/json' },
	Body = HttpService:JSONEncode({
		embeds = { embed }
	})
})

]]

return MessageEmbed
