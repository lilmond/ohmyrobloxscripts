-- Made by lilmond
-- Check out the other versions: https://github.com/lilmond/ohmyrobloxscripts

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local tool = Instance.new("Tool")
tool.Name = "Fe Magneto"
tool.Parent = player.Backpack
tool.RequiresHandle = false

local active = false
local magneto_throw = false
local preview_part = nil
if getgenv().move_position == nil then
	getgenv().move_position = CFrame.new(0, 0, -3)
end
local move_position = getgenv().move_position

local function grab_part()
	local target_part = mouse.Target
	if not target_part then return end
	if target_part.Name == "Fe Move Preview Part" then return end
	
	if target_part:GetRootPart() then
		target_part = target_part:GetRootPart()
	end
	
	if target_part.Anchored then return end
	
	local character = player.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	active = true
	
	while ((wait() and active) and not magneto_throw) do
		if not isnetworkowner(target_part) then continue end
		target_part.CFrame = hrp.CFrame * move_position
		target_part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		target_part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end
	
	if (magneto_throw and isnetworkowner(target_part)) then
		target_part.AssemblyLinearVelocity = (mouse.Hit.Position - workspace.Camera.Focus.Position).Unit * 500
	end
end

local function show_preview()
	if workspace:FindFirstChild("Fe Move Preview Part") then
		workspace:FindFirstChild("Fe Move Preview Part"):Destroy()
	end
	local part = Instance.new("Part")
	preview_part = part
	part.Name = "Fe Move Preview Part"
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0.5
	part.BrickColor = BrickColor.new("Lime green")
	part.Parent = workspace
	
	while wait() do
		local character = player.Character
		if not character then break end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then break end
		if not preview_part then break end
		
		part.CFrame = hrp.CFrame * move_position
	end
	
	part:Destroy()
end

local function do_magneto_throw()
	magneto_throw = true
	wait(1)
	magneto_throw = false
end

local function delete_preview()
	preview_part = nil
end

tool.Activated:Connect(function()
	grab_part()
end)

tool.Equipped:Connect(function()
	show_preview()
end)

tool.Unequipped:Connect(function()
	delete_preview()
end)

tool.Destroying:Connect(function()
	delete_preview()
end)

tool:GetPropertyChangedSignal("Parent"):Connect(function()
	if not (tool.Parent == player.Backpack or tool.Parent == player.Character) then
		delete_preview()
	end
end)

uis.InputBegan:Connect(function(key, paused)
	-- if paused then return end
	
	-- left
	if key.KeyCode == Enum.KeyCode.J then
		move_position = move_position * CFrame.new(-1, 0, 0)
        getgenv().move_position = move_position
    -- right	
	elseif key.KeyCode == Enum.KeyCode.L then
		move_position = move_position * CFrame.new(1, 0, 0)
        getgenv().move_position = move_position
	-- front
	elseif key.KeyCode == Enum.KeyCode.I then
		move_position = move_position * CFrame.new(0, 0, -1)
        getgenv().move_position = move_position
	-- back
	elseif key.KeyCode == Enum.KeyCode.K then
		move_position = move_position * CFrame.new(0, 0, 1)
        getgenv().move_position = move_position
	-- up	
	elseif key.KeyCode == Enum.KeyCode.O then
		move_position = move_position * CFrame.new(0, 1, 0)
        getgenv().move_position = move_position
	-- down
	elseif key.KeyCode == Enum.KeyCode.U then
		move_position = move_position * CFrame.new(0, -1, 0)
        getgenv().move_position = move_position
		
		
	elseif key.KeyCode == Enum.KeyCode.P then
		active = false
	elseif key.KeyCode == Enum.KeyCode.E then
		do_magneto_throw()
	elseif key.KeyCode == Enum.KeyCode.R then
		move_position = CFrame.new(0, 0, -3)
        getgenv().move_position = move_position
	end
end)
