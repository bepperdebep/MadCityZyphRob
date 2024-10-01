-- Get the Local Player and HumanoidRootPart
local lp = game.Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Noclip function to allow passing through walls
local runService = game:GetService("RunService")
local noclip = true
runService.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Function to smoothly teleport in steps
local function smoothTeleportTo(targetPos, steps)
    local currentPos = hrp.Position
    local stepSize = (targetPos - currentPos) / steps
    
    for i = 1, steps do
        hrp.CFrame = hrp.CFrame + stepSize
        wait(0.05) -- Adjust speed of teleportation (0.05 seconds per step)
    end

    -- Ensure the player is at the exact target position
    hrp.CFrame = CFrame.new(targetPos)

    -- Return true once the player is at the destination
    if (hrp.Position - targetPos).magnitude < 1 then
        return true
    end
    return false -- Return false if the teleport failed
end

-- Collect all SmashCash parts
local smashCashParts = {}
for _, part in pairs(workspace.ObjectSelection:GetDescendants()) do
    if part:IsA("Part") and part.Name == "SmashCash" then
        table.insert(smashCashParts, part)
    end
end

-- Check if there are any SmashCash parts
if #smashCashParts > 0 then
    -- Select a random SmashCash part
    local randomPart = smashCashParts[math.random(1, #smashCashParts)]
    
    -- Smoothly teleport to the random SmashCash part
    smoothTeleportTo(randomPart.Position + Vector3.new(0, 3, 0), 25) -- Add a small vertical offset

    print("Teleported to", randomPart.Name)

    -- Access the specific RemoteEvent inside the SmashCash object
    local cashEvent = randomPart:FindFirstChild("Cash") and randomPart.Cash:FindFirstChild("Cash") and randomPart.Cash.Cash.Event

    -- Check if the event exists and is a RemoteEvent
    if cashEvent and cashEvent:IsA("RemoteEvent") then
        -- Fire the RemoteEvent
        cashEvent:FireServer()
        print("Fired Cash event inside", randomPart.Name)
    else
        print("Cash event not found inside", randomPart.Name)
    end
else
    print("No SmashCash parts found.")
end

-- Stop noclip after the action
noclip = false
