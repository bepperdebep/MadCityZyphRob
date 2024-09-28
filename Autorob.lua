-- Noclip function
local noclip = true -- Set to true to activate noclip
game:GetService('RunService').Stepped:Connect(function()
    if noclip then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

-- Function to make the player immune to damage
local function makeImmune()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.MaxHealth = math.huge -- Set max health to infinite
        humanoid.HealthChanged:Connect(function(health)
            if health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth -- Reset health to max
            end
        end)
    end
end

-- Function to smoothly teleport in 50 steps
local function smoothTeleportTo(targetPos)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local currentPos = humanoidRootPart.Position
        local steps = 25 -- 50 steps for smoother teleportation
        local stepSize = (targetPos - currentPos) / steps
        
        for i = 1, steps do
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + stepSize
            wait(0.05) -- Adjust speed of teleportation (0.05 seconds per step)
        end
        
        -- Ensure the player is at the exact target position
        humanoidRootPart.CFrame = CFrame.new(targetPos)
        
        -- Wait only once the player has arrived at the target position
        if (humanoidRootPart.Position - targetPos).magnitude < 1 then
            return true -- Return true once the player is at the destination
        end
    end
    return false -- Return false if the teleport failed
end

-- Start noclip and immunity
noclip = true
makeImmune() -- Make the player immune to damage

-- Teleport to the first location (1365, 44, -153) in 50 steps
if smoothTeleportTo(Vector3.new(1365, 44, -153)) then
    wait(2) -- Wait for 2 seconds after reaching the position
end

-- Teleport to the second location (1308, 144, -138) in 50 steps and wait for 22 seconds after arriving
if smoothTeleportTo(Vector3.new(1308, 144, -138)) then
    wait(22) -- Wait for 22 seconds after arriving at the position
end

-- Teleport to the third location (2121, 26, 424) in 50 steps
if smoothTeleportTo(Vector3.new(2121, 26, 424)) then
    wait(2) -- Optional wait after reaching this position
end

-- Teleport to the fourth location (-1049, 18, -488) in 50 steps and wait for 3 seconds
if smoothTeleportTo(Vector3.new(-1047.5889892578125, 18.27899932861328, -479.7900085449219)) then
    wait(3) -- Wait for 3 seconds once the player is at this position
end


-- Teleport to the fifth location (1022, 51073, 584) in 50 steps and wait for 16 seconds after arriving
if smoothTeleportTo(Vector3.new(1009, 51101, 592)) then
    wait(16) -- Wait for 16 seconds after arriving at this position
end


if smoothTeleportTo(Vector3.new(1231.141845703125, 51051.234375, 381.09619140625)) then
    wait(2) 
end

-- Teleport back to the third location (2121, 26, 424) in 50 steps
if smoothTeleportTo(Vector3.new(2121, 26, 424)) then
    -- Optional wait after returning to the position
    wait(0) 
end

-- Teleport back to the third location (2121, 26, 424) in 50 steps
if smoothTeleportTo(Vector3.new(2121, 26, 424)) then
    -- Optional wait after returning to the position
    wait(0) 
end

-- Teleport back to the third location (2121, 26, 424) in 50 steps
if smoothTeleportTo(Vector3.new(2121, 26, 424)) then
    -- Optional wait after returning to the position
    wait(0) 
end

-- Stop noclip after all teleports
noclip = false

-- Reset the character
game.Players.LocalPlayer.Character:BreakJoints()
