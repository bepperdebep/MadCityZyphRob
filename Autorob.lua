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

-- Function to smoothly teleport in specified steps
local function smoothTeleportTo(targetPos, steps)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local currentPos = humanoidRootPart.Position
        local stepSize = (targetPos - currentPos) / steps
        
        for i = 1, steps do
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + stepSize
            wait(0.05) -- Adjust speed of teleportation (0.05 seconds per step)
        end
        
        -- Ensure the player is at the exact target position
        humanoidRootPart.CFrame = CFrame.new(targetPos)
        
        -- Return true once the player is at the destination
        if (humanoidRootPart.Position - targetPos).magnitude < 1 then
            return true
        end
    end
    return false -- Return false if the teleport failed
end

-- Start noclip
noclip = true

-- Teleport to the fourth location (-1049, 18, -488) in 50 steps and wait for 3 seconds
if smoothTeleportTo(Vector3.new(-1049, 18, -488), 50) then
    wait(3) -- Wait for 3 seconds once the player is at this position
end

-- Teleport to the next location (1229, 51420, 404) in 5 steps
if smoothTeleportTo(Vector3.new(1229, 51420, 404), 5) then
    -- No wait after arriving at this position
end

-- Teleport to the next location (978, 51302, 602) in 5 steps
if smoothTeleportTo(Vector3.new(978, 51302, 602), 5) then
    -- No wait after arriving at this position
end

-- Teleport to the fifth location (1022, 51073, 584) in 50 steps
if smoothTeleportTo(Vector3.new(1023, 51073, 585), 50) then
    noclip = false -- Remove noclip instantly when arriving
    wait(0) -- Wait for 16 seconds after arriving at this position
end

-- Teleport to the fifth location (1022, 51073, 584) in 50 steps
if smoothTeleportTo(Vector3.new(1023, 51073, 585), 50) then
    noclip = false -- Remove noclip instantly when arriving
    wait(0) -- Wait for 16 seconds after arriving at this position
end

-- Teleport to the fifth location (1022, 51073, 584) in 50 steps
if smoothTeleportTo(Vector3.new(1023, 51073, 585), 50) then
    noclip = false -- Remove noclip instantly when arriving
    wait(16) -- Wait for 16 seconds after arriving at this position
end

-- Turn noclip back on before teleporting back
noclip = true

-- Teleport back to the third location (2121, 26, 424) in 50 steps
if smoothTeleportTo(Vector3.new(2121, 26, 424), 50) then
    wait(2) -- Optional wait after returning to the position
end

-- Stop noclip after all teleports
noclip = false
