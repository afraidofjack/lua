local overrides = {}
local flags = shared.library.flags

local ReplicatedStorage = game:GetService'ReplicatedStorage'

local getconstants = getconstants
local islclosure = islclosure
local is_syn = is_synapse_function
local find = table.find

local client = game:GetService'Players'.LocalPlayer

overrides[142847746] = {
	get_damage_remote = function()
		local reg = debug.getregistry()
		for i = 1, #reg do
			local fn = reg[i]
			if type(fn) == 'function' and islclosure(fn) and not is_syn(fn) then
				local constants = getconstants(fn)
				if find(constants, 'Client') and find(constants, 'MobHit') then
					local index = find(constants, 'InvokeServer')
					local remoteName = index and constants[index - 1]

					if not remoteName then continue end

					local remote = ReplicatedStorage:FindFirstChild(remoteName, true)

					if remote then return remote end
				end
			end
		end
	end,
	deal_damage = function(self, mob)
		local humanoid = mob:FindFirstChildWhichIsA'Humanoid'
		local tool = client.Character and client.Character:FindFirstChildWhichIsA'Tool'

		if humanoid and tool then
			local config = tool:FindFirstChild'WeaponConfig' and require(tool.WeaponConfig)
			local damage = config and (config.MinDamage + config.MaxDamage) / 2

			self.mob_text.Text = 'Target: ' .. mob.Name

			if damage and flags.oneShot then
				local iterations
				if damage >= humanoid.MaxHealth then
					iterations = 1
				else
					iterations = math.ceil(humanoid.MaxHealth / damage)
				end

				for i = 1, iterations do
					self.damage_remote:InvokeServer(mob, mob:FindFirstChildWhichIsA'BasePart')
				end
			else
				self.damage_remote:InvokeServer(mob, mob:FindFirstChildWhichIsA'BasePart')
			end
		end
	end
}

return overrides
